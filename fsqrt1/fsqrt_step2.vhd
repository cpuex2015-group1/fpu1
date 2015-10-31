library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsqrt_step2 is
  Port (
    input     : in  STD_LOGIC_VECTOR (31 downto 0);
    flag_in   : in  STD_LOGIC;
    data1_in  : in  STD_LOGIC_VECTOR (22 downto 0);
    data2     : in  STD_LOGIC_VECTOR (12 downto 0);
    output    : out STD_LOGIC_VECTOR (31 downto 0);
    flag_out  : out STD_LOGIC;
    var       : out STD_LOGIC_VECTOR (13 downto 0);
    data1_out : out STD_LOGIC_VECTOR (22 downto 0));
end fsqrt_step2;

architecture struct of fsqrt_step2 is

  signal tmp_frac : std_logic_vector(28 downto 0);

begin

  tmp_frac  <= ('0' & input(13 downto 0)) * ('1' & data2) when input(23) = '1' else
               (input(13 downto 0) & '0') * ('1' & data2);
  var       <= tmp_frac(28 downto 15);
  output    <= input;
  flag_out  <= flag_in;
  data1_out <= data1_in;

end struct;

