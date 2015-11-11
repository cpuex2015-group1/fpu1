library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fadd_step3b is
  Port (
    flag2   : in STD_LOGIC;
    sign2   : in STD_LOGIC;
    expo2   : in STD_LOGIC_VECTOR (7 downto 0);
    frac2   : in STD_LOGIC_VECTOR (25 downto 0);
    result3 : out STD_LOGIC_VECTOR (31 downto 0));
end fadd_step3b;

architecture struct of fadd_step3b is

  signal tmp_frac1 : std_logic_vector(25 downto 0);

  signal expo : std_logic_vector (7 downto 0);
  signal frac : std_logic_vector (25 downto 0);

begin
  
  tmp_frac1 <= ("00" & frac2(25 downto 2)) - x"800000" when frac2(25) = '1' else
               ('0' & frac2(25 downto 1)) + 1 when (frac2(1 downto 0) = "11") and (flag2 = '0') else
               ('0' & frac2(25 downto 1));

  frac      <= tmp_frac1 + 1 when (frac2(25) = '1') and ((frac2(1 downto 0) = "11") or ((frac2(2 downto 0) = "110") and (flag2 = '0'))) else
               tmp_frac1     when (frac2(25) = '1') else
               ("0" & tmp_frac1(25 downto 1)) - x"800000" when tmp_frac1(24) = '1' else
               tmp_frac1 - x"800000";

  expo      <= expo2 - 1 when (frac2(25) = '0') and (tmp_frac1(24) = '0') else
               expo2;

  result3   <= sign2 & expo & frac(22 downto 0);

end struct;
