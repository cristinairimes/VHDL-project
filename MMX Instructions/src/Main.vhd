library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity Main is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end Main;

architecture Behavioral of Main is

component MPG is
  Port (en : out STD_LOGIC;
        input : in STD_LOGIC;
        clock : in STD_LOGIC);
end component;

component SSD is
     Port (digit: in STD_LOGIC_VECTOR (15 downto 0);
           clk: in STD_LOGIC;
           cat: out STD_LOGIC_VECTOR (6 downto 0);
           an: out STD_LOGIC_VECTOR (3 downto 0));
end component;

component Registrii is
    Port (clk: in STD_LOGIC;
          reg1: in STD_LOGIC_VECTOR (2 downto 0);
          reg2: in STD_LOGIC_VECTOR (2 downto 0);
          num: in STD_LOGIC;
          save: in STD_LOGIC;
          rst: in STD_LOGIC;
          inc: in STD_LOGIC;
          dec: in STD_LOGIC;
          val: in STD_LOGIC_VECTOR (63 downto 0);
          op1: out STD_LOGIC_VECTOR (63 downto 0);
          op2: out STD_LOGIC_VECTOR (63 downto 0);
          afisare: out STD_LOGIC_VECTOR (63 downto 0);
          registrul : out STD_LOGIC_VECTOR (7 downto 0)
            );
end component;

component ALU is
    Port (instr: in STD_LOGIC_VECTOR (1 downto 0);
          adresare: in STD_LOGIC;
          op1: in STD_LOGIC_VECTOR (63 downto 0);
          op2: in STD_LOGIC_VECTOR (63 downto 0);
          rez: out STD_LOGIC_VECTOR (63 downto 0) 
          );
end component;

--MPG
signal ENABLE: STD_LOGIC;
signal NUMARATOR: STD_LOGIC;
signal RESET : STD_LOGIC;
signal INC : STD_LOGIC;
signal DEC : STD_LOGIC;

--SSD
signal registru_1_4: STD_LOGIC_VECTOR (15 downto 0);

--MEM
signal valoare_mem: STD_LOGIC_VECTOR (63 downto 0);
signal operand1: STD_LOGIC_VECTOR (63 downto 0);
signal operand2: STD_LOGIC_VECTOR (63 downto 0);
signal leds : STD_LOGIC_VECTOR (7 downto 0);

--ALU
signal Rez_ALU: STD_LOGIC_VECTOR (63 downto 0);

begin
    
    patrime_registru: process(sw(3 downto 0), valoare_mem)
    begin
        case sw(3 downto 0) is
            when "0001" => registru_1_4 <= valoare_mem(15 downto 0);
            when "0010" => registru_1_4 <= valoare_mem(31 downto 16);
            when "0100" => registru_1_4 <= valoare_mem(47 downto 32);
            when "1000" => registru_1_4 <= valoare_mem(63 downto 48);
            when others => registru_1_4 <= x"FA1D";
        end case;
    end process;
    
    led(7 downto 0) <= leds;
    
    MPG_UL0 : MPG PORT MAP (ENABLE, btn(0), clk); --mijloc
    MPG_UL1 : MPG PORT MAP (NUMARATOR, btn(1), clk); --sus
    MPG_UL2 : MPG PORT MAP (RESET, btn(2), clk); --stanga
    MPG_UL3 : MPG PORT MAP (INC, btn(3), clk); --dreapta
    MPG_UL4 : MPG PORT MAP (DEC, btn(4), clk); --jos
    
    SSD_UL : SSD PORT MAP (registru_1_4, clk, cat, an);
    
    MEM_UL: REGISTRII PORT MAP(clk, sw(12 downto 10), sw(6 downto 4), NUMARATOR, ENABLE, RESET, INC, DEC, Rez_ALU, operand1, operand2, valoare_mem, leds);
    ALU_UL: ALU PORT MAP(sw(15 downto 14), sw(13), operand1, operand2, Rez_ALU);
    
end Behavioral;
