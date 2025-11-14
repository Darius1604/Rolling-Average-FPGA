----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2024 12:25:58 PM
-- Design Name: 
-- Module Name: storenumbers - Behavioral
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
use IEEE.NUMERIC_STD.ALL; 

entity StoreAndAdd is
    Port (
        INPUT       : in STD_LOGIC_VECTOR(7 downto 0);
        LENGTH      : in STD_LOGIC_VECTOR(2 downto 0);
        ENABLESTORE : in STD_LOGIC;
        CLOCK       : in STD_LOGIC;
        RESETARE    : in STD_LOGIC;
        STORAGE     : out STD_LOGIC_VECTOR(127 downto 0);
        FirstQueue     : out STD_LOGIC_VECTOR(7 downto 0);
        SUM         : out STD_LOGIC_VECTOR(11 downto 0);
        CheckBuffer : in STD_LOGIC_VECTOR(7 downto 0);
        BufferFull  : out STD_LOGIC
    );
end StoreAndAdd;

architecture Behavioral of StoreAndAdd is
    signal CopyStorage : STD_LOGIC_VECTOR(127 downto 0) := (others => '0');
    signal SUMA        : UNSIGNED(11 downto 0) := (others => '0'); 
  
  
    signal FIRSTELEM2   : UNSIGNED(7 downto 0) := (others => '0');
    signal FIRSTELEM4   : UNSIGNED(7 downto 0) := (others => '0');
    signal FIRSTELEM8   : UNSIGNED(7 downto 0) := (others => '0');
    signal FIRSTELEM16  : UNSIGNED(7 downto 0) := (others => '0'); 
    
begin
    STORAGE <= CopyStorage;
    FirstQueue <= std_logic_vector(FIRSTELEM2) when LENGTH="100" else 
              std_logic_vector(FIRSTELEM4) when LENGTH="101" else 
              std_logic_vector(FIRSTELEM8) when LENGTH="110" else 
              std_logic_vector(FIRSTELEM16) when LENGTH="111" else
              "00000000";
    SUM <= STD_LOGIC_VECTOR(SUMA);

    process(CLOCK, ENABLESTORE, RESETARE)
        variable a, b, c, d : INTEGER;
    begin
        FIRSTELEM2 <= UNSIGNED(CopyStorage(15 downto 8));
        FIRSTELEM4 <= UNSIGNED(CopyStorage(31 downto 24));
        FIRSTELEM8 <= UNSIGNED(CopyStorage(63 downto 56));
        FIRSTELEM16 <= UNSIGNED(CopyStorage(127 downto 120));

        if CheckBuffer >= "00000011" and LENGTH = "100" then 
            BufferFull <= '1';
        elsif CheckBuffer >= "00000101" and LENGTH = "101" then 
            BufferFull <= '1';
        elsif CheckBuffer >= "00001001" and LENGTH = "110" then 
            BufferFull <= '1';
        elsif CheckBuffer >= "00010001" and LENGTH = "111" then   
            BufferFull <= '1';           
        else
            BufferFull <= '0';
        end if;

        if RESETARE = '1' then
            SUMA <= (OTHERS => '0');
            CopyStorage <= (OTHERS => '0');
        elsif rising_edge(CLOCK) then
            if LENGTH = "101" and ENABLESTORE = '1' then
                for i in 4 downto 2 loop
                    a := 8 * i - 1;
                    b := 8 * (i - 1);
                    c := 8 * (i - 1) - 1;
                    d := 8 * (i - 2);
                    CopyStorage(a downto b) <= CopyStorage(c downto d);
                end loop;
                CopyStorage(7 downto 0) <= INPUT;
                SUMA <= SUMA + UNSIGNED(INPUT) - FIRSTELEM4; 
            elsif LENGTH = "100" and ENABLESTORE = '1' then
                CopyStorage(15 downto 8) <= CopyStorage(7 downto 0);
                CopyStorage(7 downto 0) <= INPUT;
                SUMA <= SUMA + UNSIGNED(INPUT) - FIRSTELEM2; 
            elsif LENGTH = "110" and ENABLESTORE = '1' then
                for i in 8 downto 2 loop
                    a := 8 * i - 1;
                    b := 8 * (i - 1);
                    c := 8 * (i - 1) - 1;
                    d := 8 * (i - 2);
                    CopyStorage(a downto b) <= CopyStorage(c downto d);
                end loop;
                CopyStorage(7 downto 0) <= INPUT;
                SUMA <= SUMA + UNSIGNED(INPUT) - FIRSTELEM8; 
            elsif LENGTH = "111" and ENABLESTORE = '1' then
                for i in 16 downto 2 loop
                    a := 8 * i - 1;
                    b := 8 * (i - 1);
                    c := 8 * (i - 1) - 1;
                    d := 8 * (i - 2);
                    CopyStorage(a downto b) <= CopyStorage(c downto d);
                end loop;
                CopyStorage(7 downto 0) <= INPUT;
                SUMA <= SUMA + UNSIGNED(INPUT) - FIRSTELEM16; 
            end if;
        end if;
    end process;
end Behavioral;
