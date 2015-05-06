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

entity k1 is
	port(
		clk,rst : in STD_LOGIC;
		op : in STD_LOGIC_VECTOR(3 downto 0);
		k1_out : out STD_LOGIC_VECTOR(7 downto 0)
	);
end k1;

architecture Behavorial of k1 is 
	SIGNAL k1_value : STD_LOGIC_VECTOR(7 downto 0);
	type   k_1     is array (0 to 15)  of STD_LOGIC_VECTOR (7 downto 0);
	signal k1 : k_1 := (X"30",
				X"31",
				X"32",
				X"35",
				X"38",
				X"0a",
				X"10",
				X"14",
				X"1a",
				X"00",
				X"00",
				X"00",
				X"00",
				X"00",
				X"00",
				X"00");
begin
	process(clk) begin
			if rst = '1' then
				k1_value <= X"00";
			else
				--hämta första värdet
				k1_value <= k1(conv_integer(op));
			end if;
	end process;
	
	k1_out <= k1_value;
end Behavorial;
