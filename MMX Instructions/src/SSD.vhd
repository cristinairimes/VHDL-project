library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SSD is
    Port (digit: in STD_LOGIC_VECTOR (15 downto 0);
           clk: in STD_LOGIC;
           cat: out STD_LOGIC_VECTOR (6 downto 0);
           an: out STD_LOGIC_VECTOR (3 downto 0));
end SSD;

architecture Behavioral of SSD is

signal count: STD_LOGIC_VECTOR (15 downto 0) := x"0000";
signal iesire_MUX: STD_LOGIC_VECTOR (3 downto 0) := "0000";

begin
    numarator : process(clk)
    begin
        if rising_edge(clk) then
            count <= count + 1;
        end if;
    end process;
    
    MUX1 : process(count, digit)
    begin
        case count(15 downto 14) is
            when "00" => iesire_MUX <= digit(3 downto 0);
            when "01" => iesire_MUX <= digit(7 downto 4);
            when "10" => iesire_MUX <= digit(11 downto 8);
            when others => iesire_MUX <= digit (15 downto 12);
        end case;
    end process;
    
    H27S : process(clk, iesire_MUX)
    begin
        if rising_edge(clk) then
            case(iesire_MUX) is
                when "0000" => cat <= "1000000"; --0
                when "0001" => cat <= "1111001"; --1
                when "0010" => cat <= "0100100"; --2
                when "0011" => cat <= "0110000"; --3
                when "0100" => cat <= "0011001"; --4
                when "0101" => cat <= "0010010"; --5
                when "0110" => cat <= "0000010"; --6
                when "0111" => cat <= "1111000"; --7
                when "1000" => cat <= "0000000"; --8
                when "1001" => cat <= "0010000"; --9
                when "1010" => cat <= "0001000"; --A
                when "1011" => cat <= "0000011"; --b
                when "1100" => cat <= "1000110"; --C
                when "1101" => cat <= "0100001"; --d
                when "1110" => cat <= "0000110"; --E
                when others => cat <= "0001110"; --F
            end case;
        end if;
    end process;
    
    MUX2 : process(count)
    begin
        case count (15 downto 14) is
            when "00" => an <= "1110";
            when "01" => an <= "1101";
            when "10" => an <= "1011";
            when others => an <= "0111";
        end case;
    end process;

end Behavioral;
