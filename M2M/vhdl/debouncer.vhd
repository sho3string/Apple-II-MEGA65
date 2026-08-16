----------------------------------------------------------------------------------
-- MiSTer2MEGA65 Framework 
--
-- Debouncer for the joystick ports that includes a port switcher and the
-- ability to turn the joysticks on/off.
--
-- MiSTer2MEGA65 done by sy2002 and MJoergen in 2022 and licensed under GPL v3
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debouncer is
generic (
   CLK_FREQ           : in integer
);
port (
   clk                : in std_logic;  
   reset_n            : in std_logic;
   
   flip_joys_i        : in std_logic;
   joy_1_on           : in std_logic;
   joy_2_on           : in std_logic;
 
   joy_1_up_n         : in std_logic;
   joy_1_down_n       : in std_logic;
   joy_1_left_n       : in std_logic;
   joy_1_right_n      : in std_logic;
   joy_1_fire_n       : in std_logic;
   
   dbnce_joy1_up_n    : out std_logic;
   dbnce_joy1_down_n  : out std_logic;
   dbnce_joy1_left_n  : out std_logic;
   dbnce_joy1_right_n : out std_logic;
   dbnce_joy1_fire_n  : out std_logic;
   
   joy_2_up_n         : in std_logic;
   joy_2_down_n       : in std_logic;
   joy_2_left_n       : in std_logic;
   joy_2_right_n      : in std_logic;
   joy_2_fire_n       : in std_logic;
   
   -- use raw for use with Amiga mouse
   
   --dbnce_joy2_up_n    : out std_logic;
   --dbnce_joy2_down_n  : out std_logic;
   --dbnce_joy2_left_n  : out std_logic;
   --dbnce_joy2_right_n : out std_logic;
   dbnce_joy2_fire_n  : out std_logic;
   
   raw_joy2_up_n      : out std_logic;
   raw_joy2_down_n    : out std_logic;
   raw_joy2_left_n    : out std_logic;
   raw_joy2_right_n   : out std_logic
    
);
end debouncer;

architecture beh of debouncer is

signal j1_u, j1_d, j1_l, j1_r, j1_f : std_logic;
signal j2_u, j2_d, j2_l, j2_r, j2_f : std_logic;


signal j1_u_sync1, j1_u_sync2 : std_logic := '1';
signal j1_d_sync1, j1_d_sync2 : std_logic := '1';
signal j1_l_sync1, j1_l_sync2 : std_logic := '1';
signal j1_r_sync1, j1_r_sync2 : std_logic := '1';

signal j2_u_sync1, j2_u_sync2 : std_logic := '1';
signal j2_d_sync1, j2_d_sync2 : std_logic := '1';
signal j2_l_sync1, j2_l_sync2 : std_logic := '1';
signal j2_r_sync1, j2_r_sync2 : std_logic := '1';



begin

    -- Raw joystick direction synchronizers.
    -- No debounce: required for quadrature mouse signals.
    raw_sync_proc : process(clk)
    begin
       if rising_edge(clk) then
    
          -- Physical port 1
          j1_u_sync1 <= joy_1_up_n;
          j1_u_sync2 <= j1_u_sync1;
    
          j1_d_sync1 <= joy_1_down_n;
          j1_d_sync2 <= j1_d_sync1;
    
          j1_l_sync1 <= joy_1_left_n;
          j1_l_sync2 <= j1_l_sync1;
    
          j1_r_sync1 <= joy_1_right_n;
          j1_r_sync2 <= j1_r_sync1;
    
          -- Physical port 2
          j2_u_sync1 <= joy_2_up_n;
          j2_u_sync2 <= j2_u_sync1;
    
          j2_d_sync1 <= joy_2_down_n;
          j2_d_sync2 <= j2_d_sync1;
    
          j2_l_sync1 <= joy_2_left_n;
          j2_l_sync2 <= j2_l_sync1;
    
          j2_r_sync1 <= joy_2_right_n;
          j2_r_sync2 <= j2_r_sync1;
    
       end if;
    end process;
    
    handle_outputs : process(all)
    begin
       -- Defaults: joystick ports disabled
       dbnce_joy1_up_n      <= '1';
       dbnce_joy1_down_n    <= '1';
       dbnce_joy1_left_n    <= '1';
       dbnce_joy1_right_n   <= '1';
       dbnce_joy1_fire_n    <= '1';
    
       raw_joy2_up_n        <= '1';
       raw_joy2_down_n      <= '1';
       raw_joy2_left_n      <= '1';
       raw_joy2_right_n     <= '1';
       dbnce_joy2_fire_n    <= '1';
    
    
       -- Logical joystick 1:
       -- normal debounced joystick signals
       if joy_1_on = '1' then
          if flip_joys_i = '0' then
             dbnce_joy1_up_n    <= j1_u;
             dbnce_joy1_down_n  <= j1_d;
             dbnce_joy1_left_n  <= j1_l;
             dbnce_joy1_right_n <= j1_r;
             dbnce_joy1_fire_n  <= j1_f;
          else
             dbnce_joy1_up_n    <= j2_u;
             dbnce_joy1_down_n  <= j2_d;
             dbnce_joy1_left_n  <= j2_l;
             dbnce_joy1_right_n <= j2_r;
             dbnce_joy1_fire_n  <= j2_f;
          end if;
       end if;


       -- Logical joystick 2:
       -- raw synchronized directions for quadrature mouse,
       -- but fire remains normally debounced.
       if joy_2_on = '1' then
          if flip_joys_i = '0' then
             raw_joy2_up_n     <= j2_u_sync2;
             raw_joy2_down_n   <= j2_d_sync2;
             raw_joy2_left_n   <= j2_l_sync2;
             raw_joy2_right_n  <= j2_r_sync2;
             dbnce_joy2_fire_n <= j2_f;
          else
             raw_joy2_up_n     <= j1_u_sync2;
             raw_joy2_down_n   <= j1_d_sync2;
             raw_joy2_left_n   <= j1_l_sync2;
             raw_joy2_right_n  <= j1_r_sync2;
             dbnce_joy2_fire_n <= j1_f;
          end if;
       end if;

    end process;


   
   -- debouncer settings for the joysticks:
   -- 1ms for any joystick direction and the fire button
        
   do_dbnce_joy1_up : entity work.debounce
      generic map(initial => '1', clk_freq => CLK_FREQ, stable_time => 1)
      port map (clk => clk, reset_n => reset_n, button => joy_1_up_n, result => j1_u);

   do_dbnce_joy1_down : entity work.debounce
      generic map(initial => '1', clk_freq => CLK_FREQ, stable_time => 1)
      port map (clk => clk, reset_n => reset_n, button => joy_1_down_n, result => j1_d);

   do_dbnce_joy1_left : entity work.debounce
      generic map(initial => '1', clk_freq => CLK_FREQ, stable_time => 1)
      port map (clk => clk, reset_n => reset_n, button => joy_1_left_n, result => j1_l);

   do_dbnce_joy1_right : entity work.debounce
      generic map(initial => '1', clk_freq => CLK_FREQ, stable_time => 1)
      port map (clk => clk, reset_n => reset_n, button => joy_1_right_n, result => j1_r);

   do_dbnce_joy1_fire : entity work.debounce
      generic map(initial => '1', clk_freq => CLK_FREQ, stable_time => 1)
      port map (clk => clk, reset_n => reset_n, button => joy_1_fire_n, result => j1_f);
      
   do_dbnce_joy2_up : entity work.debounce
      generic map(initial => '1', clk_freq => CLK_FREQ, stable_time => 1)
      port map (clk => clk, reset_n => reset_n, button => joy_2_up_n, result => j2_u);

   do_dbnce_joy2_down : entity work.debounce
      generic map(initial => '1', clk_freq => CLK_FREQ, stable_time => 1)
      port map (clk => clk, reset_n => reset_n, button => joy_2_down_n, result => j2_d);

   do_dbnce_joy2_left : entity work.debounce
      generic map(initial => '1', clk_freq => CLK_FREQ, stable_time => 1)
      port map (clk => clk, reset_n => reset_n, button => joy_2_left_n, result => j2_l);

   do_dbnce_joy2_right : entity work.debounce
      generic map(initial => '1', clk_freq => CLK_FREQ, stable_time => 1)
      port map (clk => clk, reset_n => reset_n, button => joy_2_right_n, result => j2_r);

   do_dbnce_joy2_fire : entity work.debounce
      generic map(initial => '1', clk_freq => CLK_FREQ, stable_time => 1)
      port map (clk => clk, reset_n => reset_n, button => joy_2_fire_n, result => j2_f);      
end beh;
