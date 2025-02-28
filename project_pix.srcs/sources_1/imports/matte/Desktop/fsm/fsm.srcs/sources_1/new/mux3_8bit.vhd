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


entity mux3_8bit is
  Port (clk, rst: in std_logic;
        sel: in std_logic_vector(1 downto 0);
        blackpadd, whitepadd, mirror: in std_logic_vector(7 downto 0);
        pixout: out std_logic_vector(7 downto 0) );
end mux3_8bit;


architecture Behavioral of mux3_8bit is

--component mux2_f7 is
--  Port (a, b, s: in std_logic;
--        o: out std_logic );
--end component;

--component mux2_f8 is
--  Port (a, b, s: in std_logic;
--        o: out std_logic );
--end component;

signal pix_int: std_logic_vector(7 downto 0);

begin

    with sel select
        pix_int <= blackpadd when "01",
                   whitepadd when "10",
                   mirror when "11",
                   "00000000" when others;
                  
    process(clk, rst)
    begin
     if(rst = '1') then
        pixout <= (others=>'0');
     elsif(rising_edge(clk)) then
        pixout <= pix_int;
     end if;
    end process;

end Behavioral;
