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

entity PCREG is
	port(
		clk,rst : in STD_LOGIC;
		bussDATA : in STD_LOGIC_VECTOR(15 downto 0);
		P : in STD_LOGIC;
		W : in STD_LOGIC;
		PCOUT : out STD_LOGIC_VECTOR(15 downto 0)
	);
end pcReg;

architecture Behavorial of PCREG is 
	SIGNAL PCounter : STD_LOGIC_VECTOR(15 downto 0);
begin
	process(clk,rst) begin
		if rst = '1' then
			PCounter <= X"0000";
		elsif P = '1' then
			PCounter <= pCounter + 1;
		elsif w = '1' then
			PCounter <= bussData;
		end if;
	end process;
	
	PCOut <= pCounter;
end Behavorial;
	
