library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fadd is
  Port (
    clk     : in  STD_LOGIC;
    input1  : in  STD_LOGIC_VECTOR (31 downto 0);
    input2  : in  STD_LOGIC_VECTOR (31 downto 0);
    output  : out STD_LOGIC_VECTOR (31 downto 0));
end fadd;

architecture struct of fadd is

  component fadd_step1 
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
  end component;

  component fadd_step2a is
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
  end component;

  component fadd_step2b is
    Port (
      w_frac1 : in STD_LOGIC_VECTOR (22 downto 0);
      l_frac1 : in STD_LOGIC_VECTOR (22 downto 0);
      shift1  : in STD_LOGIC_VECTOR (4 downto 0);
      flag2   : out STD_LOGIC;
      frac2   : out STD_LOGIC_VECTOR (25 downto 0));
  end component;

  component fadd_step2c is
    Port (
      w_frac1 : in STD_LOGIC_VECTOR (22 downto 0);
      l_frac1 : in STD_LOGIC_VECTOR (22 downto 0);
      shift1  : in STD_LOGIC_VECTOR (4 downto 0);
      count2  : out STD_LOGIC_VECTOR (4 downto 0);
      frac2   : out STD_LOGIC_VECTOR (25 downto 0));
  end component;

  component fadd_step3a is
    Port (
      flag2   : in STD_LOGIC;
      sign2   : in STD_LOGIC;
      expo2   : in STD_LOGIC_VECTOR (7 downto 0);
      frac2   : in STD_LOGIC_VECTOR (25 downto 0);
      result3 : out STD_LOGIC_VECTOR (31 downto 0));
  end component;

  component fadd_step3b is
    Port (
      flag2   : in STD_LOGIC;
      sign2   : in STD_LOGIC;
      expo2   : in STD_LOGIC_VECTOR (7 downto 0);
      frac2   : in STD_LOGIC_VECTOR (25 downto 0);
      result3 : out STD_LOGIC_VECTOR (31 downto 0));
  end component;

  component fadd_step3c is
    Port (
      count2  : in STD_LOGIC_VECTOR (4 downto 0);
      sign2   : in STD_LOGIC;
      expo2   : in STD_LOGIC_VECTOR (7 downto 0);
      frac2   : in STD_LOGIC_VECTOR (25 downto 0);
      result3 : out STD_LOGIC_VECTOR (31 downto 0));
  end component;

  signal way1        :  STD_LOGIC_VECTOR (1 downto 0);
  signal way2        :  STD_LOGIC_VECTOR (1 downto 0);
  signal way3        :  STD_LOGIC_VECTOR (1 downto 0);
  signal result1d    :  STD_LOGIC_VECTOR (31 downto 0);
  signal result2d    :  STD_LOGIC_VECTOR (31 downto 0);
  signal result3d    :  STD_LOGIC_VECTOR (31 downto 0);

  signal sign1_out   :  STD_LOGIC;
  signal expo1_out   :  STD_LOGIC_VECTOR (7 downto 0);
  signal w_frac1_out :  STD_LOGIC_VECTOR (22 downto 0);
  signal l_frac1_out :  STD_LOGIC_VECTOR (22 downto 0);
  signal shift1_out  :  STD_LOGIC_VECTOR (4 downto 0);

  signal sign1_in    :  STD_LOGIC;
  signal expo1_in    :  STD_LOGIC_VECTOR (7 downto 0);
  signal w_frac1_in  :  STD_LOGIC_VECTOR (22 downto 0);
  signal l_frac1_in  :  STD_LOGIC_VECTOR (22 downto 0);
  signal shift1_in   :  STD_LOGIC_VECTOR (4 downto 0);

  signal flag2a_out  :  STD_LOGIC;
  signal sign2_out  :  STD_LOGIC;
  signal expo2_out  :  STD_LOGIC_VECTOR (7 downto 0);
  signal frac2a_out  :  STD_LOGIC_VECTOR (25 downto 0);

  signal flag2b_out  :  STD_LOGIC;
  signal frac2b_out  :  STD_LOGIC_VECTOR (25 downto 0);

  signal count2c_out :  STD_LOGIC_VECTOR (4 downto 0);
  signal frac2c_out  :  STD_LOGIC_VECTOR (25 downto 0);

  signal flag2a_in   :  STD_LOGIC;
  signal sign2_in   :  STD_LOGIC;
  signal expo2_in   :  STD_LOGIC_VECTOR (7 downto 0);
  signal frac2a_in   :  STD_LOGIC_VECTOR (25 downto 0);

  signal flag2b_in   :  STD_LOGIC;
  signal frac2b_in   :  STD_LOGIC_VECTOR (25 downto 0);

  signal count2c_in  :  STD_LOGIC_VECTOR (4 downto 0);
  signal frac2c_in   :  STD_LOGIC_VECTOR (25 downto 0);

  signal result3a    :  STD_LOGIC_VECTOR (31 downto 0);
  signal result3b    :  STD_LOGIC_VECTOR (31 downto 0);
  signal result3c    :  STD_LOGIC_VECTOR (31 downto 0);

begin

  step1 : fadd_step1 PORT MAP (
      input1  => input1,
      input2  => input2,
      way1    => way1,
      result1 => result1d,
      sign1   => sign1_out,
      expo1   => expo1_out,
      w_frac1 => w_frac1_out,
      l_frac1 => l_frac1_out,
      shift1  => shift1_out);

  step2a : fadd_step2a PORT MAP (
      sign1   => sign1_in,
      expo1   => expo1_in,
      w_frac1 => w_frac1_in,
      l_frac1 => l_frac1_in,
      shift1  => shift1_in,
      flag2   => flag2a_out,
      sign2   => sign2_out,
      expo2   => expo2_out,
      frac2   => frac2a_out);

  step2b : fadd_step2b PORT MAP (
      w_frac1 => w_frac1_in,
      l_frac1 => l_frac1_in,
      shift1  => shift1_in,
      flag2   => flag2b_out,
      frac2   => frac2b_out);

  step2c : fadd_step2c PORT MAP (
      w_frac1 => w_frac1_in,
      l_frac1 => l_frac1_in,
      shift1  => shift1_in,
      count2  => count2c_out,
      frac2   => frac2c_out);

  step3a : fadd_step3a PORT MAP (
      flag2   => flag2a_in,
      sign2   => sign2_in,
      expo2   => expo2_in,
      frac2   => frac2a_in,
      result3 => result3a);

  step3b : fadd_step3b PORT MAP (
      flag2   => flag2b_in,
      sign2   => sign2_in,
      expo2   => expo2_in,
      frac2   => frac2b_in,
      result3 => result3b);

  step3c : fadd_step3c PORT MAP (
      count2  => count2c_in,
      sign2   => sign2_in,
      expo2   => expo2_in,
      frac2   => frac2c_in,
      result3 => result3c);

  output <= result3a when way3 = "00" else
            result3b when way3 = "01" else
            result3c when way3 = "10" else
            result3d;

  floatadd : process(clk)
  begin
    if rising_edge(clk) then

      way2 <= way1;
      way3 <= way2;
      result2d <= result1d;
      result3d <= result2d;     

      sign1_in   <= sign1_out;
      expo1_in   <= expo1_out;
      w_frac1_in <= w_frac1_out;
      l_frac1_in <= l_frac1_out;
      shift1_in  <= shift1_out;

      sign2_in   <= sign2_out;
      expo2_in   <= expo2_out;

      flag2a_in  <= flag2a_out;
      frac2a_in  <= frac2a_out;

      flag2b_in  <= flag2b_out;
      frac2b_in  <= frac2b_out;

      count2c_in <= count2c_out;
      frac2c_in  <= frac2c_out;

    end if;
  end process;
    
end struct;


