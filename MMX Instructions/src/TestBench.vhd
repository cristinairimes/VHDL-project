library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TestBench is
--  Port ( );
end TestBench;

architecture Behavioral of TestBench is

component Main1 is
    Port ( clk : in STD_LOGIC;
           ENABLE : in STD_LOGIC;
           NUMARATOR : in STD_LOGIC;
           RESET : in STD_LOGIC;
           INC : in STD_LOGIC;
           DEC : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

signal clk_1 : STD_LOGIC := '0';
signal ENABLE_1 : STD_LOGIC := '0';
signal NUMARATOR_1 : STD_LOGIC := '0';
signal RESET_1 : STD_LOGIC := '0';
signal INC_1 : STD_LOGIC := '0';
signal DEC_1 : STD_LOGIC := '0';
signal sw_1 : STD_LOGIC_VECTOR (15 downto 0);
signal an_1 : STD_LOGIC_VECTOR (3 downto 0);
signal cat_1 : STD_LOGIC_VECTOR (6 downto 0);

begin

    MMX: Main1 PORT MAP (clk_1, ENABLE_1, NUMARATOR_1, RESET_1, INC_1, DEC_1, sw_1, an_1, cat_1);    
    process
    begin
        clk_1 <= '0';
        wait for 5 ns;
        clk_1 <= '1';
        wait for 5 ns;
    end process;
    
    process
    begin
        --pmaddb--
        sw_1 <= x"0380";    wait for 10 ns;     sw_1 <= x"0381";    ENABLE_1 <= '1';
        wait for 10 ns;     sw_1 <= x"0382";    ENABLE_1 <= '0';    wait for 10 ns;
        sw_1 <= x"0384";    wait for 10 ns;     sw_1 <= x"0388";
        
        --x"0004000300020001" + x"1110111011101110" => reg0 = x"1114111311121111"
        
        --pmaddd--
        wait for 10 ns;  --mergem la registru 5
        NUMARATOR_1 <= '1';
        wait for 60 ns;
        NUMARATOR_1 <= '0';
        sw_1 <= x"3700";
        wait for 10 ns;      ENABLE_1 <= '1';    wait for 10 ns;     ENABLE_1 <= '0';
        sw_1 <= x"3701";    wait for 10 ns;     sw_1 <= x"3702";    wait for 10 ns;
        sw_1 <= x"3704";    wait for 10 ns;     sw_1 <= x"3708";
        
        --x"FFFFFFFFFFFFFFFF" + x"0000000200000003" => reg5 = x"000000100000002"
        
        --pmsubb--
        wait for 10 ns; --mergem la registru 0
        NUMARATOR_1 <= '1';
        wait for 30 ns;
        NUMARATOR_1 <= '0';
        sw_1 <= x"4380";
        wait for 10 ns;      ENABLE_1 <= '1';    wait for 10 ns;     ENABLE_1 <= '0';
        sw_1 <= x"4381";    wait for 10 ns;     sw_1 <= x"4382";    wait for 10 ns;
        sw_1 <= x"4384";    wait for 10 ns;     sw_1 <= x"4388";
        
        --x"1114111311121111" - x"1110111011101110" => reg0 = x"0004000300020001"
        
        --pmsubd--
        wait for 10 ns;  --mergem la registru 5
        NUMARATOR_1 <= '1';
        wait for 60 ns;
        NUMARATOR_1 <= '0';
        sw_1 <= x"7700";
        wait for 10 ns;      ENABLE_1 <= '1';    wait for 10 ns;     ENABLE_1 <= '0';
        sw_1 <= x"7701";    wait for 10 ns;     sw_1 <= x"7702";    wait for 10 ns;
        sw_1 <= x"7704";    wait for 10 ns;     sw_1 <= x"7708";
        
        --x"000000100000002" - x"FFFFFFFFFFFFFFFF" => reg5 = x"1114111311121111"
        
        --pmmullw--
        wait for 10 ns; --mergem la registru 1
        NUMARATOR_1 <= '1';
        wait for 40 ns;
        NUMARATOR_1 <= '0';
        sw_1 <= x"8500";
        wait for 10 ns;      ENABLE_1 <= '1';    wait for 20 ns;     ENABLE_1 <= '0';
        sw_1 <= x"8501";    wait for 10 ns;     sw_1 <= x"8502";    wait for 10 ns;
        sw_1 <= x"8504";    wait for 10 ns;     sw_1 <= x"8508";
        
        --x"1112111211121112" * x"1110111211141116" => reg1 = x"432065448768A98C"
        --temp0 = x"0123A98C"
        --temp1 = x"01238768"
        --temp2 = x"01236544"
        --temp3 = x"01234320"
        
        --pmaddwd--
        wait for 10 ns; --mergem la registru 3
        NUMARATOR_1 <= '1';
        wait for 20 ns;
        NUMARATOR_1 <= '0';
        sw_1 <= x"CE00";
        wait for 10 ns;      ENABLE_1 <= '1';    wait for 20 ns;     ENABLE_1 <= '0';
        sw_1 <= x"CE01";    wait for 10 ns;     sw_1 <= x"CE02";    wait for 10 ns;
        sw_1 <= x"CE04";    wait for 10 ns;     sw_1 <= x"CE08";    wait for 10 ns;
        
        --x"1112111211121112" * x"1110111211141116" => reg3 = x"0246A864024730F4"
        --temp0 = x"0123A98C" + x"01238768"
        --temp1 = x"01236544" + x"01234320"
        
    end process;

end Behavioral;
