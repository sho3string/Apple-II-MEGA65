library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sector_ram_dp is
  port (
    clk : in std_logic;
    -- Port A (CPU access)
    addr_a : in unsigned(8 downto 0);
    data_in_a : in unsigned(7 downto 0);
    data_out_a : out unsigned(7 downto 0);
    we_a : in std_logic;

    -- Port B (external access)
    addr_b : in unsigned(8 downto 0);
    data_in_b : in unsigned(7 downto 0);
    data_out_b : out unsigned(7 downto 0);
    we_b : in std_logic
  );
end entity;

architecture rtl of sector_ram_dp is
  type ram_type is array(0 to 511) of unsigned(7 downto 0);
  signal ram : ram_type;
begin
  -- Port A
  process(clk)
  begin
    if rising_edge(clk) then
      if we_a = '1' then
        ram(to_integer(addr_a)) <= data_in_a;
      end if;
      data_out_a <= ram(to_integer(addr_a));
    end if;
  end process;

  -- Port B
  process(clk)
  begin
    if rising_edge(clk) then
      if we_b = '1' then
        ram(to_integer(addr_b)) <= data_in_b;
      end if;
      data_out_b <= ram(to_integer(addr_b));
    end if;
  end process;
end architecture;
