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

    variable loopcount : std_logic_vector(7 downto 0) := "00000000";
   --this variable is to avoid error "- Loop has iterated 64 times. Use "set -loop_iteration_limit XX" to iterate more."

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
      while (shift > 0) and (loopcount < 63) loop
        if tmp_frac1(0) = '1' then
          flag := '1';
        end if;
        tmp_frac1 := "0" & tmp_frac1(25 downto 1);
        shift := shift - 1;
        loopcount := loopcount + 1;
      end loop;
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
      while (shift > 0) and (loopcount < 63) loop
        if tmp_frac1(0) = '1' then
          flag := '1';
        end if;
        tmp_frac1 := '0' & tmp_frac1(25 downto 1);
        shift := shift - 1;
        loopcount := loopcount + 1;
      end loop;
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
        tmp_frac1 := w_frac - l_frac;
      else
        tmp_frac1 := (w_frac(24 downto 0) & '0') + "1000000000000000000000000" - l_frac - x"800000";
      end if;
      if tmp_frac1 = 0 then
        result := pluszero;
        state := '1';
      else
        while ((shift = 0) and (tmp_frac1(23) = '0')) or ((shift = 1) and (tmp_frac1(24) = '0')) loop
          tmp_frac1 := tmp_frac1(24 downto 0) & '0';
          count := count + 1;
          loopcount := loopcount + 1;
        end loop;
        if w_expo < (count + 1) then
          result := pluszero;
          state := '1';
        else
          expo := w_expo - count;
          if (count = 0) and (tmp_frac1(1 downto 0) = "11") then
            frac := ('0' & tmp_frac1(25 downto 1)) + 1 - x"800000";
          else
            if shift = 0 then
              frac := tmp_frac1 - x"800000";
            else
              frac := ('0' & tmp_frac1(25 downto 1)) - x"800000";
            end if;
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


