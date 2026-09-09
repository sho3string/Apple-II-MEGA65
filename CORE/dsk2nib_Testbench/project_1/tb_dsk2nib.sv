`timescale 1ns/1ps

// -----------------------------------------------------------------------------
// Testbench for dsk2nib.sv
//
// Purpose:
//   Feed each 4096-byte track from a .DSK image through the real dsk2nib RTL,
//   model the same synchronous source-RAM / falling-edge destination-RAM timing
//   used by floppy_track.sv, and compare the generated 6656-byte NIB track
//   byte-for-byte against a known-good .NIB image.
//
// IMPORTANT:
//   Edit DSK_FILE and NIB_FILE below to absolute paths on your machine.
// -----------------------------------------------------------------------------

module tb_dsk2nib;

    localparam integer TRACKS         = 35;
    localparam integer DSK_TRACK_SIZE = 4096;
    localparam integer NIB_TRACK_SIZE = 6656;

    // -------------------------------------------------------------------------
    // EDIT THESE TWO PATHS
    // Use forward slashes, even on Windows.
    // Example:
    //   "C:/Github/Apple-II-MEGA65/test/Choplifter (19xx)(-)(1).dsk"
    // -------------------------------------------------------------------------
    parameter string DSK_FILE = "/mnt/hgfs/Github/Apple-II-MEGA65/CORE/dsk2nib_Testbench/project_1/Choplifter (19xx)(-).dsk";
    parameter string NIB_FILE = "/mnt/hgfs/Github/Apple-II-MEGA65/CORE/dsk2nib_Testbench/project_1/Choplifter (19xx)(-).nib";

    reg clk   = 1'b0;
    reg reset = 1'b1;
    reg start = 1'b0;
    reg [5:0] track = 6'd0;

    wire [11:0] dsk_addr;
    reg  [7:0]  dsk_data = 8'h00;

    wire [12:0] nib_addr;
    wire [7:0]  nib_data;
    wire        nib_we;
    wire        busy;
    wire        done;

    reg [7:0] dsk_mem      [0:DSK_TRACK_SIZE-1];
    reg [7:0] expected_nib [0:NIB_TRACK_SIZE-1];
    reg [7:0] captured_nib [0:NIB_TRACK_SIZE-1];
    reg       captured_we  [0:NIB_TRACK_SIZE-1];

    integer dsk_fd;
    integer nib_fd;
    integer rc;
    integer t;
    integer i;
    integer writes;
    integer mismatches;
    integer missing_writes;
    integer total_mismatches;
    integer total_missing_writes;
    integer failed_tracks;
    integer report_count;
    integer capture_index;

    // 50 MHz test clock. The absolute frequency is irrelevant to functional
    // conversion; only edge ordering matters here.
    always #10 clk = ~clk;

    // -------------------------------------------------------------------------
    // DUT: exact converter used by the core
    // -------------------------------------------------------------------------
    dsk2nib dut (
        .clk      (clk),
        .reset    (reset),
        .start    (start),
        .track    (track),

        .dsk_addr (dsk_addr),
        .dsk_data (dsk_data),

        .nib_addr (nib_addr),
        .nib_data (nib_data),
        .nib_we   (nib_we),

        .busy     (busy),
        .done     (done)
    );

    // -------------------------------------------------------------------------
    // Synchronous DSK source RAM model
    //
    // This models dsk_source_dpram port B in floppy_track.sv:
    //   address is presented by dsk2nib,
    //   data appears after a rising clock edge.
    //
    // dsk2nib's ST_READ_DSK_ADDR -> ST_READ_DSK_WAIT -> ST_READ_DSK_DATA
    // sequence is therefore exercised with real one-cycle synchronous latency.
    // -------------------------------------------------------------------------
    always @(posedge clk) begin
        dsk_data <= dsk_mem[dsk_addr];
    end

    // -------------------------------------------------------------------------
    // NIB destination RAM model
    //
    // floppy_track.sv uses FALLING_A=1 for floppy_dpram. dsk2nib updates
    // nib_data/nib_we/nib_addr on the rising edge, so the RAM consumes those
    // updated values on the following falling edge.
    //
    // The real core compensates for dsk2nib incrementing nib_addr on the same
    // rising edge as a write by using (dsk_nib_addr - 1). Do exactly that here.
    // -------------------------------------------------------------------------
    always @(negedge clk) begin
        if (nib_we) begin
            if (nib_addr == 13'd0) begin
                $display("ERROR: nib_we asserted with nib_addr == 0 at time %0t", $time);
            end
            else begin
                capture_index = nib_addr - 1;

                if (capture_index >= 0 && capture_index < NIB_TRACK_SIZE) begin
                    captured_nib[capture_index] = nib_data;
                    captured_we[capture_index]  = 1'b1;
                    writes = writes + 1;
                end
                else begin
                    $display("ERROR: out-of-range NIB write: addr=%0d data=%02x time=%0t",
                             capture_index, nib_data, $time);
                end
            end
        end
    end

    task automatic load_track;
        input integer trk;
        integer seek_rc;
        integer read_rc;
        begin
            seek_rc = $fseek(dsk_fd, trk * DSK_TRACK_SIZE, 0);
            if (seek_rc != 0) begin
                $display("FATAL: failed seeking DSK to track %0d", trk);
                $finish;
            end

            read_rc = $fread(dsk_mem, dsk_fd);
            if (read_rc != DSK_TRACK_SIZE) begin
                $display("FATAL: DSK track %0d read returned %0d bytes, expected %0d",
                         trk, read_rc, DSK_TRACK_SIZE);
                $finish;
            end

            seek_rc = $fseek(nib_fd, trk * NIB_TRACK_SIZE, 0);
            if (seek_rc != 0) begin
                $display("FATAL: failed seeking NIB to track %0d", trk);
                $finish;
            end

            read_rc = $fread(expected_nib, nib_fd);
            if (read_rc != NIB_TRACK_SIZE) begin
                $display("FATAL: NIB track %0d read returned %0d bytes, expected %0d",
                         trk, read_rc, NIB_TRACK_SIZE);
                $finish;
            end
        end
    endtask

    task automatic clear_capture;
        integer n;
        begin
            writes = 0;
            for (n = 0; n < NIB_TRACK_SIZE; n = n + 1) begin
                captured_nib[n] = 8'h00;
                captured_we[n]  = 1'b0;
            end
        end
    endtask

    task automatic run_conversion;
        input integer trk;
        begin
            track = trk[5:0];

            // Pulse start for exactly one rising edge.
            @(negedge clk);
            start = 1'b1;
            @(negedge clk);
            start = 1'b0;

            // Wait for the converter to complete.
            wait (busy === 1'b1);
            wait (done === 1'b1);

            // Allow the current cycle to settle before comparing.
            @(negedge clk);
        end
    endtask

    task automatic compare_track;
        input integer trk;
        integer n;
        begin
            mismatches    = 0;
            missing_writes = 0;
            report_count  = 0;

            for (n = 0; n < NIB_TRACK_SIZE; n = n + 1) begin
                if (!captured_we[n]) begin
                    missing_writes = missing_writes + 1;
                    if (report_count < 20) begin
                        $display("TRACK %0d MISSING WRITE at NIB offset %0d (0x%04x), expected=%02x",
                                 trk, n, n, expected_nib[n]);
                        report_count = report_count + 1;
                    end
                end
                else if (captured_nib[n] !== expected_nib[n]) begin
                    mismatches = mismatches + 1;
                    if (report_count < 20) begin
                        $display("TRACK %0d MISMATCH at NIB offset %0d (0x%04x): expected=%02x actual=%02x",
                                 trk, n, n, expected_nib[n], captured_nib[n]);
                        report_count = report_count + 1;
                    end
                end
            end

            if (writes != NIB_TRACK_SIZE) begin
                $display("TRACK %0d WRITE COUNT: observed=%0d expected=%0d",
                         trk, writes, NIB_TRACK_SIZE);
            end

            if (mismatches == 0 && missing_writes == 0 && writes == NIB_TRACK_SIZE) begin
                $display("TRACK %0d PASS: all %0d bytes match", trk, NIB_TRACK_SIZE);
            end
            else begin
                $display("TRACK %0d FAIL: mismatches=%0d missing_writes=%0d writes=%0d",
                         trk, mismatches, missing_writes, writes);
                failed_tracks = failed_tracks + 1;
            end

            total_mismatches     = total_mismatches + mismatches;
            total_missing_writes = total_missing_writes + missing_writes;
        end
    endtask

    initial begin
        $display("------------------------------------------------------------");
        $display("dsk2nib RTL byte-for-byte verification");
        $display("DSK: %s", DSK_FILE);
        $display("NIB: %s", NIB_FILE);
        $display("------------------------------------------------------------");

        dsk_fd = $fopen(DSK_FILE, "rb");
        if (dsk_fd == 0) begin
            $display("FATAL: cannot open DSK file: %s", DSK_FILE);
            $finish;
        end

        nib_fd = $fopen(NIB_FILE, "rb");
        if (nib_fd == 0) begin
            $display("FATAL: cannot open NIB file: %s", NIB_FILE);
            $finish;
        end

        total_mismatches     = 0;
        total_missing_writes = 0;
        failed_tracks        = 0;
        writes               = 0;

        // Reset DUT.
        repeat (5) @(posedge clk);
        reset = 1'b0;
        repeat (3) @(posedge clk);

        // Test the complete disk, one track at a time.
        for (t = 0; t < TRACKS; t = t + 1) begin
            load_track(t);
            clear_capture();

            $display("\nTesting track %0d...", t);
            run_conversion(t);
            compare_track(t);

            // dsk2nib returns to ST_IDLE immediately after ST_DONE.
            repeat (2) @(posedge clk);
        end

        $display("\n============================================================");
        if (failed_tracks == 0) begin
            $display("PASS: ALL 35 TRACKS MATCH THE REFERENCE NIB BYTE-FOR-BYTE");
        end
        else begin
            $display("FAIL: %0d track(s) differ", failed_tracks);
            $display("Total mismatched bytes : %0d", total_mismatches);
            $display("Total missing writes   : %0d", total_missing_writes);
        end
        $display("============================================================\n");

        $fclose(dsk_fd);
        $fclose(nib_fd);
        $finish;
    end

endmodule
