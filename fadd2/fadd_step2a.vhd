library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fadd_step2a is
  Port (
    sign1   : in STD_LOGIC;
    expo1   : in STD_LOGIC_VECTOR (7 downto 0);
    w_frac1 : in STD_LOGIC_VECTOR (22 downto 0);
    l_frac1 : in STD_LOGIC_VECTOR (22 downto 0);
    shift1  : in STD_LOGIC_VECTOR (4 downto 0);
    flag2   : out STD_LOGIC;
    sign2   : out STD_LOGIC;
    expo2   : out STD_LOGIC_VECTOR (7 downto 0);
    frac2   : out STD_LOGIC_VECTOR (25 downto 0));
end fadd_step2a;

architecture struct of fadd_step2a is

  function shift_r(s : std_logic_vector(25 downto 0); k : std_logic_vector(4 downto 0))
    return std_logic_vector
  is
    variable i : integer;
    variable t : std_logic_vector(26 downto 0);
    -- t(26) is flag.
  begin
    i := conv_integer(k);
    case i is
      when 0 => t := "0" & s;
      when 1 => t := "10" & s(25 downto 1);
                if s(0 downto 0) = "0" then
                  t := '0' & t(25 downto 0); 
                end if;
      when 2 => t := "100" & s(25 downto 2);
                if s(1 downto 0) = "00" then
                  t := '0' & t(25 downto 0);
                end if;
      when 3 => t := "1000" & s(25 downto 3);
                if s(2 downto 0) = "000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 4 => t := "10000" & s(25 downto 4);
                if s(3 downto 0) = "0000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 5 => t := "100000" & s(25 downto 5);
                if s(4 downto 0) = "00000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 6 => t := "1000000" & s(25 downto 6);
                if s(5 downto 0) = "000000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 7 => t := "10000000" & s(25 downto 7);
                if s(6 downto 0) = "0000000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 8 => t := "100000000" & s(25 downto 8);
                if s(7 downto 0) = "00000000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 9 => t := "1000000000" & s(25 downto 9);
                if s(8 downto 0) = "000000000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 10 => t := "10000000000" & s(25 downto 10);
                if s(9 downto 0) = "0000000000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 11 => t := "100000000000" & s(25 downto 11);
                if s(10 downto 0) = "00000000000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 12 => t := "1000000000000" & s(25 downto 12);
                if s(11 downto 0) = "000000000000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 13 => t := "10000000000000" & s(25 downto 13);
                if s(12 downto 0) = "0000000000000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 14 => t := "100000000000000" & s(25 downto 14);
                if s(13 downto 0) = "00000000000000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 15 => t := "1000000000000000" & s(25 downto 15);
                if s(14 downto 0) = "000000000000000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 16 => t := "10000000000000000" & s(25 downto 16);
                if s(15 downto 0) = "0000000000000000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 17 => t := "100000000000000000" & s(25 downto 17);
                if s(16 downto 0) = "00000000000000000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 18 => t := "1000000000000000000" & s(25 downto 18);
                if s(17 downto 0) = "000000000000000000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 19 => t := "10000000000000000000" & s(25 downto 19);
                if s(18 downto 0) = "0000000000000000000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 20 => t := "100000000000000000000" & s(25 downto 20);
                if s(19 downto 0) = "00000000000000000000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 21 => t := "1000000000000000000000" & s(25 downto 21);
                if s(20 downto 0) = "000000000000000000000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 22 => t := "10000000000000000000000" & s(25 downto 22);
                if s(21 downto 0) = "0000000000000000000000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 23 => t := "100000000000000000000000" & s(25 downto 23);
                if s(22 downto 0) = "00000000000000000000000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 24 => t := "1000000000000000000000000" & s(25 downto 24);
                if s(23 downto 0) = "000000000000000000000000" then
                  t := '0' & t(25 downto 0);
                end if;
      when 25 => t := "10000000000000000000000000" & s(25 downto 25);
                if s(24 downto 0) = "0000000000000000000000000" then
                  t := '0' & t(25 downto 0);
                end if;
      when others => t := (others => '0');
    end case;
    return t;
  end shift_r;

  signal tmp_frac1 : std_logic_vector(25 downto 0);
  signal tmp_frac2 : std_logic_vector(25 downto 0);
  signal tmp_frac3 : std_logic_vector(25 downto 0);
  signal shifted_frac : std_logic_vector(26 downto 0);

begin

  sign2 <= sign1;
  expo2 <= expo1;
  tmp_frac1 <= ("00" & l_frac1 & "0") + "1000000000000000000000000";
  tmp_frac2 <= ("00" & w_frac1 & "0") + "1000000000000000000000000";

  shifted_frac <= shift_r(tmp_frac1, shift1);
  flag2 <= shifted_frac(26);
  tmp_frac3 <= shifted_frac(25 downto 0);

  frac2 <= tmp_frac2 + tmp_frac3;

end struct;
