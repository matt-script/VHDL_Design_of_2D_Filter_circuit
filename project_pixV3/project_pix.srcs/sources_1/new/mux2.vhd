----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2024 01:04:50
-- Design Name: 
-- Module Name: mux2 - Behavioral
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

Library UNISIM;
use UNISIM.vcomponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux2_f7 is
  Port (a, b, s: in std_logic;
        o: out std_logic );
end mux2_f7;

architecture Behavioral of mux2_f7 is

begin

MUXF7_inst : MUXF7
port map (
   O => o,    -- Output of MUX to general routing
   I0 => a,  -- Input (tie to LUT6 O6 pin)
   I1 => b,  -- Input (tie to LUT6 O6 pin)
   S => s     -- Input select to MUX
);


end Behavioral;
