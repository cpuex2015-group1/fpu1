library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fadd_step3c is
  Port (
    count2  : in STD_LOGIC_VECTOR (4 downto 0);
    sign2   : in STD_LOGIC;
    expo2   : in STD_LOGIC_VECTOR (7 downto 0);
    frac2   : in STD_LOGIC_VECTOR (25 downto 0);
    result3 : out STD_LOGIC_VECTOR (31 downto 0));
end fadd_step3c;

architecture struct of fadd_step3c is

  signal expo : std_logic_vector (7 downto 0);
  signal frac : std_logic_vector (25 downto 0);

  constant pluszero : std_logic_vector(31 downto 0) := x"00000000";

begin

  expo <= expo2 - count2;

  frac <= ('0' & frac2(25 downto 1)) - x"7FFFFF" when (count2 = 0) and (frac2(1 downto 0) = "11") else
          ('0' & frac2(25 downto 1)) - x"800000";

  result3 <= pluszero when (count2 = 25) or (expo2 <= count2) else
             sign2 & expo & frac(22 downto 0);

end struct;
