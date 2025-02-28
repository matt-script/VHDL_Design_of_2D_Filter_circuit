----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2024 02:39:35
-- Design Name: 
-- Module Name: bufgen - Behavioral
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

entity bufgen is
  Port (clk, rst: in std_logic;
        cmd: in std_logic_vector(1 downto 0);
        sel: in std_logic_vector(2 downto 0);
        pixels: in std_logic_vector(71 downto 0);
        pixout: out std_logic_vector(71 downto 0) );
end bufgen;

architecture Behavioral of bufgen is

component padd is
  Port (clk, rst, c0: in std_logic;
        sel: in std_logic_vector(2 downto 0);
        pixels: in std_logic_vector(71 downto 0);
        b_out, n_out: out std_logic_vector(71 downto 0) );
end component;

component mirror is
  Port (clk, rst: in std_logic;
        sel: in std_logic_vector(2 downto 0);
        pixels: in std_logic_vector(71 downto 0);
        pixout: out std_logic_vector(71 downto 0) );
end component;

signal mirr_int, black_int, white_int, padd_int, pix_int: std_logic_vector(71 downto 0);

begin

  PAD: padd port map(clk, rst, cmd(0), sel, pixels, white_int, black_int);
  MIRR: mirror port map(clk, rst, sel, pixels, mirr_int);
  
  MUX2a: for i in 0 to 71 generate
    MUXF7_inst : MUXF7
        port map (
           O => padd_int(i),    -- Output of MUX to general routing
           I0 => black_int(i),  -- Input (tie to LUT6 O6 pin)
           I1 => white_int(i),  -- Input (tie to LUT6 O6 pin)
           S => cmd(0)     -- Input select to MUX
        );
  end generate;
  
   MUX2b: for i in 0 to 71 generate
    MUXF8_inst : MUXF8
        port map (
           O => pix_int(i),    -- Output of MUX to general routing
           I0 => mirr_int(i),  -- Input (tie to LUT6 O6 pin)
           I1 => padd_int(i),  -- Input (tie to LUT6 O6 pin)
           S => cmd(1)     -- Input select to MUX
        );
  end generate;

    process(clk, rst)
    begin
     if(rst = '1') then
        pixout <= (others=>'0');
     elsif(rising_edge(clk)) then
        pixout <= pix_int;
     end if;
    end process;

end Behavioral;
