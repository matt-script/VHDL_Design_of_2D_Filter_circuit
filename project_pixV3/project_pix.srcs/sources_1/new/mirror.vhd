----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2024 02:01:13
-- Design Name: 
-- Module Name: mirror - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mirror  is
  Port (clk, rst: in std_logic;
        sel: in std_logic_vector(2 downto 0);
        pixels: in std_logic_vector(71 downto 0);
        pixout: out std_logic_vector(71 downto 0) );
end mirror;

architecture Behavioral of mirror is

component mux8_72bit is
  Port (clk, rst: in std_logic;
        sel: in std_logic_vector(2 downto 0);
        nordovest, up, nordest, left, right, sudovest, down, sudest: in std_logic_vector(71 downto 0);
        pixout: out std_logic_vector(71 downto 0) );
end component;

signal pix1, pix2, pix3, pix4, pix5, pix6, pix7, pix8, pix9: std_logic_vector(7 downto 0);
signal state1, state2, state3, state4, state5, state6, state7, state8, pixels_in, pixint: std_logic_vector(71 downto 0);
signal sel_in: std_logic_vector(2 downto 0);

begin

--  process(clk, rst)
--  begin
--     if(rst = '1') then
--        sel_in <= (others=>'0');
--        pixels_in <= (others=>'0');
--     elsif(rising_edge(clk)) then
--        sel_in <= sel;
--        pixels_in <= pixels;
--     end if;
--  end process;

  pix1 <= pixels(71 downto 64);
  pix2 <= pixels(63 downto 56);
  pix3 <= pixels(55 downto 48);
  pix4 <= pixels(47 downto 40);
  pix5 <= pixels(39 downto 32);
  pix6 <= pixels(31 downto 24);
  pix7 <= pixels(23 downto 16);
  pix8 <= pixels(15 downto 8);
  pix9 <= pixels(7 downto 0);
  
  state1 <= pix9 & pix8 & pix9 & pix6 & pix5 & pix6 & pix9 & pix8 & pix9;  
  state2 <= pix7 & pix8 & pix9 & pix4 & pix5 & pix6 & pix7 & pix8 & pix9;  
  state3 <= pix7 & pix8 & pix7 & pix4 & pix5 & pix4 & pix7 & pix8 & pix7;  
  state4 <= pix3 & pix2 & pix3 & pix6 & pix5 & pix6 & pix9 & pix8 & pix9;  
  state5 <= pix1 & pix2 & pix1 & pix4 & pix5 & pix4 & pix7 & pix8 & pix7;  
  state6 <= pix3 & pix2 & pix3 & pix6 & pix5 & pix6 & pix3 & pix2 & pix3;  
  state7 <= pix1 & pix2 & pix3 & pix4 & pix5 & pix6 & pix1 & pix2 & pix3;  
  state8 <= pix1 & pix2 & pix1 & pix4 & pix5 & pix4 & pix1 & pix2 & pix1;
  
  PAD: mux8_72bit port map(clk, rst, sel,
                            state1,
                            state2,
                            state3,
                            state4,
                            state5,
                            state6,
                            state7,
                            state8,
                            pixint);
                            
  process(clk, rst)
  begin
     if(rst = '1') then
        pixout <= (others=>'0');
     elsif(rising_edge(clk)) then
        sel_in <= sel;
        pixout <= pixint;
     end if;
  end process;

end Behavioral;
