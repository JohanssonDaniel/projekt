library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;
--use ieee.numeric_bit;
--use ieee.numeric_std;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lab is
    Port ( 
    	clk,rst : in  STD_LOGIC
    	);
end lab;

architecture Behavorial of lab is

-- Component Declaration
  COMPONENT myPC is
		port(
			clk,rst : in STD_LOGIC;
			k1,k2 : in STD_LOGIC_VECTOR(7 downto 0);
			SEQ : in STD_LOGIC_VECTOR(3 downto 0);
			my_out : out STD_LOGIC_VECTOR(7 downto 0)
		);
	end COMPONENT;
  
  COMPONENT myMem
      	port(
		my_out : in STD_LOGIC_VECTOR(7 downto 0);
		my_row : out STD_LOGIC_VECTOR(27 downto 0)
	);
  END COMPONENT;
        SIGNAL my_counter : STD_LOGIC_VECTOR(7 downto 0) := X"00";
	SIGNAL my_Row : STD_LOGIC_VECTOR(27 downto 0) := X"0000000";
	alias myADR			: std_logic_vector(6 downto 0) is my_Row(6 downto 0);
	alias SEQ			: std_logic_vector(3 downto 0) is my_Row(10 downto 7);
	alias LC			: std_logic_vector(1 downto 0) is my_Row(12 downto 11);
	alias P				: std_logic is my_Row(13);
	alias S				: std_logic is my_Row(14);
	alias FB			: std_logic_vector(2 downto 0) is my_Row(17 downto 15);
	alias TB			: std_logic_vector(2 downto 0) is my_Row(20 downto 18);	
	alias ALU			: std_logic_vector(3 downto 0) is my_Row(24 downto 21); 
	--MYPC	
	SIGNAL k1,k2 : STD_LOGIC_VECTOR(7 downto 0) := X"00"; 	
	SIGNAL my_out : STD_LOGIC_VECTOR(7 downto 0) := X"00"; 
  
BEGIN

  -- Component Instantiation
  my_pc : myPC PORT MAP(
  	clk => clk,
  	rst => rst,
  	k1 => k1,
  	k2 => k2,
  	SEQ => SEQ,
  	my_out => my_out
  );
  my_mem : myMem PORT MAP(
  	my_out => my_out,
  	my_row => my_row
  );
		
		
end Behavorial;
