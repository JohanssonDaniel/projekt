-- TestBench Template 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY lab_tb IS
END lab_tb;

ARCHITECTURE behavior OF lab_tb IS 

  -- Component Declaration
  COMPONENT lab
    PORT(
      CLK : in  STD_LOGIC;								-- 100Mhz onboard clock
           RST : in  STD_LOGIC;								-- Button D
           MISO : in  STD_LOGIC;								-- Master In Slave Out, JA3
           SW : in  STD_LOGIC_VECTOR (2 downto 0);		-- Switches 2, 1, and 0
           SS : out  STD_LOGIC;								-- Slave Select, Pin 1, Port JA
           MOSI : out  STD_LOGIC;							-- Master Out Slave In, Pin 2, Port JA
           SCLK : out  STD_LOGIC;							-- Serial Clock, Pin 4, Port JA
           LED : out  STD_LOGIC_VECTOR (2 downto 0);	-- LEDs 2, 1, and 0
           AN : out  STD_LOGIC_VECTOR (3 downto 0);	-- Anodes for Seven Segment Display
           SEG : out  STD_LOGIC_VECTOR (6 downto 0)); -- Cathodes for Seven Segment Display);
  END COMPONENT;
  SIGNAL an :  std_logic_vector(3 downto 0);
  signal tb_running : boolean := true;

--Inputs
  signal clk   : std_logic                    := '0';
  signal rst   : std_logic                    := '0';
  signal MISO  : std_logic                    := '0';
  --signal MISO2 : std_logic                    := '0';
  signal SW    : std_logic_vector(2 downto 0) := (others => '0');

  --Outputs
  signal SS       : std_logic;
  --signal SS2      : std_logic;
  signal MOSI     : std_logic;
  --signal MOSI2    : std_logic;
  signal SCLK     : std_logic;
  --signal SCLK2    : std_logic;
  signal LED : STD_LOGIC_VECTOR (2 downto 0);
  signal AN  : STD_LOGIC_VECTOR (3 downto 0);
  signal SEG : STD_LOGIC_VECTOR (6 downto 0);
  
BEGIN

  -- Component Instantiation
  uut: lab PORT MAP(
    clk => clk,
    rst => rst,
    an  => an, 
    MISO     => MISO,
    SW       => SW,
    SS       => SS,
    MOSI     => MOSI,
    SCLK     => SCLK,
    SEG      => SEG,
    LED      => LED);


  clk_gen : process
  begin
    while tb_running loop
      clk <= '0';
      wait for 20 ns;
      clk <= '1';
      wait for 20 ns;
    end loop;
    wait;
  end process;

  

  stimuli_generator : process
    variable i : integer;
  begin
    -- Aktivera reset ett litet tag.
    rst <= '1';
    wait for 500 ns;

    wait until rising_edge(clk);        -- se till att reset släpps synkront
                                        -- med klockan
    rst <= '0';
    report "Reset released" severity note;


    for i in 0 to 50000000 loop         -- Vänta ett antal klockcykler
      wait until rising_edge(clk);
    end loop;  -- i
    
    tb_running <= false;                -- Stanna klockan (vilket medför att inga
                                        -- nya event genereras vilket stannar
                                        -- simuleringen).
    wait;
  end process;
      
END;
