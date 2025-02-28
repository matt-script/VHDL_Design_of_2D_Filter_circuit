----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2024 00:57:06
-- Design Name: 
-- Module Name: mux4_8bit - Behavioral
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

entity mux8_72bit is
    generic(n: integer := 72);
  Port (clk, rst: in std_logic;
        sel: in std_logic_vector(2 downto 0);
        nordovest, up, nordest, left, right, sudovest, down, sudest: in std_logic_vector(n-1 downto 0);
        pixout: out std_logic_vector(n-1 downto 0) );
end mux8_72bit;


architecture Behavioral of mux8_72bit is

--component mux2_f7 is
--  Port (a, b, s: in std_logic;
--        o: out std_logic );
--end component;

--component mux2_f8 is
--  Port (a, b, s: in std_logic;
--        o: out std_logic );
--end component;

signal state_int0, state_int1: std_logic_vector(n-1 downto 0);

begin
  
  MUX8: for i in 0 to n-1 generate
    LUT6_0: LUT6
        generic map (
            INIT => "1111111100000000111100001111000011001100110011001010101010101010"  
        )
        port map (
            I0 => nordovest(i),
            I1 => up(i),
            I2 => nordest(i),
            I3 => left(i),
            I4 => sel(0),
            I5 => sel(1),
            O  => state_int0(i)
        );

    LUT6_1: LUT6
        generic map (
            INIT => "1111111100000000111100001111000011001100110011001010101010101010"  
        )
        port map (
            I0 => right(i),
            I1 => sudovest(i),
            I2 => down(i),
            I3 => sudest(i),
            I4 => sel(0),
            I5 => sel(1),
            O  => state_int1(i)
        );


    MUXF7_inst : MUXF7
        port map (
           O => pixout(i),    -- Output of MUX to general routing
           I0 => state_int0(i),  -- Input (tie to LUT6 O6 pin)
           I1 => state_int1(i),  -- Input (tie to LUT6 O6 pin)
           S => sel(2)     -- Input select to MUX
        );
  end generate;

end Behavioral;