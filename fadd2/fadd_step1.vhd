library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fadd_step1 is
  Port (
    input1  : in  STD_LOGIC_VECTOR (31 downto 0);
    input2  : in  STD_LOGIC_VECTOR (31 downto 0);
    way1    : out STD_LOGIC_VECTOR (1 downto 0);
    result1 : out STD_LOGIC_VECTOR (31 downto 0);
    sign1   : out STD_LOGIC;
    expo1   : out STD_LOGIC_VECTOR (7 downto 0);
    w_frac1 : out STD_LOGIC_VECTOR (22 downto 0);
    l_frac1 : out STD_LOGIC_VECTOR (22 downto 0);
    shift1  : out STD_LOGIC_VECTOR (4 downto 0));
end fadd_step1;

architecture struct of fadd_step1 is

  signal bool : boolean;

  signal w_sign : std_logic;
  signal l_sign : std_logic;
  signal w_expo : std_logic_vector (7 downto 0);
  signal l_expo : std_logic_vector (7 downto 0);
  signal w_frac : std_logic_vector (22 downto 0);
  signal l_frac : std_logic_vector (22 downto 0);

  signal tmp_shift1 : std_logic_vector(7 downto 0);
  signal tmp_shift2 : std_logic_vector(7 downto 0);
  signal tmp_shift3 : std_logic_vector(7 downto 0);
  
  signal tmp_result1 : std_logic_vector(31 downto 0);
  signal tmp_result2 : std_logic_vector(31 downto 0);

  signal flag : std_logic_vector(1 downto 0);

  constant pluszero : std_logic_vector(31 downto 0) := x"00000000";
  constant minuszero : std_logic_vector(31 downto 0) := x"80000000";
  constant plusinf : std_logic_vector(31 downto 0) := x"7F800000";
  constant minusinf : std_logic_vector(31 downto 0) := x"FF800000";
  constant nan : std_logic_vector(31 downto 0) := x"7FC00000";

begin

  bool <= input1(30 downto 0) >= input2(30 downto 0);

  tmp_shift1 <= input1(30 downto 23) - input2(30 downto 23);
  tmp_shift2 <= input2(30 downto 23) - input1(30 downto 23);

  w_sign <= input1(31) when bool else input2(31);
  l_sign <= input2(31) when bool else input1(31);

  w_expo(7 downto 0)  <= input1(30 downto 23) when bool else input2(30 downto 23);
  l_expo(7 downto 0)  <= input2(30 downto 23) when bool else input1(30 downto 23);

  w_frac(22 downto 0) <= input1(22 downto 0) when bool else input2(22 downto 0);
  l_frac(22 downto 0) <= input2(22 downto 0) when bool else input1(22 downto 0);

  tmp_shift3  <= tmp_shift1 when bool else tmp_shift2;


  tmp_result1 <= nan when ((w_expo and l_expo) = x"FF") and (w_sign /= l_sign) else
                 (w_sign & w_expo & w_frac);

  tmp_result2 <= minuszero when ((l_expo or w_expo) = x"00") and ((w_sign and l_sign) = '1') else
                 pluszero  when (l_expo or w_expo) = x"00" else
                 (w_sign & w_expo & w_frac);

  flag  <= "10" when w_expo = x"FF" else
           "11" when l_expo = x"00" else
           "01" when tmp_shift3 > 25 else 
           "00";

  way1  <= "11" when flag /= "00" else
           "00" when w_sign = l_sign else
           "01" when tmp_shift3 > 1 else
           "10";

  result1 <= tmp_result1 when flag = "10" else
             tmp_result2 when flag = "11" else
             (w_sign & w_expo & w_frac);

  sign1   <= w_sign;
  expo1   <= w_expo;
  w_frac1 <= w_frac;
  l_frac1 <= l_frac;
  shift1  <= tmp_shift3(4 downto 0);

end struct;

