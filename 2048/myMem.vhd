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

entity myMem is
	port(
		myPC : in STD_LOGIC_VECTOR(7 downto 0);
		myMem_out : out STD_LOGIC_VECTOR(27 downto 0)
	);
end myMem;

architecture Behavorial of myMem is 
	type instructionMem is array (0 to 127) of std_logic_vector(27 downto 0);
	constant instructionset : instructionMem := ( X"00f8000",
                                                      X"008a000",
                                                      X"0004100", 
                                                      X"0078080",
                                                      X"00fa080",
                                                      X"0078000",
                                                      X"00b8080",
                                                      X"0240000",
                                                      X"0980000",
                                                      X"0138080",
                                                      X"0380000",
                                                      X"0041000",
                                                      X"1a00800",
                                                      X"000060f",
                                                      X"000028c",
                                                      X"0130180",
                                                      X"0002000",
                                                      X"02c0000",
                                                      X"0840000",
                                                      X"0118180",
                                                      X"0000216",
                                                      X"0002180",
                                                      X"0002000",
                                                      X"02c0000",
                                                      X"0840000",
                                                      X"0118180",
                                                      X"0000780",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"00b0180",
                                                      X"0190180",
                                                      X"0380000",
                                                      X"0880000",
                                                      X"0130180",
                                                      X"0380000",
                                                      X"0a80000",
                                                      X"0130180",
                                                      X"0380000",
                                                      X"0c80000",
                                                      X"0130180",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000",
                                                      X"0000000");
                                                      
        SIGNAL myMem : instructionMem := instructionset;
                                                      
begin
	process (myPc) begin
		myMem_out <= myMem(conv_integer(myPC));
	end process;
end Behavorial;
	
