library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Hex_to_7seg is
    Port (
        clock_100Mhz : in STD_LOGIC;
        reset : in STD_LOGIC;
        hex : in STD_LOGIC_VECTOR(7 downto 0);
        hexsum : in STD_LOGIC_VECTOR(7 downto 0);  
        cat : out STD_LOGIC_VECTOR(6 downto 0); 
        an : out STD_LOGIC_VECTOR(3 downto 0); 
        BufferChecker : in std_logic
    );
end Hex_to_7seg;

architecture Behavioral of Hex_to_7seg is
    signal hex_digit1, hex_digit2 : STD_LOGIC_VECTOR(3 downto 0);
    signal LED_BCD : unsigned(3 downto 0) := (others => '0');
    signal refresh_counter : unsigned(19 downto 0) := (others => '0');
    signal LED_activating_counter : unsigned(1 downto 0);
begin
    process(clock_100Mhz, reset)
    begin
        if reset = '1' then
            refresh_counter <= (others => '0');
        elsif rising_edge(clock_100Mhz) then
            refresh_counter <= refresh_counter + 1;
        end if;
    end process;

    LED_activating_counter <= refresh_counter(19 downto 18);

 
    process(LED_activating_counter, hex, hexsum, BufferChecker)
    begin
        case LED_activating_counter is
            when "00" =>
                an <= "0111"; 
                LED_BCD <= unsigned(hex(7 downto 4));
            when "01" =>
                an <= "1011"; 
                LED_BCD <= unsigned(hex(3 downto 0));
            when "10" =>
                if BufferChecker = '0' then
                    an <= "1111";
                else
                    an <= "1101"; 
                    LED_BCD <= unsigned(hexsum(7 downto 4));
                end if;
            when "11" =>
                if BufferChecker = '0' then
                    an <= "1111";
                else
                    an <= "1110";
                    LED_BCD <= unsigned(hexsum(3 downto 0));
                end if;
            when others =>
                an <= (others => '0'); 
        end case;
    end process;

  
    process(LED_BCD)
    begin
        case LED_BCD is
            when "0000" => cat <= "1000000"; -- '0'
            when "0001" => cat <= "1111001"; -- '1'
            when "0010" => cat <= "0100100"; -- '2'
            when "0011" => cat <= "0110000"; -- '3'
            when "0100" => cat <= "0011001"; -- '4'
            when "0101" => cat <= "0010010"; -- '5'
            when "0110" => cat <= "0000010"; -- '6'
            when "0111" => cat <= "1111000"; -- '7'
            when "1000" => cat <= "0000000"; -- '8'
            when "1001" => cat <= "0010000"; -- '9'
            when "1010" => cat <= "0001000"; -- 'A'
            when "1011" => cat <= "0000011"; -- 'B'
            when "1100" => cat <= "1000110"; -- 'C'
            when "1101" => cat <= "0100001"; -- 'D'
            when "1110" => cat <= "0000110"; -- 'E'
            when "1111" => cat <= "0001110"; -- 'F'
            when others => cat <= "1111111"; -- Off
        end case;
    end process;

end Behavioral;
