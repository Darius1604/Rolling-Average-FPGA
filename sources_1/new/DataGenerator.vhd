library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DataGenerator is
    Port (
        RST       : in STD_LOGIC;
        EN        : in STD_LOGIC;
        CLK       : in STD_LOGIC;
        OUT_C     : out STD_LOGIC_VECTOR(7 downto 0);
 
        Control   : in STD_LOGIC_VECTOR(2 downto 0);
        NUM       : out STD_LOGIC_VECTOR(7 downto 0);
        RESETARE2 : in STD_LOGIC 
    );
end DataGenerator;

architecture Behavioral of DataGenerator is
    signal C            : STD_LOGIC_VECTOR(7 downto 0) := "00000001";
    signal XOR1, XOR2, XOR3 : STD_LOGIC;
    
    signal NumInter     : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal CountBuffer  : STD_LOGIC_VECTOR(2 downto 0) := "001";
begin
    process(RST, CLK, EN, Control, RESETARE2)
    begin
        if (RST = '1') then
            C <= "00000001";
            CountBuffer <= "001";
       
        elsif (RESETARE2 = '1') then
            NumInter <= (others => '0');
        else
            if rising_edge(CLK) then
                if (EN = '1' and Control = "110") then
                    NumInter <= NumInter + 1;
                    C(3) <= C(2);
                    C(2) <= C(1);
                    C(1) <= C(0);
                    C(0) <= C(2) XOR C(3);
                    C(7 downto 4) <= "0000";
                  
                end if;

                if (EN = '1' and Control = "111") then
                    NumInter <= NumInter + 1;
                    XOR1 <= C(7) XOR C(5);
                    XOR2 <= XOR1 XOR C(4);
                    XOR3 <= XOR2 XOR C(3);
                    C(7) <= C(6);
                    C(6) <= C(5);
                    C(5) <= C(4);
                    C(4) <= C(3);
                    C(3) <= C(2);
                    C(2) <= C(1);
                    C(1) <= C(0);
                    C(0) <= XOR3;
                   
                end if;

                if (EN = '1' and Control = "010") then
                    NumInter <= NumInter + 1;
                    case CountBuffer is
                        when "001" => C <= "00001111";
                        when "010" => C <= "00001101";
                        when "011" => C <= "00001011"; 
                        when "100" => C <= "00001001"; 
                        when "101" => C <= "00000111";
                        when "110" => C <= "00000101";
                        when others => C <= "00000000";
                    end case;

                    if (CountBuffer(2) = '0' or CountBuffer(1) = '0') then
                        CountBuffer <= CountBuffer + 1;
                    else
                        CountBuffer <= "001";
                    end if;
                end if;

                if (EN = '1' and Control = "011") then
                    NumInter <= NumInter + 1;
                    case CountBuffer is
                        when "001" => C <= "00000001";
                        when "010" => C <= "00000100";
                        when "011" => C <= "00000110"; 
                        when "100" => C <= "00000111"; 
                        when "101" => C <= "00001111";
                        when "110" => C <= "00000011";
                        when others => C <= "00000000";
                    end case;

                    if (CountBuffer(2) = '0' or CountBuffer(1) = '0') then
                        CountBuffer <= CountBuffer + 1;
                    else
                        CountBuffer <= "001";
                    end if;
                end if;
            end if;
        end if;
    end process;

    NUM <= NumInter;
    OUT_C <= C;
  

end Behavioral;
