`timescale 1ns/1ps

// Standalone 35-track test for nib2dsk.sv.
// Uses a known-good .NIB image and its corresponding DOS-order .DSK.
// Set paths below (or override parameters from Vivado).
module tb_nib2dsk_partial;
    localparam integer TRACKS = 35;
    localparam integer NIB_BYTES = 6656;
    localparam integer DSK_BYTES = 4096;
    localparam integer MAX_CYCLES = 300000;

    parameter string DSK_FILE = "/mnt/hgfs/Github/Apple-II-MEGA65/CORE/nib2dsk_Testbench/Choplifter (19xx)(-).dsk";
    parameter string NIB_FILE = "/mnt/hgfs/Github/Apple-II-MEGA65/CORE/nib2dsk_Testbench/Choplifter (19xx)(-).nib";

    reg clk = 0;
    always #10 clk = ~clk;
    reg reset = 1;
    reg start = 0;
    reg [5:0] track = 0;
    wire [12:0] nib_addr;
    reg [7:0] nib_data = 0;
    wire [11:0] dsk_addr;
    wire [7:0] dsk_data;
    wire dsk_we, busy, done, error;
    wire [15:0] sector_mask;

    reg [7:0] nib_mem [0:NIB_BYTES-1];
    reg [7:0] expected_dsk [0:DSK_BYTES-1];
    reg [7:0] recovered_dsk [0:DSK_BYTES-1];
    reg written [0:DSK_BYTES-1];
    integer nib_fd, dsk_fd, rc, t, i, cycles;
    integer mismatches, missing, writes, failed, total_mismatches;
    integer shown;

    nib2dsk dut (
        .clk(clk), .reset(reset), .start(start), .track(track),
        .nib_addr(nib_addr), .nib_data(nib_data),
        .dsk_addr(dsk_addr), .dsk_data(dsk_data), .dsk_we(dsk_we),
        .busy(busy), .done(done), .error(error), .sector_mask(sector_mask)
    );

    // One-clock synchronous BRAM read, matching the converter's RAM interface.
    always @(posedge clk)
        nib_data <= nib_mem[nib_addr];

    // Capture registered write outputs on the opposite edge, so the last
    // write of each sector is not lost when dsk_we is deasserted.
    always @(negedge clk) begin
        if (!reset && dsk_we) begin
            recovered_dsk[dsk_addr] = dsk_data;
            written[dsk_addr] = 1'b1;
            writes = writes + 1;
        end
    end

    task automatic load_track(input integer trk);
        integer seek_result, read_result;
        begin
            seek_result = $fseek(nib_fd, trk*NIB_BYTES, 0);
            if (seek_result != 0) $fatal(1, "NIB seek failed: track %0d", trk);
            read_result = $fread(nib_mem, nib_fd);
            if (read_result != NIB_BYTES)
                $fatal(1, "NIB track %0d: read %0d, expected %0d", trk, read_result, NIB_BYTES);

            seek_result = $fseek(dsk_fd, trk*DSK_BYTES, 0);
            if (seek_result != 0) $fatal(1, "DSK seek failed: track %0d", trk);
            read_result = $fread(expected_dsk, dsk_fd);
            if (read_result != DSK_BYTES)
                $fatal(1, "DSK track %0d: read %0d, expected %0d", trk, read_result, DSK_BYTES);
        end
    endtask

    task automatic clear_capture;
        integer n;
        begin
            writes = 0;
            for (n=0; n<DSK_BYTES; n=n+1) begin
                recovered_dsk[n] = 8'h00;
                written[n] = 1'b0;
            end
        end
    endtask

    task automatic run_case(input integer scenario, input [15:0] expected_mask,
                            input bit expected_error);
        integer n, bad;
        begin
            // Begin with original DSK bytes, as a writeback staging buffer
            // would. Any rejected sector must remain byte-for-byte unchanged.
            clear_capture();
            for (n=0; n<DSK_BYTES; n=n+1) recovered_dsk[n] = expected_dsk[n];
            track = 0;
            @(negedge clk); start = 1;
            @(negedge clk); start = 0;
            cycles = 0;
            while (done !== 1'b1 && cycles < MAX_CYCLES) begin
                @(negedge clk);
                cycles = cycles + 1;
            end
            if (cycles >= MAX_CYCLES) $fatal(1, "Timeout case %0d", scenario);
            @(negedge clk);
            bad = 0;
            for (n=0; n<DSK_BYTES; n=n+1) begin
                if (recovered_dsk[n] !== expected_dsk[n]) bad++;
                // DSK soft sector 0 is logical 0, soft sector 4 is logical 7.
                if (((scenario >= 1 && n < 256) ||
                     (scenario >= 2 && n >= 1024 && n < 1280)) && written[n]) bad++;
            end
            if (sector_mask !== expected_mask || error !== expected_error ||
                writes !== (16 - (scenario >= 1) - (scenario >= 2))*256 || bad)
                $fatal(1,"FAIL case=%0d mask=%04x error=%b writes=%0d bad=%0d",
                       scenario,sector_mask,error,writes,bad);
            $display("PASS partial case %0d: mask=%04x error=%b writes=%0d cycles=%0d",
                     scenario,sector_mask,error,writes,cycles);
        end
    endtask

    initial begin
        nib_fd = $fopen(NIB_FILE, "rb");
        dsk_fd = $fopen(DSK_FILE, "rb");
        if (!nib_fd || !dsk_fd) $fatal(1,"Missing reference disk images");
        repeat (5) @(negedge clk);
        reset = 0;
        load_track(0);
        // Case 0: untouched track, all sectors valid.
        run_case(0,16'hffff,0);
        // Case 1: corrupt physical sector 0's GCR checksum.
        // Each physical sector is 416 bytes; data field begins at byte 70,
        // followed by 342 data symbols and one checksum symbol.
        nib_mem[412] = 8'h00;
        run_case(1,16'hfffe,1);
        // Case 2: also invalidate physical sector 1's address prologue.
        // Physical sector 1 corresponds to logical sector 7, soft sector 4.
        nib_mem[416 + 48 + 2] = 8'h00;
        run_case(2,16'hff7e,1);
        $fclose(nib_fd);
        $fclose(dsk_fd);
        $display("PASS: partial-sector recovery and rejected-sector preservation");
        $finish;
    end
endmodule
