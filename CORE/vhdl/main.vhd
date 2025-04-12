----------------------------------------------------------------------------------
-- MiSTer2MEGA65 Framework
--
-- Wrapper for the MiSTer core that runs exclusively in the core's clock domanin
--
-- MiSTer2MEGA65 done by sy2002 and MJoergen in 2022 and licensed under GPL v3
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.video_modes_pkg.all;

entity main is
   generic (
      G_VDNUM                 : natural                     -- amount of virtual drives
   );
   port (
      clk_main_i              : in  std_logic;
      clk_video_i             : in  std_logic;
      reset_soft_i            : in  std_logic;
      reset_hard_i            : in  std_logic;
      pause_i                 : in  std_logic;

      -- MiSTer core main clock speed:
      -- Make sure you pass very exact numbers here, because they are used for avoiding clock drift at derived clocks
      clk_main_speed_i        : in  natural;

      -- Video output
      video_ce_o              : out std_logic;
      video_ce_ovl_o          : out std_logic;
      video_red_o             : out std_logic_vector(7 downto 0);
      video_green_o           : out std_logic_vector(7 downto 0);
      video_blue_o            : out std_logic_vector(7 downto 0);
      video_vs_o              : out std_logic;
      video_hs_o              : out std_logic;
      video_hblank_o          : out std_logic;
      video_vblank_o          : out std_logic;

      -- Audio output (Signed PCM)
      audio_left_o            : out signed(15 downto 0);
      audio_right_o           : out signed(15 downto 0);

      -- M2M Keyboard interface
      kb_key_num_i            : in  integer range 0 to 79;    -- cycles through all MEGA65 keys
      kb_key_pressed_n_i      : in  std_logic;                -- low active: debounced feedback: is kb_key_num_i pressed right now?

      -- MEGA65 joysticks and paddles/mouse/potentiometers
      joy_1_up_n_i            : in  std_logic;
      joy_1_down_n_i          : in  std_logic;
      joy_1_left_n_i          : in  std_logic;
      joy_1_right_n_i         : in  std_logic;
      joy_1_fire_n_i          : in  std_logic;

      joy_2_up_n_i            : in  std_logic;
      joy_2_down_n_i          : in  std_logic;
      joy_2_left_n_i          : in  std_logic;
      joy_2_right_n_i         : in  std_logic;
      joy_2_fire_n_i          : in  std_logic;

      pot1_x_i                : in  std_logic_vector(7 downto 0);
      pot1_y_i                : in  std_logic_vector(7 downto 0);
      pot2_x_i                : in  std_logic_vector(7 downto 0);
      pot2_y_i                : in  std_logic_vector(7 downto 0);
      
      ioctl_download          : std_logic;
      ioctl_index             : std_logic_vector(7 downto 0);
      ioctl_wr                : std_logic;
      ioctl_addr              : std_logic_vector(24 downto 0);
      ioctl_data              : std_logic_vector(7 downto 0);
      
      main_drive_led_o        : out std_logic
      
   );
end entity main;



architecture synthesis of main is


signal keyboard_n     : std_logic_vector(79 downto 0);

signal audio_l        : std_logic_vector(9 downto 0);
signal audio_r        : std_logic_vector(9 downto 0);

signal padded_l       : std_logic_vector(15 downto 0);
signal padded_r       : std_logic_vector(15 downto 0);

signal text_color     : std_logic := '0';

signal tape_adc       : std_logic;
signal tape_adc_act   : std_logic;

signal ram_addr       : std_logic_vector(17 downto 0);
signal ram_dout       : std_logic_vector(15 downto 0);
signal ram_din        : std_logic_vector(7 downto 0);
signal ram_we         : std_logic;
signal ram_aux        : std_logic;

signal ps2_key        : std_logic_vector(10 downto 0);
signal decoded_key    : unsigned(7 downto 0);          -- From keyboard_adapter
signal akd            : std_logic;                     -- Any key down signal
signal open_apple     : std_logic;
signal closed_apple   : std_logic;
signal soft_reset     : std_logic := '0';
signal video_toggle   : std_logic := '0';	  -- signal to control change of video modes
signal palette_toggle : std_logic := '0';	  -- signal to control change of paleetes

signal sd_buff_addr   : unsigned(8 downto 0);
signal sd_buff_dout   : unsigned(7 downto 0);
-- Declare an array type for 8-bit wide elements
type sd_buff_array is array (0 to 2) of unsigned(7 downto 0);
-- Signal declaration
signal sd_buff_din    : sd_buff_array;
signal sd_buff_wr     : std_logic;
signal sd_ack         : std_logic_vector(2 downto 0);

-- Declare the array type for 32-bit wide elements
type sd_lba_array is array (0 to 2) of unsigned(31 downto 0);
-- Signal declaration
signal sd_lba : sd_lba_array;


-- Declare two memory blocks
type ram_type is array (0 to 196607) of std_logic_vector(7 downto 0); -- 192KB
type ram_type_aux is array (0 to 65535) of std_logic_vector(7 downto 0); -- 64KB
signal ram0 : ram_type;
signal ram1 : ram_type_aux;
signal ram_dout_internal   : std_logic_vector(15 downto 0);

signal adc_bus             : std_logic_vector(3 downto 0);

signal D1_ACTIVE,D2_ACTIVE : std_logic;
signal TRACK1_RAM_BUSY     : std_logic;
signal TRACK1_RAM_ADDR     : unsigned(12 downto 0);
signal TRACK1_RAM_DI       : unsigned(7 downto 0);
signal TRACK1_RAM_DO       : unsigned(7 downto 0);
signal TRACK1_RAM_WE       : std_logic;
signal TRACK1              : unsigned(5 downto 0);

signal TRACK2_RAM_BUSY     : std_logic;
signal TRACK2_RAM_ADDR     : unsigned(12 downto 0);
signal TRACK2_RAM_DI       : unsigned(7 downto 0);
signal TRACK2_RAM_DO       : unsigned(7 downto 0);
signal TRACK2_RAM_WE       : std_logic;
signal TRACK2              : unsigned(5 downto 0);

signal DISK_READY          : std_logic_vector(1 downto 0);

signal hdd_mounted         : std_logic := '0';
signal hdd_read            : std_logic;
signal hdd_write           : std_logic;
signal hdd_protect         : std_logic;
signal cpu_wait_hdd        : std_logic := '0';

signal UART_CTS            : std_logic; 
signal UART_RTS            : std_logic; 
signal UART_RXD            : std_logic; 
signal UART_TXD            : std_logic; 
signal UART_DTR            : std_logic; 
signal UART_DSR            : std_logic;

signal RTC                 : std_logic_vector(64 downto 0);

constant m65_capslock      : integer := 72;

begin
   
   padded_l <= '0' & audio_l & "00000";
   padded_r <= '0' & audio_r & "00000";
   
   audio_left_o(15) <= not padded_l(15);
   audio_left_o(14 downto 0) <= signed(padded_l(14 downto 0));
   audio_right_o(15) <= not padded_r(15);
   audio_right_o(14 downto 0) <= signed(padded_l(14 downto 0));
   
   process(clk_main_i) begin	
	    --flag to enable Lo-Res text artifacting, only applicable in screen mode 2'b00
        if rising_edge(clk_main_i) then
           text_color <= '1'; --(~status[20] & ~status[19] & status[21]);
        end if;
   end process; 
   
   process(clk_main_i)
    begin
        if rising_edge(clk_main_i) then
            -- RAM0 (192KB) for lower byte when ram_aux = 0
            if ram_we = '1' and ram_aux = '0' then
                ram0(to_integer(unsigned(ram_addr))) <= ram_din;
                ram_dout_internal(7 downto 0) <= ram_din;
            elsif ram_aux = '0' then
                ram_dout_internal(7 downto 0) <= ram0(to_integer(unsigned(ram_addr)));
            end if;

            -- RAM1 (64KB) for upper byte when ram_aux = 1
            if ram_we = '1' and ram_aux = '1' then
                ram1(to_integer(unsigned(ram_addr(15 downto 0)))) <= ram_din;
                ram_dout_internal(15 downto 8) <= ram_din;
            elsif ram_aux = '1' then
                ram_dout_internal(15 downto 8) <= ram1(to_integer(unsigned(ram_addr(15 downto 0))));
            end if;
        end if;
    end process;
    -- Assign internal signal to the output
    ram_dout <= ram_dout_internal;
  
   i_apple2_top : entity work.apple2_top
   port map (
   
        clk_14m         => clk_main_i,
        clk_50m         => clk_video_i, -- super serial ( 1.8432 MHz ). Use video clk 57.27272727272727 / 31 = 1.847
        cpu_wait        => cpu_wait_hdd,
        cpu_type        => '1', -- 65c02 - Apple IIe Enhanced
        reset_cold      => reset_hard_i,
        reset_warm      => reset_soft_i,
        
        hblank          => video_hblank_o,
        vblank          => video_vblank_o,
        hsync           => video_hs_o,
        vsync           => video_vs_o,
        r               => video_red_o,
        g               => video_green_o,
        b               => video_blue_o,
        video_switch    => video_toggle,
        palette_switch  => palette_toggle,
        screen_mode     => "00", -- Color
        text_color      => text_color,
        color_palette   => "00", -- Original NTSC
        palmode         => '0', -- Disabled
        romswitch       => '1',
        audio_l         => audio_l,
        audio_r         => audio_r,
        tape_in         => tape_adc_act and tape_adc,
        
        ram_addr        => ram_addr,
        ram_do          => ram_dout,
	    ram_di          => ram_din,
	    ram_we          => ram_we,
	    ram_aux         => ram_aux,
	    
	    ioctl_addr      => ioctl_addr,
	    ioctl_data      => ioctl_data,
	    ioctl_download  => ioctl_download,
	    ioctl_index     => ioctl_index,
	    ioctl_wr        => ioctl_wr,
        
        ps2_key         => ps2_key,
        mega65_caps     => not keyboard_n(m65_capslock),
        joy             => "000000", -- to do
        joy_an          => "0000000000000000", -- to do
        
        mb_enabled      => '1', -- enable mockingboard active low ( disabled for now )
        
        TRACK1          => TRACK1,
	    TRACK1_ADDR     => TRACK1_RAM_ADDR,
	    TRACK1_DI       => TRACK1_RAM_DI,
	    TRACK1_DO       => TRACK1_RAM_DO,
	    TRACK1_WE       => TRACK1_RAM_WE,
	    TRACK1_BUSY     => TRACK1_RAM_BUSY,
	    
	    TRACK2          => TRACK2,
	    TRACK2_ADDR     => TRACK2_RAM_ADDR,
	    TRACK2_DI       => TRACK2_RAM_DI,
	    TRACK2_DO       => TRACK2_RAM_DO,
	    TRACK2_WE       => TRACK2_RAM_WE,
	    TRACK2_BUSY     => TRACK2_RAM_BUSY,
	    
	    DISK_READY      => DISK_READY,
	    D1_ACTIVE       => D1_ACTIVE,
	    D2_ACTIVE       => D2_ACTIVE,
	    DISK_ACT        => main_drive_led_o,
        
        D1_WP           => '0', -- disk 1 motor on/off
	    D2_WP           => '0', -- disk 2 motor om/off
	    
	    HDD_SECTOR      => sd_lba(1)(15 downto 0),
	    HDD_READ        => hdd_read,
	    HDD_WRITE       => hdd_write,
	    HDD_MOUNTED     => hdd_mounted,
	    HDD_PROTECT     => hdd_protect,
	    HDD_RAM_ADDR    => sd_buff_addr,
	    HDD_RAM_DI      => sd_buff_dout,
	    HDD_RAM_DO      => sd_buff_din(1),
	    HDD_RAM_WE      => sd_buff_wr and sd_ack(1),
	    
	    UART_TXD        => UART_TXD,
	    UART_RXD        => UART_RXD,
	    UART_RTS        => UART_RTS,
	    UART_CTS        => UART_CTS,
	    UART_DTR        => UART_DTR,
	    UART_DSR        => UART_DSR,
	    RTC             => RTC
        
   );
  
   -- to do
   i_ltc2308_tape : entity work.ltc2308_tape
    port map (
        reset       => reset_soft_i or reset_hard_i,
        clk         => clk_main_i,
        adc_bus     => adc_bus,
        dout        => tape_adc,
        active      => tape_adc_act
   );
   
   -- Convert MEGA65 keystrokes to the Apple II keyboard matrix
   i_keyboard : entity work.keyboard
      port map (
         clk_main_i           => clk_main_i,

         -- Interface to the MEGA65 keyboard
         key_num_i            => kb_key_num_i,
         key_pressed_n_i      => kb_key_pressed_n_i,

         -- @TODO: Create the kind of keyboard output that your core needs
         -- "example_n_o" is a low active register and used by the demo core:
         --    bit 0: Space
         --    bit 1: Return
         --    bit 2: Run/Stop
         keyboard_n_o          => keyboard_n
      ); -- i_keyboard
      
     -- Instantiate the keyboard adapter
    
    i_keyboard_adapter : entity work.keyboard_adapter
        port map (
            keyboard_n         => keyboard_n,
            kb_key_pressed_n   => kb_key_pressed_n_i,
            CLK_14M            => clk_main_i,
            reset              => reset_soft_i,
            --reads              => '0',            -- Not used for now
            --akd                => akd,
            --K                  => decoded_key,
            ps2_key            => ps2_key
            --open_apple         => open_apple,
            --closed_apple       => closed_apple,
            --soft_reset         => soft_reset,
            --video_toggle       => video_toggle,
            --palette_toggle     => palette_toggle
    );
    
end architecture synthesis;

