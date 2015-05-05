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

entity MUX is
	port(
		clk,rst : in STD_LOGIC;
		GRx : std_logic_vector(1 downto 0);
		FB : in STD_LOGIC_VECTOR(2 downto 0);
		BUSSDATA : in STD_LOGIC_VECTOR(15 downto 0);
		MUXOut : out STD_LOGIC_VECTOR(15 downto 0)
	);
end MUX;

architecture Behavorial of MUX is 
	SIGNAL GR0 : STD_LOGIC_VECTOR(15 downto 0);
	SIGNAL GR1 : STD_LOGIC_VECTOR(15 downto 0);
	SIGNAL GR2 : STD_LOGIC_VECTOR(15 downto 0);
	SIGNAL GR3 : STD_LOGIC_VECTOR(15 downto 0);
begin
	--MUX
	process(clk,rst) begin
		if rising_edge(clk) then
			if rst='1' then
				GR0 <= X"0000";
				GR1 <= X"0000";
				GR2 <= X"0000";
				GR3 <= X"0000";
			elsif (FB = "110") then
				case GRx is
					when "00" => GR0 <= BUSSDATA;
					when "01" => GR1 <= BUSSDATA;
					when "10" => GR2 <= BUSSDATA;
					when "11" => GR3 <= BUSSDATA;
					when others => null;
				end case;
			end if;
		end if;
	end process;
	
	with GRx select
	MUXOut <= GR0 when "00", 
						GR1 when "01", 
						GR2 when "10", 
					  GR3 when "11", 
					  (others => '0') when others;
end Behavorial;
