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

entity 2048 is
    Port ( clk,rst : in  STD_LOGIC;
           seg: out  STD_LOGIC_VECTOR(7 downto 0);
           an : out  STD_LOGIC_VECTOR (3 downto 0));
end 2048;

architecture Behavorial of 2048 is
  	
  	component pcReg
  	port (	clk,rst : in STD_LOGIC;
		data : in STD_LOGIC_VECTOR(15 downto 0);
		P : in STD_LOGIC;
		PC : out STD_LOGIC_VECTOR(7 downto 0));
		
	pc_inst : PCREG(
		clk => clk,
		rst => rst,
		data => BUSS,
	)
		
		
end Behavorial;
