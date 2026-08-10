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

    input         change,
    input         mount,
    input   [5:0] track,
    output        ready,
    input         active,

    input  [12:0] ram_addr,
    output  [7:0] ram_do,
    input   [7:0] ram_di,
    input         ram_we,
    output        busy
);


// -------------------------------------------------------------------------
// Core -> SD clock-domain synchronizers
// -------------------------------------------------------------------------

reg reset_sd_ff1 = 0;
reg reset_sd     = 0;

reg change_sd_ff1 = 0;
reg change_sd     = 0;

reg mount_sd_ff1 = 0;
reg mount_sd     = 0;

reg active_sd_ff1 = 0;
reg active_sd     = 0;

reg [5:0] track_sd_ff1 = 0;
reg [5:0] track_sd     = 0;


// Synchronize control signals into the SD/QNICE clock domain.
// Two-stage synchronizers reduce the probability of metastability
// when crossing from the Apple core clock domain.

always @(posedge sd_clk) begin
    reset_sd_ff1 <= reset;
    reset_sd     <= reset_sd_ff1;

    change_sd_ff1 <= change;
    change_sd     <= change_sd_ff1;

    mount_sd_ff1 <= mount;
    mount_sd     <= mount_sd_ff1;

    active_sd_ff1 <= active;
    active_sd     <= active_sd_ff1;

    track_sd_ff1 <= track;
    track_sd     <= track_sd_ff1;
end


// -------------------------------------------------------------------------
// Dirty flag
//
// ram_we belongs to the Apple/core clock domain, so detect it there.
// The resulting LEVEL is synchronized into the SD domain.
// -------------------------------------------------------------------------

reg dirty_core = 0;

reg clear_dirty_toggle_sd = 0;
reg clear_dirty_ff1       = 0;
reg clear_dirty_ff2       = 0;
reg clear_dirty_old       = 0;

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

        // New Disk II write takes priority.
        if (ready && ram_we)
            dirty_core <= 1;
    end
end


// Synchronize dirty level into QNICE domain.

reg dirty_sd_ff1 = 0;
reg dirty_sd     = 0;

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


always @(posedge sd_clk) begin

    old_change <= change_sd;
    old_ack    <= sd_ack;


    // Remove request once QNICE acknowledges it.
    if (sd_ack)
        {sd_rd, sd_wr} <= 2'b00;


    // ---------------------------------------------------------------------
    // Original MiSTer disk-change behaviour
    // ---------------------------------------------------------------------

    if (~old_change & change_sd) begin

        ready_sd <= mount_sd;

        cur_track <= 6'h3f;

        busy_sd <= 0;

        sd_rd <= 0;
        sd_wr <= 0;

        saving <= 0;

        rel_lba <= 0;
    end

    else if (reset_sd) begin

        ready_sd <= 0;

        cur_track <= 6'h3f;

        busy_sd <= 0;

        sd_rd <= 0;
        sd_wr <= 0;

        saving <= 0;

        rel_lba <= 0;
        lba     <= 0;
    end

    // ---------------------------------------------------------------------
    // Continue current 13-sector transfer
    // ---------------------------------------------------------------------

    else if (busy_sd) begin

        if (old_ack && ~sd_ack) begin

            if (rel_lba != 4'd12) begin

                lba     <= lba + 1'd1;
                rel_lba <= rel_lba + 1'd1;

                if (saving)
                    sd_wr <= 1;
                else
                    sd_rd <= 1;
            end

            // Dirty old track has been saved.
            // Now load newly selected track.
            else if (saving && (cur_track != track_sd)) begin

                saving   <= 0;
                cur_track <= track_sd;

                rel_lba <= 0;

                lba <= track_sd * 8'd13;

                sd_rd <= 1;
            end

            // Entire 13-block operation finished.
            else begin

                busy_sd <= 0;

                // Tell core-domain dirty latch to clear.
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

        // Save dirty current track first.
        if (dirty_sd && cur_track != 6'h3f) begin

            saving <= 1;

            lba <= cur_track * 8'd13;

            rel_lba <= 0;

            sd_wr <= 1;
            busy_sd <= 1;
        end

        // Load requested track.
        else begin

            saving   <= 0;
            cur_track <= track_sd;

            rel_lba <= 0;

            lba <= track_sd * 8'd13;

            sd_rd <= 1;
            busy_sd <= 1;
        end
    end
end


// -------------------------------------------------------------------------
// SD/QNICE -> Apple/core status synchronization
// -------------------------------------------------------------------------

reg ready_core_ff1 = 0;
reg ready_core     = 0;

reg busy_core_ff1  = 0;
reg busy_core      = 0;

always @(posedge clk) begin

    ready_core_ff1 <= ready_sd;
    ready_core     <= ready_core_ff1;

    busy_core_ff1 <= busy_sd;
    busy_core     <= busy_core_ff1;
end

assign ready = ready_core;
assign busy  = busy_core;


// -------------------------------------------------------------------------
// Dual-clock track RAM
//
// Port A = QNICE / SD transfer side
// Port B = Apple Disk II side
// -------------------------------------------------------------------------

dualport_2clk_ram #(
    .ADDR_WIDTH (13),
    .DATA_WIDTH (8),
    .FALLING_A  (1)
) floppy_dpram (

    // QNICE side
    .clock_a   (sd_clk),
    .address_a ({rel_lba, sd_buff_addr}),
    .wren_a    (sd_buff_wr & sd_ack),
    .data_a    (sd_buff_dout),
    .q_a       (sd_buff_din),

    // Apple Disk II side
    .clock_b   (clk),
    .address_b (ram_addr),
    .data_b    (ram_di),
    .wren_b    (ram_we),
    .q_b       (ram_do)
);


endmodule