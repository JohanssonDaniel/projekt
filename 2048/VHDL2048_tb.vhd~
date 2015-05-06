-- TestBench Template 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY VHDL2048_tb IS
END VHDL2048_tb;

ARCHITECTURE behavior OF VHDL2048_tb IS 

  -- Component Declaration
  COMPONENT VHDL2048
    PORT(
    	clk,rst : in  STD_LOGIC
    	--myMemRow_out : out STD_LOGIC_VECTOR(27 downto 0);
    	--myPC_out : out STD_LOGIC_VECTOR(7 downto 0)
    	);
	end component;

  	SIGNAL clk : std_logic := '0';
  	SIGNAL rst : std_logic := '0';
  	signal tb_running : boolean := true;
    	--SIGNAl myMemRow_out : STD_LOGIC_VECTOR(27 downto 0);
    	--SIGNAL myPC_out : STD_LOGIC_VECTOR(7 downto 0);
BEGIN

	VHDL2048_c : VHDL2048 PORT MAP (
	clk => clk,
	rst => rst
	--myMemRow_out => myMemRow_out,
	--myPC_out => myPC_out
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
      
END behavior;
