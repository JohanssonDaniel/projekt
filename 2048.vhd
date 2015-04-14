library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lab is
    Port ( clk,rst : in  STD_LOGIC;
		   data : in STD_LOGIC (15 downto 0);
		   vgaRed, vgaGreen : out  STD_LOGIC_VECTOR (2 downto 0);
		   vgaBlue : out  STD_LOGIC_VECTOR (2 downto 1);
		   ca,cb,cc,cd,ce,cf,cg,dp, Hsync,Vsync : out  STD_LOGIC;
	       an : out  STD_LOGIC_VECTOR (3 downto 0));
end lab;

architecture Behavioral of lab is
  component leddriver
    Port ( clk,rst : in  STD_LOGIC;
           ca,cb,cc,cd,ce,cf,cg,dp : out  STD_LOGIC;
           an : out  STD_LOGIC_VECTOR (3 downto 0);
           ledvalue : in  STD_LOGIC_VECTOR (15 downto 0));
  end component;
  
  signal clkctr : STD_LOGIC (1 downto 0) = "00"; 				-- Clock counter (mod 4 in design)
  signal datactr: STD_LOGIC (1 downto 0) = "00";				-- When recieving data, point to the correct row in pitcure mem
  signal row : STD_LOGIC (1 downto 0) = "00";	
  signal datarec : STD_LOGIC = "0";								-- = 1 when begin to recieve data
  signal sreg : STD_LOGIC = (15 downto 0);						-- Register for sending current row to vga
  type ram_t is array (0 to 3) of std_logic_vector(0 to 15);
	
  constant notsorandomstart : ram_t := ("0000000000000000",
										"0000001000000000",
										"0000000000000000",
										"0000000000000000");	--Spawns a 2 on (1,1)
								
begin
	process(clk) begin											-- Increase clock counter
		if rising_edge(clk) then
			if rst='1' then
				clkctr <= "00";
			else
				clkctr <= clkctr + 1;
			end if;
		end if;
	end process;
  
	process(clk) begin											-- Next row every 4:th clock
		if rising_edge(clk) then 
			if rst = '1' then
				row <= "00";
			elsif clkctr = '3' then
				row <= row + 1;
			end if;
		end if;
	end process;
	
	process(clk) 												-- Load next row from ram into sreg 
		if rising_edge(clk) then
			if rst = '1' then
				row <= "00";
				sreg = "0000000000000000";
			elsif clkctr = '3' then
				sreg <= ram_t(convinteger(row) + 1);
			end if;
		end if;
	end process;
end Behavioral;