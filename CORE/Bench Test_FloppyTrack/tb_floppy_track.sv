`timescale 1ns/1ps

module tb_floppy_track;

    parameter string DSK_FILE =
        "/mnt/hgfs/Github/Apple-II-MEGA65/CORE/dsk2nib_Testbench/project_1/Choplifter (19xx)(-).dsk";

    parameter string NIB_FILE =
        "/mnt/hgfs/Github/Apple-II-MEGA65/CORE/dsk2nib_Testbench/project_1/Choplifter (19xx)(-).nib";

    localparam integer TRACKS = 35;
    localparam integer DSK_TRACK_BYTES = 4096;
    localparam integer NIB_TRACK_BYTES = 6656;
    localparam integer DSK_BYTES = TRACKS * DSK_TRACK_BYTES;
    localparam integer NIB_BYTES = TRACKS * NIB_TRACK_BYTES;

    reg clk = 0;
    reg sd_clk = 0;
    always #35 clk = ~clk;
    always #10 sd_clk = ~sd_clk;

    reg reset = 1;

    wire [31:0] sd_lba;
    wire sd_rd;
    wire sd_wr;
    reg sd_ack = 0;

    reg [8:0] sd_buff_addr = 0;
    reg [7:0] sd_buff_dout = 0;
    wire [7:0] sd_buff_din;
    reg sd_buff_wr = 0;

    reg [1:0] img_type = 2'b01;
    reg change = 0;
    reg mount = 1;
    reg [5:0] track = 0;
    wire ready;
    reg active = 0;

    reg [12:0] ram_addr = 0;
    wire [7:0] ram_do;
    reg [7:0] ram_di = 0;
    reg ram_we = 0;
    wire busy;

    wire dbg_dsk_seen;
    wire dbg_dsk_start;
    wire dbg_dsk_done;

    reg [7:0] dsk_image [0:DSK_BYTES-1];
    reg [7:0] nib_image [0:NIB_BYTES-1];

    integer fd;
    integer bytes_read;

    reg transfer_active = 0;
    integer transfer_index = 0;
    integer transfer_base = 0;
    integer block_requests = 0;
    integer lba_errors = 0;

    always @(posedge sd_clk) begin
        if (reset) begin
            sd_ack <= 0;
            sd_buff_wr <= 0;
            sd_buff_addr <= 0;
            sd_buff_dout <= 0;
            transfer_active <= 0;
            transfer_index <= 0;
            transfer_base <= 0;
            block_requests <= 0;
            lba_errors <= 0;
        end else begin
            if (!transfer_active) begin
                sd_ack <= 0;
                sd_buff_wr <= 0;
                if (sd_rd) begin
                    transfer_active <= 1;
                    transfer_index <= 0;
                    transfer_base <= sd_lba * 512;
                    block_requests <= block_requests + 1;

                    if ((sd_lba * 512) >= DSK_BYTES) begin
                        $display("ERROR: sd_lba out of range: %0d", sd_lba);
                        lba_errors <= lba_errors + 1;
                    end

                    sd_ack <= 1;
                    sd_buff_wr <= 1;
                    sd_buff_addr <= 0;
                    sd_buff_dout <= dsk_image[sd_lba * 512];
                end
            end else begin
                if (transfer_index == 511) begin
                    sd_buff_wr <= 0;
                    sd_ack <= 0;
                    transfer_active <= 0;
                end else begin
                    transfer_index <= transfer_index + 1;
                    sd_buff_addr <= transfer_index + 1;
                    sd_buff_dout <= dsk_image[transfer_base + transfer_index + 1];
                end
            end
        end
    end

    always @(posedge sd_clk)
        if (!reset && sd_wr)
            $display("ERROR: unexpected sd_wr at time %0t LBA=%0d", $time, sd_lba);

    integer ready_busy_cycles = 0;
    always @(posedge clk) begin
        if (reset)
            ready_busy_cycles <= 0;
        else if (ready && busy)
            ready_busy_cycles <= ready_busy_cycles + 1;
    end

    floppy_track dut (
        .clk(clk),
        .sd_clk(sd_clk),
        .reset(reset),

        .sd_lba(sd_lba),
        .sd_rd(sd_rd),
        .sd_wr(sd_wr),
        .sd_ack(sd_ack),

        .sd_buff_addr(sd_buff_addr),
        .sd_buff_dout(sd_buff_dout),
        .sd_buff_din(sd_buff_din),
        .sd_buff_wr(sd_buff_wr),

        .img_type(img_type),
        .change(change),
        .mount(mount),
        .track(track),
        .ready(ready),
        .active(active),

        .ram_addr(ram_addr),
        .ram_do(ram_do),
        .ram_di(ram_di),
        .ram_we(ram_we),
        .busy(busy),

        .dbg_dsk_seen(dbg_dsk_seen),
        .dbg_dsk_start(dbg_dsk_start),
        .dbg_dsk_done(dbg_dsk_done)
    );

    task automatic read_track_byte(input integer addr, output reg [7:0] value);
    begin
        @(negedge clk);
        ram_addr = addr[12:0];
        @(posedge clk);
        #1;
        value = ram_do;
    end
    endtask

    task automatic compare_track(input integer track_num);
        integer i;
        integer mismatches;
        integer first_bad;
        reg [7:0] actual;
        reg [7:0] expected;
    begin
        mismatches = 0;
        first_bad = -1;

        for (i = 0; i < NIB_TRACK_BYTES; i = i + 1) begin
            read_track_byte(i, actual);
            expected = nib_image[track_num * NIB_TRACK_BYTES + i];

            if (actual !== expected) begin
                if (first_bad < 0)
                    first_bad = i;

                if (mismatches < 20)
                    $display("  MISMATCH track=%0d offset=%0d (0x%04x) expected=%02x actual=%02x",
                             track_num, i, i, expected, actual);

                mismatches = mismatches + 1;
            end
        end

        if (mismatches == 0)
            $display("TRACK %0d PASS: floppy_dpram matches all 6656 reference bytes", track_num);
        else
            $display("TRACK %0d FAIL: %0d mismatches, first at %0d (0x%04x)",
                     track_num, mismatches, first_bad, first_bad);
    end
    endtask

    task automatic wait_for_track_cycle(input integer track_num);
        integer timeout;
        integer start_requests;
    begin
        start_requests = block_requests;
        timeout = 0;

        while (busy !== 1'b1 && timeout < 200000) begin
            @(posedge clk);
            timeout = timeout + 1;
        end
        if (timeout >= 200000) begin
            $display("FATAL: track %0d never asserted busy", track_num);
            $finish;
        end

        timeout = 0;
        while (busy !== 1'b0 && timeout < 1000000) begin
            @(posedge clk);
            timeout = timeout + 1;
        end
        if (timeout >= 1000000) begin
            $display("FATAL: track %0d never completed", track_num);
            $finish;
        end

        repeat (4) @(posedge clk);

        if ((block_requests - start_requests) != 8)
            $display("ERROR: track %0d requested %0d DSK blocks, expected 8",
                     track_num, block_requests - start_requests);
        else
            $display("Track %0d transfer complete: 8 DSK blocks + conversion", track_num);
    end
    endtask

    integer t;

    initial begin
        $display("------------------------------------------------------------");
        $display("floppy_track + dsk2nib integration verification");
        $display("DSK: %s", DSK_FILE);
        $display("NIB: %s", NIB_FILE);
        $display("------------------------------------------------------------");

        fd = $fopen(DSK_FILE, "rb");
        if (fd == 0) begin
            $display("FATAL: could not open DSK file");
            $finish;
        end
        bytes_read = $fread(dsk_image, fd);
        $fclose(fd);
        if (bytes_read != DSK_BYTES) begin
            $display("FATAL: DSK size/read mismatch got=%0d expected=%0d", bytes_read, DSK_BYTES);
            $finish;
        end

        fd = $fopen(NIB_FILE, "rb");
        if (fd == 0) begin
            $display("FATAL: could not open NIB file");
            $finish;
        end
        bytes_read = $fread(nib_image, fd);
        $fclose(fd);
        if (bytes_read != NIB_BYTES) begin
            $display("FATAL: NIB size/read mismatch got=%0d expected=%0d", bytes_read, NIB_BYTES);
            $finish;
        end

        reset = 1;
        mount = 1;
        img_type = 2'b01;
        track = 0;
        active = 0;
        change = 0;

        repeat (10) @(posedge sd_clk);
        repeat (5) @(posedge clk);

        reset = 0;

        repeat (8) @(posedge clk);

        @(negedge clk);
        change = 1;
        repeat (4) @(posedge clk);
        @(negedge clk);
        change = 0;

        $display("");
        $display("Testing track 0 through full floppy_track path...");
        wait_for_track_cycle(0);
        compare_track(0);

        for (t = 1; t < TRACKS; t = t + 1) begin
            $display("");
            $display("Testing track %0d through full floppy_track path...", t);
            @(negedge clk);
            track = t[5:0];
            wait_for_track_cycle(t);
            compare_track(t);
        end

        $display("");
        $display("============================================================");
        $display("Integration test complete");
        $display("Total 512-byte read requests : %0d (expected %0d)", block_requests, TRACKS * 8);
        $display("LBA range errors             : %0d", lba_errors);
        $display("ready && busy core cycles    : %0d", ready_busy_cycles);
        $display("dbg_dsk_seen/start/done      : %0d/%0d/%0d",
                 dbg_dsk_seen, dbg_dsk_start, dbg_dsk_done);
        $display("");
        $display("If all tracks PASS but ready&&busy is non-zero,");
        $display("track visibility/handoff timing to drive_ii becomes");
        $display("a prime suspect rather than conversion data.");
        $display("============================================================");

        $finish;
    end

endmodule


// Behavioural stand-in for the M2M dualport RAM used by floppy_track.
// Do not also add the framework dualport_2clk_ram to this first simulation.

module dualport_2clk_ram #(
    parameter integer ADDR_WIDTH = 10,
    parameter integer DATA_WIDTH = 8,
    parameter integer FALLING_A = 0,
    parameter integer FALLING_B = 0
)(
    input wire clock_a,
    input wire [ADDR_WIDTH-1:0] address_a,
    input wire [DATA_WIDTH-1:0] data_a,
    input wire wren_a,
    output reg [DATA_WIDTH-1:0] q_a,

    input wire clock_b,
    input wire [ADDR_WIDTH-1:0] address_b,
    input wire [DATA_WIDTH-1:0] data_b,
    input wire wren_b,
    output reg [DATA_WIDTH-1:0] q_b
);

    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    generate
        if (FALLING_A) begin : g_fall_a
            always @(negedge clock_a) begin
                if (wren_a)
                    mem[address_a] <= data_a;
                q_a <= mem[address_a];
            end
        end else begin : g_rise_a
            always @(posedge clock_a) begin
                if (wren_a)
                    mem[address_a] <= data_a;
                q_a <= mem[address_a];
            end
        end
    endgenerate

    generate
        if (FALLING_B) begin : g_fall_b
            always @(negedge clock_b) begin
                if (wren_b)
                    mem[address_b] <= data_b;
                q_b <= mem[address_b];
            end
        end else begin : g_rise_b
            always @(posedge clock_b) begin
                if (wren_b)
                    mem[address_b] <= data_b;
                q_b <= mem[address_b];
            end
        end
    endgenerate

endmodule
