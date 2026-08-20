---------------------------------------------------------------------------------------------------------
-- MiSTer2MEGA65 Framework
--
-- Custom keyboard controller for Apple IIe core.
--
-- Runs in the clock domain of the core.
--
-- MiSTer2MEGA65 provides the MEGA65 keyboard as a continuously scanned
-- key number (0..79) together with an active-low debounced key state.
--
-- This module:
--
--   1. Reconstructs the complete 80-key MEGA65 keyboard state.
--   2. Maps physical MEGA65 keys to Apple/PS2-style scan codes.
--   3. Provides an optional MEGA65 glyph-oriented keyboard layout.
--   4. Generates private pseudo scan codes for MEGA65-specific symbol keys.
--
-- The pseudo codes are interpreted by keyboard_apple.vhd.
--
-- MiSTer2MEGA65 done by sy2002 and MJoergen in 2022 and licensed under GPL v3
---------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity keyboard is
   port (
      clk_main_i       : in std_logic;
      reset_i          : in std_logic;

      ---------------------------------------------------------------------------
      -- Interface to the MEGA65 keyboard scanner
      ---------------------------------------------------------------------------

      key_num_i        : in integer range 0 to 79;
      key_pressed_n_i  : in std_logic;

      ---------------------------------------------------------------------------
      -- Keyboard layout
      --
      -- 0 = original Apple II positional layout
      -- 1 = MEGA65 glyph-oriented layout
      ---------------------------------------------------------------------------

      mega65_layout_i  : in std_logic;

      ---------------------------------------------------------------------------
      -- Apple II keyboard interface
      ---------------------------------------------------------------------------

      ps2_key_o        : out std_logic_vector(10 downto 0);
      mega65_alt_o     : out std_logic
   );
end keyboard;


architecture beh of keyboard is

   ---------------------------------------------------------------------------
   -- MEGA65 physical keyboard matrix positions
   ---------------------------------------------------------------------------

   constant m65_ins_del       : integer := 0;
   constant m65_return        : integer := 1;
   constant m65_horz_crsr     : integer := 2;
   constant m65_f7            : integer := 3;
   constant m65_f1            : integer := 4;
   constant m65_f3            : integer := 5;
   constant m65_f5            : integer := 6;
   constant m65_vert_crsr     : integer := 7;

   constant m65_3             : integer := 8;
   constant m65_w             : integer := 9;
   constant m65_a             : integer := 10;
   constant m65_4             : integer := 11;
   constant m65_z             : integer := 12;
   constant m65_s             : integer := 13;
   constant m65_e             : integer := 14;
   constant m65_left_shift    : integer := 15;

   constant m65_5             : integer := 16;
   constant m65_r             : integer := 17;
   constant m65_d             : integer := 18;
   constant m65_6             : integer := 19;
   constant m65_c             : integer := 20;
   constant m65_f             : integer := 21;
   constant m65_t             : integer := 22;
   constant m65_x             : integer := 23;

   constant m65_7             : integer := 24;
   constant m65_y             : integer := 25;
   constant m65_g             : integer := 26;
   constant m65_8             : integer := 27;
   constant m65_b             : integer := 28;
   constant m65_h             : integer := 29;
   constant m65_u             : integer := 30;
   constant m65_v             : integer := 31;

   constant m65_9             : integer := 32;
   constant m65_i             : integer := 33;
   constant m65_j             : integer := 34;
   constant m65_0             : integer := 35;
   constant m65_m             : integer := 36;
   constant m65_k             : integer := 37;
   constant m65_o             : integer := 38;
   constant m65_n             : integer := 39;

   constant m65_plus          : integer := 40;
   constant m65_p             : integer := 41;
   constant m65_l             : integer := 42;
   constant m65_minus         : integer := 43;
   constant m65_dot           : integer := 44;
   constant m65_colon         : integer := 45;
   constant m65_at            : integer := 46;
   constant m65_comma         : integer := 47;

   constant m65_gbp           : integer := 48;
   constant m65_asterisk      : integer := 49;
   constant m65_semicolon     : integer := 50;
   constant m65_clr_home      : integer := 51;
   constant m65_right_shift   : integer := 52;
   constant m65_equal         : integer := 53;
   constant m65_arrow_up      : integer := 54;  -- symbol, not cursor
   constant m65_slash         : integer := 55;

   constant m65_1             : integer := 56;
   constant m65_arrow_left    : integer := 57;  -- symbol, not cursor
   constant m65_ctrl          : integer := 58;
   constant m65_2             : integer := 59;
   constant m65_space         : integer := 60;
   constant m65_mega          : integer := 61;
   constant m65_q             : integer := 62;
   constant m65_run_stop      : integer := 63;

   constant m65_no_scrl       : integer := 64;
   constant m65_tab           : integer := 65;
   constant m65_alt           : integer := 66;
   constant m65_help          : integer := 67;
   constant m65_f9            : integer := 68;
   constant m65_f11           : integer := 69;
   constant m65_f13           : integer := 70;
   constant m65_esc           : integer := 71;

   constant m65_capslock      : integer := 72;
   constant m65_up_crsr       : integer := 73;
   constant m65_left_crsr     : integer := 74;
   constant m65_restore       : integer := 75;


   ---------------------------------------------------------------------------
   -- Apple / PS2 scan codes used by keyboard_apple
   ---------------------------------------------------------------------------

   constant apple_keycode_esc         : std_logic_vector(7 downto 0) := x"76";

   constant apple_keycode_1           : std_logic_vector(7 downto 0) := x"16";
   constant apple_keycode_2           : std_logic_vector(7 downto 0) := x"1E";
   constant apple_keycode_3           : std_logic_vector(7 downto 0) := x"26";
   constant apple_keycode_4           : std_logic_vector(7 downto 0) := x"25";
   constant apple_keycode_5           : std_logic_vector(7 downto 0) := x"2E";
   constant apple_keycode_6           : std_logic_vector(7 downto 0) := x"36";
   constant apple_keycode_7           : std_logic_vector(7 downto 0) := x"3D";
   constant apple_keycode_8           : std_logic_vector(7 downto 0) := x"3E";
   constant apple_keycode_9           : std_logic_vector(7 downto 0) := x"46";
   constant apple_keycode_0           : std_logic_vector(7 downto 0) := x"45";

   constant apple_keycode_tab         : std_logic_vector(7 downto 0) := x"0D";

   constant apple_keycode_q           : std_logic_vector(7 downto 0) := x"15";
   constant apple_keycode_w           : std_logic_vector(7 downto 0) := x"1D";
   constant apple_keycode_e           : std_logic_vector(7 downto 0) := x"24";
   constant apple_keycode_r           : std_logic_vector(7 downto 0) := x"2D";
   constant apple_keycode_t           : std_logic_vector(7 downto 0) := x"2C";
   constant apple_keycode_y           : std_logic_vector(7 downto 0) := x"35";
   constant apple_keycode_u           : std_logic_vector(7 downto 0) := x"3C";
   constant apple_keycode_i           : std_logic_vector(7 downto 0) := x"43";
   constant apple_keycode_o           : std_logic_vector(7 downto 0) := x"44";
   constant apple_keycode_p           : std_logic_vector(7 downto 0) := x"4D";

   constant apple_keycode_a           : std_logic_vector(7 downto 0) := x"1C";
   constant apple_keycode_s           : std_logic_vector(7 downto 0) := x"1B";
   constant apple_keycode_d           : std_logic_vector(7 downto 0) := x"23";
   constant apple_keycode_f           : std_logic_vector(7 downto 0) := x"2B";
   constant apple_keycode_g           : std_logic_vector(7 downto 0) := x"34";
   constant apple_keycode_h           : std_logic_vector(7 downto 0) := x"33";
   constant apple_keycode_j           : std_logic_vector(7 downto 0) := x"3B";
   constant apple_keycode_k           : std_logic_vector(7 downto 0) := x"42";
   constant apple_keycode_l           : std_logic_vector(7 downto 0) := x"4B";

   constant apple_keycode_z           : std_logic_vector(7 downto 0) := x"1A";
   constant apple_keycode_x           : std_logic_vector(7 downto 0) := x"22";
   constant apple_keycode_c           : std_logic_vector(7 downto 0) := x"21";
   constant apple_keycode_v           : std_logic_vector(7 downto 0) := x"2A";
   constant apple_keycode_b           : std_logic_vector(7 downto 0) := x"32";
   constant apple_keycode_n           : std_logic_vector(7 downto 0) := x"31";
   constant apple_keycode_m           : std_logic_vector(7 downto 0) := x"3A";

   constant apple_keycode_semicolon   : std_logic_vector(7 downto 0) := x"4C";
   constant apple_keycode_comma       : std_logic_vector(7 downto 0) := x"41";
   constant apple_keycode_period      : std_logic_vector(7 downto 0) := x"49";
   constant apple_keycode_slash       : std_logic_vector(7 downto 0) := x"4A";

   constant apple_keycode_space       : std_logic_vector(7 downto 0) := x"29";
   constant apple_keycode_return      : std_logic_vector(7 downto 0) := x"5A";
   constant apple_keycode_delete      : std_logic_vector(7 downto 0) := x"71";

   constant apple_keycode_lshift      : std_logic_vector(7 downto 0) := x"12";
   constant apple_keycode_rshift      : std_logic_vector(7 downto 0) := x"59";
   constant apple_keycode_capslock    : std_logic_vector(7 downto 0) := x"58";
   constant apple_keycode_ctrl        : std_logic_vector(7 downto 0) := x"14";

   constant apple_keycode_openapple   : std_logic_vector(7 downto 0) := x"1F";
   constant apple_keycode_closedapple : std_logic_vector(7 downto 0) := x"11";

   constant apple_keycode_up          : std_logic_vector(7 downto 0) := x"75";
   constant apple_keycode_down        : std_logic_vector(7 downto 0) := x"72";
   constant apple_keycode_left        : std_logic_vector(7 downto 0) := x"6B";
   constant apple_keycode_right       : std_logic_vector(7 downto 0) := x"74";

   constant apple_keycode_quote       : std_logic_vector(7 downto 0) := x"52";
   constant apple_keycode_backtick    : std_logic_vector(7 downto 0) := x"5D";
   constant apple_keycode_sqbrack_l   : std_logic_vector(7 downto 0) := x"54";
   constant apple_keycode_sqbrack_r   : std_logic_vector(7 downto 0) := x"5B";
   constant apple_keycode_minus       : std_logic_vector(7 downto 0) := x"4E";
   constant apple_keycode_equal       : std_logic_vector(7 downto 0) := x"55";
   constant apple_keycode_backslash   : std_logic_vector(7 downto 0) := x"0E";

   constant apple_keycode_reset       : std_logic_vector(7 downto 0) := x"06";
   


   ---------------------------------------------------------------------------
   -- Private MEGA65 pseudo scan codes
   --
   -- These are not real PS/2 codes.
   --
   -- keyboard_apple interprets these to reproduce glyphs that don't have
   -- a simple one-to-one physical Apple keyboard equivalent.
   ---------------------------------------------------------------------------

   constant m65_code_colon       : std_logic_vector(7 downto 0) := x"F0"; -- :
   constant m65_code_at          : std_logic_vector(7 downto 0) := x"F1"; -- @ / {
   constant m65_code_asterisk    : std_logic_vector(7 downto 0) := x"F2"; -- * / }
   constant m65_code_plus        : std_logic_vector(7 downto 0) := x"F3"; -- +

   constant m65_code_dquote      : std_logic_vector(7 downto 0) := x"F4"; -- "
   constant m65_code_ampersand   : std_logic_vector(7 downto 0) := x"F5"; -- &
   constant m65_code_quote       : std_logic_vector(7 downto 0) := x"F6"; -- '
   constant m65_code_lparen      : std_logic_vector(7 downto 0) := x"F7"; -- (
   constant m65_code_rparen      : std_logic_vector(7 downto 0) := x"F8"; -- )
   constant m65_code_hash        : std_logic_vector(7 downto 0) := x"F9"; -- # / £

   -- Deliberately ignored by keyboard_apple.
   constant m65_code_noop        : std_logic_vector(7 downto 0) := x"FA";

   -- Dedicated MEGA65 ; key.
   -- keyboard_apple dynamically maps Shift+; to ].
   constant m65_code_semicolon   : std_logic_vector(7 downto 0) := x"FB";
   
   constant m65_code_backtick    : std_logic_vector(7 downto 0) := x"FC";
   constant m65_code_comma       : std_logic_vector(7 downto 0) := x"EC";
   constant m65_code_dot         : std_logic_vector(7 downto 0) := x"ED";
   constant m65_code_slash       : std_logic_vector(7 downto 0) := x"EE";
   constant m65_code_equal       : std_logic_vector(7 downto 0) := x"EB";
   ---------------------------------------------------------------------------
   -- Mapping arrays
   ---------------------------------------------------------------------------

   type slv8_array is array (0 to 64) of std_logic_vector(7 downto 0);


   ---------------------------------------------------------------------------
   -- Physical keys represented by the translation arrays
   ---------------------------------------------------------------------------

   constant m65_keys : integer_vector := (

       0 => m65_ins_del,
       1 => m65_return,
       2 => m65_0,
       3 => m65_1,
       4 => m65_2,
       5 => m65_3,
       6 => m65_4,
       7 => m65_5,
       8 => m65_6,
       9 => m65_7,
      10 => m65_8,
      11 => m65_9,
      12 => m65_a,
      13 => m65_b,
      14 => m65_c,
      15 => m65_d,
      16 => m65_e,
      17 => m65_f,
      18 => m65_g,
      19 => m65_h,
      20 => m65_i,
      21 => m65_j,
      22 => m65_k,
      23 => m65_l,
      24 => m65_m,
      25 => m65_n,
      26 => m65_o,
      27 => m65_p,
      28 => m65_q,
      29 => m65_r,
      30 => m65_s,
      31 => m65_t,
      32 => m65_u,
      33 => m65_v,
      34 => m65_w,
      35 => m65_x,
      36 => m65_y,
      37 => m65_z,

      38 => m65_left_shift,
      39 => m65_right_shift,
      40 => m65_capslock,
      41 => m65_esc,
      42 => m65_ctrl,
      43 => m65_tab,

      44 => m65_comma,
      45 => m65_dot,

      46 => m65_mega,           -- Open Apple

      47 => m65_up_crsr,
      48 => m65_vert_crsr,
      49 => m65_left_crsr,
      50 => m65_horz_crsr,

      51 => m65_slash,
      52 => m65_colon,
      53 => m65_semicolon,
      54 => m65_equal,
      55 => m65_at,
      56 => m65_asterisk,
      57 => m65_plus,
      58 => m65_minus,

      59 => m65_restore,        -- Closed Apple

      -- MEGA65/C64-style ↑ symbol key.
      60 => m65_arrow_up,

      61 => m65_space,

      -- CTRL+F13 is used for Apple soft reset.
      62 => m65_f13,

      -- Dedicated £/# key.
      63 => m65_gbp,

      -- MEGA65/C64-style ← symbol key.
      64 => m65_arrow_left
   );


   ---------------------------------------------------------------------------
   -- Original Apple positional keyboard mapping
   ---------------------------------------------------------------------------

   constant ps2_codes_apple : slv8_array := (

       0 => apple_keycode_delete,
       1 => apple_keycode_return,
       2 => apple_keycode_0,
       3 => apple_keycode_1,
       4 => apple_keycode_2,
       5 => apple_keycode_3,
       6 => apple_keycode_4,
       7 => apple_keycode_5,
       8 => apple_keycode_6,
       9 => apple_keycode_7,
      10 => apple_keycode_8,
      11 => apple_keycode_9,
      12 => apple_keycode_a,
      13 => apple_keycode_b,
      14 => apple_keycode_c,
      15 => apple_keycode_d,
      16 => apple_keycode_e,
      17 => apple_keycode_f,
      18 => apple_keycode_g,
      19 => apple_keycode_h,
      20 => apple_keycode_i,
      21 => apple_keycode_j,
      22 => apple_keycode_k,
      23 => apple_keycode_l,
      24 => apple_keycode_m,
      25 => apple_keycode_n,
      26 => apple_keycode_o,
      27 => apple_keycode_p,
      28 => apple_keycode_q,
      29 => apple_keycode_r,
      30 => apple_keycode_s,
      31 => apple_keycode_t,
      32 => apple_keycode_u,
      33 => apple_keycode_v,
      34 => apple_keycode_w,
      35 => apple_keycode_x,
      36 => apple_keycode_y,
      37 => apple_keycode_z,
      38 => apple_keycode_lshift,
      39 => apple_keycode_rshift,
      40 => apple_keycode_capslock,
      41 => apple_keycode_esc,
      42 => apple_keycode_ctrl,
      43 => apple_keycode_tab,
      44 => apple_keycode_comma,
      45 => apple_keycode_period,
      46 => apple_keycode_openapple,
      47 => apple_keycode_up,
      48 => apple_keycode_down,
      49 => apple_keycode_left,
      50 => apple_keycode_right,

      ------------------------------------------------------------------------
      -- Original positional mapping
      ------------------------------------------------------------------------

      51 => apple_keycode_slash,
      52 => apple_keycode_semicolon,
      53 => apple_keycode_quote,
      54 => apple_keycode_backtick,
      55 => apple_keycode_sqbrack_l,
      56 => apple_keycode_sqbrack_r,
      57 => apple_keycode_minus,
      58 => apple_keycode_equal,
      59 => apple_keycode_closedapple,
      60 => m65_code_noop,
      61 => apple_keycode_space,
      62 => apple_keycode_reset,
      -- Additional MEGA65 keys not present in the original positional map.
      63 => m65_code_hash,
      64 => m65_code_noop
   );


   ---------------------------------------------------------------------------
   -- MEGA65 glyph-oriented keyboard mapping
   ---------------------------------------------------------------------------

   constant ps2_codes_mega65 : slv8_array := (

       0 => apple_keycode_delete,
       1 => apple_keycode_return,
       2 => apple_keycode_0,
       3 => apple_keycode_1,
       4 => apple_keycode_2,
       5 => apple_keycode_3,
       6 => apple_keycode_4,
       7 => apple_keycode_5,
       8 => apple_keycode_6,
       9 => apple_keycode_7,
      10 => apple_keycode_8,
      11 => apple_keycode_9,
      12 => apple_keycode_a,
      13 => apple_keycode_b,
      14 => apple_keycode_c,
      15 => apple_keycode_d,
      16 => apple_keycode_e,
      17 => apple_keycode_f,
      18 => apple_keycode_g,
      19 => apple_keycode_h,
      20 => apple_keycode_i,
      21 => apple_keycode_j,
      22 => apple_keycode_k,
      23 => apple_keycode_l,
      24 => apple_keycode_m,
      25 => apple_keycode_n,
      26 => apple_keycode_o,
      27 => apple_keycode_p,
      28 => apple_keycode_q,
      29 => apple_keycode_r,
      30 => apple_keycode_s,
      31 => apple_keycode_t,
      32 => apple_keycode_u,
      33 => apple_keycode_v,
      34 => apple_keycode_w,
      35 => apple_keycode_x,
      36 => apple_keycode_y,
      37 => apple_keycode_z,
      38 => apple_keycode_lshift,
      39 => apple_keycode_rshift,
      40 => apple_keycode_capslock,
      41 => apple_keycode_esc,
      42 => apple_keycode_ctrl,
      43 => apple_keycode_tab,
      44 => m65_code_comma,   -- , / ALT -> ~
      45 => m65_code_dot,     -- . / ALT -> |
      46 => apple_keycode_openapple,
      47 => apple_keycode_up,
      48 => apple_keycode_down,
      49 => apple_keycode_left,
      50 => apple_keycode_right,

      ------------------------------------------------------------------------
      -- Dedicated MEGA65 symbol keys
      --
      -- keyboard_apple handles the shifted interpretation dynamically.
      ------------------------------------------------------------------------

      51 => m65_code_slash,             -- /

      52 => m65_code_colon,            -- :
                                         -- Shift -> [

      53 => m65_code_semicolon,        -- ;
                                         -- Shift -> ]

      54 => m65_code_equal,             -- = / ALT -> _

      55 => m65_code_at,               -- @
                                         -- Shift -> {

      56 => m65_code_asterisk,         -- *
                                         -- Shift -> }

      57 => m65_code_plus,             -- +

      58 => apple_keycode_minus,       -- -

      59 => apple_keycode_closedapple,


      ------------------------------------------------------------------------
      -- MEGA65 ↑ key
      --
      -- MEGA65 has no dedicated backslash key.
      --
      -- ↑       -> \
      -- Shift+↑ -> |
      ------------------------------------------------------------------------

      60 => m65_code_noop,       -- MEGA65 ↑ power key unused


      61 => apple_keycode_space,

      62 => apple_keycode_reset,


      ------------------------------------------------------------------------
      -- MEGA65 £/# key
      --
      -- Produces the same Apple matrix position as Shift+3.
      -- Actual displayed glyph depends on selected Apple character/video ROM.
      ------------------------------------------------------------------------

      63 => m65_code_hash,


      ------------------------------------------------------------------------
      -- MEGA65 ← key
      --
      -- Repurposed for the Apple ` / ~ key:
      --
      -- ←       -> `
      -- Shift+← -> ~
      ------------------------------------------------------------------------

      64 => m65_code_noop
   );


   ---------------------------------------------------------------------------
   -- Internal MEGA65 keyboard state
   ---------------------------------------------------------------------------

   signal key_pressed_n :
      std_logic_vector(79 downto 0) := (others => '1');


   ---------------------------------------------------------------------------
   -- Apple keyboard event state
   ---------------------------------------------------------------------------

   signal toggle_bit :
      std_logic := '0';

   signal prev_keyboard_n :
      std_logic_vector(79 downto 0) := (others => '1');


begin

   mega65_alt_o <= not key_pressed_n(m65_alt);

   ---------------------------------------------------------------------------
   -- Reconstruct complete MEGA65 keyboard state
   --
   -- M2M scans keys 0..79 and supplies one debounced key state at a time.
   ---------------------------------------------------------------------------

   keyboard_state : process(clk_main_i)
   begin

      if rising_edge(clk_main_i) then
         if reset_i = '1' then
            key_pressed_n <= (others => '1');
         else
            key_pressed_n(key_num_i) <= key_pressed_n_i;
         end if;
      end if;
   end process keyboard_state;


   ---------------------------------------------------------------------------
   -- MEGA65 key -> Apple PS/2-style event converter
   --
   -- ps2_key_o:
   --
   -- bit 10       = event toggle
   -- bit 9        = 1 press / 0 release
   -- bit 8        = extended PS/2 flag
   -- bits 7..0    = scan code / private pseudo code
   ---------------------------------------------------------------------------

   keyboard_map_proc : process(clk_main_i)

      variable toggled : std_logic;

   begin

      if rising_edge(clk_main_i) then

         if reset_i = '1' then
            toggle_bit      <= '0';
            ps2_key_o       <= (others => '0');
            prev_keyboard_n <= (others => '1');

         else

            -------------------------------------------------------------------
            -- Look for changes in any key that participates in our Apple map.
            -------------------------------------------------------------------

            for current_key_index in
               ps2_codes_apple'low to ps2_codes_apple'high
            loop


               if
                  key_pressed_n(m65_keys(current_key_index)) /=
                  prev_keyboard_n(m65_keys(current_key_index))
               then


                  --------------------------------------------------------------
                  -- Remember new physical key state
                  --------------------------------------------------------------

                  prev_keyboard_n(m65_keys(current_key_index))
                     <= key_pressed_n(m65_keys(current_key_index));


                  --------------------------------------------------------------
                  -- Generate a new event toggle
                  --------------------------------------------------------------

                  toggled    := not toggle_bit;
                  toggle_bit <= toggled;
                  ps2_key_o(10) <= toggled;


                  --------------------------------------------------------------
                  -- Key state
                  --
                  -- MEGA65:
                  --     0 = pressed
                  --     1 = released
                  --
                  -- keyboard_apple:
                  --     1 = pressed
                  --     0 = released
                  --------------------------------------------------------------

                  ps2_key_o(9)
                     <= not key_pressed_n(m65_keys(current_key_index));

                  --------------------------------------------------------------
                  -- Extended PS/2 flag
                  --
                  -- Cursor keys and Delete use extended PS/2 codes.
                  --------------------------------------------------------------

                  if
                     m65_keys(current_key_index) = m65_ins_del   or
                     m65_keys(current_key_index) = m65_up_crsr   or
                     m65_keys(current_key_index) = m65_vert_crsr or
                     m65_keys(current_key_index) = m65_left_crsr or
                     m65_keys(current_key_index) = m65_horz_crsr
                  then
                     ps2_key_o(8) <= '1';
                  else
                     ps2_key_o(8) <= '0';
                  end if;


                  --------------------------------------------------------------
                  -- Select keyboard map
                  --
                  -- Shifted MEGA65 glyph translation is deliberately NOT done
                  -- here. keyboard_apple handles that dynamically so changing
                  -- Shift while a key is already held/repeating also works.
                  --------------------------------------------------------------

                  if mega65_layout_i = '1' then

                       if mega65_alt_o = '1' and
                          m65_keys(current_key_index) = m65_arrow_left
                       then
                          ps2_key_o(7 downto 0) <= m65_code_backtick;
                       else
                          ps2_key_o(7 downto 0)
                             <= ps2_codes_mega65(current_key_index);
                       end if;
                    
                    else
                       ps2_key_o(7 downto 0)
                          <= ps2_codes_apple(current_key_index);
                    
                  end if;
    
                  --------------------------------------------------------------
                  -- Only emit one key event this clock.
                  --------------------------------------------------------------

                  exit;
               end if;
            end loop;
         end if;
      end if;
   end process keyboard_map_proc;


end beh;