
`timescale 1ns/1ps

// Standalone 35-track test for nib2dsk.sv.
// Uses a known-good .NIB image and its corresponding DOS-order .DSK.
// Set paths below (or override parameters from Vivado).
module tb_nib2dsk;
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

    initial begin
        failed = 0;
        total_mismatches = 0;
        nib_fd = $fopen(NIB_FILE, "rb");
        if (!nib_fd) $fatal(1, "Cannot open NIB_FILE: %s", NIB_FILE);
        dsk_fd = $fopen(DSK_FILE, "rb");
        if (!dsk_fd) $fatal(1, "Cannot open DSK_FILE: %s", DSK_FILE);

        repeat (5) @(negedge clk);
        reset = 0;
        for (t=0; t<TRACKS; t=t+1) begin
            load_track(t);
            clear_capture();
            track = t;
            @(negedge clk);
            start = 1;
            @(negedge clk);
            start = 0;

            cycles = 0;
            while (done !== 1'b1 && cycles < MAX_CYCLES) begin
                @(negedge clk);
                cycles = cycles + 1;
            end
            if (cycles >= MAX_CYCLES)
                $fatal(1, "Timeout decoding track %0d", t);
            // done is registered; capture any final write.
            @(negedge clk);

            mismatches = 0;
            missing = 0;
            shown = 0;
            for (i=0; i<DSK_BYTES; i=i+1) begin
                if (!written[i]) begin
                    missing = missing + 1;
                end else if (recovered_dsk[i] !== expected_dsk[i]) begin
                    mismatches = mismatches + 1;
                    if (shown < 8) begin
                        $display("  track %0d offset %04x: expected %02x got %02x",
                                 t, i, expected_dsk[i], recovered_dsk[i]);
                        shown = shown + 1;
                    end
                end
            end
            total_mismatches = total_mismatches + mismatches;
            if (error || sector_mask !== 16'hffff || missing || mismatches || writes != DSK_BYTES) begin
                failed = failed + 1;
                $display("FAIL track %0d: error=%b mask=%04x writes=%0d missing=%0d mismatches=%0d cycles=%0d",
                         t, error, sector_mask, writes, missing, mismatches, cycles);
            end else begin
                $display("PASS track %0d: %0d bytes, 16 sectors, %0d cycles", t, writes, cycles);
            end
        end
        $fclose(nib_fd);
        $fclose(dsk_fd);
        if (failed) $fatal(1, "FAILED: %0d/%0d tracks; %0d mismatched bytes", failed, TRACKS, total_mismatches);
        $display("PASS: all 35 tracks decoded byte-for-byte to original DSK");
        $finish;
    end
endmodule
