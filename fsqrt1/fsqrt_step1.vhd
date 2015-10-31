library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsqrt_step1 is
  Port (
    input   : in  STD_LOGIC_VECTOR (31 downto 0);
    output  : out STD_LOGIC_VECTOR (31 downto 0);
    addr    : out STD_LOGIC_VECTOR (9 downto 0);
    flag    : out STD_LOGIC);
end fsqrt_step1;

architecture struct of fsqrt_step1 is

  signal tmp_sign : std_logic;
  signal tmp_expo : std_logic_vector(7 downto 0);

begin

  addr <= input(23 downto 14);

  tmp_sign <= input(31);
  tmp_expo <= input(30 downto 23);

  output  <= x"7FC00000" when tmp_sign = '1' else
             input when tmp_expo = x"FF" else
             x"00000000" when tmp_expo = x"00" else
             input;

  flag  <= '1' when (tmp_sign = '1') or (tmp_expo = x"FF") or (tmp_expo = x"00") else
           '0';

end struct;

