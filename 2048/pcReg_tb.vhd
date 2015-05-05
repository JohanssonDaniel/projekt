-- TestBench Template 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY pcReg_tb IS
END pcReg_tb;

ARCHITECTURE behavior OF pcReg_tb IS 

  -- Component Declaration
  COMPONENT pcReg
      	port(
		clk,rst : in STD_LOGIC;
		BUSSData : in STD_LOGIC_VECTOR(15 downto 0);
		P : in STD_LOGIC;
		W : in STD_LOGIC;
		PCOUT : out STD_LOGIC_VECTOR(15 downto 0)
	);
  END COMPONENT;

  SIGNAL clk : std_logic := '0';
  SIGNAL rst : std_logic := '0';
  SIGNAL BUSSDATA : STD_LOGIC_VECTOR(15 downto 0) := X"0000";
  SIGNAL P : STD_LOGIC := '0';
  SIGNAL PCOUT : STD_LOGIC_VECTOR(15 downto 0) := X"0000";
  signal tb_running : boolean := true;
  SIGNAL W : STD_LOGIC := '0';
BEGIN

  -- Component Instantiation
  uut: pcReg PORT MAP(
    clk => clk,
    rst => rst,
    BUSSData => BUSSData,
    P => P,
    W => W,
    PCOUT => PCOUT);


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
    P <= '1';

    for i in 0 to 50000000 loop         -- Vänta ett antal klockcykler
      wait until rising_edge(clk);
    end loop;  -- i
    
    tb_running <= false;                -- Stanna klockan (vilket medför att inga
                                        -- nya event genereras vilket stannar
                                        -- simuleringen).
    wait;
  end process;
      
END;
