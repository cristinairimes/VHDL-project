library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity ALU is
    Port (instr: in STD_LOGIC_VECTOR (1 downto 0);
          adresare: in STD_LOGIC;
          op1: in STD_LOGIC_VECTOR (63 downto 0);
          op2: in STD_LOGIC_VECTOR (63 downto 0);
          rez: out STD_LOGIC_VECTOR (63 downto 0) 
          );
end ALU;

architecture Behavioral of ALU is

signal temp: STD_LOGIC_VECTOR (63 downto 0) := x"0000000000000000";
signal temp1 : STD_LOGIC_VECTOR (127 downto 0) := x"00000000000000000000000000000000"; --folositi pentru operatiile de inmultire
signal temp2 : STD_LOGIC_VECTOR (127 downto 0) := x"00000000000000000000000000000000";

begin
    
    process(instr, adresare, op1, op2)
    begin
        ---toate operatiile daca au overflow sau underflow => ignorare de carry si retinerea valorii rezultate prin wrap-around
        ---adunarea si scaderea cu adresare pe byte si dword se face fara semn, confrom descrierii instructiunii
        case instr is
            when "00" =>
                case adresare is
                    when '0' =>
                        temp(7 downto 0) <= op1(7 downto 0) + op2(7 downto 0);
                        temp(15 downto 8) <= op1(15 downto 8) + op2(15 downto 8);
                        temp(23 downto 16) <= op1(23 downto 16) + op2(23 downto 16);
                        temp(31 downto 24) <= op1(31 downto 24) + op2(31 downto 24);
                        temp(39 downto 32) <= op1(39 downto 32) + op2(39 downto 32);
                        temp(47 downto 40) <= op1(47 downto 40) + op2(47 downto 40);
                        temp(55 downto 48) <= op1(55 downto 48) + op2(55 downto 48);
                        temp(63 downto 56) <= op1(63 downto 56) + op2(63 downto 56);         
                    when others => --1--
                        temp(31 downto 0) <= op1(31 downto 0) + op2(31 downto 0);
                        temp(63 downto 32) <= op1(63 downto 32) + op2(63 downto 32);
                end case;
            when "01" =>
                case adresare is
                    when '0' =>
                        temp(7 downto 0) <= op1(7 downto 0) - op2(7 downto 0);
                        temp(15 downto 8) <= op1(15 downto 8) - op2(15 downto 8);
                        temp(23 downto 16) <= op1(23 downto 16) - op2(23 downto 16);
                        temp(31 downto 24) <= op1(31 downto 24) - op2(31 downto 24);
                        temp(39 downto 32) <= op1(39 downto 32) - op2(39 downto 32);
                        temp(47 downto 40) <= op1(47 downto 40) - op2(47 downto 40);
                        temp(55 downto 48) <= op1(55 downto 48) - op2(55 downto 48);
                        temp(63 downto 56) <= op1(63 downto 56) - op2(63 downto 56);
                    when others => --1--
                        temp(31 downto 0) <= op1(31 downto 0) - op2(31 downto 0);
                        temp(63 downto 32) <= op1(63 downto 32) - op2(63 downto 32);
                end case;
       ---la operatiile de inmultire se lucreaza numai cu reprezentare pe word si integeri cu semn
            when "10" =>
                temp1(31 downto 0) <= op1(15 downto 0) * op2(15 downto 0);
                temp1(63 downto 32) <= op1(31 downto 16) * op2(31 downto 16);
                temp1(95 downto 64) <= op1(47 downto 32) * op2(47 downto 32);
                temp1(127 downto 96) <= op1(63 downto 48) * op2(63 downto 48);
                
                temp(15 downto 0) <= temp1(15 downto 0);
                temp(31 downto 16) <= temp1(47 downto 32);
                temp(47 downto 32) <= temp1(79 downto 64);
                temp(63 downto 48) <= temp1(111 downto 96);
                
            when others =>                  --11--
                temp2(31 downto 0) <= op1(15 downto 0) * op2(15 downto 0);
                temp2(63 downto 32) <= op1(31 downto 16) * op2(31 downto 16);
                temp2(95 downto 64) <= op1(47 downto 32) * op2(47 downto 32);
                temp2(127 downto 96) <= op1(63 downto 48) * op2(63 downto 48);
                
                temp(31 downto 0) <= temp2(63 downto 32) + temp2(31 downto 0);
                temp(63 downto 32) <= temp2(127 downto 96) + temp2(95 downto 64);
            
        end case;
    end process;
    
    rez <= temp;
end Behavioral;
