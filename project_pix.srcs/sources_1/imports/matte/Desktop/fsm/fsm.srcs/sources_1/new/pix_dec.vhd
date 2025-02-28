----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2024 03:44:17
-- Design Name: 
-- Module Name: out_dec - Behavioral
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


entity pix_dec is
  Port (clk, rst, border_sel: in std_logic;
        cmd_sel: in std_logic_vector (1 downto 0);
        state_sel: in std_logic_vector (2 downto 0);
        pixin, nero, bianco: in std_logic_vector (7 downto 0);
        pixels: in std_logic_vector (63 downto 0);
        pixout: out std_logic_vector (7 downto 0) );
end pix_dec;


architecture Behavioral of pix_dec is

component mux3_8bit is
  Port (clk, rst: in std_logic;
        sel: in std_logic_vector(1 downto 0);
        blackpadd, whitepadd, mirror: in std_logic_vector(7 downto 0);
        pixout: out std_logic_vector(7 downto 0) );
 end component;
 
 component mux8_8bit is
  Port (clk, rst: in std_logic;
        sel: in std_logic_vector(2 downto 0);
        nordovest, up, nordest, left, right, sudovest, down, sudest: in std_logic_vector(7 downto 0);
        pixout: out std_logic_vector(7 downto 0) );
 end component;

 component mux2_border is
  Port (clk, rst, sel: in std_logic;
        prop, gen: in std_logic_vector(7 downto 0);
        pixout: out std_logic_vector(7 downto 0) );
 end component;
 
 signal state: std_logic_vector(63 downto 0);
 signal pixgen, pixin1, pixin2: std_logic_vector(7 downto 0);

begin

    STATO: for i in 0 to 7 generate
        mux: mux3_8bit port map(clk, rst, cmd_sel, nero, bianco, pixels(8*(7-i)+7 downto 8*(7-i)), state(8*i+7 downto 8*i));
    end generate;
    
    GEN: mux8_8bit port map(clk, rst, state_sel,
                            state(7 downto 0),
                            state(15 downto 8),
                            state(23 downto 16),
                            state(31 downto 24),
                            state(39 downto 32),
                            state(47 downto 40),
                            state(55 downto 48),
                            state(63 downto 56),
                            pixgen(7 downto 0));
                            
    PIX_OUT: mux2_border port map(clk, rst, border_sel, pixin2, pixgen, pixout);

    process(clk, rst)
    begin
     if(rst = '1') then
        pixin1 <= (others=>'0');
        pixin2 <= (others=>'0');
     elsif(rising_edge(clk)) then
        pixin1 <= pixin;
        pixin2 <= pixin1;
     end if;
    end process;

end Behavioral;
