library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP is
generic(nv: integer := 16;
        nf: integer := 15;
        ddim: integer := 32;
        bdim: integer := 5 );
port(clk,rst, go: in std_logic;
cmd: in std_logic_vector(1 downto 0);
pixel_in: in std_logic_vector(23 downto 0);
wc,wl,w: in std_logic_vector(23 downto 0);
pixel_out: out std_logic_vector(23 downto 0);
valid, finish: out std_logic );
end TOP;

architecture Behavioral of TOP is

component  TOP_PIX is
port(pixels: in std_logic_vector(71 downto 0);
wc,wl,w: in std_logic_vector(7 downto 0);
clk,rst: in std_logic;
pix_out: out std_logic_vector(7 downto 0));
end component;

component state_dec is
  generic( ddim: integer;
           bdim: integer );
  Port ( clk, rst, go: in std_logic;
         stato: out std_logic_vector(3 downto 0);
         finish: out std_logic );
end component;

component newbuf is
generic (d: integer);
  Port (clk, rst: in std_logic;
        cmd: in std_logic_vector(1 downto 0);
        stato: in std_logic_vector(3 downto 0);
        pixin: in std_logic_vector(7 downto 0);
        pixout: out std_logic_vector(71 downto 0) );
end component;

component fifo is
generic(n: integer);
Port (Din: in std_logic;
clk, rst: in std_logic;
Q: out std_logic
);
end component;

signal go_int, finish_int: std_logic;
signal stato_int: std_logic_vector (3 downto 0);
signal pixels_int, fsm_pix: std_logic_vector(215 downto 0);

begin

START: fifo generic map(ddim+1)
            port map(go, clk, rst, go_int);
VALID_FLAG: fifo generic map(nv)
            port map(go_int, clk, rst, valid);

F_S_M: state_dec generic map(ddim, bdim)
                 port map(clk, rst, go_int, stato_int, finish_int);       
            
END_FLAG: fifo generic map(nf)
               port map(finish_int, clk, rst, finish);
            

RGB: for i in 0 to 2 generate
    BUF: newbuf generic map(ddim)
                port map(clk, rst, cmd, stato_int, pixel_in(8*i+7 downto 8*i), pixels_int(72*i+71 downto 72*i));
    
    TO_HW_i: TOP_PIX port map(pixels_int(72*i+71 downto 72*i),
                              wc(8*i+7 downto 8*i), wl(8*i+7 downto 8*i), w(8*i+7 downto 8*i),
                              clk, rst,
                              pixel_out(8*i+7 downto 8*i));
end generate;

end Behavioral;
