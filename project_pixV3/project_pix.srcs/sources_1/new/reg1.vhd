----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.05.2024 11:23:23
-- Design Name: 
-- Module Name: reg1 - Behavioral
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

entity reg is
Port (Din: in std_logic;
clk, rst: in std_logic;
Q: out std_logic
);
end reg;

architecture Behavioral of reg is
begin
 process(clk,rst)
 begin
 if (rst='1') then
 Q <='0';
 elsif rising_edge(clk) then 
  Q<=Din;
  end if; 
 end process;

end Behavioral;
