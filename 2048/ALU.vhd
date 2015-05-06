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

entity ALU is
	port(
		clk,rst : in STD_LOGIC;
		aluInstruction : in STD_LOGIC_VECTOR(3 downto 0); 		--Instruktion
		BUSS : in STD_LOGIC_VECTOR(15 downto 0); 	--data från buss
		Z,N,C,V : out std_logic;				--Flaggor
		AR : out STD_LOGIC_VECTOR(15 downto 0)  	-- Uträknad data
	);
end ALU;

architecture Behavorial of ALU is
	SIGNAL aluAR : STD_LOGIC_VECTOR(15 downto 0); 
begin
	process (BUSS) begin
		--if rising_edge(clk) then
			if rst = '1' then
				Z <= '0';
				N <= '0';
				C <= '0';
				V <= '0';
				--AR <= X"0000";
				--aluAR <= X"0000";
			else
				case aluInstruction is
					when "0001" => aluAR <= BUSS; 
					when "0011" => aluAR <= "0000000000000000";
					when "0100" => aluAR <= aluAR + BUSS;
					when "0101" => aluAR <= aluAR - BUSS;
					when "0110" => aluAR <= aluAR and BUSS;
					when "0111" => aluAR <= aluAR or BUSS;
					when "1000" => aluAR <= aluAR + BUSS; --samma som "0100"
				
					when "1001" => 	aluAR(15 downto 12) <=  aluAR(11 downto 8);       		--Logic shift left
										aluAR(11 downto 8)  <= aluAR(7 downto 4);
										aluAR(7 downto 4)   <= aluAR(3 downto 0);
										aluAR(3 downto 0)   <= X"0";
				
					when "1101" => 	aluAR(3 downto 0)   <= 	aluAR(7 downto 4);  		--Logic shift right, 0 shifts in
										aluAR(7 downto 4)   <= aluAR(11 downto 8);
										aluAR(11 downto 8)  <= aluAR(15 downto 12);
										aluAR(15 downto 12) <= X"0";
					when others => null;
					end case;
			--end if;
		end if;
	end process;
	
	AR <= aluAR;
end Behavorial;
	
