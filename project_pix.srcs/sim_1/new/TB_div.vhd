----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.05.2024 21:56:27
-- Design Name: 
-- Module Name: TB_div - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.std_logic_ARITH.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB_stateDec is
--  Port ( );
end TB_stateDec;

architecture Behavioral of TB_stateDec is

component state_dec IS
  Port ( clk, rst, go: in std_logic;
         cmd: in std_logic_vector(1 downto 0);
         valid, finish, border: out std_logic 
  );
end component;

signal reset, go_in, valid_out, finish_out, border_out: std_logic;
signal cmd_in: std_logic_vector(1 downto 0);
signal clock: std_logic := '0';
constant clk_period : time := 2.6 ns;

begin

dut: state_dec
    port map(clock, reset, go_in, cmd_in, valid_out, finish_out, border_out);

process
 begin
 wait for clk_period/2;
 clock<= not clock;
 end process;
 
process
 begin
 reset <= '1';
 wait for 150 ns;
 reset <= '0';
 go_in <= '1';
 cmd_in <= "10";
 wait;
 end process;

end Behavioral;
