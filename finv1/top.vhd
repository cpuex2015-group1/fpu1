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

architecture fpu3 of top is

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
    "00010111001001010010011011000001",
    "00101101000000000101101011001011",
    "01010101000111110100011100000010",
    "10001100000000100001011011110110",
    "00000010001010001001111001100110",
    "01100011000011001011000101100000",
    "00001000100101100010111111100110",
    "01001011010011010001001010000110",
    "00011000101110000000100011010110",
    "01001101100101110100000111000010");

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

  component finv
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

  floatinv: finv port map(
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

end fpu3;

