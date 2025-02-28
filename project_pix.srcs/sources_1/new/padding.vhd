----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2024 00:22:59
-- Design Name: 
-- Module Name: padding - Behavioral
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

library UNISIM;
use UNISIM.VComponents.all;

entity padd is
  Port (clk, rst, c0: in std_logic;
        sel: in std_logic_vector(2 downto 0);
        pixels: in std_logic_vector(71 downto 0);
        b_out, n_out: out std_logic_vector(71 downto 0) );
end padd;


architecture Behavioral of padd is

component mux8_72bit is
  Port (clk, rst: in std_logic;
        sel: in std_logic_vector(2 downto 0);
        nordovest, up, nordest, left, right, sudovest, down, sudest: in std_logic_vector(71 downto 0);
        pixout: out std_logic_vector(71 downto 0) );
end component;

signal state1, state2, state3, state4, state5, state6, state7, state8, state_int: std_logic_vector(143 downto 0);
signal pix1, pix2, pix3, pix4, pix5, pix6, pix7, pix8, pix9, b, n: std_logic_vector(7 downto 0);
--signal pix_int: std_logic_vector(71 downto 0);

begin
  
  pix1 <= pixels(71 downto 64);
  pix2 <= pixels(63 downto 56);
  pix3 <= pixels(55 downto 48);
  pix4 <= pixels(47 downto 40);
  pix5 <= pixels(39 downto 32);
  pix6 <= pixels(31 downto 24);
  pix7 <= pixels(23 downto 16);
  pix8 <= pixels(15 downto 8);
  pix9 <= pixels(7 downto 0);
  n <= "00000000";
  b <= "11111111";
  
  state1 <= b & b & b & b & pix5 & pix6 & pix7 & pix8 & pix9 &
            n & n & n & n & pix5 & pix6 & pix7 & pix8 & pix9;
            
  state2 <= b & b & b & pix4 & pix5 & pix6 & pix7 & pix8 & pix9 &
            n & n & n & pix4 & pix5 & pix6 & pix7 & pix8 & pix9;
            
  state3 <= b & b & b & pix4 & pix5 & b & pix7 & pix8 & b &
            n & n & n & pix4 & pix5 & n & pix7 & pix8 & n;
            
  state4 <= b & pix2 & pix3 & b & pix5 & pix6 & b & pix8 & pix9 &
            n & pix2 & pix3 & n & pix5 & pix6 & n & pix8 & pix9;
            
  state5 <= pix1 & pix2 & b & pix4 & pix5 & b & pix7 & pix8 & b &
            pix1 & pix2 & n & pix4 & pix5 & n & pix7 & pix8 & n;
            
  state6 <= b & pix2 & pix3 & b & pix5 & pix6 & b & b & b &
            n & pix2 & pix3 & n & pix5 & pix6 & n & n & n;
            
  state7 <= pix1 & pix2 & pix3 & pix4 & pix5 & pix6 & b & b & b &
            pix1 & pix2 & pix3 & pix4 & pix5 & pix6 & n & n & n;
            
  state8 <= pix1 & pix2 & b & pix4 & pix5 & pix6 & b & b & b &
            pix1 & pix2 & n & pix4 & pix5 & pix6 & n & n & n;
  
                             
  B_W: for i in 0 to 1 generate
    PAD: mux8_72bit port map(clk, rst, sel,
                            state1(72*i+71 downto 72*i),
                            state2(72*i+71 downto 72*i),
                            state3(72*i+71 downto 72*i),
                            state4(72*i+71 downto 72*i),
                            state5(72*i+71 downto 72*i),
                            state6(72*i+71 downto 72*i),
                            state7(72*i+71 downto 72*i),
                            state8(72*i+71 downto 72*i),
                            state_int(72*i+71 downto 72*i));
  end generate;
  
--  MUX2: for i in 0 to 71 generate
--    MUXF8_inst : MUXF8
--        port map (
--           O => pix_int(i),    -- Output of MUX to general routing
--           I0 => state_int(i),  -- Input (tie to LUT6 O6 pin)
--           I1 => state_int(72+i),  -- Input (tie to LUT6 O6 pin)
--           S => c0     -- Input select to MUX
--        );
--  end generate;
                  
    process(clk, rst)
    begin
     if(rst = '1') then
        b_out <= (others=>'0');
        n_out <= (others=>'0');
     elsif(rising_edge(clk)) then
        b_out <= state_int(143 downto 72);
        n_out <= state_int(71 downto 0);
     end if;
    end process;

end Behavioral;
