library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity state_dec is
  generic( ddim: integer;
           bdim: integer );
  Port ( clk, rst: in std_logic;
         go: in std_logic;
         stato: out std_logic_vector(3 downto 0);
         finish: out std_logic );
end state_dec;


architecture Behavioral of state_dec is

type state_type is (start, nordovest, up, nordest, left, center, right, sudovest, down, sudest, idle);
signal state : state_type;
signal count_o, count_v: std_logic_vector(bdim-1 downto 0);

begin

process (clk, rst)
 begin

 if (rst = '1') then
    count_o <= (others=>'0');
    count_v <= (others=>'0');
    stato <= (others=>'0');
    finish <= '0';
    state <= start;
 elsif (rising_edge(clk)) then
 
    case state is
    
        when idle =>        state <= idle;
                            stato <= "1111";
                            finish <= '1';
                        
        when start =>       if (go = '1') then      -- se pix6 è cambiato;
                                state <= nordovest;
                            end if;
                            stato <= "1111";
                            finish <= '0';
                        
        when nordovest =>   stato <= "0000";
                            finish <= '0';
                            state <= up;
        
        when up =>          stato <= "0001";
                            finish <= '0';
                            count_o <= count_o + 1;
                            if (count_o = conv_std_logic_vector(ddim-3, bdim)) then -- se count = 29;
                                count_o <= (others => '0');
                                state <= nordest;
                            end if;
        
        when nordest =>     stato <= "0010";
                            finish <= '0';
                            state <= left;
        
        when left =>        stato <= "0011";
                            finish <= '0';
                            state <= center;
        
        when center =>      stato <= "1000";
                            finish <= '0';
                            count_o <= count_o+1;
                            if (count_o = conv_std_logic_vector(ddim-3, bdim)) then -- se count = 29;
                                 count_o <= (others => '0');
                                 state <= right;
                            end if;
        
        when right =>       stato <= "0100";
                            finish <= '0';
                            count_v <= count_v + 1;
                            if (count_v = conv_std_logic_vector(ddim-3, bdim)) then -- se count_v = 29;
                                 count_v <= (others => '0');
                                 state <= sudovest;
                            else state <= left;
                            end if;
        
        when sudovest =>    stato <= "0101";
                            finish <= '0';
                            state <= down;
        
        when down =>        stato <= "0110";
                            finish <= '0';
                            count_o <= count_o + 1;
                            if (count_o = conv_std_logic_vector(ddim-3, bdim)) then -- se count = 29;
                                 count_o <= (others => '0');
                                 state <= sudest;
                            end if;
        
        when sudest =>      stato <= "0111";
                            finish <= '1';
                            state <= idle;
        
    end case;
 end if;
 
end process;

end Behavioral;