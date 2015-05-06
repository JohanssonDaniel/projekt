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

entity pm is
	port(
		clk,rst : in STD_LOGIC;
		TB : in STD_LOGIC_VECTOR(2 downto 0);
		FB : in STD_LOGIC_VECTOR(2 downto 0);
		BUSS : in STD_LOGIC_VECTOR(15 downto 0);
		PM_OUT : out STD_LOGIC_VECTOR(15 downto 0)
	);
end pm;

architecture Behavorial of pm is 
		type mem is array (0 to 255) of std_logic_vector(15 downto 0);
		--SIGNAL pm_value : STD_LOGIC_VECTOR(15 downto 0);
		signal asr_value : STD_LOGIC_VECTOR(7 downto 0);
	--lab1upg2 KLISTRA IN
	
		constant lab1upg2 : mem := (X"0cfe",
								X"4d02",
								X"000f",
								X"1cfd",
								X"0cfe",
								X"4d06",
								X"00f0",
								X"5c04",
								X"2cfd",
								X"1cfd",
								X"0cfe",
								X"4d0c",
								X"0f00",
								X"5c08",
								X"2cfd",
								X"1cfd",
								X"0cfe",
								X"4d12",
								X"f000",
								X"5c08",
								X"5c04",
								X"2cfd",
								X"1cff",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"0000",
								X"001c",
								X"53af",
								X"0000");
	
	signal PM : mem := lab1upg2;
begin
	process(BUSS) begin
		if rst = '1' then
			pm_out <= X"0000";
			asr_value <= X"00";
		elsif TB ="010" then  --SKICKAR VÄRDE FRÅN MINNE TILL BUSS
			PM_OUT <= PM(conv_integer(asr_value));
		elsif FB="010" then		--SKICKAR VÄRDE FRÅN BUSS IN TILL MINNET
			PM(conv_integer(asr_value)) <= BUSS;
		elsif FB="111" then		--UPDATERAR ASR
			asr_value <= std_logic_vector(resize(UNSIGNED(BUSS),asr_value'LENGTH));
		end if;
	end process;
	
	--ASR <= asr_value;
	--PM_OUT <= pm_value;
	
end Behavorial;
	
