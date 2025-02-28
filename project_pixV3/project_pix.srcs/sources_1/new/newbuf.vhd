----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2024 03:21:20
-- Design Name: 
-- Module Name: newbuf - Behavioral
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

entity newbuf is
generic (d: integer);
  Port (clk, rst: in std_logic;
        cmd: in std_logic_vector(1 downto 0);
        stato: in std_logic_vector(3 downto 0);
        pixin: in std_logic_vector(7 downto 0);
        pixout: out std_logic_vector(71 downto 0) );
end newbuf;

architecture Behavioral of newbuf is

component bufgen is
  Port (clk, rst: in std_logic;
        cmd: in std_logic_vector(1 downto 0);
        sel: in std_logic_vector(2 downto 0);
        pixels: in std_logic_vector(71 downto 0);
        pixout: out std_logic_vector(71 downto 0) );
end component;

component TOP_BUF is
generic (d: integer);
  Port (pixel_in: in std_logic_vector(7 downto 0);
        clk,rst: in std_logic;
        pixel_out: out std_logic_vector(71 downto 0) );
end component;

signal buf_int, buf_int1, buf_gen, buf_prop, pix_int: std_logic_vector(71 downto 0);
signal s, gp, gp_int: std_logic;

begin

    process(clk, rst)
    begin
     if(rst = '1') then
        buf_int1 <= (others=>'0');
        buf_prop <= (others=>'0');
        s <= '0';
        gp <= '0';
        pixout <= (others=>'0');
     elsif(rising_edge(clk)) then
        buf_int1 <= buf_int;
        buf_prop <= buf_int1;
        s <= stato(3);
        gp <= gp_int;
        pixout <= pix_int;
     end if;
    end process;
    
    BUF: top_buf generic map(d)
                 port map(pixin, clk, rst, buf_int);
                 
    GEN: bufgen port map(clk, rst, cmd, stato(2 downto 0), buf_int, buf_gen);
    
    gp_int <= (cmd(1) nor cmd(0)) or s;
    
  MUX2: for i in 0 to 71 generate
    MUXF8_inst : MUXF7
        port map (
           O => pix_int(i),    -- Output of MUX to general routing
           I0 => buf_gen(i),  -- Input (tie to LUT6 O6 pin)
           I1 => buf_prop(i),  -- Input (tie to LUT6 O6 pin)
           S => gp     -- Input select to MUX
        );
  end generate;

end Behavioral;
