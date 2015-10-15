library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity top is
  Port ( MCLK1 : in  STD_LOGIC;
         RS_TX : out  STD_LOGIC);
end top;

architecture fpu1 of top is

  function shift_l(s : std_logic_vector(7 downto 0); k : integer)
    return std_logic_vector
  is
    variable t : std_logic_vector(7 downto 0);
  begin
    case k is
      when 0 => t := s;
      when 1 => t := s(6 downto 0) & "0";
      when 2 => t := s(5 downto 0) & "00";
      when 3 => t := s(4 downto 0) & "000";
      when 4 => t := s(3 downto 0) & "0000";
      when 5 => t := s(2 downto 0) & "00000";
      when 6 => t := s(1 downto 0) & "000000";
      when 7 => t := s(0) & "0000000";
      when others => t := (others => '0');
    end case;
    return t;
  end shift_l; 

  signal clk,iclk: std_logic;
  type rom_t is array(0 to 19) of std_logic_vector(31 downto 0);

  constant input1_data: rom_t :=(
    "01111111100000000000000000000001",
    "11111111100000000000000000000000",
    "01111111100000000000000000000000",
    "10000000000100100001001000000000",
    "00000000000100100001011010000000",
    "00000000000000000011100110000000",
    "00110000000000001000100000100000",
    "01111111011111111011100000101000",
    "11111111011101111010010001001100",
    "10001110011111111000100000100000",
    "01000011000110010101110100001110",
    "00000110011000100011100110001110",
    "10001110011111011000000000100000",
    "00110100011000011010000000000000",
    "00010011000000010101110101001110",
    "10000001011111010101001000001000",
    "01010100100100011010000001101000",
    "01100100101011001000101000100010",
    "10000001100000001000101001101110",
    "00110100110101001010010101100010");

  constant input2_data: rom_t :=(
    "01010101010101010101010101010101",
    "01111111100000000000000000000000",
    "00110011001100110011001100110011",
    "10000000000000100010000000000010",
    "10000000000100100010010000110010",
    "10000110000000000000000000000000",
    "00000000100000100001000010000110",
    "01111101000000010000100000000000",
    "11111110100010001110000000000000",
    "10001011110000001001000010000110",
    "01000110101101100110110110100110",
    "10101100100000000000000000000000",
    "01001001110001101011001010000110",
    "10110101011000100010010101101001",
    "10010111100001100110110110100110",
    "00000001100000101001010001000000",
    "11010101000100100011101011101001",
    "11100100101011001000101000100010",
    "00000001100000000101100100011101",
    "10110100110010101100000110101001");

  constant answer_data: rom_t :=(
    "01111111100000000000000000000001",
    "01111111110000000000000000000000",
    "01111111100000000000000000000000",
    "10000000000000000000000000000000",
    "00000000000000000000000000000000",
    "10000110000000000000000000000000",
    "00110000000000001000100000100000",
    "01111111100000000000000000000000",
    "11111111100000000000000000000000",
    "10001110100000101100011001010010",
    "01000110101101111010000001100000",
    "10101100100000000000000000000000",
    "01001001110001101011001010000110",
    "10110101001010011011110101101001",
    "10010111100001100010110011110111",
    "00000000000000000000000000000000",
    "11010100100100101101010101101010",
    "00000000000000000000000000000000",
    "00000000000000000000000000000000",
    "00110010100111100011101110010000");

  signal rom_addr: std_logic_vector(5 downto 0) := (others=>'0');

  signal input1: std_logic_vector(31 downto 0) := (others=>'0');
  signal input2: std_logic_vector(31 downto 0) := (others=>'0');

  signal result: std_logic_vector(31 downto 0);

  signal count: std_logic_vector(3 downto 0) := "0000";
  signal errorcount: std_logic_vector(7 downto 0) := "00000000";
  
  signal go : std_logic := '0';
  signal busy : std_logic := '0';

  component serialif
  port (
    serialO : out std_logic;
    dataIN  : in  std_logic_vector(7 downto 0);
    send    : in  std_logic;
    full    : out std_logic;    
    clk     : in  std_logic);
  end component;

  component fadd
  Port (
    input1  : in  STD_LOGIC_VECTOR (31 downto 0);
    input2  : in  STD_LOGIC_VECTOR (31 downto 0);
    output : out STD_LOGIC_VECTOR (31 downto 0));
  end component;

begin
  ib: IBUFG port map (
    i=>MCLK1,
    o=>iclk);
  bg: BUFG port map (
    i=>iclk,
    o=>clk);

  floatadd: fadd port map(
    input1 => input1,
    input2 => input2,
    output => result);

  rs232c: serialif
  port map (
    clk=>clk,
    dataIN=>errorcount,
    send=>go,
    full=>busy,
    serialO=>rs_tx);

  test : process(clk)
  begin
    if rising_edge(clk) then

      if count = "0000" then
        input1 <= input1_data(conv_integer(rom_addr));
        input2 <= input2_data(conv_integer(rom_addr));
        count <= count + 1;
      elsif count = "1111" then
        if rom_addr = "10011" then
          if answer_data(conv_integer(rom_addr)) /= result then
            errorcount <= errorcount + 1;
          end if;
          go <= '1';
        else
          rom_addr <= rom_addr + 1;
          if answer_data(conv_integer(rom_addr)) /= result then
            errorcount <= errorcount + 1;
          end if;
          count <= "0000";
        end if;
      else
        count <= count + 1;
      end if;

    end if;
  end process;

end fpu1;

