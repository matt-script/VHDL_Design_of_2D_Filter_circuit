----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.05.2024 11:25:50
-- Design Name: 
-- Module Name: fifo_1bit - Behavioral
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

entity fifo33 is
Port (Din: in std_logic;
clk, rst: in std_logic;
Q: out std_logic
);
end fifo33;

architecture Behavioral of fifo33 is

component reg is
Port (Din: in std_logic;
clk, rst: in std_logic;
Q: out std_logic
);
end component;

signal dint: std_logic_vector(34 downto 0);

begin

    dint(0) <= Din;
    FIFO: for i in 0 to 33 generate
        FLIP_FLOP: reg port map(dint(i), clk, rst, dint(i+1));
    end generate;
    Q <= dint(34);

end Behavioral;
