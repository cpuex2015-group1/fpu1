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

architecture fpu4 of top is

  signal clk,iclk: std_logic;
  type input_rom  is array(0 to 9) of std_logic_vector(31 downto 0);
  type output_rom is array(0 to 9) of std_logic_vector(31 downto 0);

  constant input_data: input_rom :=(
    "01100111110001100110100101110011",
    "01010001111111110100101011101100",
    "00101001110011011011101010101011",
    "11110010111110111110001101000110",
    "01111100110000100101010011111000",
    "00011011111010001110011110001101",
    "01110110010110100010111001100011",
    "00110011100111111100100110011010",
    "01100110001100100000110110110111",
    "00110001010110001010001101011010");

  constant answer_data: output_rom :=(
    "01010011100111110101110100001101",
    "01001000101101001100010011100001",
    "00110100101000100100011010000101",
    "01111111110000000000000000000000",
    "01011110000111011011011101101001",
    "00101101101011001010100100101101",
    "01011010111011000101010111010111",
    "00111001100011110000001101100110",
    "01010010110101010111111110101101",
    "00111000011010110111111110000010");

  signal rom_addr: std_logic_vector(3 downto 0) := (others=>'0');
  signal input: std_logic_vector(31 downto 0) := (others=>'0');
  signal result: std_logic_vector(31 downto 0);
  signal count: std_logic_vector(3 downto 0) := "0000";
  signal errorcount: std_logic_vector(7 downto 0) := "00000000";
  signal go : std_logic := '0';
  constant wtime : std_logic_vector(15 downto 0) := x"1B16";
  signal writestate : std_logic_vector(3 downto 0) := "1001";
  signal writecountdown : std_logic_vector(15 downto 0) := (others=>'0');
  signal writebuf : std_logic_vector(7 downto 0);

  component fsqrt
  Port (
    clk    : in  STD_LOGIC;
    input  : in  STD_LOGIC_VECTOR (31 downto 0);
    output : out STD_LOGIC_VECTOR (31 downto 0));
  end component;

begin
  ib: IBUFG port map (
    i=>MCLK1,
    o=>iclk);
  bg: BUFG port map (
    i=>iclk,
    o=>clk);

  squareroot: fsqrt port map(
    clk    => clk,
    input  => input,
    output => result);

  test : process(clk)
  begin
    if rising_edge(clk) then

      if count < "0011" then
        input <= input_data(conv_integer(rom_addr));
        rom_addr <= rom_addr + 1;
        count <= count + 1;

      elsif count = "0011" then
        if rom_addr = 9 then
          count <= "0100";
        end if;
        if answer_data(conv_integer(rom_addr) - 3) /= result then
          errorcount <= errorcount + 1;
        end if;
        input <= input_data(conv_integer(rom_addr));
        rom_addr <= rom_addr + 1;
        
      elsif count < "0111"  then
        if answer_data(conv_integer(rom_addr) - 3) /= result then
          errorcount <= errorcount + 1;
        end if;
        rom_addr <= rom_addr + 1;
        count <= count + 1;
      elsif count = "0111" then
        go <= '1';
        count <= "1111";
      end if;


      if writestate = "1001" then
        if go = '1' then
          RS_TX <= '0';
          writebuf <= errorcount;
          writestate <= "0000";
          writecountdown <= wtime;
        else
          RS_TX <= '1';
        end if;
      elsif writestate = "1000" then
        if writecountdown = 0 then
          RS_TX <= '1';
          writestate <= "1001";
          go <= '0';
        else
          writecountdown <= writecountdown - 1;
        end if;
      else
        if writecountdown = 0 then
          RS_TX <= writebuf(0);
          writebuf <= '1' & writebuf(7 downto 1);
          writecountdown <= wtime;
          writestate <= writestate + 1;
        else
          writecountdown <= writecountdown - 1;
        end if;
      end if;

    end if;
  end process;

end fpu4;

