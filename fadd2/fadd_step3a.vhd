library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fadd_step3a is
  Port (
    flag2   : in STD_LOGIC;
    sign2   : in STD_LOGIC;
    expo2   : in STD_LOGIC_VECTOR (7 downto 0);
    frac2   : in STD_LOGIC_VECTOR (25 downto 0);
    result3 : out STD_LOGIC_VECTOR (31 downto 0));
end fadd_step3a;

architecture struct of fadd_step3a is

  signal tmp_frac1 : std_logic_vector(25 downto 0);
  signal tmp_frac2 : std_logic_vector(25 downto 0);
  signal expo : std_logic_vector (7 downto 0);
  signal frac : std_logic_vector (25 downto 0);

  constant plusinf : std_logic_vector(31 downto 0) := x"7F800000";
  constant minusinf : std_logic_vector(31 downto 0) := x"FF800000";

begin
 
  tmp_frac1 <= ("00" & frac2(25 downto 2)) - x"800000" when frac2(25) = '1' else
               frac2;

  tmp_frac2 <= tmp_frac1 + 1 when (frac2(25) = '1') and (frac2(1) = '1') and ((frac2(0) = '1') or (frac2(2) = '1') or (flag2 = '1')) else
               tmp_frac1 + 1 when (frac2(25) = '0') and (frac2(0) = '1') and ((frac2(1) = '1') or (flag2 = '1')) else
               tmp_frac1;

  frac      <= tmp_frac2 when frac2(25) = '1' else
               ("00" & tmp_frac2(25 downto 2)) - x"800000" when tmp_frac2(25) = '1' else
               ("0" & tmp_frac2(25 downto 1)) - x"800000";

  expo      <= expo2 when (frac2(25) = '0') and (tmp_frac2(25) = '0') else
               expo2 + 1;

  result3   <= plusinf when (frac2(25) = '1') and (expo2 = x"FE") and (sign2 = '0') else
               minusinf when (frac2(25) = '1') and (expo2 = x"FE") else
               sign2 & expo & frac(22 downto 0);

end struct;
