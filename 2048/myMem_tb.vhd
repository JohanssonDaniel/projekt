-- TestBench Template 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;
ENTITY myMem_tb IS
END myMem_tb;

ARCHITECTURE behavior OF myMem_tb IS 

  -- Component Declaration
  COMPONENT myMem
      	port(
		myPC : in STD_LOGIC_VECTOR(7 downto 0);
		myRow : out STD_LOGIC_VECTOR(27 downto 0)
	);
  END COMPONENT;
  SIGNAL myPC : STD_LOGIC_VECTOR(7 downto 0) := X"00";
  SIGNAL myRow : STD_LOGIC_VECTOR(27 downto 0) := X"0000000"; 

  SIGNAL clk : std_logic := '0';
  SIGNAL rst : std_logic := '0';
  signal tb_running : boolean := true;
BEGIN

  -- Component Instantiation
  uut: myMem PORT MAP(
  	myPC => myPC,
  	myRow => myRow
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
    
    for i in 0 to 10 loop
    	if rising_edge(clk) then
    		myPc <= myPc + 1;
	end if;
	end loop;

    for i in 0 to 50000000 loop         -- Vänta ett antal klockcykler
      wait until rising_edge(clk);
    end loop;  -- i
    
    tb_running <= false;                -- Stanna klockan (vilket medför att inga
                                        -- nya event genereras vilket stannar
                                        -- simuleringen).
    wait;
  end process;
      
END;
