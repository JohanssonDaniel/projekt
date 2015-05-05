-- TestBench Template 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY myPC_tb IS
END myPC_tb;

ARCHITECTURE behavior OF myPC_tb IS 

  -- Component Declaration
  COMPONENT myPC
      	port(
		clk,rst : in STD_LOGIC;
		k1,k2 : in STD_LOGIC_VECTOR(7 downto 0);
		SEQ : in STD_LOGIC_VECTOR(3 downto 0);
		myPCOut : out STD_LOGIC_VECTOR(7 downto 0)
	);
  END COMPONENT;

	SIGNAL clk : std_logic := '0';
	SIGNAL rst : std_logic := '0';
	SIGNAL tb_running : boolean := true;
	
	SIGNAL k1,k2 : STD_LOGIC_VECTOR(7 downto 0) := X"00"; 	
	SIGNAL SEQ : STD_LOGIC_VECTOR(3 downto 0) := "0000";
	SIGNAL myPCOut : STD_LOGIC_VECTOR(7 downto 0) := X"00"; 
  
BEGIN

  -- Component Instantiation
  uut: myPC PORT MAP(
  	clk => clk,
  	rst => rst,
  	k1 => k1,
  	k2 => k2,
  	SEQ => SEQ,
  	myPCOut => myPCOut
  );


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
 
    for i in 0 to 50000000 loop         -- Vänta ett antal klockcykler
      wait until rising_edge(clk);
    end loop;  -- i
    
    tb_running <= false;                -- Stanna klockan (vilket medför att inga
                                        -- nya event genereras vilket stannar
                                        -- simuleringen).
    wait;
  end process;
      
END;
