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
		   JA : in STD_LOGIC_VECTOR (7 downto 0);					--Joystick input
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
  
	signal movingBlockDirection : STD_LOGIC_VECTOR (1 downto 0) := "00";
	CONSTANT moveLeft : STD_LOGIC_VECTOR (1 downto 0):= "11";
	CONSTANT moveRight : STD_LOGIC_VECTOR (1 downto 0):= "10";
	signal currentColumn : STD_LOGIC_VECTOR (1 downto 0) := "00";
	signal columnVal : STD_LOGIC_VECTOR (3 downto 0) := "0000";
	signal neighbuorVal : STD_LOGIC_VECTOR (3 downto 0) := "0000";
	signal clkctr : STD_LOGIC_VECTOR (1 downto 0) := "00"; 				-- Clock counter (mod 4 in design)
	signal datactr: STD_LOGIC_VECTOR (1 downto 0) := "00";				-- When recieving data, point to the correct row in pitcure mem
	signal row : STD_LOGIC_VECTOR (1 downto 0) := "00";	
	signal sreg : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";						-- Register for sending current row to vga
	
	type ram_t is array (0 to 3) of std_logic_vector(0 to 15);			--Varje två potens representeras av en byte och vi har fyra på varje ram
	
	constant notsorandomstart : ram_t := ("0000000000000000",
										"0000001000000000",
										"0000000000000000",
										"0000000000000000");	--Spawns a 2 on (1,1)
	signal bildminne,tempRam : ram_t := notsorandomstart;
	
begin
	--GPU
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
			elsif clkctr = 3 then
				row <= row + 1;
			end if;
		end if;
	end process;
	
	process(clk)begin												-- Load next row from ram into sreg 
		if rising_edge(clk) then
			if rst = '1' then
				row <= "00";
				sreg <= "0000000000000000";
			elsif clkctr = 3 then
				sreg <= bildminne(conv_integer(row) + 1);
			end if;
		end if;
	end process;
	
	--joyStick
	process(clk) begin
		if rising_edge(clk) then
			if rst = '1' then
				--resetboard
				movingBlockDirection <= "00";
			elsif JA = 16 then								--Vänster
				movingBlockDirection <= moveLeft;
			elsif JA = 8 then							--Höger
				movingBlockDirection <= moveRight;
			end if;
		end if;
	end process;
	
	--2048
	process(clk) begin
		if rising_edge(clk)	then
			if row = 4	then
				bildminne <= tempRam;							--Placeholder
				row <= "00";
			elsif currentColumn = -1 then						--Näst sista kolumnen
				row <= row + 1;
			else
				columnVal <= tempRam(conv_integer(row) + 1)((conv_integer(currentColumn)*4) to ((conv_integer(currentColumn)+1)*4)-1);
				if columnVal = 0	then 				--currentColumn index the second bit, currentColumn*4 index second byte	
					currentColumn <= currentColumn - 1;
				elsif currentColumn = 3 then 
					neighbuorVal <= tempRam(conv_integer(row) + 1)(conv_integer(currentColumn+1)*4 to (conv_integer(currentColumn)+2)*4-1);
					if neighbuorVal = 0 then
						tempRam(conv_integer(row) + 1)(conv_integer(currentColumn+1)*4 to (conv_integer(currentColumn)+2)*4-1) <= columnVal;
						tempRam(conv_integer(row) + 1)((conv_integer(currentColumn)*4) to ((conv_integer(currentColumn)+1)*4)-1) <= "0000";
					elsif columnVal = neighbuorVal then
						tempRam(conv_integer(row) + 1)(conv_integer(currentColumn+1)*4 to (conv_integer(currentColumn)+2)*4-1) <= columnVal + neighbuorVal;
						tempRam(conv_integer(row) + 1)((conv_integer(currentColumn)*4) to ((conv_integer(currentColumn)+1)*4)-1) <= "0000";
						--currentScore
					end if;
				end if;
			end if;
		end if;
	end process;
end Behavioral;

