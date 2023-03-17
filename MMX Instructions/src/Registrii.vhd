library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Registrii is
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
end Registrii;

architecture Behavioral of Registrii is
    
    type reg_array is array (0 to 7) of STD_LOGIC_VECTOR (63 downto 0);
    signal registru : reg_array := (x"0004000300020001", x"1112111211121112", x"1110111211141116", x"1112111211121112",
                                    x"1110111211141116", x"FFFFFFFFFFFFFFFF", x"0000000200000003", x"1110111011101110");
    
    signal counter: STD_LOGIC_VECTOR (2 downto 0) := "000";
begin
    
    process(clk, counter)
    begin
        if rising_edge(clk) then
            case counter is
                when "000" => registrul <= "00000001";
                when "001" => registrul <= "00000010";
                when "010" => registrul <= "00000100";
                when "011" => registrul <= "00001000";
                when "100" => registrul <= "00010000";
                when "101" => registrul <= "00100000";
                when "110" => registrul <= "01000000";
                when "111" => registrul <= "10000000";
                when others =>
            end case;
        end if;
    end process;
    
    process(clk, num, save)
    begin
        if rst = '1' then
            registru <= (others => x"0000000000000000");
        elsif rising_edge(clk) then
        
            if counter = "111" and num = '1' then
                counter <= "000";
            elsif num = '1' then
                counter <= counter + 1;
            end if;
            
            if save = '1' then
                registru(conv_integer(reg1)) <= val;
            end if;
            
            if inc = '1' then
                case reg2 is
                    when "000" => registru(conv_integer(reg1))(15 downto 0) <= registru(conv_integer(reg1))(15 downto 0) + '1';
                    when "001" => registru(conv_integer(reg1))(31 downto 16) <= registru(conv_integer(reg1))(31 downto 16) + '1';
                    when "010" => registru(conv_integer(reg1))(47 downto 32) <= registru(conv_integer(reg1))(47 downto 32) + '1';
                    when others => registru(conv_integer(reg1))(63 downto 48) <= registru(conv_integer(reg1))(63 downto 48) + '1';
                end case;
            end if;
            
            if dec = '1' then
                case reg2 is
                    when "000" => registru(conv_integer(reg1))(15 downto 0) <= registru(conv_integer(reg1))(15 downto 0) - '1';
                    when "001" => registru(conv_integer(reg1))(31 downto 16) <= registru(conv_integer(reg1))(31 downto 16) - '1';
                    when "010" => registru(conv_integer(reg1))(47 downto 32) <= registru(conv_integer(reg1))(47 downto 32) - '1';
                    when others => registru(conv_integer(reg1))(63 downto 48) <= registru(conv_integer(reg1))(63 downto 48) - '1';
                end case;
            end if;
            
        end if;
    end process;
    
    op1 <= registru(conv_integer(reg1));
    op2 <= registru(conv_integer(reg2));
    afisare <= registru(conv_integer(counter));
    
end Behavioral;
