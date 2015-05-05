-- TestBench Template 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ALU_tb IS
END ALU_tb;

ARCHITECTURE behavior OF ALU_tb IS 

  -- Component Declaration
  COMPONENT ALU
      	port(
      		clk,rst : in STD_LOGIC;
		aluInstruction : in STD_LOGIC_VECTOR(3 downto 0); 		--Instruktion
		BUSS : in STD_LOGIC_VECTOR(15 downto 0); 	--data från buss
		Z,N,C,V : out std_logic;				--Flaggor
		AR : out STD_LOGIC_VECTOR(15 downto 0)  	-- Uträknad data
	);
  END COMPONENT;

	SIGNAL clk : std_logic := '0';
	SIGNAL rst : std_logic := '0';
	SIGNAL tb_running : boolean := true;

  
	SIGNAL aluInstruction : STD_LOGIC_VECTOR(3 downto 0) := "0000"; 		--Instruktion
	SIGNAL BUSS : STD_LOGIC_VECTOR(15 downto 0) := X"1010"; 	--data från buss
	SIGNAL AR : STD_LOGIC_VECTOR(15 downto 0) := X"0000";  	-- Uträknad data
	SIGNAL Z,N,C,V : std_logic;				--Flaggor 
  
BEGIN

  -- Component Instantiation
  uut: ALU PORT MAP(
  	clk => clk,
  	rst => rst, 
  	aluInstruction => aluInstruction,
  	BUSS => BUSS,
  	Z => Z,
  	N => N,
  	C => C,
  	V => V,
  	AR => AR
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
    
    wait until rising_edge(clk);
    aluInstruction <= "0001";
    wait until rising_edge(clk);
    aluInstruction <= "1001";
    for i in 0 to 4 loop
	    wait until rising_edge(clk);
    end loop;
    aluInstruction <= "0000";
 
 
 
    for i in 0 to 50000000 loop         -- Vänta ett antal klockcykler
      wait until rising_edge(clk);
    end loop;  -- i
    
    tb_running <= false;                -- Stanna klockan (vilket medför att inga
                                        -- nya event genereras vilket stannar
                                        -- simuleringen).
    wait;
  end process;
      
END;
