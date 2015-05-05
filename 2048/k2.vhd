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

entity k2 is
	port(
		clk,rst : in STD_LOGIC;
		m : in STD_LOGIC_VECTOR(1 downto 0);
		k2_out : out STD_LOGIC_VECTOR(7 downto 0)
	);
end k2;

architecture Behavorial of k2 is 
	SIGNAL k2_value : STD_LOGIC_VECTOR(7 downto 0);
	type   k_2     is array (0 to 3)  of STD_LOGIC_VECTOR (7 downto 0);
	signal k2 : k_2 := (	X"00",
				X"01",
				X"02",
				X"09");
begin
	process(clk,rst) begin
		if rst = '1' then
			k2_value <= X"00";
		else
			--hämta första värdet
			k2_value <= k2(conv_integer(m));
		end if;
	end process;
	
	k2_out <= k2_value;
end Behavorial;
