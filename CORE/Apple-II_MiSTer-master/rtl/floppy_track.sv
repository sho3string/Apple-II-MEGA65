//
// Apple ][ track read/write interface
//

module floppy_track
(
    input         clk,        // Apple/core clock
    input         sd_clk,     // QNICE clock
    input         reset,
    output [31:0] sd_lba,
    output reg    sd_rd,
    output reg    sd_wr,
    input         sd_ack,
    input   [8:0] sd_buff_addr,
    input   [7:0] sd_buff_dout,
    output  [7:0] sd_buff_din,
    input         sd_buff_wr,
    // 00 = native NIB
    // 01 = DSK, converted to NIB internally
    input   [1:0] img_type,
    input         change,
    input         mount,
    input   [5:0] track,
    output        ready,
    input         active,
    input  [12:0] ram_addr,
    output  [7:0] ram_do,
    input   [7:0] ram_di,
    input         ram_we,
    output        busy,

    // ---------------------------------------------------------------------
    // Temporary DSK debug outputs
    // ---------------------------------------------------------------------
    output reg    dbg_dsk_seen,
    output reg    dbg_dsk_start,
    output reg    dbg_dsk_done
);

// -------------------------------------------------------------------------
// Core -> SD clock-domain synchronizers
//
// ASYNC_REG tells Vivado these registers form intentional CDC synchronizer
// chains.  This encourages the two stages to be placed close together and
// prevents normal optimization from restructuring the synchronizer.
// -------------------------------------------------------------------------
(* ASYNC_REG = "TRUE" *) reg reset_sd_ff1 = 0;
(* ASYNC_REG = "TRUE" *) reg reset_sd     = 0;
(* ASYNC_REG = "TRUE" *) reg change_sd_ff1 = 0;
(* ASYNC_REG = "TRUE" *) reg change_sd     = 0;
(* ASYNC_REG = "TRUE" *) reg mount_sd_ff1 = 0;
(* ASYNC_REG = "TRUE" *) reg mount_sd     = 0;
(* ASYNC_REG = "TRUE" *) reg active_sd_ff1 = 0;
(* ASYNC_REG = "TRUE" *) reg active_sd     = 0;
(* ASYNC_REG = "TRUE" *) reg [5:0] track_sd_ff1 = 0;
(* ASYNC_REG = "TRUE" *) reg [5:0] track_sd     = 0;
(* ASYNC_REG = "TRUE" *) reg [1:0] img_type_sd_ff1 = 0;
(* ASYNC_REG = "TRUE" *) reg [1:0] img_type_sd     = 0;

// -------------------------------------------------------------------------
// Synchronize control signals into the SD/QNICE clock domain
// -------------------------------------------------------------------------
always @(posedge sd_clk) begin
    reset_sd_ff1    <= reset;
    reset_sd        <= reset_sd_ff1;
    change_sd_ff1   <= change;
    change_sd       <= change_sd_ff1;
    mount_sd_ff1    <= mount;
    mount_sd        <= mount_sd_ff1;
    active_sd_ff1   <= active;
    active_sd       <= active_sd_ff1;
    track_sd_ff1    <= track;
    track_sd        <= track_sd_ff1;
    img_type_sd_ff1 <= img_type;
    img_type_sd     <= img_type_sd_ff1;
end

// -------------------------------------------------------------------------
// Dirty flag
//
// For now DSK images are READ ONLY from the backing-file point of view.
//
// Disk II may still write into the converted track RAM, but we must NOT
// attempt the existing 13-block NIB writeback into a 143360-byte DSK file.
// NIB -> DSK write conversion can be added later.
// -------------------------------------------------------------------------
reg dirty_core = 0;
reg clear_dirty_toggle_sd = 0;
(* ASYNC_REG = "TRUE" *) reg clear_dirty_ff1 = 0;
(* ASYNC_REG = "TRUE" *) reg clear_dirty_ff2 = 0;
reg clear_dirty_old = 0;
always @(posedge clk) begin
    clear_dirty_ff1 <= clear_dirty_toggle_sd;
    clear_dirty_ff2 <= clear_dirty_ff1;
    clear_dirty_old <= clear_dirty_ff2;
    if (reset) begin
        dirty_core <= 0;
    end
    else begin
        // SD side finished handling the dirty track.
        if (clear_dirty_ff2 != clear_dirty_old)
            dirty_core <= 0;
        // Native NIB may be written back normally.
        // DSK writeback is deliberately disabled until NIB -> DSK exists.
        if (ready && !busy && ram_we)
            dirty_core <= 1;
    end
end

// -------------------------------------------------------------------------
// Synchronize dirty level into QNICE domain
// -------------------------------------------------------------------------
(* ASYNC_REG = "TRUE" *) reg dirty_sd_ff1 = 0;
(* ASYNC_REG = "TRUE" *) reg dirty_sd     = 0;
always @(posedge sd_clk) begin
    dirty_sd_ff1 <= dirty_core;
    dirty_sd     <= dirty_sd_ff1;
end

// -------------------------------------------------------------------------
// SD / QNICE-domain floppy transfer state
// -------------------------------------------------------------------------
reg [31:0] lba       = 0;
reg  [3:0] rel_lba   = 0;
reg        old_ack    = 0;
reg        old_change = 0;
reg  [5:0] cur_track  = 0;
reg        saving     = 0;
reg        ready_sd   = 0;
reg        busy_sd    = 0;
assign sd_lba = lba;

// -------------------------------------------------------------------------
// DSK -> NIB converter control
// -------------------------------------------------------------------------
reg dsk_start      = 0;
reg dsk_converting = 0;
reg nib_decode_start = 0;
reg nib_decoding = 0;
reg dsk_copying = 0;
reg [12:0] copy_count = 0;
reg [11:0] copy_addr_q = 0;
reg copy_valid_q = 0;
reg [15:0] decoded_mask = 0;
wire [12:0] nib_decode_addr;
wire [11:0] nib_decode_dsk_addr;
wire [7:0] nib_decode_dsk_data;
wire nib_decode_dsk_we, nib_decode_done, nib_decode_busy, nib_decode_error;
wire [15:0] nib_decode_mask;
wire [7:0] staging_read_data;
wire [7:0] staging_unused;
reg [11:0] stage_read_addr = 0;
reg [11:0] copy_write_addr = 0;
reg copy_write_en = 0;
wire dsk_conv_busy;
wire dsk_conv_done;
wire [11:0] dsk_conv_addr;
wire [12:0] dsk_nib_addr;
wire  [7:0] dsk_nib_data;
wire        dsk_nib_we;

// -------------------------------------------------------------------------
// Sticky DSK debug flags
//
// dbg_dsk_seen  = img_type 01 reached floppy_track
// dbg_dsk_start = 8 DSK blocks completed and converter was started
// dbg_dsk_done  = dsk2nib completed a track
// -------------------------------------------------------------------------
always @(posedge sd_clk) begin
    if (reset_sd) begin
        dbg_dsk_seen  <= 1'b0;
        dbg_dsk_start <= 1'b0;
        dbg_dsk_done  <= 1'b0;
    end
    else begin
        if (img_type_sd == 2'b01)
            dbg_dsk_seen <= 1'b1;
        if (dsk_start)
            dbg_dsk_start <= 1'b1;
        if (dsk_conv_done)
            dbg_dsk_done <= 1'b1;
    end
end

// -------------------------------------------------------------------------
// Track transfer/control state machine

// -------------------------------------------------------------------------
always @(posedge sd_clk) begin
    // dsk_start is a one-clock pulse
    dsk_start <= 0;
    nib_decode_start <= 0;
    old_change <= change_sd;
    old_ack    <= sd_ack;
    // Remove request once QNICE acknowledges it.
    if (sd_ack)
        {sd_rd, sd_wr} <= 2'b00;

    // ---------------------------------------------------------------------
    // Disk change
    // ---------------------------------------------------------------------
    if (~old_change & change_sd) begin
        ready_sd <= mount_sd;
        cur_track <= 6'h3f;
        busy_sd <= 0;
        sd_rd <= 0;
        sd_wr <= 0;
        saving <= 0;
        rel_lba <= 0;
        dsk_converting <= 0;
        nib_decoding <= 0;
        dsk_copying <= 0;
        copy_write_en <= 0;
    end

    // ---------------------------------------------------------------------
    // Reset
    // ---------------------------------------------------------------------
    else if (reset_sd) begin
        ready_sd <= 0;
        cur_track <= 6'h3f;
        busy_sd <= 0;
        sd_rd <= 0;
        sd_wr <= 0;
        saving <= 0;
        rel_lba <= 0;
        lba     <= 0;
        dsk_converting <= 0;
        nib_decoding <= 0;
        dsk_copying <= 0;
        copy_write_en <= 0;
    end

    // ---------------------------------------------------------------------
    // Continue current transfer / conversion

    // ---------------------------------------------------------------------
    else if (busy_sd) begin

        // ---------------------------------------------------------------
        // DSK data has already been loaded.
        // Wait until DSK -> NIB conversion finishes.
        // ---------------------------------------------------------------
        if (nib_decoding) begin
            if (nib_decode_done) begin
                nib_decoding <= 0;
                decoded_mask <= nib_decode_mask;
                copy_count <= 0;
                dsk_copying <= 1;
            end
        end
        else if (dsk_copying) begin
            // Stage RAM read is synchronous. At each sd_clk rising edge,
            // latch the previous read's data/address for falling-edge DSK write.
            copy_write_en <= copy_valid_q;
            copy_write_addr <= copy_addr_q;
       
            if (copy_count < 13'd4096) begin
                stage_read_addr <= copy_count[11:0];
                copy_addr_q <= copy_count[11:0];
                copy_valid_q <= decoded_mask[copy_count[11:8]];
                copy_count <= copy_count + 1'b1;
            end else begin
                copy_valid_q <= 0;
                // Drain the last two pipeline transfers before SD save.
                if (copy_count == 13'd4096)
                    copy_count <= 13'd4097;
                else if (copy_count == 13'd4097)
                    copy_count <= 13'd4098;
                else begin
                    copy_write_en <= 0;
                    dsk_copying <= 0;
                    if (decoded_mask != 16'h0000) begin
                        saving <= 1;
                        rel_lba <= 0;
                        lba <= cur_track * 32'd8;
                        sd_wr <= 1;
                    end else if (cur_track != track_sd) begin
                        saving <= 0;
                        cur_track <= track_sd;
                        rel_lba <= 0;
                        lba <= track_sd * 32'd8;
                        sd_rd <= 1;
                    end else begin
                        busy_sd <= 0;
                    end
                    if (decoded_mask == 16'h0000)
                        clear_dirty_toggle_sd <= ~clear_dirty_toggle_sd;
                end
            end
        end
        else if (dsk_converting) begin
            if (dsk_conv_done) begin
                dsk_converting <= 0;
                busy_sd        <= 0;
                clear_dirty_toggle_sd <= ~clear_dirty_toggle_sd;
            end
        end

        // ---------------------------------------------------------------
        // Current SD block has completed.

        // ---------------------------------------------------------------
        else if (old_ack && ~sd_ack) begin

            // -----------------------------------------------------------
            // More blocks remain.
            //
            // NIB:
            //     13 * 512 = 6656 bytes
            //
            // DSK:
            //      8 * 512 = 4096 bytes
            // -----------------------------------------------------------
            if (
                (saving && (rel_lba != ((img_type_sd == 2'b01) ? 4'd7 : 4'd12))) ||
                (
                    !saving &&
                    (
                        ((img_type_sd == 2'b00) &&
                         (rel_lba != 4'd12)) ||
                        ((img_type_sd == 2'b01) &&
                         (rel_lba != 4'd7))
                    )
                )
            ) begin
                lba     <= lba + 1'd1;
                rel_lba <= rel_lba + 1'd1;
                if (saving)
                    sd_wr <= 1;
                else
                    sd_rd <= 1;
            end

            // -----------------------------------------------------------
            // Dirty old NIB track has been saved.
            // Now load newly selected track.
            // -----------------------------------------------------------
            else if (saving && (cur_track != track_sd)) begin
                saving    <= 0;
                cur_track <= track_sd;
                rel_lba <= 0;
                if (img_type_sd == 2'b01)
                    lba <= track_sd * 8'd8;
                else
                    lba <= track_sd * 8'd13;
                sd_rd <= 1;
            end

            // -----------------------------------------------------------
            // Finished receiving all 4096 bytes of a DSK track.
            //
            // Start conversion into the normal 6656-byte NIB track RAM.
            // -----------------------------------------------------------
            else if (!saving && (img_type_sd == 2'b01)) begin
                dsk_start      <= 1;
                dsk_converting <= 1;
                // busy_sd remains asserted until dsk_conv_done
            end

            // -----------------------------------------------------------
            // Native NIB operation finished.
            // -----------------------------------------------------------
            else begin
                busy_sd <= 0;
                clear_dirty_toggle_sd <= ~clear_dirty_toggle_sd;
            end
        end
    end

    // ---------------------------------------------------------------------
    // Start track load/save
    // ---------------------------------------------------------------------
    else if (
        ready_sd &&
        (
            (cur_track != track_sd) ||
            (old_change && ~change_sd) ||
            (dirty_sd && ~active_sd)
        )
    ) begin

        // ---------------------------------------------------------------
        // Save dirty current NIB track first.
        // ---------------------------------------------------------------
        if (dirty_sd && cur_track != 6'h3f) begin
            saving <= 1;
            lba <= cur_track * ((img_type_sd == 2'b01) ? 32'd8 : 32'd13);
            rel_lba <= 0;
            busy_sd <= 1;
            if (img_type_sd == 2'b01) begin
                saving <= 0;
                nib_decode_start <= 1;
                nib_decoding <= 1;
            end else begin
                sd_wr <= 1;
            end
        end

        // ---------------------------------------------------------------
        // Load requested track.
        // ---------------------------------------------------------------
        else begin
            saving    <= 0;
            cur_track <= track_sd;
            rel_lba <= 0;
            if (img_type_sd == 2'b01)
                lba <= track_sd * 8'd8;
            else
                lba <= track_sd * 8'd13;
            sd_rd   <= 1;
            busy_sd <= 1;
        end
    end
end

// -------------------------------------------------------------------------
// SD/QNICE -> Apple/core status synchronization
// -------------------------------------------------------------------------
(* ASYNC_REG = "TRUE" *) reg ready_core_ff1 = 0;
(* ASYNC_REG = "TRUE" *) reg ready_core     = 0;
(* ASYNC_REG = "TRUE" *) reg busy_core_ff1 = 0;
(* ASYNC_REG = "TRUE" *) reg busy_core     = 0;
always @(posedge clk) begin
    ready_core_ff1 <= ready_sd;
    ready_core     <= ready_core_ff1;
    busy_core_ff1 <= busy_sd;
    busy_core     <= busy_core_ff1;
end
assign ready = ready_core;
assign busy  = busy_core;

// ============================================================================
// DSK SOURCE RAM
// ============================================================================
//
// Standard .DSK track:
//
//     16 sectors * 256 bytes = 4096 bytes
//     8 vdrive blocks * 512 bytes
//
// Port A:
//     QNICE loads the DSK track.
//
// Port B:
//     dsk2nib reads the DSK source bytes.
// ============================================================================
wire [7:0] dsk_ram_do_a;
wire [7:0] dsk_ram_do_b;
dualport_2clk_ram #(
    .ADDR_WIDTH (12),
    .DATA_WIDTH (8),
    .FALLING_A  (1)
) dsk_source_dpram (
    // QNICE / SD side
    .clock_a   (sd_clk),
    .address_a ({rel_lba[2:0], sd_buff_addr}),
    .wren_a    (
        sd_buff_wr &&
        sd_ack &&
        (img_type_sd == 2'b01) &&
        !dsk_converting
    ),
    .data_a    (sd_buff_dout),
    .q_a       (dsk_ram_do_a),
    // Converter side
    .clock_b   (sd_clk),
    .address_b (dsk_copying ? copy_write_addr : dsk_conv_addr),
    .data_b    (staging_read_data),
    .wren_b    (dsk_copying && copy_write_en),
    .q_b       (dsk_ram_do_b)
);

// ============================================================================
// DSK -> NIB CONVERTER
// ============================================================================
dsk2nib i_dsk2nib
(
    .clk      (sd_clk),
    .reset    (reset_sd),
    .start    (dsk_start),
    .track    (cur_track),
    .dsk_addr (dsk_conv_addr),
    .dsk_data (dsk_ram_do_b),
    .nib_addr (dsk_nib_addr),
    .nib_data (dsk_nib_data),
    .nib_we   (dsk_nib_we),
    .busy     (dsk_conv_busy),
    .done     (dsk_conv_done)
);

// ============================================================================
// NIB TRACK RAM
// ============================================================================
//
// Native NIB:
//     QNICE writes 13 * 512 bytes directly.
//
// DSK:
//     QNICE loads 4096-byte DSK source RAM,
//     then dsk2nib generates the 6656-byte NIB track here.
//
// Port B remains the Apple Disk II interface.

// ============================================================================
wire [7:0] nib_ram_do_a;
nib2dsk i_nib2dsk 
(
    .clk(sd_clk), 
    .reset(reset_sd), 
    .start(nib_decode_start),
    .track(cur_track), 
    .nib_addr(nib_decode_addr),
    .nib_data(nib_ram_do_a),
    .dsk_addr(nib_decode_dsk_addr), 
    .dsk_data(nib_decode_dsk_data),
    .dsk_we(nib_decode_dsk_we), 
    .busy(nib_decode_busy),
    .done(nib_decode_done), 
    .error(nib_decode_error),
    .sector_mask(nib_decode_mask)
);
// Decoder output is isolated from the live DSK source RAM until scan ends.
dualport_2clk_ram #(
    .ADDR_WIDTH(12), .DATA_WIDTH(8), .FALLING_A(1)
) dsk_staging_dpram (
    .clock_a(sd_clk), 
    .address_a(nib_decode_dsk_addr),
    .data_a(nib_decode_dsk_data),
    .wren_a(nib_decoding && nib_decode_dsk_we), 
    .q_a(staging_unused),
    .clock_b(sd_clk), 
    .address_b(stage_read_addr),
    .data_b(8'h00), 
    .wren_b(1'b0), 
    .q_b(staging_read_data)
);
// QNICE readback source
assign sd_buff_din =
    (img_type_sd == 2'b01)
        ? dsk_ram_do_a
        : nib_ram_do_a;

// -------------------------------------------------------------------------
// Converter writes
//
// dsk2nib increments nib_addr at the same edge it asserts nib_we.
// Therefore the RAM sees the previous nib_data/nib_we but the incremented
// address. Subtract one while converting.
// -------------------------------------------------------------------------
wire [12:0] track_ram_addr_a =
    dsk_converting ? (dsk_nib_addr - 13'd1) :
    nib_decoding ? nib_decode_addr : {rel_lba, sd_buff_addr};
wire [7:0] track_ram_data_a =
    dsk_converting
        ? dsk_nib_data
        : sd_buff_dout;
wire track_ram_we_a =
    dsk_converting
        ? dsk_nib_we
        : (
            sd_buff_wr &&
            sd_ack &&
            (img_type_sd == 2'b00)
          );
dualport_2clk_ram #(
    .ADDR_WIDTH (13),
    .DATA_WIDTH (8),
    .FALLING_A  (1)
) floppy_dpram (
    // SD loader / converter side
    .clock_a   (sd_clk),
    .address_a (track_ram_addr_a),
    .wren_a    (track_ram_we_a),
    .data_a    (track_ram_data_a),
    .q_a       (nib_ram_do_a),
    // Apple Disk II side
    .clock_b   (clk),
    .address_b (ram_addr),
    .data_b    (ram_di),
    .wren_b    (ram_we),
    .q_b       (ram_do)
);

endmodule
