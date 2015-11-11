library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fadd_step2c is
  Port (
    w_frac1 : in STD_LOGIC_VECTOR (22 downto 0);
    l_frac1 : in STD_LOGIC_VECTOR (22 downto 0);
    shift1  : in STD_LOGIC_VECTOR (4 downto 0);
    count2  : out STD_LOGIC_VECTOR (4 downto 0);
    frac2   : out STD_LOGIC_VECTOR (25 downto 0));
end fadd_step2c;

architecture struct of fadd_step2c is

  function LZC(s : std_logic_vector(25 downto 0))
    return std_logic_vector
  is
    variable x : std_logic_vector(25 downto 0);
    variable y : std_logic_vector(25 downto 0);
    variable n : std_logic_vector(4 downto 0) := "11001";
  begin
    x := s;

    y := x"0000" & x(25 downto 16);
    if y /= 0 then
      n := n - 16;
      x := y;
    end if;
    y := x"00" & x(25 downto 8);
    if y /= 0 then
      n := n - 8;
      x := y;
    end if;
    y := x"0" & x(25 downto 4);
    if y /= 0 then
      n := n - 4;
      x := y;
    end if;
    y := "00" & x(25 downto 2);
    if y /= 0 then
      n := n - 2;
      x := y;
    end if;
    y := "0" & x(25 downto 1);
    if y /= 0 then
      n := n - 1;
      x := y;
    end if;

    return n - x(0);
  end LZC; 

  function shift_l(s : std_logic_vector(25 downto 0); k : std_logic_vector(4 downto 0))
    return std_logic_vector
  is
    variable i : integer;
    variable t : std_logic_vector(25 downto 0);
  begin
    i := conv_integer(k);
    case i is
      when 0 => t := s;
      when 1 => t := s(24 downto 0) & "0";
      when 2 => t := s(23 downto 0) & "00";
      when 3 => t := s(22 downto 0) & "000";
      when 4 => t := s(21 downto 0) & "0000";
      when 5 => t := s(20 downto 0) & "00000";
      when 6 => t := s(19 downto 0) & "000000";
      when 7 => t := s(18 downto 0) & "0000000";
      when 8 => t := s(17 downto 0) & "00000000";
      when 9 => t := s(16 downto 0) & "000000000";
      when 10 => t := s(15 downto 0) & "0000000000";
      when 11 => t := s(14 downto 0) & "00000000000";
      when 12 => t := s(13 downto 0) & "000000000000";
      when 13 => t := s(12 downto 0) & "0000000000000";
      when 14 => t := s(11 downto 0) & "00000000000000";
      when 15 => t := s(10 downto 0) & "000000000000000";
      when 16 => t := s(9 downto 0) & "0000000000000000";
      when 17 => t := s(8 downto 0) & "00000000000000000";
      when 18 => t := s(7 downto 0) & "000000000000000000";
      when 19 => t := s(6 downto 0) & "0000000000000000000";
      when 20 => t := s(5 downto 0) & "00000000000000000000";
      when 21 => t := s(4 downto 0) & "000000000000000000000";
      when 22 => t := s(3 downto 0) & "0000000000000000000000";
      when 23 => t := s(2 downto 0) & "00000000000000000000000";
      when 24 => t := s(1 downto 0) & "000000000000000000000000";
      when others => t := (others => '0');
    end case;
    return t;
  end shift_l; 

  signal tmp_frac  : std_logic_vector(25 downto 0);
  signal tmp_count : std_logic_vector(4 downto 0);

begin

  tmp_frac <= "00" & (w_frac1 - l_frac1) & '0' when shift1 = 0 else
              ("00" & w_frac1 & '0') - ("000" & l_frac1) + x"800000";

  tmp_count <= LZC(tmp_frac);
  frac2  <= shift_l(tmp_frac, tmp_count);
  count2 <= tmp_count;

end struct;
