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
			myPCOut : out STD_LOGIC_VECTOR(7 downto 0)
		);
	end COMPONENT;
  
  COMPONENT myMem
      	port(
		myPC : in STD_LOGIC_VECTOR(7 downto 0);
		myRow : out STD_LOGIC_VECTOR(27 downto 0)
	);
  END COMPONENT;
	--MYMEM
        SIGNAL myPC : STD_LOGIC_VECTOR(7 downto 0) := X"00";
	SIGNAL myRow : STD_LOGIC_VECTOR(27 downto 0) := X"0000000"; 
	--MYPC	
	SIGNAL k1,k2 : STD_LOGIC_VECTOR(7 downto 0) := X"00"; 	
	SIGNAL SEQ : STD_LOGIC_VECTOR(3 downto 0) := "0000";
	SIGNAL myPCOut : STD_LOGIC_VECTOR(7 downto 0) := X"00"; 
  
BEGIN

  -- Component Instantiation
  my_pc : myPC PORT MAP(
  	clk => clk,
  	rst => rst,
  	k1 => k1,
  	k2 => k2,
  	SEQ => SEQ,
  	myPCOut => myPCOut
  );
  my_mem : myMem PORT MAP(
  	myPC => myPC,
  	myRow => myRow
  );
		
		
end Behavorial;
