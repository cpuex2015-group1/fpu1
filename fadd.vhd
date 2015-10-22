library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fadd is
  Port (
    input1  : in  STD_LOGIC_VECTOR (31 downto 0);
    input2  : in  STD_LOGIC_VECTOR (31 downto 0);
    output  : out STD_LOGIC_VECTOR (31 downto 0));
end fadd;

architecture struct of fadd is

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

  function fadd(a : std_logic_vector(31 downto 0); b : std_logic_vector(31 downto 0))
    return std_logic_vector
  is
    variable w : std_logic_vector (31 downto 0);
    variable w_sign : std_logic;
    variable l_sign : std_logic;
    variable w_expo : std_logic_vector (7 downto 0);
    variable l_expo : std_logic_vector (7 downto 0);
    variable w_frac : std_logic_vector (25 downto 0) := (others => '0');
    variable l_frac : std_logic_vector (25 downto 0) := (others => '0');

    variable shifted_frac : std_logic_vector (26 downto 0) := (others => '0');
    variable tmp_frac1 : std_logic_vector(25 downto 0) := (others => '0');
    variable tmp_frac2 : std_logic_vector (25 downto 0) := (others => '0');
    variable expo : std_logic_vector (7 downto 0);
    variable frac : std_logic_vector (25 downto 0) := (others => '0');

    variable shift : std_logic_vector(7 downto 0);
    variable count : std_logic_vector(4 downto 0) := "00000";
    variable flag : std_logic := '0';

    constant pluszero : std_logic_vector(31 downto 0) := x"00000000";
    constant minuszero : std_logic_vector(31 downto 0) := x"80000000";
    constant plusinf : std_logic_vector(31 downto 0) := x"7F800000";
    constant minusinf : std_logic_vector(31 downto 0) := x"FF800000";
    constant nan : std_logic_vector(31 downto 0) := x"7FC00000";

    variable state : std_logic := '0';
    variable result : std_logic_vector(31 downto 0);

  begin

    if a(30 downto 0) >= b(30 downto 0) then
      w := a;
      w_sign := a(31);
      l_sign := b(31);
      w_expo(7 downto 0) := a(30 downto 23);
      l_expo(7 downto 0) := b(30 downto 23);
      w_frac(22 downto 0) := a(22 downto 0);
      l_frac(22 downto 0) := b(22 downto 0);
      shift := a(30 downto 23) - b(30 downto 23);
    else
      w := b;
      w_sign := b(31);
      l_sign := a(31);
      w_expo(7 downto 0) := b(30 downto 23);
      l_expo(7 downto 0) := a(30 downto 23);
      w_frac(22 downto 0) := b(22 downto 0);
      l_frac(22 downto 0) := a(22 downto 0);
      shift := b(30 downto 23) - a(30 downto 23);
    end if;

    if w_expo = x"FF" then
      if (l_expo = x"FF") and (w_sign /= l_sign) then
        result := nan;
      else
        result := w;
      end if;
      state := '1';
    elsif l_expo = 0 then
      if w_expo = 0 then
        if (w_sign and l_sign) = '1' then
          result := minuszero;
        else
          result := pluszero;
        end if;
      else
        result := w;
      end if;
      state := '1';
    elsif shift > 25 then
      result := w;
      state := '1';
    elsif w_sign = l_sign then
      tmp_frac1 := l_frac + x"800000";
      tmp_frac1 := tmp_frac1(24 downto 0) & "0";

      shifted_frac := shift_r(tmp_frac1, shift(4 downto 0));
      flag := shifted_frac(26);
      tmp_frac1 := shifted_frac(25 downto 0);

      tmp_frac2 := w_frac + x"800000";
      tmp_frac2 := (tmp_frac2(24 downto 0) & "0") + tmp_frac1;

      if tmp_frac2(25) = '1' then
        if w_expo = x"FE" then
          if w_sign = '0' then
            result := plusinf;
          else
            result := minusinf;
          end if;
          state := '1';
        else
          frac := ("00" & tmp_frac2(25 downto 2)) - x"800000";
          if (tmp_frac2(1) = '1') and ((tmp_frac2(0) = '1') or (tmp_frac2(2) = '1') or (flag = '1')) then
            frac := frac + 1;
          end if;
          expo := w_expo + 1;
        end if;

      else
        if (tmp_frac2(0) = '1') and ((tmp_frac2(1) = '1') or (flag = '1')) then
          tmp_frac2 := tmp_frac2 + 1;
        end if;
        if tmp_frac2(25) = '1' then
          frac := ("00" & tmp_frac2(25 downto 2)) - x"800000";
          expo := w_expo + 1;
        else
          frac := ("0" & tmp_frac2(25 downto 1)) - x"800000";
          expo := w_expo;
        end if;
      end if;

    elsif shift > 1 then
      tmp_frac1 := l_frac + x"800000";
      tmp_frac1 := tmp_frac1(23 downto 0) & "00";

      shifted_frac := shift_r(tmp_frac1, shift(4 downto 0));
      flag := shifted_frac(26);
      tmp_frac1 := shifted_frac(25 downto 0);

      tmp_frac2 := w_frac + x"800000";
      tmp_frac2 := (tmp_frac2(23 downto 0) & "00") - tmp_frac1;

      if tmp_frac2(25) = '1' then
        expo := w_expo;    
        frac := ("00" & tmp_frac2(25 downto 2)) - x"800000";
        if (tmp_frac2(1 downto 0) = "11") or ((tmp_frac2(2 downto 0) = "110") and (flag = '0')) then
          frac := frac + 1;
        end if;

      else
        frac := '0' & tmp_frac2(25 downto 1);
        if (tmp_frac2(1 downto 0) = "11") and (flag = '0') then
          frac := frac + 1;
        end if;
        if frac(24) = '1' then
          frac := ("0" & frac(25 downto 1)) - x"800000";
          expo := w_expo;
        else
          frac := frac - x"800000";
          expo := w_expo - 1;
        end if;
      end if;

    else
      if shift = 0 then
        tmp_frac1 := (w_frac(24 downto 0) - l_frac(24 downto 0)) & '0';
      else
        tmp_frac1 := (w_frac(24 downto 0) & '0') - l_frac + x"800000";
      end if;
      if tmp_frac1 = 0 then
        result := pluszero;
        state := '1';
      else
        count := LZC(tmp_frac1);
        tmp_frac1 := shift_l(tmp_frac1, count);
        if w_expo <= count then
          result := pluszero;
          state := '1';
        else
          expo := w_expo - count;
          if (count = 0) and (tmp_frac1(1 downto 0) = "11") then
            frac := ('0' & tmp_frac1(25 downto 1)) - x"7FFFFF";
          else
            frac := ('0' & tmp_frac1(25 downto 1)) - x"800000";
          end if;
        end if;
      end if;
    end if;

    if state = '1' then
      return result;
    else
      result := w_sign & expo & frac(22 downto 0);
      return result;
    end if;

    return x"FFFFFFFF";
    -- return x"FFFFFFFF" if irregular action occur

  end fadd;

begin

  output <= fadd(input1,input2);
    
end struct;


