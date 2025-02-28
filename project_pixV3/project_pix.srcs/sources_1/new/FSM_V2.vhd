library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity FSM_V2 is
Port( clock, rst: in std_logic;
cmd: in std_logic_vector(1 downto 0);
valid, finish: out std_logic;
pixels: in std_logic_vector(215 downto 0);
pixels_out: out std_logic_vector(215 downto 0)
);
end FSM_V2;


architecture Behavioral of FSM_V2 is

type state_type is (start, nordovest, up, nordest, left, center, right, sudovest, down, sudest, ending, idle);
signal state, next_state : state_type;
signal cmd_int: std_logic_vector (1 downto 0);
signal count_o, count_v: std_logic_vector(5 downto 0);
signal valid_int, finish_int: std_logic := '0';
signal pix1, pix2, pix3, pix4, pix5, pix6, pix7, pix8, pix9: std_logic_vector(23 downto 0);
signal pix_int1, pix_int2, pix_int3, pix_int4, pix_int5, pix_int6, pix_int7, pix_int8, pix_int9: std_logic_vector(23 downto 0);
signal pixels_int: std_logic_vector(215 downto 0);

begin

PIXEL: for i in 0 to 2 generate
pix1(8*i+7 downto 8*i) <= pixels(71+72*i downto 64+72*i);
pix2(8*i+7 downto 8*i) <= pixels(63+72*i downto 56+72*i);
pix3(8*i+7 downto 8*i) <= pixels(55+72*i downto 48+72*i);
pix4(8*i+7 downto 8*i) <= pixels(47+72*i downto 40+72*i);
pix5(8*i+7 downto 8*i) <= pixels(39+72*i downto 32+72*i);
pix6(8*i+7 downto 8*i) <= pixels(31+72*i downto 24+72*i);
pix7(8*i+7 downto 8*i) <= pixels(23+72*i downto 16+72*i);
pix8(8*i+7 downto 8*i) <= pixels(15+72*i downto 8+72*i);
pix9(8*i+7 downto 8*i) <= pixels(7+72*i downto 72*i);

pixels_int(71+72*i downto 64+72*i) <= pix_int1(8*i+7 downto 8*i);
pixels_int(63+72*i downto 56+72*i) <= pix_int2(8*i+7 downto 8*i);
pixels_int(55+72*i downto 48+72*i) <= pix_int3(8*i+7 downto 8*i);
pixels_int(47+72*i downto 40+72*i) <= pix_int4(8*i+7 downto 8*i);
pixels_int(39+72*i downto 32+72*i) <= pix_int5(8*i+7 downto 8*i);
pixels_int(31+72*i downto 24+72*i) <= pix_int6(8*i+7 downto 8*i);
pixels_int(23+72*i downto 16+72*i) <= pix_int7(8*i+7 downto 8*i);
pixels_int(15+72*i downto 8+72*i) <= pix_int8(8*i+7 downto 8*i);
pixels_int(7+72*i downto 72*i) <= pix_int9(8*i+7 downto 8*i);
end generate;

PIPELINE: process(clock, rst)
begin
if (rst = '1') then
    valid <= '0';
    finish <= '0';
    pixels_out <= (others=>'0');
    cmd_int <= (others=>'0');
elsif (rising_edge(clock)) then
    cmd_int <= cmd;
    valid <= valid_int;
    finish <= finish_int;
    pixels_out <= pixels_int;
end if;
end process;

STATE_DECODE: process (clock, rst)
 begin

 if (rst = '1') then
    count_o <= (others=>'0');
    count_v <= (others=>'0');
    state <= start;
 elsif (rising_edge(clock)) then
    state <= next_state;
    
    case state is
    
        when idle =>        next_state <= idle;
                        
        when start =>       if (pix6 /= "00000000") then -- se count = 33;
                               next_state <= nordovest;
                            elsif (pix5 /= "00000000") then -- se count = 34;
                                 count_o <= (others => '0');
                                next_state <= up;
                            end if;
                        
        when nordovest =>   next_state <= up;
        
        when up =>          count_o <= count_o + 1;
                            if (count_o = "001010") then -- se count = 10;
                                valid_int <= '1';
                            elsif (count_o = "011100") then -- se count = 28;
                                 next_state <= nordest;
                            elsif (count_o = "011101") then -- se count = 29;
                                 count_o <= (others => '0');
                                next_state <= left;
                            end if;
        
        when nordest =>     next_state <= center;
        
        when left =>        next_state <= center;
        
        when center =>      count_o <= count_o+1;
                            if (count_o = "011100") then -- se count_o = 28;
                                 next_state <= right;
                            elsif (count_o = "011101") then -- se count = 29;
                                 count_o <= (others => '0');
                                 count_v <= count_v + 1;
                                 if (count_v = "011101") then -- se count_v = 28;
                                     next_state <= sudovest;
                                 else next_state <= left;
                                 end if;
                            end if;
        
        when right =>       if (count_v = "011110") then -- se count_v = 28;
                                 count_v <= (others => '0');
                                 next_state <= down;
                            else next_state <= center;
                            end if;
        
        when sudovest =>    next_state <= down;
        
        when down =>        count_o <= count_o + 1;
                            if (count_o = "011100") then -- se count = 29;
                                 next_state <= sudest;
                            elsif (count_o = "011101") then -- se count = 29;
                                 count_o <= (others => '0');
                                next_state <= ending;
                            end if;
        
        when sudest =>      next_state <= ending;
        
        when ending =>      count_o <= count_o + 1;
                            if (count_o = "001011") then -- se count = 11;
                                count_o <= (others => '0');
                                valid_int <= '0';
                                finish_int <= '1';
                                next_state <= idle;
                            end if;
        
    end case;
 end if;
 
end process;


OUTPUT_DECODE: process (clock, rst)
begin

if (rst = '1') then
   pix_int1 <= (others=>'0');
   pix_int2 <= (others=>'0');
   pix_int3 <= (others=>'0');
   pix_int4 <= (others=>'0');
   pix_int5 <= (others=>'0');
   pix_int6 <= (others=>'0');
   pix_int7 <= (others=>'0');
   pix_int8 <= (others=>'0');
   pix_int9 <= (others=>'0');
elsif (rising_edge(clock)) then

    case state is
    
        when idle =>        pix_int1 <= (others=>'0');
                            pix_int2 <= (others=>'0');
                            pix_int3 <= (others=>'0');
                            pix_int4 <= (others=>'0');
                            pix_int5 <= (others=>'0');
                            pix_int6 <= (others=>'0');
                            pix_int7 <= (others=>'0');
                            pix_int8 <= (others=>'0');
                            pix_int9 <= (others=>'0');
        
        when start =>       pix_int1 <= pix1;
                            pix_int2 <= pix2;
                            pix_int3 <= pix3;
                            pix_int4 <= pix4;
                            pix_int5 <= pix5;
                            pix_int6 <= pix6;
                            pix_int7 <= pix7;
                            pix_int8 <= pix8;
                            pix_int9 <= pix9;
        
        when nordovest =>   pix_int5 <= pix5;
                            pix_int6 <= pix6;
                            pix_int8 <= pix8;
                            pix_int9 <= pix9;
                            if (cmd = "00") then        -- toroidale
                                pix_int1 <= pix1;
                                pix_int2 <= pix2;
                                pix_int3 <= pix3;
                                pix_int4 <= pix4;
                                pix_int7 <= pix7;
                            elsif (cmd = "01") then        -- black padding
                                pix_int1 <= pix1;
                                pix_int2 <= pix2;
                                pix_int3 <= pix3;
                                pix_int4 <= pix4;
                                pix_int7 <= (others=>'0');
                            elsif (cmd = "10") then     -- white padding
                                pix_int1 <= (others=>'1');
                                pix_int2 <= (others=>'1');
                                pix_int3 <= (others=>'1');
                                pix_int4 <= (others=>'1');
                                pix_int7 <= (others=>'1');
                            elsif (cmd = "11") then     -- symmetrical padding (mirroring)
                                pix_int1 <= pix9;
                                pix_int2 <= pix8;
                                pix_int3 <= pix9;
                                pix_int4 <= pix6;
                                pix_int7 <= pix9;
                            end if;
        
        when up =>          pix_int4 <= pix4;
                            pix_int5 <= pix5;
                            pix_int6 <= pix6;
                            pix_int7 <= pix7;
                            pix_int8 <= pix8;
                            pix_int9 <= pix9;
                            if (cmd = "00") then        -- toroidale
                                pix_int1 <= pix1;
                                pix_int2 <= pix2;
                                pix_int3 <= pix3;
                            elsif (cmd = "10") then     -- white padding
                                pix_int1 <= (others=>'1');
                                pix_int2 <= (others=>'1');
                                pix_int3 <= (others=>'1');
                            elsif (cmd = "11") then     -- symmetrical padding (mirroring)
                                pix_int1 <= pix7;
                                pix_int2 <= pix8;
                                pix_int3 <= pix9;
                            end if;
        
        when nordest =>     pix_int4 <= pix4;
                            pix_int5 <= pix5;
                            pix_int7 <= pix7;
                            pix_int8 <= pix8;
                            if (cmd = "00") then        -- toroidale
                                pix_int1 <= pix1;
                                pix_int2 <= pix2;
                                pix_int3 <= pix3;
                                pix_int6 <= pix4;
                                pix_int9 <= pix7;
                            elsif (cmd = "01") then        -- black padding
                                pix_int1 <= pix1;
                                pix_int2 <= pix2;
                                pix_int3 <= pix3;
                                pix_int6 <= (others=>'0');
                                pix_int9 <= (others=>'0');
                            elsif (cmd = "10") then     -- white padding
                                pix_int1 <= (others=>'1');
                                pix_int2 <= (others=>'1');
                                pix_int3 <= (others=>'1');
                                pix_int6 <= (others=>'1');
                                pix_int9 <= (others=>'1');
                            elsif (cmd = "11") then     -- symmetrical padding (mirroring)
                                pix_int1 <= pix7;
                                pix_int2 <= pix8;
                                pix_int3 <= pix7;
                                pix_int6 <= pix4;
                                pix_int9 <= pix7;
                            end if;
                                
        
        when left =>        pix_int2 <= pix2;
                            pix_int3 <= pix3;
                            pix_int5 <= pix5;
                            pix_int6 <= pix6;
                            pix_int8 <= pix8;
                            pix_int9 <= pix9;
                            if (cmd = "00") then        -- toroidale
                                pix_int1 <= pix1;
                                pix_int4 <= pix2;
                                pix_int7 <= pix7;
                            elsif (cmd = "01") then        -- black padding
                                pix_int1 <= (others=>'0');
                                pix_int4 <= (others=>'0');
                                pix_int7 <= (others=>'0');
                            elsif (cmd = "10") then     -- white padding
                                pix_int1 <= (others=>'1');
                                pix_int4 <= (others=>'1');
                                pix_int7 <= (others=>'1');
                            elsif (cmd = "11") then     -- symmetrical padding (mirroring)
                                pix_int1 <= pix3;
                                pix_int4 <= pix6;
                                pix_int7 <= pix9;
                            end if;
                            
        when center =>      pix_int1 <= pix1;
                            pix_int2 <= pix2;
                            pix_int3 <= pix3;
                            pix_int4 <= pix4;
                            pix_int5 <= pix5;
                            pix_int6 <= pix6;
                            pix_int7 <= pix7;
                            pix_int8 <= pix8;
                            pix_int9 <= pix9;
        
        when right =>       pix_int1 <= pix1;
                            pix_int2 <= pix2;
                            pix_int4 <= pix4;
                            pix_int5 <= pix5;
                            pix_int7 <= pix7;
                            pix_int8 <= pix8;
                            if (cmd = "00") then        -- toroidale
                                pix_int3 <= pix3;
                                pix_int6 <= pix6;
                                pix_int9 <= pix9;
                            elsif (cmd = "01") then        -- black padding
                                pix_int3 <= (others=>'0');
                                pix_int6 <= (others=>'0');
                                pix_int9 <= (others=>'0');
                            elsif (cmd = "10") then     -- white padding
                                pix_int3 <= (others=>'1');
                                pix_int6 <= (others=>'1');
                                pix_int9 <= (others=>'1');
                            elsif (cmd = "11") then     -- symmetrical padding (mirroring)
                                pix_int3 <= pix1;
                                pix_int6 <= pix4;
                                pix_int9 <= pix7;
                            end if;
        
        when sudovest =>    pix_int2 <= pix2;
                            pix_int3 <= pix3;
                            pix_int5 <= pix5;
                            pix_int6 <= pix6;
                            if (cmd = "00") then        -- toroidale
                                pix_int1 <= pix1;
                                pix_int4 <= pix4;
                                pix_int7 <= pix7;
                                pix_int8 <= pix8;
                                pix_int9 <= pix9;
                            elsif (cmd = "01") then        -- black padding
                                pix_int1 <= (others=>'0');
                                pix_int4 <= (others=>'0');
                                pix_int7 <= (others=>'0');
                                pix_int8 <= (others=>'0');
                                pix_int9 <= (others=>'0');
                            elsif (cmd = "10") then     -- white padding
                                pix_int1 <= (others=>'1');
                                pix_int4 <= (others=>'1');
                                pix_int7 <= (others=>'1');
                                pix_int8 <= (others=>'1');
                                pix_int9 <= (others=>'1');
                            elsif (cmd = "11") then     -- symmetrical padding (mirroring)
                                pix_int1 <= pix3;
                                pix_int4 <= pix6;
                                pix_int7 <= pix3;
                                pix_int8 <= pix2;
                                pix_int9 <= pix3;
                            end if;
        
        when down =>        pix_int1 <= pix1;
                            pix_int2 <= pix2;
                            pix_int3 <= pix3;
                            pix_int4 <= pix4;
                            pix_int5 <= pix5;
                            pix_int6 <= pix6;
                            if (cmd = "00") then        -- toroidale
                                pix_int7 <= pix7;
                                pix_int8 <= pix8;
                                pix_int9 <= pix9;
                            elsif (cmd = "01") then        -- black padding
                                pix_int7 <= (others=>'0');
                                pix_int8 <= (others=>'0');
                                pix_int9 <= (others=>'0');
                            elsif (cmd = "10") then     -- white padding
                                pix_int7 <= (others=>'1');
                                pix_int8 <= (others=>'1');
                                pix_int9 <= (others=>'1');
                            elsif (cmd = "11") then     -- symmetrical padding (mirroring)
                                pix_int7 <= pix1;
                                pix_int8 <= pix2;
                                pix_int9 <= pix3;
                            end if;
        
        when sudest =>      pix_int1 <= pix1;
                            pix_int2 <= pix2;
                            pix_int4 <= pix4;
                            pix_int5 <= pix5;
                            if (cmd = "00") then        -- toroidale
                                pix_int3 <= pix3;
                                pix_int6 <= pix6;
                                pix_int7 <= pix7;
                                pix_int8 <= pix8;
                                pix_int9 <= pix9;
                            elsif (cmd = "01") then        -- black padding
                                pix_int3 <= (others=>'0');
                                pix_int6 <= (others=>'0');
                                pix_int7 <= (others=>'0');
                                pix_int8 <= (others=>'0');
                                pix_int9 <= (others=>'0');
                            elsif (cmd = "10") then     -- white padding
                                pix_int3 <= (others=>'1');
                                pix_int6 <= (others=>'1');
                                pix_int7 <= (others=>'1');
                                pix_int8 <= (others=>'1');
                                pix_int9 <= (others=>'1');
                            elsif (cmd = "11") then     -- symmetrical padding (mirroring)
                                pix_int3 <= pix1;
                                pix_int6 <= pix4;
                                pix_int7 <= pix1;
                                pix_int8 <= pix2;
                                pix_int9 <= pix1;
                            end if;
        
        when ending =>      pix_int1 <= (others=>'0');
                            pix_int2 <= (others=>'0');
                            pix_int3 <= (others=>'0');
                            pix_int4 <= (others=>'0');
                            pix_int5 <= (others=>'0');
                            pix_int6 <= (others=>'0');
                            pix_int7 <= (others=>'0');
                            pix_int8 <= (others=>'0');
                            pix_int9 <= (others=>'0');
        
    end case;
 end if;

end process;

end Behavioral;