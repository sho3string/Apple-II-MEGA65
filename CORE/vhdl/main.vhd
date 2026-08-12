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
use work.vdrives_pkg.all;

library xpm;
use xpm.vcomponents.xpm_cdc_single;
use xpm.vcomponents.xpm_cdc_array_single;


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
     
      ioctl_download          : in std_logic;
      ioctl_index             : in std_logic_vector(7 downto 0);
      ioctl_wr                : in std_logic;
      ioctl_addr              : in std_logic_vector(24 downto 0);
      ioctl_data              : in std_logic_vector(7 downto 0);
      
      apple_qnice_clk_i       : in  std_logic;
      apple_qnice_addr_i      : in  std_logic_vector(27 downto 0);
      apple_qnice_data_i      : in  std_logic_vector(15 downto 0);
      apple_qnice_data_o      : out std_logic_vector(15 downto 0);
      apple_qnice_ce_i        : in  std_logic;
      apple_qnice_we_i        : in  std_logic;
      
      drive_led_o             : out std_logic;
      
      osm_control_i           : in  std_logic_vector(255 downto 0)
      
   );
end entity main;

architecture synthesis of main is

    signal audio_l        : std_logic_vector(9 downto 0);
    signal audio_r        : std_logic_vector(9 downto 0);
    
    signal padded_l       : std_logic_vector(15 downto 0);
    signal padded_r       : std_logic_vector(15 downto 0);
    
    signal text_color     : std_logic := '0';
    
    signal tape_adc       : std_logic;
    signal tape_adc_act   : std_logic;
    
    signal ram_addr       : std_logic_vector(17 downto 0);
    signal ram_dout       : std_logic_vector(15 downto 0) := (others => '0');
    signal ram_din        : std_logic_vector(7 downto 0);
    signal ram_we         : std_logic;
    signal ram_aux        : std_logic;
    
    signal keyboard_n     : std_logic_vector(79 downto 0);
    signal ps2_key        : std_logic_vector(10 downto 0);
    signal decoded_key    : unsigned(7 downto 0);          -- From keyboard_adapter
    signal akd            : std_logic;                     -- Any key down signal
    signal open_apple     : std_logic;
    signal closed_apple   : std_logic;
    signal soft_reset     : std_logic := '0';
    signal video_toggle_o   : std_logic := '0';	  -- signal to control change of video modes
    signal palette_toggle_o : std_logic := '0';	  -- signal to control change of paleetes
    
    signal sd_buff_addr   : std_logic_vector(8 downto 0);
    signal sd_buff_dout   : std_logic_vector(7 downto 0);
    signal img_mounted    : std_logic_vector(G_VDNUM - 1 downto 0);
    signal img_readonly   : std_logic;
    signal img_size       : std_logic_vector(31 downto 0);
    signal img_type       : std_logic_vector(1 downto 0);
    
    signal sd_buff_din    : vd_vec_array(G_VDNUM - 1 downto 0)(7 downto 0);
    signal sd_buff_wr     : std_logic;
    
    
    signal sd_lba         : vd_vec_array(G_VDNUM - 1 downto 0)(31 downto 0);
    signal sd_ack         : vd_std_array(G_VDNUM - 1 downto 0);
    signal sd_rd          : vd_std_array(G_VDNUM - 1 downto 0);
    signal sd_wr          : vd_std_array(G_VDNUM - 1 downto 0);
    signal sd_blk_cnt     : vd_vec_array(G_VDNUM - 1 downto 0)(5 downto 0);
    
    signal fd1_wp         : std_logic := '0';
    signal fd2_wp         : std_logic := '0';

    signal vdrives_mounted: std_logic_vector(G_VDNUM - 1 downto 0);
    signal disk_change:     std_logic_vector(G_VDNUM - 1 downto 0);
    signal cache_dirty    : std_logic_vector(G_VDNUM - 1 downto 0);
    signal prevent_reset  : std_logic;
    
    -- Apple II ram/auxilliary ram. Aux ram is utilised for the 80 column mode
    type ram_type is array (natural range <>) of std_logic_vector(7 downto 0);
    signal ram0 : ram_type(0 to 196607) := (others => (others => '0'));
    signal ram1 : ram_type(0 to 65535)  := (others => (others => '0'));
    
    signal adc_bus             : std_logic_vector(3 downto 0);
    
    signal D1_ACTIVE,D2_ACTIVE : std_logic;
    signal TRACK1_RAM_ADDR     : unsigned(12 downto 0);
    signal TRACK1_RAM_DI       : unsigned(7 downto 0);
    signal TRACK1_RAM_DO       : unsigned(7 downto 0);
    signal TRACK1_RAM_WE       : std_logic;
    signal TRACK1              : unsigned(5 downto 0);
    signal TRACK1_RAM_BUSY     : std_logic;
   
    signal TRACK2_RAM_ADDR     : unsigned(12 downto 0);
    signal TRACK2_RAM_DI       : unsigned(7 downto 0);
    signal TRACK2_RAM_DO       : unsigned(7 downto 0);
    signal TRACK2_RAM_WE       : std_logic;
    signal TRACK2              : unsigned(5 downto 0);
    signal TRACK2_RAM_BUSY     : std_logic;
    
    signal DISK_READY          : std_logic_vector(1 downto 0);

    signal reset_core_n        : std_logic := '1';
    signal reset_core_int      : std_logic := '0';
    
    signal hdd_mounted         : std_logic := '0';
    signal hdd_read            : std_logic;
    signal hdd_write           : std_logic;
    signal hdd_protect         : std_logic;attribute KEEP : string;
    signal cpu_wait_hdd        : std_logic := '0';
   
    signal sd_lba_unsigned     : unsigned(31 downto 0);
    signal sd_buff_din_unsigned: unsigned(7 downto 0);
    
    signal UART_CTS            : std_logic; 
    signal UART_RTS            : std_logic; 
    signal UART_RXD            : std_logic; 
    signal UART_TXD            : std_logic; 
    signal UART_DTR            : std_logic; 
    signal UART_DSR            : std_logic;
    signal RTC                 : std_logic_vector(64 downto 0);
    
    constant m65_capslock      : integer := 72;
    
    -- Expansion slots
    signal slot4_mockingboard  : std_logic := '0';
    signal slot4_mouse         : std_logic := '0';
    signal slot5_mockingboard  : std_logic := '0';
    signal slot5_mouse         : std_logic := '0';
    signal slot5_saturn5       : std_logic := '0';
    
    signal palmode             : std_logic := '0'; -- default NTSC
    signal romswitch           : std_logic := '1';
    signal screen_mode         : std_logic_vector(1 downto 0) := "00";
    
    signal cpu_type            : std_logic  := '1'; -- 0 - 6502, 1 - 65C02
    signal cpu_type_prev       : std_logic  := '1';
    signal cpu_mode_changed    : std_logic  := '0';
    
    signal palette_mode        : std_logic_vector(1 downto 0);
    signal screen_mode_req     : std_logic_vector(1 downto 0) := (others => '0');
    signal palette_req         : std_logic_vector(1 downto 0) := (others => '0');
    
    signal old_toggle          : std_logic := '0';
    signal old_pal_toggle      : std_logic := '0';
    
    signal color_palette       : std_logic_vector(1 downto 0) := (others => '0');
    
    signal apple_joy           : std_logic_vector(5 downto 0)  := (others => '0');
    signal apple_joy_an        : std_logic_vector(15 downto 0) := (others => '0');
    
    signal pot1_val            : std_logic_vector(7 downto 0);
    signal potxy_sw            : std_logic;
    signal pot_pol_sw          : std_logic;
    signal joy2_button         : std_logic;
    
    signal mouse_x_m65         : signed(8 downto 0) := (others => '0');
    signal mouse_y_m65         : signed(8 downto 0) := (others => '0');
    signal mouse_strobe_m65    : std_logic := '0';
    signal mouse_button_m65    : std_logic := '0';
    
    signal mouse_x_old         : std_logic_vector(1 downto 0) := "00";
    signal mouse_y_old         : std_logic_vector(1 downto 0) := "00";
    
    constant C_MENU_FD_A           : integer := 5;
    constant C_MENU_FD_B           : integer := 6;
    constant C_MENU_NO_4           : integer := 11;
    constant C_MENU_MB_4           : integer := 12;
    constant C_MENU_MO_4           : integer := 13;
    constant C_MENU_NO_5           : integer := 17;
    constant C_MENU_MB_5           : integer := 18;
    constant C_MENU_MO_5           : integer := 19;
    constant C_MENU_SN_5           : integer := 20;
    constant C_MENU_HDMI_16_9_50   : natural := 27;
    constant C_MENU_HDMI_16_9_60   : natural := 28;
    constant C_MENU_HDMI_4_3_50    : natural := 29;
    constant C_MENU_HDMI_5_4_50    : natural := 30;
    constant C_MENU_HDMI_640_60    : natural := 31;
    constant C_MENU_HDMI_720_5994  : natural := 32;
    constant C_MENU_SVGA_800_60    : natural := 33;
    constant C_MENU_CRT_EMULATION  : natural := 36;
    constant C_MENU_HDMI_ZOOM      : natural := 37;
    constant C_MENU_IMPROVE_AUDIO  : natural := 38;
    constant C_MENU_COLOR          : natural := 41;
    constant C_MENU_BW             : natural := 42;
    constant C_MENU_GREEN          : natural := 43;
    constant C_MENU_AMBER          : natural := 44;
    constant C_MENU_CPU_65C02      : natural := 46;
    constant C_MENU_ROMSWITCH      : natural := 47;
    constant C_MENU_PALMODE        : natural := 48;
    constant C_MENU_NTSC           : natural := 50;
    constant C_MENU_2GS            : natural := 51;
    constant C_MENU_AppleWin       : natural := 52;
    constant C_MENU_2CPAL          : natural := 53;
    constant C_MENU_LRT            : natural := 56;
    
    --constant C_MENU_POTXY  : natural := <your bit>; to do
    --constant C_MENU_POTPOL : natural := <your bit>; to do

begin
   
   
   -- prevent data corruption by not allowing a soft reset to happen while the cache is still dirty
   -- since we can have more than one cache that might be dirty, we convert the std_logic_vector of length G_VDNUM
   -- into an unsigned and check for zero
   prevent_reset <= '0' when unsigned(cache_dirty) = 0 else
                    '1';

   padded_l <= '0' & audio_l & "00000";
   padded_r <= '0' & audio_r & "00000";
   
   audio_left_o(15) <= not padded_l(15);
   audio_left_o(14 downto 0) <= signed(padded_l(14 downto 0));
   audio_right_o(15) <= not padded_r(15);
   audio_right_o(14 downto 0) <= signed(padded_r(14 downto 0));
   
   -- write protect
   fd1_wp <= '1' when osm_control_i(C_MENU_FD_A) else '0';
   fd2_wp <= '1' when osm_control_i(C_MENU_FD_B) else '0';
   
   -- misc toggles
   romswitch <= '1' when osm_control_i(C_MENU_ROMSWITCH) else '0';
   palmode   <= '1' when osm_control_i(C_MENU_PALMODE) else '0';
   
   
   -- quadrature-to-delta converter between MEGA65 port 2 and apple2_top
    mouse_proc : process(clk_main_i)
        variable mouse_x_new : std_logic_vector(1 downto 0);
        variable mouse_y_new : std_logic_vector(1 downto 0);
        variable dx          : integer range -1 to 1;
        variable dy          : integer range -1 to 1;
    
    begin
       if rising_edge(clk_main_i) then
    
          mouse_strobe_m65 <= '0';
          mouse_x_m65      <= (others => '0');
          mouse_y_m65      <= (others => '0');
    
          -- Amiga-style quadrature mouse on MEGA65 port 2
          -- Amiga mouse DB9 quadrature:
          -- pin 1 / UP    = V
          -- pin 2 / DOWN  = H
          -- pin 3 / LEFT  = VQ
          -- pin 4 / RIGHT = HQ
            
          mouse_x_new := joy_2_down_n_i & joy_2_right_n_i; -- H/HQ
          mouse_y_new := joy_2_up_n_i   & joy_2_left_n_i;  -- V/VQ
    
          dx := 0;
          dy := 0;
    
          ------------------------------------------------------------------
          -- X quadrature
          --
          -- Valid sequence one direction:
          --   00 -> 01 -> 11 -> 10 -> 00
          --
          -- Reverse sequence = opposite direction.
          ------------------------------------------------------------------
    
          case mouse_x_old & mouse_x_new is
             when "0001" | "0111" | "1110" | "1000" =>
                dx := -1;
             when "0010" | "1011" | "1101" | "0100" =>
                dx := 1;
             when others =>
                dx := 0;
          end case;

          ------------------------------------------------------------------
          -- Y quadrature
          ------------------------------------------------------------------
    
          case mouse_y_old & mouse_y_new is
             when "0001" | "0111" | "1110" | "1000" =>
                dy := 1;
             when "0010" | "1011" | "1101" | "0100" =>
                dy := -1;
             when others =>
                dy := 0;
          end case;

          ------------------------------------------------------------------
          -- Generate one Apple mouse event for each quadrature transition.
          ------------------------------------------------------------------
    
          if dx /= 0 or dy /= 0 then
             mouse_x_m65      <= to_signed(dx, 9);
             mouse_y_m65      <= to_signed(dy, 9);
             mouse_strobe_m65 <= '1';
          end if;
    
    
          mouse_x_old <= mouse_x_new;
          mouse_y_old <= mouse_y_new;
    
          ------------------------------------------------------------------
          -- Amiga left mouse button is the normal DB9 fire pin.
          -- Apple mouse BUTTON is active high.
          ------------------------------------------------------------------
    
          mouse_button_m65 <= not joy_2_fire_n_i;
       end if;
    end process;
   
   second_button_proc : process(all)
    begin
       -- Select which MEGA65 POT line carries button 2.
       -- 0 = POTX
       -- 1 = POTY
       --if potxy_sw = '0' then
          pot1_val <= pot1_x_i; -- hard wired to potx for now
       --else
        --  pot1_val <= pot1_y_i;
       --end if;
    
       -- Convert POT level into active-high Apple II PB2.
       --
       -- Different joystick adapters use opposite POT polarities.
       --if pot_pol_sw = '1' then
          -- Active-low POT button, e.g. Amiga-style
          if unsigned(pot1_val) < unsigned'(x"80") then -- hard wired to Amiga style for now
             joy2_button <= '1';
          else
             joy2_button <= '0';
          end if;
       /*else
          -- Active-high POT button, e.g. C64GS-style
          if unsigned(pot1_val) >= unsigned'(x"80") then
             joy2_button <= '1';
          else
             joy2_button <= '0';
          end if;
       end if;*/
    end process;
   
   joystick_proc : process(all)
    begin
       -- Centre
       apple_joy_an <= x"0000";
       apple_joy    <= (others => '0');
    
       ------------------------------------------------------------
       -- MEGA65 joystick 1 -> Apple II joystick X/Y
       --
       -- MEGA65 inputs are active LOW.
       -- Apple joy_an is signed:
       --   negative = left/up
       --   zero     = centre
       --   positive = right/down
       ------------------------------------------------------------
    
       -- X axis
       if joy_1_left_n_i = '0' then
          apple_joy_an(15 downto 8) <= x"80";  -- -128
       elsif joy_1_right_n_i = '0' then
          apple_joy_an(15 downto 8) <= x"7F";  -- +127
       end if;
    
       -- Y axis
       if joy_1_up_n_i = '0' then
          apple_joy_an(7 downto 0) <= x"80";   -- -128
       elsif joy_1_down_n_i = '0' then
          apple_joy_an(7 downto 0) <= x"7F";   -- +127
       end if;
    
       -- Apple game-port pushbutton 1
       apple_joy(4) <= not joy_1_fire_n_i;
       
       -- MEGA65 POTX/POTY second button -> Apple PB2
        apple_joy(5) <= joy2_button;
    end process;
   
   process(clk_main_i)
    begin
       if rising_edge(clk_main_i) then
    
          old_toggle     <= video_toggle_o;
          old_pal_toggle <= palette_toggle_o;
    
          -- Display change request from keyboard
          if video_toggle_o /= old_toggle then
             screen_mode_req <= std_logic_vector(unsigned(screen_mode) + 1);
          end if;
    
          -- Palette change request from keyboard
          if palette_toggle_o /= old_pal_toggle then
             palette_req     <= std_logic_vector(unsigned(palette_mode) + 1);
             screen_mode_req <= "00";  -- force colour when switching palettes
          end if;
    
       end if;
    end process;
    
   screen_mode_proc : process(all)
   begin
    -- 00: Color, 01: B&W, 10:Green, 11: Amber
    if osm_control_i(C_MENU_COLOR) then 
        screen_mode <= "00";
    elsif osm_control_i(C_MENU_BW) then 
        screen_mode <= "01";
    elsif osm_control_i(C_MENU_GREEN) then 
        screen_mode <= "10";
    elsif osm_control_i(C_MENU_AMBER) then 
        screen_mode <= "11";
    end if;
   end process;
   
   -- 00: Original (//e NTSC), 01: //gs, 02: AppleWin, 03: //c PAL
   colour_assignment_proc : process(all)
   begin
       color_palette <= "00"; -- default
       
       if osm_control_i(C_MENU_NTSC) then
         color_palette <= "00";
       elsif osm_control_i(C_MENU_2GS) then
         color_palette <= "01";
       elsif osm_control_i(C_MENU_AppleWin) then
         color_palette <= "10";
       elsif osm_control_i(C_MENU_2CPAL) then
         color_palette <= "11";
       end if;
       
   end process;
   
    slot_assignment_proc : process(all)
    begin
       -- Defaults: nothing installed
       -- Mouse and Mockingboard enables are active low.
       slot4_mockingboard <= '0';
       slot5_mockingboard <= '0';
       slot4_mouse        <= '0';
       slot5_mouse        <= '0';
       slot5_saturn5      <= '0';
    
       -- Slot 4
       if osm_control_i(C_MENU_MB_4) = '1' then
          slot4_mockingboard <= '1';
    
       elsif osm_control_i(C_MENU_MO_4) = '1' then
          slot4_mouse <= '1';
       end if;
    
       -- Slot 5
       if osm_control_i(C_MENU_MB_5) = '1' then
          slot5_mockingboard <= '1';
    
       elsif osm_control_i(C_MENU_MO_5) = '1' then
          slot5_mouse <= '1';
    
       elsif osm_control_i(C_MENU_SN_5) = '1' then
          slot5_saturn5 <= '1';
       end if;
    end process;

   --------------------------------------------------------------------------------------------------
   -- Hard reset
   --------------------------------------------------------------------------------------------------

   hard_reset_proc : process (clk_main_i)
   begin
      if rising_edge(clk_main_i) then
         if reset_soft_i = '1' or reset_hard_i = '1' or reset_core_int = '1' then
            reset_core_n <= prevent_reset and (not reset_hard_i);
        else
            reset_core_n <= '1';
        end if;
      end if;
   end process hard_reset_proc;
   
   --------------------------------------------------------------------------------------------------
   -- Track when CPU is changed
   --------------------------------------------------------------------------------------------------
   
    cpu_mode_proc : process(clk_main_i)
    begin
        if rising_edge(clk_main_i) then
            -- update cpu_type
            if osm_control_i(C_MENU_CPU_65C02) then
                cpu_type <= '1';
            else
                cpu_type <= '0';
            end if;
    
            -- detect change
            if cpu_type /= cpu_type_prev then
                cpu_mode_changed <= '1';
            else
                cpu_mode_changed <= '0';
            end if;
    
            cpu_type_prev <= cpu_type;
        end if;
    end process;
    
   --------------------------------------------------------------------------------------------------
   -- Assert reset when CPU is changed
   --------------------------------------------------------------------------------------------------
    
   cpu_reset_proc : process(clk_main_i)
    begin
        if rising_edge(clk_main_i) then
            if cpu_mode_changed = '1' then
                reset_core_int <= '1';   -- assert reset
            else
                reset_core_int <= '0';   -- release reset
            end if;
        end if;
    end process;

  process(clk_main_i)
    begin
       if rising_edge(clk_main_i) then
          -- Enable Lo-Res text artifacting only in Color mode
          if screen_mode = "00" and osm_control_i(C_MENU_LRT) = '1' then
             text_color <= '1';
          else
             text_color <= '0';
          end if;
       end if;
    end process;
   
    -- RAM0 Process: Handles lower byte when ram_aux = '0'
    i_ram0: process(clk_main_i)
    begin
        if rising_edge(clk_main_i) then
            if ram_we = '1' and ram_aux = '0' then
                ram0(to_integer(unsigned(ram_addr))) <= ram_din;
                ram_dout(7 downto 0) <= ram_din;
            else
                ram_dout(7 downto 0) <= ram0(to_integer(unsigned(ram_addr)));
            end if;
        end if;
    end process;

    -- RAM1 Process: Handles upper byte when ram_aux = '1'
    i_ram1: process(clk_main_i)
    begin
        if rising_edge(clk_main_i) then
            if ram_we = '1' and ram_aux = '1' then
                ram1(to_integer(unsigned(ram_addr(15 downto 0)))) <= ram_din;
                ram_dout(15 downto 8) <= ram_din;
            else
                ram_dout(15 downto 8) <= ram1(to_integer(unsigned(ram_addr(15 downto 0))));
            end if;
        end if;
    end process;
  

   -- Convert MEGA65 keystrokes to the Apple II keyboard matrix
   i_keyboard : entity work.keyboard
      port map (
         clk_main_i           => clk_main_i,

         -- Interface to the MEGA65 keyboard
         key_num_i            => kb_key_num_i,
         key_pressed_n_i      => kb_key_pressed_n_i,

         -- @TODO: Create the kind of keyboard output that your core needs
         -- "example_n_o" is a low  active register and used by the demo core:
         --    bit 0: Space
         --    bit 1: Return
         --    bit 2: Run/Stop
         keyboard_n_o          => keyboard_n
      ); -- i_keyboard
      
     -- keyboard adapter
    i_keyboard_adapter : entity work.keyboard_adapter
        port map (
            keyboard_n         => keyboard_n,
            kb_key_pressed_n   => kb_key_pressed_n_i,
            CLK_14M            => clk_main_i,
            reset              => reset_soft_i,
            ps2_key            => ps2_key
    );
    
    i_apple2_top : entity work.apple2_top
   port map (
        clk_14m         => clk_main_i,
        clk_50m         => apple_qnice_clk_i,
        cpu_wait        => cpu_wait_hdd,
        cpu_type        => cpu_type,            -- 1 = 65c02 - Apple IIe Enhanced, 2 non Enhanced
        reset_cold      => not reset_core_n,
        reset_warm      => not reset_core_n,
        
        hblank          => video_hblank_o,
        vblank          => video_vblank_o,
        hsync           => video_hs_o,
        vsync           => video_vs_o,
        r               => video_red_o,
        g               => video_green_o,
        b               => video_blue_o,
        video_switch    => video_toggle_o,
        palette_switch  => palette_toggle_o,
        screen_mode     => screen_mode,         -- 00: Color, 01: B&W, 10:Green, 11: Amber
        text_color      => text_color,                 -- text_color,
        color_palette   => color_palette,       -- 00: Original (//e NTSC), 01: //gs, 02: AppleWin, 03: //c PAL
        palmode         => palmode,
        romswitch       => romswitch,   -- bottom toggle switch on apple ii US/UK keyboard
        audio_l         => audio_l,
        audio_r         => audio_r,
        tape_in         => tape_adc_act and tape_adc,
        
        ps2_key         => ps2_key,
        mega65_caps     => not keyboard_n(m65_capslock),
        joy             => apple_joy,
        joy_an          => apple_joy_an,

        TRACK1          => TRACK1,
	    TRACK1_ADDR     => TRACK1_RAM_ADDR,
	    TRACK1_DI       => TRACK1_RAM_DI,
	    TRACK1_DO       => TRACK1_RAM_DO,
	    TRACK1_WE       => TRACK1_RAM_WE,
	    TRACK1_BUSY     => TRACK1_RAM_BUSY,
	    -- Track buffer interface disk 2
	    TRACK2          => TRACK2,
	    TRACK2_ADDR     => TRACK2_RAM_ADDR,
	    TRACK2_DI       => TRACK2_RAM_DI,
	    TRACK2_DO       => TRACK2_RAM_DO,
	    TRACK2_WE       => TRACK2_RAM_WE,
	    TRACK2_BUSY     => TRACK2_RAM_BUSY,
	    
	    DISK_READY      => DISK_READY,
	    D1_ACTIVE       => D1_ACTIVE,
	    D2_ACTIVE       => D2_ACTIVE,
	    DISK_ACT        => drive_led_o,
        
        D1_WP           => fd1_wp, -- disk 1 write protect
	    D2_WP           => fd2_wp, -- disk 2 write protect
	    
	    
	    HDD_SECTOR      => sd_lba_unsigned(15 downto 0),
	    HDD_READ        => hdd_read,
	    HDD_WRITE       => hdd_write,
	    HDD_MOUNTED     => hdd_mounted,
	    HDD_PROTECT     => hdd_protect,
	    HDD_RAM_ADDR    => unsigned(sd_buff_addr),
	    HDD_RAM_DI      => unsigned(sd_buff_dout),
	    HDD_RAM_DO      => sd_buff_din_unsigned,
	    
	    HDD_RAM_WE      => '0',--sd_buff_wr and sd_ack(1),
	    
	    
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
	    
	    UART_TXD        => UART_TXD,
	    UART_RXD        => UART_RXD,
	    UART_RTS        => UART_RTS,
	    UART_CTS        => UART_CTS,
	    UART_DTR        => UART_DTR,
	    UART_DSR        => UART_DSR,
	    RTC             => RTC,
	    
	    mouse_x       => mouse_x_m65,
        mouse_y       => mouse_y_m65,
        mouse_button  => mouse_button_m65,
        mouse_strobe  => mouse_strobe_m65,

	    mouse_4_inslot  => slot4_mouse,        -- enable mouse
	    mouse_5_inslot  => slot5_mouse,        -- enable mouse
	    mb_4_inslot     => slot4_mockingboard, -- enable mockingboard
	    mb_5_inslot     => slot5_mockingboard, -- enable mockingboard
	    saturn_5_inslot => slot5_saturn5
        
   );
   
   i_vdrives : entity work.vdrives
      generic map (
         VDNUM       => G_VDNUM,
         BLKSZ       => 2                    -- 1 = 256 bytes block size, 2 = 512 bytes blocksize
      )
      port map
      (
         clk_qnice_i       => apple_qnice_clk_i,
         clk_core_i        => clk_main_i,
         reset_core_i      => not reset_core_n,

         -- Core clock domain
         img_mounted_o     => img_mounted,
         img_readonly_o    => img_readonly,
         img_size_o        => img_size,
         img_type_o        => img_type,
         drive_mounted_o   => vdrives_mounted,
         disk_change_o     => disk_change,
         -- Cache output signals: The dirty flags can be used to enforce data consistency
         -- (for example by ignoring/delaying a reset or delaying a drive unmount/mount, etc.)
         -- The flushing flags can be used to signal the fact that the caches are currently
         -- flushing to the user, for example using a special color/signal for example
         -- at the drive led
         cache_dirty_o     => cache_dirty,
         cache_flushing_o  => open,

         -- QNICE clock domain
         sd_lba_i          => sd_lba,
         sd_blk_cnt_i      => sd_blk_cnt,
         sd_rd_i           => sd_rd,
         sd_wr_i           => sd_wr,
         sd_ack_o          => sd_ack,

         sd_buff_addr_o    => sd_buff_addr,
         sd_buff_dout_o    => sd_buff_dout,
         sd_buff_din_i     => sd_buff_din,
         sd_buff_wr_o      => sd_buff_wr,

         -- QNICE interface (MMIO, 4k-segmented)
         -- qnice_addr is 28-bit because we have a 16-bit window selector and a 4k window: 65536*4096 = 268.435.456 = 2^28
         qnice_addr_i      => apple_qnice_addr_i,
         qnice_data_i      => apple_qnice_data_i,
         qnice_data_o      => apple_qnice_data_o,
         qnice_ce_i        => apple_qnice_ce_i,
         qnice_we_i        => apple_qnice_we_i
      ); -- i_vdrives
      
   
   -- to do
   i_floppy_track_1 : entity work.floppy_track
    port map (
        
        clk          => clk_main_i, -- 14.31760 Mhz
        sd_clk       => apple_qnice_clk_i,
        reset        => not reset_core_n,
        ram_addr     => TRACK1_RAM_ADDR,
        ram_di       => TRACK1_RAM_DI,
        ram_do       => TRACK1_RAM_DO,
        ram_we       => TRACK1_RAM_WE,
        
        track        => TRACK1,
        busy         => TRACK1_RAM_BUSY,
        change       => disk_change(0),
        mount        => vdrives_mounted(0),
        ready        => DISK_READY(0),
        active       => D1_ACTIVE,

        sd_buff_addr => sd_buff_addr,
        sd_buff_dout => sd_buff_dout,
        sd_buff_din  => sd_buff_din(0),
        sd_buff_wr   => sd_buff_wr,

        sd_lba       => sd_lba(0),
        sd_rd        => sd_rd(0),
        sd_wr        => sd_wr(0),
        sd_ack       => sd_ack(0)	
   );
   
   
   i_floppy_track_2 : entity work.floppy_track
    port map (
        
        clk          => clk_main_i, -- 14.31760 Mhz
        sd_clk       => apple_qnice_clk_i,
        reset        => not reset_core_n,
        ram_addr     => TRACK2_RAM_ADDR,
        ram_di       => TRACK2_RAM_DI,
        ram_do       => TRACK2_RAM_DO,
        ram_we       => TRACK2_RAM_WE,
        
        track        => TRACK2,
        busy         => TRACK2_RAM_BUSY,
        change       => disk_change(1),
        mount        => vdrives_mounted(1),
        ready        => DISK_READY(1),
        active       => D2_ACTIVE,

        sd_buff_addr => sd_buff_addr,
        sd_buff_dout => sd_buff_dout,
        sd_buff_din  => sd_buff_din(1),
        sd_buff_wr   => sd_buff_wr,

        sd_lba       => sd_lba(1),
        sd_rd        => sd_rd(1),
        sd_wr        => sd_wr(1),
        sd_ack       => sd_ack(1)	
   );
   
   
   -- to do
   /*
   i_ltc2308_tape : entity work.ltc2308_tape
    port map (
        reset       => reset_soft_i or reset_hard_i,
        clk         => clk_main_i,
        adc_bus     => adc_bus,
        dout        => tape_adc,
        active      => tape_adc_act
   );
   */

end architecture synthesis;

