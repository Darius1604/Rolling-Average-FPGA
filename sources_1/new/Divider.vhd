----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2024 02:42:54 PM
-- Design Name: 
-- Module Name: Divider - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Divider is
    Port (
        Qin : in std_logic_vector(11 downto 0);
        CLOCK : in std_logic;
        LEN : in std_logic_vector(2 downto 0);
        Qout : out std_logic_vector(7 downto 0);
        RESET : in std_logic;
        ENABLE : in std_logic
    );
end Divider;

architecture Behavioral of Divider is
    signal sr_vector : std_logic_vector(11 downto 0) := (others => '0');
    signal sr_vectorD : std_logic_vector(11 downto 0) := (others => '0');
 
begin
    sr_vector <= Qin;
    Qout <= sr_vectorD(7 downto 0);   
    
    process(ENABLE, RESET, CLOCK)
        variable a : INTEGER;
    begin
        if RESET = '1' then 
            sr_vectorD <= (others => '0');
        else
            if ENABLE = '1' then
                if LEN = "100" then
                    sr_vectorD(11) <= '0';
                    for i in 10 downto 0 loop
                        a := i;
                        sr_vectorD(a) <= sr_vector(a + 1);
                    end loop;
                elsif LEN = "101" then
                    sr_vectorD(11) <= '0';
                    sr_vectorD(10) <= '0';
                    for i in 9 downto 0 loop
                        a := i;
                        sr_vectorD(a) <= sr_vector(a + 2);
                    end loop;
                elsif LEN = "110" then
                    sr_vectorD(11) <= '0';
                    sr_vectorD(10) <= '0';
                    sr_vectorD(9) <= '0';
                    for i in 8 downto 0 loop
                        a := i;
                        sr_vectorD(a) <= sr_vector(a + 3);
                    end loop;
                elsif LEN = "111" then
                    sr_vectorD(11) <= '0';
                    sr_vectorD(10) <= '0';
                    sr_vectorD(9) <= '0';
                    sr_vectorD(8) <= '0';
                    for i in 7 downto 0 loop
                        a := i;
                        sr_vectorD(a) <= sr_vector(a + 4);
                    end loop;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
