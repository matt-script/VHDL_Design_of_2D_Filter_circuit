library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM; 34 15 47
--use UNISIM.VComponents.all;

entity fifo is
generic(n: integer);
Port (Din: in std_logic;
clk, rst: in std_logic;
Q: out std_logic
);
end fifo;

architecture Behavioral of fifo is

component reg is
Port (Din: in std_logic;
clk, rst: in std_logic;
Q: out std_logic
);
end component;

signal dint: std_logic_vector(n downto 0);

begin

    dint(0) <= Din;
    FIFO: for i in 0 to n-1 generate
        FLIP_FLOP: reg port map(dint(i), clk, rst, dint(i+1));
    end generate;
    Q <= dint(n);

end Behavioral;
