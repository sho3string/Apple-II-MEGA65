library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity keyboard_adapter is
    port (
        keyboard_n      : in std_logic_vector(79 downto 0);  -- Active-low key states
        kb_key_pressed_n: in std_logic;
        -- Apple IIe Keyboard Interface
        CLK_14M         : in std_logic;
        reset           : in std_logic;
        ps2_key         : out std_logic_vector(10 downto 0)
    );
end keyboard_adapter;

architecture Behavioral of keyboard_adapter is

-- MEGA65 key codes that kb_key_num_i is using while
-- kb_key_pressed_n_i is signalling (low active) which key is pressed
constant m65_ins_del       : integer := 0;
constant m65_return        : integer := 1;
constant m65_horz_crsr     : integer := 2;   -- means cursor right in C64 terminology
constant m65_f7            : integer := 3;
constant m65_f1            : integer := 4;
constant m65_f3            : integer := 5;
constant m65_f5            : integer := 6;
constant m65_vert_crsr     : integer := 7;   -- means cursor down in C64 terminology
constant m65_3             : integer := 8;
constant m65_w             : integer := 9;
constant m65_a             : integer := 10;
constant m65_4             : integer := 11;
constant m65_z             : integer := 12;
constant m65_s             : integer := 13;
constant m65_e             : integer := 14;
constant m65_lshift        : integer := 15;
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
constant m65_rshift        : integer := 52;
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
constant m65_up_crsr       : integer := 73;  -- cursor up
constant m65_left_crsr     : integer := 74;  -- cursor left
constant m65_restore       : integer := 75;

-- Temporary signals for mapping

signal toggle_bit           : std_logic := '0';

signal key_index            : integer range 0 to 79 := 0;
signal prev_keyboard_n      : std_logic_vector(79 downto 0) := (others => '1');
signal prev_keys            : std_logic_vector(50 downto 0) := (others => '1');
signal shift_pressed        : std_logic := '0';

type slv8_array is array (0 to 61) of std_logic_vector(7 downto 0);

-- Example key mappings for Apple IIe keys
constant apple_keycode_esc         : std_logic_vector(7 downto 0) := x"76"; -- Escape ("esc" key)
constant apple_keycode_1           : std_logic_vector(7 downto 0) := x"16"; -- 1
constant apple_keycode_2           : std_logic_vector(7 downto 0) := x"1e"; -- 2
constant apple_keycode_3           : std_logic_vector(7 downto 0) := x"26"; -- 3
constant apple_keycode_4           : std_logic_vector(7 downto 0) := x"25"; -- 4
constant apple_keycode_6           : std_logic_vector(7 downto 0) := x"36"; -- 6
constant apple_keycode_5           : std_logic_vector(7 downto 0) := x"2e"; -- 5
constant apple_keycode_7           : std_logic_vector(7 downto 0) := x"3d"; -- 7
constant apple_keycode_8           : std_logic_vector(7 downto 0) := x"3e"; -- 8
constant apple_keycode_9           : std_logic_vector(7 downto 0) := x"46"; -- 9
constant apple_keycode_tab         : std_logic_vector(7 downto 0) := x"0d"; -- Horizontal Tab
constant apple_keycode_q           : std_logic_vector(7 downto 0) := x"15"; -- Q
constant apple_keycode_w           : std_logic_vector(7 downto 0) := x"1d"; -- W
constant apple_keycode_e           : std_logic_vector(7 downto 0) := x"24"; -- E
constant apple_keycode_r           : std_logic_vector(7 downto 0) := x"2d"; -- R
constant apple_keycode_y           : std_logic_vector(7 downto 0) := x"35"; -- Y
constant apple_keycode_t           : std_logic_vector(7 downto 0) := x"2c"; -- T
constant apple_keycode_u           : std_logic_vector(7 downto 0) := x"3c"; -- U
constant apple_keycode_i           : std_logic_vector(7 downto 0) := x"43"; -- I
constant apple_keycode_o           : std_logic_vector(7 downto 0) := x"44"; -- O
constant apple_keycode_a           : std_logic_vector(7 downto 0) := x"1c"; -- A
constant apple_keycode_d           : std_logic_vector(7 downto 0) := x"23"; -- D
constant apple_keycode_s           : std_logic_vector(7 downto 0) := x"1b"; -- S
constant apple_keycode_h           : std_logic_vector(7 downto 0) := x"33"; -- H
constant apple_keycode_f           : std_logic_vector(7 downto 0) := x"2b"; -- F
constant apple_keycode_g           : std_logic_vector(7 downto 0) := x"34"; -- G
constant apple_keycode_j           : std_logic_vector(7 downto 0) := x"3b"; -- J
constant apple_keycode_k           : std_logic_vector(7 downto 0) := x"42"; -- K
constant apple_keycode_semicolon   : std_logic_vector(7 downto 0) := x"4c"; -- ;
constant apple_keycode_l           : std_logic_vector(7 downto 0) := x"4b"; -- L
constant apple_keycode_z           : std_logic_vector(7 downto 0) := x"1a"; -- Z
constant apple_keycode_x           : std_logic_vector(7 downto 0) := x"22"; -- X
constant apple_keycode_c           : std_logic_vector(7 downto 0) := x"21"; -- C
constant apple_keycode_v           : std_logic_vector(7 downto 0) := x"2a"; -- V
constant apple_keycode_b           : std_logic_vector(7 downto 0) := x"32"; -- B
constant apple_keycode_n           : std_logic_vector(7 downto 0) := x"31"; -- N
constant apple_keycode_m           : std_logic_vector(7 downto 0) := x"3a"; -- M
constant apple_keycode_comma       : std_logic_vector(7 downto 0) := x"41"; -- ,
constant apple_keycode_period      : std_logic_vector(7 downto 0) := x"49"; -- .
constant apple_keycode_slash       : std_logic_vector(7 downto 0) := x"4a"; -- /
constant apple_keycode_0           : std_logic_vector(7 downto 0) := x"45"; -- 0 , to do
constant apple_keycode_p           : std_logic_vector(7 downto 0) := x"4d"; -- P , to do
constant apple_keycode_space       : std_logic_vector(7 downto 0) := x"29"; -- Space
constant apple_keycode_return      : std_logic_vector(7 downto 0) := x"5a"; -- Return
constant apple_keycode_delete      : std_logic_vector(7 downto 0) := x"71"; -- Delete
constant apple_keycode_lshift      : std_logic_vector(7 downto 0) := x"12";
constant apple_keycode_rshift      : std_logic_vector(7 downto 0) := x"59";
constant apple_keycode_capslock    : std_logic_vector(7 downto 0) := x"58";
constant apple_keycode_ctrl        : std_logic_vector(7 downto 0) := x"14";
constant apple_keycode_openapple   : std_logic_vector(7 downto 0) := x"1f"; -- open apple
constant apple_keycode_up          : std_logic_vector(7 downto 0) := x"75";
constant apple_keycode_down        : std_logic_vector(7 downto 0) := x"72";
constant apple_keycode_left        : std_logic_vector(7 downto 0) := x"6b";
constant apple_keycode_right       : std_logic_vector(7 downto 0) := x"74";
constant apple_keycode_quote       : std_logic_vector(7 downto 0) := x"52"; -- '
constant apple_keycode_backtick    : std_logic_vector(7 downto 0) := x"5d"; -- `
constant apple_keycode_sqbrack_l   : std_logic_vector(7 downto 0) := x"54"; -- [
constant apple_keycode_sqbrack_r   : std_logic_vector(7 downto 0) := x"5b"; -- ]
constant apple_keycode_minus       : std_logic_vector(7 downto 0) := x"4e"; -- -
constant apple_keycode_equal       : std_logic_vector(7 downto 0) := x"55"; -- =
constant apple_keycode_closedapple : std_logic_vector(7 downto 0) := x"11"; -- closed apple
constant apple_keycode_backslash   : std_logic_vector(7 downto 0) := x"0e"; -- \
/*
type keymap_array is array(0 to 79) of unsigned(7 downto 0);

    signal keymap : keymap_array := (
        others => (others => '0')     
    );
*/


constant m65_keys : integer_vector := (
    m65_ins_del,
    m65_return,
    m65_0,
    m65_1,
    m65_2,
    m65_3,
    m65_4,
    m65_5,
    m65_6,
    m65_7,
    m65_8,
    m65_9,
    m65_a,
    m65_b,
    m65_c,
    m65_d,
    m65_e,
    m65_f,
    m65_g,
    m65_h,
    m65_i,
    m65_j,
    m65_k,
    m65_l,
    m65_m,
    m65_n,
    m65_o,
    m65_p,
    m65_q,
    m65_r,
    m65_s,
    m65_t,
    m65_u,
    m65_v,
    m65_w,
    m65_x,
    m65_y,
    m65_z,
    m65_lshift,
    m65_rshift,
    m65_capslock,
    m65_esc,
    m65_ctrl,
    m65_tab,
    m65_comma,
    m65_dot,
    m65_mega,
    m65_up_crsr,
    m65_vert_crsr,
    m65_left_crsr,
    m65_horz_crsr,
    m65_slash,
    m65_colon,
    m65_semicolon,
    m65_equal,
    m65_at,
    m65_asterisk,
    m65_plus,
    m65_minus,
    m65_restore,
    m65_arrow_up,
    m65_space
);

constant ps2_codes : slv8_array := (
    0 => apple_keycode_delete, -- delete, requires ext bit
    1 => apple_keycode_return, -- enter
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
   51 => apple_keycode_slash,
   52 => apple_keycode_semicolon,
   53 => apple_keycode_quote,
   54 => apple_keycode_backtick,
   55 => apple_keycode_sqbrack_l,
   56 => apple_keycode_sqbrack_r,
   57 => apple_keycode_minus,
   58 => apple_keycode_equal,
   59 => apple_keycode_closedapple,
   60 => apple_keycode_backslash,
   61 => apple_keycode_space
);

begin
    -- Key mapping process: Decode MEGA65 key codes into Apple IIe key format
    -- Initialize partial key map (expand as needed)
    
    process(CLK_14M)
        variable toggled        : std_logic;
        variable last_key_index : integer := -1; -- set to something outside the array defined in ps2_codes
        variable shift_pressed  : boolean :=  false;
    begin
        if rising_edge(CLK_14M) then
            if reset = '1' then
                toggle_bit <= '0';
                ps2_key <= (others => '0');
                prev_keyboard_n <= (others => '1');
            else

                for current_key_index in 0 to 61 loop
                    if keyboard_n(m65_keys(current_key_index)) /= prev_keyboard_n(m65_keys(current_key_index)) then
                        prev_keyboard_n(m65_keys(current_key_index)) <= keyboard_n(m65_keys(current_key_index));
                        toggled := not toggle_bit;
                        toggle_bit <= toggled;
                        ps2_key(10) <= toggled;
                        ps2_key(9) <= not keyboard_n(m65_keys(current_key_index));  -- 0 = press, 1 = release 
                        ps2_key(8) <= '1' when -- force extended bit
                        not keyboard_n(m65_ins_del) or
                        not keyboard_n(m65_up_crsr) or
                        not keyboard_n(m65_vert_crsr) or
                        not keyboard_n(m65_left_crsr) or
                        not keyboard_n(m65_horz_crsr) 
                        else '0';  -- Set to '0' if none are pressed
                        ps2_key(7 downto 0) <= ps2_codes(current_key_index);
                        /*
                        shift_pressed := true when keyboard_n(m65_lshift) ='0' or keyboard_n(m65_rshift) = '0' else false;
                        if (last_key_index >= 0 and shift_pressed and ps2_codes(current_key_index) = x"1E") then  -- Mega65 Shift + 2 = quote (")
                            ps2_key(7 downto 0) <= x"52";  -- Send PS/2 code for '
                        else
                            -- default mapping.
                            ps2_key(7 downto 0) <= ps2_codes(current_key_index);
                        end if;
                        
                        
                        last_key_index := current_key_index;*/
  
                    end if;
                end loop;
            end if;
        end if;
    end process;
   
end Behavioral;
