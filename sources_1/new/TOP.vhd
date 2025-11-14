library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    Port ( 
        RST1 : in STD_LOGIC;
        RST2 : in STD_LOGIC;
        BTN1 : in STD_LOGIC;
        CLK1 : in STD_LOGIC;
        
        AFIS : out STD_LOGIC_VECTOR(6 downto 0);
        an2 : out STD_LOGIC_VECTOR(3 downto 0);
        ModeControl : in STD_LOGIC_VECTOR(2 downto 0);
        LastGeneratedElement : out STD_LOGIC_VECTOR(7 downto 0);
        BufferLength : in STD_LOGIC_VECTOR(2 downto 0);
        BufferDimensionLed : inout STD_LOGIC
    );
end top;

architecture Behavioral of top is
    signal HEX_VALUE: STD_LOGIC_VECTOR (7 downto 0);
   
    signal WIRE: std_logic;
    signal NUMBER: std_logic_vector(3 downto 0);
    signal STORE: std_logic_vector(127 downto 0) := (others => '0');
    signal ResultSum: STD_LOGIC_VECTOR(11 downto 0);
    signal Average: STD_LOGIC_VECTOR(7 downto 0);
    signal AverageTerm: STD_LOGIC_VECTOR(7 downto 0);
    signal CNT: STD_LOGIC_VECTOR(7 downto 0); 
    signal CNT2: STD_LOGIC_VECTOR(7 downto 0); 
    signal BufferDimensionChecker: STD_LOGIC;
    
    component debouncer is
        Port ( 
            BTN : in STD_LOGIC;
            CLK : in STD_LOGIC;
            ENABLE : out STD_LOGIC
        );
    end component;
    
    component DataGenerator is
        Port ( 
            RST : in STD_LOGIC;
            EN : in STD_LOGIC;
            CLK : in STD_LOGIC;
            OUT_C : out STD_LOGIC_VECTOR(7 downto 0);
         
            Control : in STD_LOGIC_VECTOR(2 downto 0);
            NUM : out STD_LOGIC_VECTOR(7 downto 0);
            RESETARE2 : in STD_LOGIC
        ); 
    end component;
    
    component Hex_to_7seg is
        Port ( 
            clock_100Mhz : in STD_LOGIC;
            reset : in STD_LOGIC; 
            hex : in STD_LOGIC_VECTOR(7 downto 0);
            hexsum : in STD_LOGIC_VECTOR(7 downto 0); 
            cat : out STD_LOGIC_VECTOR(6 downto 0); 
            an : out STD_LOGIC_VECTOR(3 downto 0);
            BufferChecker : in STD_LOGIC 
        );
    end component;
    
    component StoreAndAdd is
        Port (
            INPUT : in STD_LOGIC_VECTOR(7 downto 0);
            LENGTH : in STD_LOGIC_VECTOR(2 downto 0);
            ENABLESTORE : in STD_LOGIC;
            CLOCK : in STD_LOGIC;
            RESETARE : in STD_LOGIC;
            STORAGE : out STD_LOGIC_VECTOR(127 downto 0);
            FirstQueue : out STD_LOGIC_VECTOR(7 downto 0);
            SUM : out STD_LOGIC_VECTOR(11 downto 0);
            CheckBuffer : in STD_LOGIC_VECTOR(7 downto 0);
            BufferFull : out STD_LOGIC
        );
    end component;
    
    component Divider is
        Port (
            Qin : in STD_LOGIC_VECTOR(11 downto 0);
            CLOCK : in STD_LOGIC;
            LEN : in STD_LOGIC_VECTOR(2 downto 0);
            Qout : out STD_LOGIC_VECTOR(7 downto 0);
            RESET : in STD_LOGIC;
            ENABLE : in STD_LOGIC
        );
    end component;

begin
    l1: debouncer 
        port map( 
            BTN => BTN1,
            CLK => CLK1,
            ENABLE => WIRE
        );
        
    l2: DataGenerator
        port map( 
            RST => RST1,
            EN => WIRE,
            CLK => CLK1,
            OUT_C => HEX_VALUE,
           
            Control => ModeControl,
            NUM => CNT,
            RESETARE2 => RST2
        );
        
    l3: StoreAndAdd
        port map( 
            INPUT => HEX_VALUE,
            LENGTH => BufferLength,
            ENABLESTORE => WIRE,
            CLOCK => CLK1,
            RESETARE => RST2,
            STORAGE => STORE,
            FirstQueue => LastGeneratedElement,
            SUM => ResultSum,
            CheckBuffer => CNT,
            BufferFull => BufferDimensionLed
        );

    l4: Divider
        port map( 
            Qin => ResultSum,
            CLOCK => CLK1,
            LEN => BufferLength,
            RESET => RST2,
            Qout => AverageTerm,
            ENABLE => WIRE
        );

    l5: Hex_to_7seg
        port map( 
            clock_100Mhz => CLK1,
            reset => RST2,
            hex => HEX_VALUE,
            hexsum => AverageTerm,
            cat => AFIS,
            an => an2,
            BufferChecker => BufferDimensionLed
        ); 
end Behavioral;
