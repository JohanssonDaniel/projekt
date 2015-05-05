-- TestBench Template 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY k2_tb IS
END k2_tb;

ARCHITECTURE behavior OF k2_tb IS 

  -- Component Declaration
  COMPONENT k2
      	port(
		clk,rst : in STD_LOGIC;
		m : in STD_LOGIC_VECTOR(1 downto 0);
		k2_out : out STD_LOGIC_VECTOR(7 downto 0)
	);
  END COMPONENT;

  SIGNAL clk : std_logic := '0';
  SIGNAL rst : std_logic := '0';
  SIGNAL m : STD_LOGIC_VECTOR(1 downto 0) := "00";
  signal tb_running : boolean := true;
  SIGNAL k2_out : STD_LOGIC_VECTOR(7 downto 0) := X"00";
BEGIN

  -- Component Instantiation
  uut: k2 PORT MAP(
    clk => clk,
    rst => rst,
    m => m,
    k2_out => k2_out);


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
    m <= "11";

    for i in 0 to 50000000 loop         -- Vänta ett antal klockcykler
      wait until rising_edge(clk);
    end loop;  -- i
    
    tb_running <= false;                -- Stanna klockan (vilket medför att inga
                                        -- nya event genereras vilket stannar
                                        -- simuleringen).
    wait;
  end process;
      
END;
