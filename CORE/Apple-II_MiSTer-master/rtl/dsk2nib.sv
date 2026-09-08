// -----------------------------------------------------------------------------
// Apple II DSK -> NIB track converter
//
// Converts one standard 16-sector DOS-order .DSK track:
//
//      4096 bytes  (16 * 256)
//
// into one pre-nibblized Disk II track:
//
//      6656 bytes  (16 * 416)
//
// This implementation follows the MiSTer dsk2nib_lib.cpp read-side algorithm.
//
// Source RAM is synchronous.  dsk_addr selects one byte from the 4096-byte
// DSK track.  dsk_data is returned by the source RAM.
//
// Destination writes directly into the existing 6656-byte NIB track RAM.
//
// Image layout:
//      .DSK track : 4096 bytes
//      .NIB track : 6656 bytes ($1A00)
//
// -----------------------------------------------------------------------------

module dsk2nib
(
    input  wire        clk,
    input  wire        reset,

    input  wire        start,
    input  wire [5:0]  track,

    // -------------------------------------------------------------------------
    // 4096-byte DSK source RAM
    // -------------------------------------------------------------------------

    output reg  [11:0] dsk_addr,
    input  wire [7:0]  dsk_data,

    // -------------------------------------------------------------------------
    // 6656-byte NIB destination RAM
    // -------------------------------------------------------------------------

    output reg  [12:0] nib_addr,
    output reg  [7:0]  nib_data,
    output reg         nib_we,

    output reg         busy,
    output reg         done
);


// -----------------------------------------------------------------------------
// State machine
// -----------------------------------------------------------------------------

localparam [5:0]
    ST_IDLE             = 0,

    ST_SECTOR_START     = 1,

    ST_GAP1             = 2,

    ST_ADDR_PROLOG      = 3,
    ST_ADDR_VOLUME      = 4,
    ST_ADDR_TRACK       = 5,
    ST_ADDR_SECTOR      = 6,
    ST_ADDR_CHECKSUM    = 7,
    ST_ADDR_EPILOG      = 8,

    ST_GAP2             = 9,

    ST_DATA_PROLOG      = 10,

    ST_CLEAR_SECONDARY  = 11,

    ST_READ_DSK_ADDR    = 12,
    ST_READ_DSK_WAIT    = 13,
    ST_READ_DSK_DATA    = 14,

    ST_SECONDARY_FIRST  = 15,
    ST_SECONDARY_REST   = 16,

    ST_PRIMARY_FIRST    = 17,
    ST_PRIMARY_REST     = 18,

    ST_DATA_CHECKSUM    = 19,
    ST_DATA_EPILOG      = 20,

    ST_NEXT_SECTOR      = 21,
    ST_DONE             = 22;

reg [5:0] state;


// -----------------------------------------------------------------------------
// Working registers
// -----------------------------------------------------------------------------

reg [3:0] phys_sector;
reg [3:0] logical_sector;
reg [3:0] soft_sector;

reg [8:0] byte_index;

reg [8:0] gap_count;
reg [2:0] field_index;

reg       odd_even_phase;

reg [7:0] address_value;

reg [7:0] previous_value;
reg [7:0] current_value;


// -----------------------------------------------------------------------------
// Buffers used by the original 6-and-2 algorithm
//
// primary_buf[i]   = source byte >> 2
//
// secondary_buf[] contains the low two bits of the source bytes packed
// three source bytes per secondary entry.
// -----------------------------------------------------------------------------

reg [7:0] primary_buf   [0:255];
reg [7:0] secondary_buf [0:85];


// -----------------------------------------------------------------------------
// Translation table
//
// Exact table from dsk2nib_lib.cpp.
// -----------------------------------------------------------------------------

function automatic [7:0] translate;
    input [5:0] value;

    begin
        case (value)

            6'h00: translate = 8'h96;
            6'h01: translate = 8'h97;
            6'h02: translate = 8'h9A;
            6'h03: translate = 8'h9B;
            6'h04: translate = 8'h9D;
            6'h05: translate = 8'h9E;
            6'h06: translate = 8'h9F;
            6'h07: translate = 8'hA6;

            6'h08: translate = 8'hA7;
            6'h09: translate = 8'hAB;
            6'h0A: translate = 8'hAC;
            6'h0B: translate = 8'hAD;
            6'h0C: translate = 8'hAE;
            6'h0D: translate = 8'hAF;
            6'h0E: translate = 8'hB2;
            6'h0F: translate = 8'hB3;

            6'h10: translate = 8'hB4;
            6'h11: translate = 8'hB5;
            6'h12: translate = 8'hB6;
            6'h13: translate = 8'hB7;
            6'h14: translate = 8'hB9;
            6'h15: translate = 8'hBA;
            6'h16: translate = 8'hBB;
            6'h17: translate = 8'hBC;

            6'h18: translate = 8'hBD;
            6'h19: translate = 8'hBE;
            6'h1A: translate = 8'hBF;
            6'h1B: translate = 8'hCB;
            6'h1C: translate = 8'hCD;
            6'h1D: translate = 8'hCE;
            6'h1E: translate = 8'hCF;
            6'h1F: translate = 8'hD3;

            6'h20: translate = 8'hD6;
            6'h21: translate = 8'hD7;
            6'h22: translate = 8'hD9;
            6'h23: translate = 8'hDA;
            6'h24: translate = 8'hDB;
            6'h25: translate = 8'hDC;
            6'h26: translate = 8'hDD;
            6'h27: translate = 8'hDE;

            6'h28: translate = 8'hDF;
            6'h29: translate = 8'hE5;
            6'h2A: translate = 8'hE6;
            6'h2B: translate = 8'hE7;
            6'h2C: translate = 8'hE9;
            6'h2D: translate = 8'hEA;
            6'h2E: translate = 8'hEB;
            6'h2F: translate = 8'hEC;

            6'h30: translate = 8'hED;
            6'h31: translate = 8'hEE;
            6'h32: translate = 8'hEF;
            6'h33: translate = 8'hF2;
            6'h34: translate = 8'hF3;
            6'h35: translate = 8'hF4;
            6'h36: translate = 8'hF5;
            6'h37: translate = 8'hF6;

            6'h38: translate = 8'hF7;
            6'h39: translate = 8'hF9;
            6'h3A: translate = 8'hFA;
            6'h3B: translate = 8'hFB;
            6'h3C: translate = 8'hFC;
            6'h3D: translate = 8'hFD;
            6'h3E: translate = 8'hFE;
            6'h3F: translate = 8'hFF;

        endcase
    end
endfunction


// -----------------------------------------------------------------------------
// Physical -> logical sector
//
// C++:
//
// phys_interleave =
//     { 0,D,B,9,7,5,3,1,E,C,A,8,6,4,2,F };
//
// phys_to_logical_sector() searches this table and returns its index.
// -----------------------------------------------------------------------------

function automatic [3:0] phys_to_logical;
    input [3:0] phys;

    begin
        case (phys)
            4'h0: phys_to_logical = 4'h0;
            4'h1: phys_to_logical = 4'h7;
            4'h2: phys_to_logical = 4'hE;
            4'h3: phys_to_logical = 4'h6;
            4'h4: phys_to_logical = 4'hD;
            4'h5: phys_to_logical = 4'h5;
            4'h6: phys_to_logical = 4'hC;
            4'h7: phys_to_logical = 4'h4;
            4'h8: phys_to_logical = 4'hB;
            4'h9: phys_to_logical = 4'h3;
            4'hA: phys_to_logical = 4'hA;
            4'hB: phys_to_logical = 4'h2;
            4'hC: phys_to_logical = 4'h9;
            4'hD: phys_to_logical = 4'h1;
            4'hE: phys_to_logical = 4'h8;
            4'hF: phys_to_logical = 4'hF;
        endcase
    end
endfunction


// -----------------------------------------------------------------------------
// Logical -> DSK soft sector
//
// Exact soft_interleave table:
//
//     { 0,7,E,6,D,5,C,4,B,3,A,2,9,1,8,F }
// -----------------------------------------------------------------------------

function automatic [3:0] logical_to_soft;
    input [3:0] logical;

    begin
        case (logical)
            4'h0: logical_to_soft = 4'h0;
            4'h1: logical_to_soft = 4'h7;
            4'h2: logical_to_soft = 4'hE;
            4'h3: logical_to_soft = 4'h6;
            4'h4: logical_to_soft = 4'hD;
            4'h5: logical_to_soft = 4'h5;
            4'h6: logical_to_soft = 4'hC;
            4'h7: logical_to_soft = 4'h4;
            4'h8: logical_to_soft = 4'hB;
            4'h9: logical_to_soft = 4'h3;
            4'hA: logical_to_soft = 4'hA;
            4'hB: logical_to_soft = 4'h2;
            4'hC: logical_to_soft = 4'h9;
            4'hD: logical_to_soft = 4'h1;
            4'hE: logical_to_soft = 4'h8;
            4'hF: logical_to_soft = 4'hF;
        endcase
    end
endfunction


// -----------------------------------------------------------------------------
// Odd/even encoding helpers
//
// C++:
//
// a[0] = ((i >> 1) & $55) | $AA
// a[1] = ( i       & $55) | $AA
// -----------------------------------------------------------------------------

function automatic [7:0] odd_even_0;
    input [7:0] value;
    begin
        odd_even_0 = ((value >> 1) & 8'h55) | 8'hAA;
    end
endfunction

function automatic [7:0] odd_even_1;
    input [7:0] value;
    begin
        odd_even_1 = (value & 8'h55) | 8'hAA;
    end
endfunction


// -----------------------------------------------------------------------------
// Destination write helper is implemented directly through nib_we/nib_data.
// nib_addr is incremented after every emitted byte.
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Main converter
// -----------------------------------------------------------------------------

integer sec_index;
integer section_index;

reg [7:0] source_byte;
reg [7:0] pair_value;
reg [7:0] secondary_old;

always @(posedge clk) begin

    if (reset) begin

        state           <= ST_IDLE;

        dsk_addr        <= 12'd0;

        nib_addr        <= 13'd0;
        nib_data        <= 8'd0;
        nib_we          <= 1'b0;

        busy            <= 1'b0;
        done            <= 1'b0;

        phys_sector     <= 4'd0;
        logical_sector  <= 4'd0;
        soft_sector     <= 4'd0;

        byte_index      <= 9'd0;
        gap_count       <= 9'd0;
        field_index     <= 3'd0;

        odd_even_phase  <= 1'b0;
        address_value   <= 8'd0;

        previous_value  <= 8'd0;
        current_value   <= 8'd0;

    end
    else begin

        nib_we <= 1'b0;
        done   <= 1'b0;

        case (state)

            // -----------------------------------------------------------------
            // Wait for a conversion request
            // -----------------------------------------------------------------

            ST_IDLE: begin

                busy <= 1'b0;

                if (start) begin

                    busy           <= 1'b1;

                    nib_addr       <= 13'd0;
                    phys_sector    <= 4'd0;

                    state          <= ST_SECTOR_START;

                end
            end


            // -----------------------------------------------------------------
            // Start one 416-byte physical NIB sector
            // -----------------------------------------------------------------

            ST_SECTOR_START: begin

                logical_sector <= phys_to_logical(phys_sector);
                soft_sector    <= logical_to_soft(
                                      phys_to_logical(phys_sector)
                                  );

                gap_count <= 0;
                state     <= ST_GAP1;

            end


            // -----------------------------------------------------------------
            // GAP 1: 48 x FF
            // -----------------------------------------------------------------

            ST_GAP1: begin

                nib_data <= 8'hFF;
                nib_we   <= 1'b1;
                nib_addr <= nib_addr + 1'b1;

                if (gap_count == 47) begin
                    field_index <= 0;
                    state       <= ST_ADDR_PROLOG;
                end
                else begin
                    gap_count <= gap_count + 1'b1;
                end

            end


            // -----------------------------------------------------------------
            // Address prolog: D5 AA 96
            // -----------------------------------------------------------------

            ST_ADDR_PROLOG: begin

                nib_we   <= 1'b1;
                nib_addr <= nib_addr + 1'b1;

                case (field_index)
                    0: nib_data <= 8'hD5;
                    1: nib_data <= 8'hAA;
                    2: nib_data <= 8'h96;
                    default: nib_data <= 8'hFF;
                endcase

                if (field_index == 2) begin
                    field_index    <= 0;
                    address_value  <= 8'hFE;
                    odd_even_phase <= 0;
                    state          <= ST_ADDR_VOLUME;
                end
                else begin
                    field_index <= field_index + 1'b1;
                end

            end


            // -----------------------------------------------------------------
            // Address volume: FE
            // -----------------------------------------------------------------

            ST_ADDR_VOLUME: begin

                nib_we   <= 1'b1;
                nib_addr <= nib_addr + 1'b1;

                if (!odd_even_phase) begin
                    nib_data       <= odd_even_0(8'hFE);
                    odd_even_phase <= 1'b1;
                end
                else begin
                    nib_data       <= odd_even_1(8'hFE);
                    odd_even_phase <= 1'b0;
                    state          <= ST_ADDR_TRACK;
                end

            end


            // -----------------------------------------------------------------
            // Address track
            // -----------------------------------------------------------------

            ST_ADDR_TRACK: begin

                nib_we   <= 1'b1;
                nib_addr <= nib_addr + 1'b1;

                if (!odd_even_phase) begin
                    nib_data       <= odd_even_0({2'b00, track});
                    odd_even_phase <= 1'b1;
                end
                else begin
                    nib_data       <= odd_even_1({2'b00, track});
                    odd_even_phase <= 1'b0;
                    state          <= ST_ADDR_SECTOR;
                end

            end


            // -----------------------------------------------------------------
            // Address logical sector
            // -----------------------------------------------------------------

            ST_ADDR_SECTOR: begin

                nib_we   <= 1'b1;
                nib_addr <= nib_addr + 1'b1;

                if (!odd_even_phase) begin
                    nib_data       <= odd_even_0({4'b0000, logical_sector});
                    odd_even_phase <= 1'b1;
                end
                else begin
                    nib_data       <= odd_even_1({4'b0000, logical_sector});
                    odd_even_phase <= 1'b0;
                    state          <= ST_ADDR_CHECKSUM;
                end

            end


            // -----------------------------------------------------------------
            // Address checksum = volume ^ track ^ logical sector
            // -----------------------------------------------------------------

            ST_ADDR_CHECKSUM: begin

                nib_we   <= 1'b1;
                nib_addr <= nib_addr + 1'b1;

                address_value <=
                    8'hFE ^
                    {2'b00, track} ^
                    {4'b0000, logical_sector};

                if (!odd_even_phase) begin

                    nib_data <= odd_even_0(
                        8'hFE ^
                        {2'b00, track} ^
                        {4'b0000, logical_sector}
                    );

                    odd_even_phase <= 1'b1;

                end
                else begin

                    nib_data <= odd_even_1(
                        8'hFE ^
                        {2'b00, track} ^
                        {4'b0000, logical_sector}
                    );

                    odd_even_phase <= 1'b0;
                    field_index    <= 0;
                    state          <= ST_ADDR_EPILOG;

                end

            end


            // -----------------------------------------------------------------
            // Address epilog: DE AA EB
            // -----------------------------------------------------------------

            ST_ADDR_EPILOG: begin

                nib_we   <= 1'b1;
                nib_addr <= nib_addr + 1'b1;

                case (field_index)
                    0: nib_data <= 8'hDE;
                    1: nib_data <= 8'hAA;
                    2: nib_data <= 8'hEB;
                    default: nib_data <= 8'hFF;
                endcase

                if (field_index == 2) begin
                    gap_count <= 0;
                    state     <= ST_GAP2;
                end
                else begin
                    field_index <= field_index + 1'b1;
                end

            end


            // -----------------------------------------------------------------
            // GAP 2: 5 x FF
            // -----------------------------------------------------------------

            ST_GAP2: begin

                nib_data <= 8'hFF;
                nib_we   <= 1'b1;
                nib_addr <= nib_addr + 1'b1;

                if (gap_count == 4) begin
                    field_index <= 0;
                    state       <= ST_DATA_PROLOG;
                end
                else begin
                    gap_count <= gap_count + 1'b1;
                end

            end


            // -----------------------------------------------------------------
            // Data prolog: D5 AA AD
            // -----------------------------------------------------------------

            ST_DATA_PROLOG: begin

                nib_we   <= 1'b1;
                nib_addr <= nib_addr + 1'b1;

                case (field_index)
                    0: nib_data <= 8'hD5;
                    1: nib_data <= 8'hAA;
                    2: nib_data <= 8'hAD;
                    default: nib_data <= 8'hFF;
                endcase

                if (field_index == 2) begin
                    byte_index <= 0;
                    state      <= ST_CLEAR_SECONDARY;
                end
                else begin
                    field_index <= field_index + 1'b1;
                end

            end


            // -----------------------------------------------------------------
            // Clear the 86-byte secondary buffer
            // -----------------------------------------------------------------

            ST_CLEAR_SECONDARY: begin

                secondary_buf[byte_index] <= 8'h00;

                if (byte_index == 85) begin
                    byte_index <= 0;
                    state      <= ST_READ_DSK_ADDR;
                end
                else begin
                    byte_index <= byte_index + 1'b1;
                end

            end


            // -----------------------------------------------------------------
            // Request source byte
            //
            // DSK source RAM layout:
            //
            //     soft_sector * 256 + byte_index
            // -----------------------------------------------------------------

            ST_READ_DSK_ADDR: begin

                dsk_addr <=
                    {soft_sector, 8'h00} +
                    byte_index[7:0];

                state <= ST_READ_DSK_WAIT;

            end


            // -----------------------------------------------------------------
            // Account for synchronous source RAM
            // -----------------------------------------------------------------

            ST_READ_DSK_WAIT: begin
                state <= ST_READ_DSK_DATA;
            end


            // -----------------------------------------------------------------
            // Build primary and secondary buffers
            //
            // C++:
            //
            // primary[i] = src[i] >> 2;
            //
            // index   = i % 86;
            // section = i / 86;
            //
            // pair = ((src[i]&2)>>1) | ((src[i]&1)<<1);
            // secondary[index] |= pair << (section*2);
            // -----------------------------------------------------------------

            ST_READ_DSK_DATA: begin

                source_byte = dsk_data;

                primary_buf[byte_index[7:0]] <=
                    source_byte >> 2;

                sec_index = byte_index % 86;
                section_index = byte_index / 86;

                pair_value =
                    ((source_byte & 8'h02) >> 1) |
                    ((source_byte & 8'h01) << 1);

                secondary_old = secondary_buf[sec_index];

                secondary_buf[sec_index] <=
                    secondary_old |
                    (pair_value << (section_index * 2));

                if (byte_index == 255) begin
                    byte_index     <= 0;
                    previous_value <= 0;
                    state          <= ST_SECONDARY_FIRST;
                end
                else begin
                    byte_index <= byte_index + 1'b1;
                    state      <= ST_READ_DSK_ADDR;
                end

            end


            // -----------------------------------------------------------------
            // First secondary byte
            //
            // dest[0] = translate(secondary[0])
            // -----------------------------------------------------------------

            ST_SECONDARY_FIRST: begin

                nib_data <= translate(secondary_buf[0][5:0]);
                nib_we   <= 1'b1;
                nib_addr <= nib_addr + 1'b1;

                previous_value <= secondary_buf[0];
                byte_index     <= 1;

                state <= ST_SECONDARY_REST;

            end


            // -----------------------------------------------------------------
            // Remaining secondary bytes
            //
            // translate(secondary[i] ^ secondary[i-1])
            // -----------------------------------------------------------------

            ST_SECONDARY_REST: begin

                current_value = secondary_buf[byte_index];

                nib_data <= translate(
                    (current_value ^ previous_value) & 8'h3F
                );

                nib_we   <= 1'b1;
                nib_addr <= nib_addr + 1'b1;

                previous_value <= current_value;

                if (byte_index == 85) begin
                    byte_index <= 0;
                    state      <= ST_PRIMARY_FIRST;
                end
                else begin
                    byte_index <= byte_index + 1'b1;
                end

            end


            // -----------------------------------------------------------------
            // First primary byte
            //
            // translate(primary[0] ^ secondary[85])
            // -----------------------------------------------------------------

            ST_PRIMARY_FIRST: begin

                nib_data <= translate(
                    (primary_buf[0] ^ secondary_buf[85]) & 8'h3F
                );

                nib_we   <= 1'b1;
                nib_addr <= nib_addr + 1'b1;

                previous_value <= primary_buf[0];
                byte_index     <= 1;

                state <= ST_PRIMARY_REST;

            end


            // -----------------------------------------------------------------
            // Remaining primary bytes
            //
            // translate(primary[i] ^ primary[i-1])
            // -----------------------------------------------------------------

            ST_PRIMARY_REST: begin

                current_value = primary_buf[byte_index];

                nib_data <= translate(
                    (current_value ^ previous_value) & 8'h3F
                );

                nib_we   <= 1'b1;
                nib_addr <= nib_addr + 1'b1;

                previous_value <= current_value;

                if (byte_index == 255) begin
                    state <= ST_DATA_CHECKSUM;
                end
                else begin
                    byte_index <= byte_index + 1'b1;
                end

            end


            // -----------------------------------------------------------------
            // Data checksum
            //
            // translate(primary[255])
            // -----------------------------------------------------------------

            ST_DATA_CHECKSUM: begin

                nib_data <= translate(primary_buf[255][5:0]);
                nib_we   <= 1'b1;
                nib_addr <= nib_addr + 1'b1;

                field_index <= 0;
                state       <= ST_DATA_EPILOG;

            end


            // -----------------------------------------------------------------
            // Data epilog: DE AA EB
            // -----------------------------------------------------------------

            ST_DATA_EPILOG: begin

                nib_we   <= 1'b1;
                nib_addr <= nib_addr + 1'b1;

                case (field_index)
                    0: nib_data <= 8'hDE;
                    1: nib_data <= 8'hAA;
                    2: nib_data <= 8'hEB;
                    default: nib_data <= 8'hFF;
                endcase

                if (field_index == 2)
                    state <= ST_NEXT_SECTOR;
                else
                    field_index <= field_index + 1'b1;

            end


            // -----------------------------------------------------------------
            // Next physical sector
            // -----------------------------------------------------------------

            ST_NEXT_SECTOR: begin

                if (phys_sector == 15) begin
                    state <= ST_DONE;
                end
                else begin
                    phys_sector <= phys_sector + 1'b1;
                    state       <= ST_SECTOR_START;
                end

            end


            // -----------------------------------------------------------------
            // Finished complete 6656-byte track
            // -----------------------------------------------------------------

            ST_DONE: begin

                busy <= 1'b0;
                done <= 1'b1;

                state <= ST_IDLE;

            end


            default: begin
                state <= ST_IDLE;
            end

        endcase
    end
end

endmodule