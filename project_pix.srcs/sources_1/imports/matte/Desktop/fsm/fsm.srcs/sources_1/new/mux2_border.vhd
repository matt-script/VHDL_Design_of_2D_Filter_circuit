library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux2_border is
  Port (clk, rst, sel: in std_logic;
        prop, gen: in std_logic_vector(7 downto 0);
        pixout: out std_logic_vector(7 downto 0) );
end mux2_border;


architecture Behavioral of mux2_border is

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
        pix_int <= gen when '0',
                   prop when '1',
                   "00000000" when others;

--    PIX: for i in 0 to 7 generate
--        MUX: mux2_f8 port map(gen(i), prop(i), sel, pix_int(i));
--    end generate;
                  
    process(clk, rst)
    begin
     if(rst = '1') then
        pixout <= (others=>'0');
     elsif(rising_edge(clk)) then
        pixout <= pix_int;
     end if;
    end process;

end Behavioral;
