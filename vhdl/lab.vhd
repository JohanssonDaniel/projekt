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
  
	CONSTANT direction_left  : STD_LOGIC_VECTOR (3 downto 0)  := "0001";
	CONSTANT direction_right : STD_LOGIC_VECTOR (3 downto 0)  := "0010";
	CONSTANT direction_up    : STD_LOGIC_VECTOR (3 downto 0)  := "0011";
	CONSTANT direction_down  : STD_LOGIC_VECTOR (3 downto 0)  := "0100";
	
	signal   direction       : STD_LOGIC_VECTOR (3 downto 0)  := "0000";
	
	signal   load_to_mem     : STD_LOGIC					  := "0";
	signal 	 rowReg          : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";
	signal   colReg is array (0 to 3) of std_logic_vector (0 to 3);
	signal   neighbuorVal    : STD_LOGIC_VECTOR (3 downto 0)  := "0000";
	signal 	 colctr, rowctr : STD_LOGIC_VECTOR (1 downto 0) := "00";
	signal 	 currentColumn, currentRow : STD_LOGIC_VECTOR (1 downto 0) := "00";
	
	signal   clkctr       : STD_LOGIC_VECTOR (1 downto 0)              := "00"; 				-- Clock counter (mod 4 in design)
	signal   srow         : STD_LOGIC_VECTOR (1 downto 0)             := "00";	
	signal   sreg         : STD_LOGIC_VECTOR (15 downto 0)             := "0000000000000000";	-- Register for sending current row to vga
	
	type ram_t is array (0 to 3) of std_logic_vector(0 to 15);			--Varje två potens representeras av en byte och vi har fyra på varje rad
	
	constant notsorandomstart : ram_t := ("0000000000100000",
										  "0000000000000000",
										  "0000000000000000",
										  "0000000000000000");	--sätter e 2:a på plats (0,2)
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
				srow <= "00";
			elsif clkctr = 3 then
				srow <= srow + 1;
			end if;
		end if;
	end process;
	
	process(clk)begin												-- Load next row from ram into sreg 
		if rising_edge(clk) then
			if rst = '1' then
				sreg <= "0000000000000000";
			elsif clkctr = 3 then
				sreg <= bildminne(conv_integer(srow) + 1);
			end if;
		end if;
	end process;
	
	--joyStick
	process(clk) begin
		if rising_edge(clk) then
			if rst = '1' then
				direction  <= "00";
			elsif JA = 16 then										--Vänster
				currentColumn <= "01";
				direction  <= direction_left;
			elsif JA = 8 then										--Höger
				currentColumn <= "10";
				direction  <= direction_right;
			end if;
		end if;
	end process;
	
	-- Testar om vi kommit till slutet av raden/kolumnen
	process(clk) begin
		if rising_edge(clk) then
			case direction is
				when direction_right => if colctr = -1 then rowctr = rowctr + 1;
				when direction_left  => if colctr =  4 then rowctr = rowctr + 1;
				when direction_up    => if rowctr = -1 then colctr = colctr + 1;
				when direction_down  => if rowctr =  4 then colctr = colctr + 1;				
				when others => direction <= direction;
			end case;
		end if;
	end process;
	
	process(clk) begin
		if rising_edge(clk) then
			if rst = '1' then
				load_to_mem <= 0;
			elsif load_to_mem = 1 then
				load_to_mem <= 0;
				bildminne <= tempRam;
			end if;
		end if;
	end process;
		
	process(clk) begin
		if rising_edge(clk) then
			if rst = '1' then
				load_row = '0';
				load_col = '0';
				rowReg    <= "0000000000000000";
				colReg    <= ("0000",
							  "0000",
							  "0000",
							  "0000");
			elsif load_row = '1' then 
				rowReg    <= tempRam(conv_integer(row) +1);			--Ladda nuvarande rad 
			elsif load_col = '1' then
				colReg    <= tempRam(0 to 3)(conv_integer(currentColumn)*4 to conv_integer(currentColumn)*4 + 4); -- Ladda alla rader i kolumnen
			end if;
		end if;
	end process;
	
	process(clk) begin
		if rising_edge(clk) then
			
	
	--2048
	process(clk) begin
		if rising_edge(clk)	then
			if gameRow = 4 then
				bildminne <= tempRam;							--Kommit till sista raden, skriv över bildminnet med det temporära bildminnet
				gameRow <= "00";
			elsif currentColumn = -1 then						--Näst sista kolumnen
				gameRow <= gameRow + 1;
			else
				variable rowVal : std_logic_vector (0 to 15) <= tempRam(conv_integer(gameRow) + 1);
				 -- kolumnen skjusteras för att peka på den 8:e biten istället för den 2:a
				variable columnVal : std_logic_vector (4 downto 0) <= rowVal(conv_integer(gameColumn)*4 to conv_integer(gameColumn + 1)*4 - 1);
				if columnVal = 0 then 				-- currentColumn index the second bit, currentColumn*4 index second byte	
					currentColumn <= currentColumn - 1;
				elsif currentColumn = 3 then 
					neighbuorVal <= rowVal(conv_integer(gameColumn + 1)*4 to conv_integer(gameColumn + 2)*4 - 1);
					if neighbuorVal = 0 then
						tempRam(conv_integer(row) + 1)(conv_integer(currentColumn)*4 to ((conv_integer(currentColumn)+1)*4)-1) <= "0000";
						tempRam(conv_integer(row) + 1)(conv_integer(currentColumn+1)*4 to (conv_integer(currentColumn)+2)*4-1) <= columnVal;
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

