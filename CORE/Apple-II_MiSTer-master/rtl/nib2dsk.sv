
// Apple II 16-sector NIB -> DOS-order DSK track decoder.
// Standalone first-stage implementation; not yet wired to floppy_track.
// Input: synchronous 6656-byte NIB RAM, output: 4096-byte DSK RAM writes.
// Output RAM must not be committed to SD unless done && !error &&
// sector_mask == 16'hffff. Each sector is written only after validation.

`timescale 1ns/1ps

module nib2dsk (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [5:0] track,
    output reg [12:0] nib_addr,
    input wire [7:0] nib_data,
    output reg [11:0] dsk_addr,
    output reg [7:0] dsk_data,
    output reg dsk_we,
    output reg busy,
    output reg done,
    output reg error,
    output reg [15:0] sector_mask
);
    localparam IDLE=0, REQ=1, WAIT_RAM=2, CONSUME=3,
               DECODE=4, OUTPUT=5, FINISH=6;
    reg [2:0] state;
    reg [2:0] return_state;
    reg [12:0] scan_pos;
    reg [12:0] read_pos;
    reg [12:0] scanned;
    reg [7:0] prev2, prev1;
    reg [1:0] mode; // 0 scan, 1 address, 2 data
    reg [8:0] field_idx;
    reg [7:0] addr_field [0:7];
    reg [7:0] encoded [0:342];
    reg [7:0] secondary [0:85];
    reg [7:0] primary [0:255];
    reg [7:0] volume, addr_track, addr_sector, addr_check;
    reg [3:0] pending_sector;
    reg pending_valid;
    reg [5:0] last_symbol;
    reg [8:0] idx;
    reg [7:0] decoded_byte;
    reg [7:0] checksum;
    reg decode_ok;
    reg [3:0] soft_sector;
    integer i, j, k;

    // Reverse of the 64-entry Disk II 6-and-2 GCR translation table.
    function automatic [6:0] untranslate(input [7:0] value);
        begin
            case (value)
                8'h96:untranslate=0; 8'h97:untranslate=1;
                8'h9a:untranslate=2; 8'h9b:untranslate=3;
                8'h9d:untranslate=4; 8'h9e:untranslate=5;
                8'h9f:untranslate=6; 8'ha6:untranslate=7;
                8'ha7:untranslate=8; 8'hab:untranslate=9;
                8'hac:untranslate=10;8'had:untranslate=11;
                8'hae:untranslate=12;8'haf:untranslate=13;
                8'hb2:untranslate=14;8'hb3:untranslate=15;
                8'hb4:untranslate=16;8'hb5:untranslate=17;
                8'hb6:untranslate=18;8'hb7:untranslate=19;
                8'hb9:untranslate=20;8'hba:untranslate=21;
                8'hbb:untranslate=22;8'hbc:untranslate=23;
                8'hbd:untranslate=24;8'hbe:untranslate=25;
                8'hbf:untranslate=26;8'hcb:untranslate=27;
                8'hcd:untranslate=28;8'hce:untranslate=29;
                8'hcf:untranslate=30;8'hd3:untranslate=31;
                8'hd6:untranslate=32;8'hd7:untranslate=33;
                8'hd9:untranslate=34;8'hda:untranslate=35;
                8'hdb:untranslate=36;8'hdc:untranslate=37;
                8'hdd:untranslate=38;8'hde:untranslate=39;
                8'hdf:untranslate=40;8'he5:untranslate=41;
                8'he6:untranslate=42;8'he7:untranslate=43;
                8'he9:untranslate=44;8'hea:untranslate=45;
                8'heb:untranslate=46;8'hec:untranslate=47;
                8'hed:untranslate=48;8'hee:untranslate=49;
                8'hef:untranslate=50;8'hf2:untranslate=51;
                8'hf3:untranslate=52;8'hf4:untranslate=53;
                8'hf5:untranslate=54;8'hf6:untranslate=55;
                8'hf7:untranslate=56;8'hf9:untranslate=57;
                8'hfa:untranslate=58;8'hfb:untranslate=59;
                8'hfc:untranslate=60;8'hfd:untranslate=61;
                8'hfe:untranslate=62;8'hff:untranslate=63;
                default:untranslate=7'h40;
            endcase
        end
    endfunction

    function automatic [7:0] decode44(input [7:0] a, input [7:0] b);
        decode44 = ((a & 8'h55) << 1) | (b & 8'h55);
    endfunction

    // These are the same logical -> soft mapping values as dsk2nib.sv.
    function automatic [3:0] logical_to_soft(input [3:0] s);
        case (s)
            0:logical_to_soft=0; 1:logical_to_soft=7;
            2:logical_to_soft=14;3:logical_to_soft=6;
            4:logical_to_soft=13;5:logical_to_soft=5;
            6:logical_to_soft=12;7:logical_to_soft=4;
            8:logical_to_soft=11;9:logical_to_soft=3;
            10:logical_to_soft=10;11:logical_to_soft=2;
            12:logical_to_soft=9;13:logical_to_soft=1;
            14:logical_to_soft=8;default:logical_to_soft=15;
        endcase
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            nib_addr <= 0; dsk_addr <= 0; dsk_data <= 0;
            dsk_we <= 0; busy <= 0; done <= 0; error <= 0;
            sector_mask <= 0; scan_pos <= 0; scanned <= 0;
            prev1 <= 0; prev2 <= 0; mode <= 0; field_idx <= 0;
            pending_valid <= 0; pending_sector <= 0;
            idx <= 0;
        end else begin
            dsk_we <= 0;
            done <= 0;
            case (state)
                IDLE: begin
                    busy <= 0;
                    if (start) begin
                        busy <= 1; error <= 0; sector_mask <= 0;
                        scan_pos <= 0; scanned <= 0;
                        prev1 <= 0; prev2 <= 0;
                        mode <= 0; pending_valid <= 0;
                        state <= REQ;
                    end
                end
                // Two cycles after setting address: compatible with registered
                // synchronous block RAM output and a registered address port.
                REQ: begin
                    nib_addr <= scan_pos;
                    state <= WAIT_RAM;
                end
                WAIT_RAM: state <= CONSUME;
                CONSUME: begin
                    scan_pos <= (scan_pos == 13'd6655) ? 13'd0 : scan_pos + 1'b1;
                    scanned <= scanned + 1'b1;
                    if (mode == 0) begin
                        if (prev2 == 8'hd5 && prev1 == 8'haa && nib_data == 8'h96) begin
                            mode <= 1;
                            field_idx <= 0;
                            pending_valid <= 0;
                        end else if (prev2 == 8'hd5 && prev1 == 8'haa && nib_data == 8'had && pending_valid) begin
                            mode <= 2;
                            field_idx <= 0;
                        end
                    end else if (mode == 1) begin
                        addr_field[field_idx] <= nib_data;
                        if (field_idx == 7) begin
                            // Four 4-and-4 encoded values: volume, track,
                            // logical sector, XOR checksum.
                            volume = decode44(addr_field[0], addr_field[1]);
                            addr_track = decode44(addr_field[2], addr_field[3]);
                            addr_sector = decode44(addr_field[4], addr_field[5]);
                            addr_check = decode44(addr_field[6], nib_data);
                            pending_valid <= (addr_track == {2'b00,track}) &&
                                (addr_sector < 16) &&
                                ((volume ^ addr_track ^ addr_sector) == addr_check);
                            pending_sector <= addr_sector[3:0];
                            mode <= 0;
                        end else field_idx <= field_idx + 1'b1;
                    end else begin
                        encoded[field_idx] <= nib_data;
                        if (field_idx == 342) begin
                            mode <= 0;
                            pending_valid <= 0;
                            state <= DECODE;
                        end else field_idx <= field_idx + 1'b1;
                    end
                    prev2 <= prev1;
                    prev1 <= nib_data;
                    if (!(mode == 2 && field_idx == 342)) begin
                        if (scanned == 13'd6655)
                            state <= FINISH;
                        else
                            state <= REQ;
                    end
                end
                DECODE: begin
                    // XOR chain: 86 secondary symbols, 256 primary symbols,
                    // one final checksum symbol.
                    decode_ok = 1;
                    last_symbol = 0;
                    for (i=0; i<86; i=i+1) begin
                        if ((untranslate(encoded[i]) > 63)) decode_ok = 0;
                        last_symbol = last_symbol ^ untranslate(encoded[i]);
                        secondary[i] = {2'b00,last_symbol};
                    end
                    for (i=0; i<256; i=i+1) begin
                        if ((untranslate(encoded[86+i]) > 63)) decode_ok = 0;
                        last_symbol = last_symbol ^ untranslate(encoded[86+i]);
                        primary[i] = {2'b00,last_symbol};
                    end
                    if ((untranslate(encoded[342]) > 63) ||
                        (untranslate(encoded[342]) != last_symbol)) decode_ok = 0;
                    if (sector_mask[pending_sector]) decode_ok = 0;
                    if (!decode_ok) begin
                        error <= 1;
                        state <= FINISH;
                    end else begin
                        soft_sector <= logical_to_soft(pending_sector);
                        idx <= 0;
                        state <= OUTPUT;
                    end
                end
                OUTPUT: begin
                    // Inverse of the dsk2nib 2-bit packing:
                    // pair = ((src&2)>>1) | ((src&1)<<1)
                    j = idx % 86;
                    k = idx / 86;
                    decoded_byte = (primary[idx] << 2) |
                        ((secondary[j] >> (k*2)) & 2'h01) << 1 |
                        ((secondary[j] >> (k*2+1)) & 2'h01);
                    dsk_addr <= {soft_sector,8'h00} + idx[7:0];
                    dsk_data <= decoded_byte;
                    dsk_we <= 1;
                    if (idx == 255) begin
                        sector_mask[pending_sector] <= 1;
                        if (scanned >= 13'd6656) state <= FINISH;
                        else state <= REQ;
                    end else idx <= idx + 1'b1;
                end
                FINISH: begin
                    busy <= 0;
                    done <= 1;
                    if (sector_mask != 16'hffff) error <= 1;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
