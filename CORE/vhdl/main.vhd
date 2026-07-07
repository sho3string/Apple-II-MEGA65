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
      
      drive_led_o             : out std_logic
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
    signal ram_dout       : std_logic_vector(15 downto 0);
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
    signal video_toggle   : std_logic := '0';	  -- signal to control change of video modes
    signal palette_toggle : std_logic := '0';	  -- signal to control change of paleetes
    
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

    signal drives_reset   : std_logic_vector(G_VDNUM - 1 downto 0);
    signal sd_drives_reset: std_logic_vector(G_VDNUM - 1 downto 0);
    signal vdrives_mounted: std_logic_vector(G_VDNUM - 1 downto 0);
    signal cache_dirty    : std_logic_vector(G_VDNUM - 1 downto 0);
    
    -- Apple II ram/auxilliary ram. Aux ram is utilised for the 80 column mode
    type ram_type is array (natural range <>) of std_logic_vector(7 downto 0);
    signal ram0 : ram_type(0 to 196607);
    signal ram1 : ram_type(0 to 65535);
    
    signal adc_bus             : std_logic_vector(3 downto 0);
    
    signal D1_ACTIVE,D2_ACTIVE : std_logic;
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
    
    signal DISK_CHANGE         : std_logic_vector(1 downto 0);
    --signal disk_mount          : std_logic_vector(1 downto 0) := (others => '0');
    
    signal dd_reset            : std_logic := reset_soft_i or reset_hard_i;
    signal reset_core          : std_logic := '0';
    
    
    signal hdd_mounted         : std_logic := '0';
    signal hdd_read            : std_logic;
    signal hdd_write           : std_logic;
    signal hdd_protect         : std_logic;attribute KEEP : string;
    signal cpu_wait_hdd        : std_logic := '0';
   
    signal sd_lba_unsigned     : unsigned(31 downto 0);
    signal sd_buff_din_unsigned: unsigned(7 downto 0);
    --signal sd_buff_dout_unsigned: unsigned(7 downto 0);
    
    signal UART_CTS            : std_logic; 
    signal UART_RTS            : std_logic; 
    signal UART_RXD            : std_logic; 
    signal UART_TXD            : std_logic; 
    signal UART_DTR            : std_logic; 
    signal UART_DSR            : std_logic;
    
    signal RTC                 : std_logic_vector(64 downto 0);
    
    signal blink : std_logic   := '0';
    
    constant m65_capslock      : integer := 72;
    
    signal track1_sd           : std_logic_vector(5 downto 0);
    signal d1_active_sd        : std_logic;
    signal mount1_sd           : std_logic;
    signal change1_sd          : std_logic;
    
    signal track2_sd           : std_logic_vector(5 downto 0);
    signal d2_active_sd        : std_logic;
    signal mount2_sd           : std_logic;
    signal change2_sd          : std_logic;
    
    signal disk_ready_sd_1     : std_logic;
    signal disk_ready_sd_2     : std_logic;
    signal busy_sd_1           : std_logic;
    signal busy_sd_2           : std_logic;
    
    signal disk_ready_core_1   : std_logic;
    signal disk_ready_core_2   : std_logic;
    signal busy_core_1         : std_logic;
    signal busy_core_2         : std_logic;
    signal DISK_READY_C        : std_logic_vector(1 downto 0);
    
    
    
    function reverse_vd_vec_array(arr : vd_vec_array) return vd_vec_array is
        variable result : vd_vec_array(arr'RANGE)(arr'element'RANGE);
    begin
        for i in arr'RANGE loop
        result(arr'HIGH - i + arr'LOW) := arr(i);
        end loop;
        return result;
    end function;

begin

   padded_l <= '0' & audio_l & "00000";
   padded_r <= '0' & audio_r & "00000";
   
   audio_left_o(15) <= not padded_l(15);
   audio_left_o(14 downto 0) <= signed(padded_l(14 downto 0));
   audio_right_o(15) <= not padded_r(15);
   audio_right_o(14 downto 0) <= signed(padded_l(14 downto 0));
   
   DISK_READY_C(0) <= disk_ready_core_1;
   DISK_READY_C(1) <= disk_ready_core_2; -- (or the synced drive2 later)

   process(apple_qnice_clk_i)
    begin
      if falling_edge(apple_qnice_clk_i) then
        blink <= not blink;
      end if;
    end process;

   process(clk_main_i) begin	
        --flag to enable Lo-Res text artifacting, only applicable in screen mode 2'b00
        if rising_edge(clk_main_i) then
           text_color <= '1'; --(~status[20] & ~status[19] & status[21]);
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
    
    -- single-bit controls (pack them to save instances)
    i_cdc_ctrl1 : xpm_cdc_array_single
    generic map ( WIDTH => 3 )
      port map (
        src_clk  => clk_main_i,
        src_in(0)=> D1_ACTIVE,
        src_in(1)=> vdrives_mounted(0),
        src_in(2)=> DISK_CHANGE(0),
        dest_clk => apple_qnice_clk_i,
        dest_out(0)=> d1_active_sd,
        dest_out(1)=> mount1_sd,
        dest_out(2)=> change1_sd
    );
    
    i_cdc_status1 : xpm_cdc_array_single
    generic map ( WIDTH => 2 )
      port map (
        src_clk     => apple_qnice_clk_i,  -- sd_clk domain
        src_in(0)   => disk_ready_sd_1,
        src_in(1)   => busy_sd_1,
    
        dest_clk    => clk_main_i,         -- Apple core domain
        dest_out(0) => disk_ready_core_1,
        dest_out(1) => busy_core_1
    );
   
  
   -- single-bit controls (pack them to save instances)
    i_cdc_ctrl2 : xpm_cdc_array_single
    generic map ( WIDTH => 3 )
      port map (
        src_clk  => clk_main_i,
        src_in(0)=> D2_ACTIVE,
        src_in(1)=> vdrives_mounted(1),
        src_in(2)=> DISK_CHANGE(1),
        dest_clk => apple_qnice_clk_i,
        dest_out(0)=> d2_active_sd,
        dest_out(1)=> mount2_sd,
        dest_out(2)=> change2_sd
    );
    
    i_cdc_status2 : xpm_cdc_array_single
    generic map ( WIDTH => 2 )
      port map (
        src_clk     => apple_qnice_clk_i,  -- sd_clk domain
        src_in(0)   => disk_ready_sd_2,
        src_in(1)   => busy_sd_2,
    
        dest_clk    => clk_main_i,         -- Apple core domain
        dest_out(0) => disk_ready_core_2,
        dest_out(1) => busy_core_2
    );
   
   i_cdc_drive : xpm_cdc_array_single
   generic map (
      WIDTH => G_VDNUM
   )
   port map (
      src_clk    => clk_main_i,
      src_in     => drives_reset,

      dest_clk   => apple_qnice_clk_i,
      dest_out   => sd_drives_reset
   );
   
   
   combined_reset_proc : process (all)
   begin
      reset_core <= '0';
      if dd_reset = '1' then
         reset_core <= '1';
      end if;
   end process combined_reset_proc;  
   
   
   drv_reset_gen : for i in 0 to G_VDNUM - 1 generate
      drives_reset(i) <= (reset_core) or (not vdrives_mounted(i));
   end generate drv_reset_gen;
   
    
    drive1 : process(clk_main_i)
    begin
        if rising_edge(clk_main_i) then
            if reset_core = '1' then
              DISK_CHANGE(0) <= '0';
            elsif img_mounted(0) = '1' then
              DISK_CHANGE(0) <= not DISK_CHANGE(0);
            end if;
        end if;
    end process;
    
    
    drive2 : process(clk_main_i)
    begin
      if rising_edge(clk_main_i) then
         if reset_core = '1' then
              DISK_CHANGE(1) <= '0';
            elsif img_mounted(1) = '1' then
              DISK_CHANGE(1) <= not DISK_CHANGE(1);
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
        romswitch       => '1', -- bottom toggle switch on apple ii US/UK keyboard
        audio_l         => audio_l,
        audio_r         => audio_r,
        tape_in         => tape_adc_act and tape_adc,
        
        ps2_key         => ps2_key,
        mega65_caps     => not keyboard_n(m65_capslock),
        joy             => "000000", -- to do
        joy_an          => "0000000000000000", -- to do

        TRACK1          => TRACK1,
	    TRACK1_ADDR     => TRACK1_RAM_ADDR,
	    TRACK1_DI       => TRACK1_RAM_DI,
	    TRACK1_DO       => TRACK1_RAM_DO,
	    TRACK1_WE       => TRACK1_RAM_WE,
	    TRACK1_BUSY     => busy_core_1,
	    -- Track buffer interface disk 2
	    TRACK2          => TRACK2,
	    TRACK2_ADDR     => TRACK2_RAM_ADDR,
	    TRACK2_DI       => TRACK2_RAM_DI,
	    TRACK2_DO       => TRACK2_RAM_DO,
	    TRACK2_WE       => TRACK2_RAM_WE,
	    TRACK2_BUSY     => busy_core_2,
	    
	    DISK_READY      => DISK_READY_C,
	    D1_ACTIVE       => D1_ACTIVE,
	    D2_ACTIVE       => D2_ACTIVE,
	    DISK_ACT        => drive_led_o,
        
        D1_WP           => '0', -- disk 1 write protect
	    D2_WP           => '0', -- disk 2 write protect
	    
	    HDD_SECTOR      => sd_lba_unsigned(15 downto 0),
	    HDD_READ        => hdd_read,
	    HDD_WRITE       => hdd_write,
	    HDD_MOUNTED     => hdd_mounted,
	    HDD_PROTECT     => hdd_protect,
	    HDD_RAM_ADDR    => unsigned(sd_buff_addr(8 downto 0)),
	    HDD_RAM_DI      => unsigned(sd_buff_dout),
	    HDD_RAM_DO      => sd_buff_din_unsigned,
	    
	    HDD_RAM_WE      => sd_buff_wr and sd_ack(1),
	    
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
	    
	    -- to do
	    mouse_x         => "000000000", --({ps2_mouse[4],ps2_mouse[15:8]}),
	    mouse_y         => "000000000", --({ps2_mouse[5],ps2_mouse[23:16]}),
	   
	    mouse_button   =>  '1',
	    mouse_strobe   =>  '1',

	    mouse_4_inslot  => '1',
	    mouse_5_inslot  => '1',
	    mb_4_inslot     => '1', -- enable mockingboard active low ( disabled for now )
	    mb_5_inslot     => '1', -- enable mockingboard active low ( disabled for now )
	    saturn_5_inslot => '1'
        
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
         reset_core_i      => reset_soft_i or reset_hard_i,

         -- Core clock domain
         img_mounted_o     => img_mounted,
         img_readonly_o    => img_readonly,
         img_size_o        => img_size,
         img_type_o        => img_type,
         drive_mounted_o   => vdrives_mounted,
         --disk_change_o     => DISK_CHANGE,
         -- Cache output signals: The dirty flags can be used to enforce data consistency
         -- (for example by ignoring/delaying a reset or delaying a drive unmount/mount, etc.)
         -- The flushing flags can be used to signal the fact that the caches are currently
         -- flushing to the user, for example using a special color/signal for example
         -- at the drive led
         cache_dirty_o     => cache_dirty,
         cache_flushing_o  => open,

         -- QNICE clock domain
         sd_lba_i          => reverse_vd_vec_array(sd_lba),
         sd_blk_cnt_i      => reverse_vd_vec_array(sd_blk_cnt),
         sd_rd_i           => sd_rd,
         sd_wr_i           => sd_wr,
         sd_ack_o          => sd_ack,

         sd_buff_addr_o    => sd_buff_addr,
         sd_buff_dout_o    => sd_buff_dout,
         sd_buff_din_i     => reverse_vd_vec_array(sd_buff_din),
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
        reset        => sd_drives_reset(0),
        ram_addr     => TRACK1_RAM_ADDR,
        ram_di       => TRACK1_RAM_DI,
        ram_do       => TRACK1_RAM_DO,
        ram_we       => TRACK1_RAM_WE,
        
        track        => unsigned(track1_sd),
        busy         => busy_sd_1,
        change       => change1_sd,
        mount        => mount1_sd,
        ready        => disk_ready_sd_1,
        active       => d1_active_sd,

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
        
        clk          => clk_main_i,
        sd_clk       => apple_qnice_clk_i,
        reset        => sd_drives_reset(1),
        ram_addr     => TRACK2_RAM_ADDR,
        ram_di       => TRACK2_RAM_DI,
        ram_do       => TRACK2_RAM_DO,
        ram_we       => TRACK2_RAM_WE,
        
        track        => unsigned(track2_sd),
        busy         => TRACK2_RAM_BUSY,
        change       => DISK_CHANGE(1),
        mount        => vdrives_mounted(1), --disk_mount(1),
        ready        => disk_ready_sd_2,
        active       => d2_active_sd,

        sd_buff_addr => sd_buff_addr(8 downto 0),
        sd_buff_dout => sd_buff_dout,
        sd_buff_din  => sd_buff_din(1),
        sd_buff_wr   => sd_buff_wr,

        sd_lba       => sd_lba(1),--sd_lba(2),
        sd_rd        => sd_rd(1),--sd_rd(2),
        sd_wr        => sd_wr(1),--sd_wr(2),
        sd_ack       => sd_ack(1)--sd_ack(2)	
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

