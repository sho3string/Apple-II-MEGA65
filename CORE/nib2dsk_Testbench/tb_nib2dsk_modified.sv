`timescale 1ns/1ps

// Hardware round-trip: modify one DSK sector -> dsk2nib -> nib2dsk.
// Does not modify the original 35-track regression test.
module tb_nib2dsk_modified;
    localparam integer DSK_BYTES = 4096;
    localparam integer NIB_BYTES = 6656;
    localparam integer TEST_TRACK = 17;
    localparam integer TEST_SOFT_SECTOR = 7;
    localparam integer MAX_CYCLES = 300000;

    parameter string DSK_FILE = "/mnt/hgfs/Github/Apple-II-MEGA65/CORE/nib2dsk_Testbench/Choplifter (19xx)(-).dsk";

    reg clk = 0;
    always #10 clk = ~clk;
    reg reset = 1;
    reg encoder_start = 0;
    reg decoder_start = 0;
    reg [5:0] track = TEST_TRACK;

    wire [11:0] enc_dsk_addr;
    reg [7:0] enc_dsk_data = 0;
    wire [12:0] enc_nib_addr;
    wire [7:0] enc_nib_data;
    wire enc_nib_we, enc_busy, enc_done;

    wire [12:0] dec_nib_addr;
    reg [7:0] dec_nib_data = 0;
    wire [11:0] dec_dsk_addr;
    wire [7:0] dec_dsk_data;
    wire dec_dsk_we, dec_busy, dec_done, dec_error;
    wire [15:0] sector_mask;

    reg [7:0] source_dsk [0:DSK_BYTES-1];
    reg [7:0] nib_mem [0:NIB_BYTES-1];
    reg [7:0] recovered_dsk [0:DSK_BYTES-1];
    reg written [0:DSK_BYTES-1];

    integer fd, rc, i, cycles, nib_writes, dsk_writes, missing, mismatches, shown;
    reg [7:0] original_byte;

    dsk2nib encoder (
        .clk(clk), .reset(reset), .start(encoder_start), .track(track),
        .dsk_addr(enc_dsk_addr), .dsk_data(enc_dsk_data),
        .nib_addr(enc_nib_addr), .nib_data(enc_nib_data), .nib_we(enc_nib_we),
        .busy(enc_busy), .done(enc_done)
    );

    nib2dsk decoder (
        .clk(clk), .reset(reset), .start(decoder_start), .track(track),
        .nib_addr(dec_nib_addr), .nib_data(dec_nib_data),
        .dsk_addr(dec_dsk_addr), .dsk_data(dec_dsk_data), .dsk_we(dec_dsk_we),
        .busy(dec_busy), .done(dec_done), .error(dec_error), .sector_mask(sector_mask)
    );

    // One-clock synchronous source/destination RAM read interfaces.
    always @(posedge clk) begin
        enc_dsk_data <= source_dsk[enc_dsk_addr];
        dec_nib_data <= nib_mem[dec_nib_addr];
    end

    // Encoder increments nib_addr on the same edge that registers nib_we.
    // Thus the registered write refers to nib_addr - 1.
    always @(negedge clk) begin
        if (!reset && enc_nib_we) begin
            if (enc_nib_addr == 0 || enc_nib_addr > NIB_BYTES)
                $fatal(1, "Encoder address out of range: %0d", enc_nib_addr);
            nib_mem[enc_nib_addr - 1'b1] = enc_nib_data;
            nib_writes = nib_writes + 1;
        end
        if (!reset && dec_dsk_we) begin
            recovered_dsk[dec_dsk_addr] = dec_dsk_data;
            written[dec_dsk_addr] = 1'b1;
            dsk_writes = dsk_writes + 1;
        end
    end

    initial begin
        nib_writes = 0;
        dsk_writes = 0;
        for (i = 0; i < NIB_BYTES; i = i + 1) nib_mem[i] = 8'h00;
        for (i = 0; i < DSK_BYTES; i = i + 1) begin
            recovered_dsk[i] = 8'h00;
            written[i] = 1'b0;
        end

        fd = $fopen(DSK_FILE, "rb");
        if (!fd) $fatal(1, "Cannot open DSK_FILE: %s", DSK_FILE);
        rc = $fseek(fd, TEST_TRACK * DSK_BYTES, 0);
        if (rc != 0) $fatal(1, "DSK seek failed");
        rc = $fread(source_dsk, fd);
        if (rc != DSK_BYTES)
            $fatal(1, "Read %0d bytes, expected %0d", rc, DSK_BYTES);
        $fclose(fd);

        // Alter multiple positions, including both ends, in one DOS-order sector.
        // XOR ensures each value actually changes from the original image.
        for (i = 0; i < 256; i = i + 1) begin
            if (i == 0 || i == 1 || i == 85 || i == 86 ||
                i == 171 || i == 172 || i == 254 || i == 255) begin
                source_dsk[TEST_SOFT_SECTOR * 256 + i] =
                    source_dsk[TEST_SOFT_SECTOR * 256 + i] ^ (8'hA5 ^ i[7:0]);
            end
        end
        $display("Modified track %0d, DSK soft sector %0d", TEST_TRACK, TEST_SOFT_SECTOR);

        repeat (5) @(negedge clk);
        reset = 0;
        @(negedge clk);
        encoder_start = 1;
        @(negedge clk);
        encoder_start = 0;

        cycles = 0;
        while (enc_done !== 1'b1 && cycles < MAX_CYCLES) begin
            @(negedge clk);
            cycles = cycles + 1;
        end
        if (cycles >= MAX_CYCLES) $fatal(1, "Encoder timeout");
        @(negedge clk);
        if (nib_writes != NIB_BYTES)
            $fatal(1, "Encoder emitted %0d bytes, expected %0d", nib_writes, NIB_BYTES);
        $display("Encoder PASS: %0d NIB bytes in %0d cycles", nib_writes, cycles);

        @(negedge clk);
        decoder_start = 1;
        @(negedge clk);
        decoder_start = 0;

        cycles = 0;
        while (dec_done !== 1'b1 && cycles < MAX_CYCLES) begin
            @(negedge clk);
            cycles = cycles + 1;
        end
        if (cycles >= MAX_CYCLES) $fatal(1, "Decoder timeout");
        @(negedge clk);

        mismatches = 0;
        missing = 0;
        shown = 0;
        for (i = 0; i < DSK_BYTES; i = i + 1) begin
            if (!written[i]) missing = missing + 1;
            else if (recovered_dsk[i] !== source_dsk[i]) begin
                mismatches = mismatches + 1;
                if (shown < 8) begin
                    $display("  offset %04x: expected %02x, got %02x",
                             i, source_dsk[i], recovered_dsk[i]);
                    shown = shown + 1;
                end
            end
        end

        if (dec_error || sector_mask !== 16'hffff ||
            dsk_writes != DSK_BYTES || missing || mismatches)
            $fatal(1, "Round-trip FAIL: error=%b mask=%04x writes=%0d missing=%0d mismatches=%0d",
                   dec_error, sector_mask, dsk_writes, missing, mismatches);

        $display("PASS: modified sector survived hardware encode/decode; all %0d track bytes match (%0d decoder cycles)",
                 DSK_BYTES, cycles);
        $finish;
    end
endmodule
