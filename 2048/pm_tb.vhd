-- TestBench Template 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY pm_tb IS
END pm_tb;

ARCHITECTURE behavior OF pm_tb IS 

  -- Component Declaration
  COMPONENT pm
      	port(
		clk,rst : in STD_LOGIC;
		ASR : in STD_LOGIC_VECTOR(7 downto 0);
		TB : in STD_LOGIC_VECTOR(2 downto 0);
		FB : in STD_LOGIC_VECTOR(2 downto 0);
		BUSS : in STD_LOGIC_VECTOR(15 downto 0);
		ASR_OUT : OUT STD_LOGIC_VECTOR(7 downto 0);
		PM_OUT : out STD_LOGIC_VECTOR(15 downto 0)
	);
  END COMPONENT;

  SIGNAL clk : std_logic := '0';
  SIGNAL rst : std_logic := '0';
  SIGNAL tb_running : boolean := true;
  SIGNAL ASR : STD_LOGIC_VECTOR(7 downto 0) := X"00";
  SIGNAL TB : STD_LOGIC_VECTOR(2 downto 0) := "000";
  SIGNAL FB : STD_LOGIC_VECTOR(2 downto 0) := "000";
  SIGNAL BUSS : STD_LOGIC_VECTOR(15 downto 0) := X"0000";
  SIGNAL ASR_OUT : STD_LOGIC_VECTOR(7 downto 0) :=X"00";
  SIGNAL PM_OUT : STD_LOGIC_VECTOR(15 downto 0) :=X"0000";
BEGIN

  -- Component Instantiation
  uut: pm PORT MAP(
    clk => clk,
    rst => rst,
    ASR => ASR,
    TB => TB,
    FB => FB,
    BUSS => BUSS,
    ASR_OUT => ASR_OUT,
    PM_OUT => PM_OUT);


  -- 100 MHz system clock
  clk_gen : process
  begin
    while tb_running loop
      clk <= '0';
      wait for 5 ns;
      clk <= '1';
      wait for 5 ns;
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
    
    --TEST1: LÄGG IN VÄRDE PÅ ASR IFRÅN BUSSEN
    BUSS <= X"0001";
    FB <="111";

    for i in 0 to 2 loop         -- Vänta ett antal klockcykler
      wait until rising_edge(clk);
    end loop;  -- i

		--TEST2: HÄMTA UT VÄRDE IFRÅN PLATS SOM ASR ÄR SATT TILL
		TB <= "010";

    for i in 0 to 50000000 loop         -- Vänta ett antal klockcykler
      wait until rising_edge(clk);
    end loop;  -- i
    
    tb_running <= false;                -- Stanna klockan (vilket medför att inga
                                        -- nya event genereras vilket stannar
                                        -- simuleringen).
    wait;
  end process;
      
END;
