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
  
	CONSTANT direction_left   : STD_LOGIC_VECTOR (3 downto 0)  := "0001";
	CONSTANT direction_right  : STD_LOGIC_VECTOR (3 downto 0)  := "0010";
	CONSTANT direction_up     : STD_LOGIC_VECTOR (3 downto 0)  := "0011";
	CONSTANT direction_down   : STD_LOGIC_VECTOR (3 downto 0)  := "0100";
	
	signal   direction        : STD_LOGIC_VECTOR (3 downto 0)  := "0000";
	
	signal   load_to_mem      : STD_LOGIC					  := '0';
	signal   load_Row         : STD_LOGIC					  := '0';
	signal   load_Col         : STD_LOGIC					  := '0';
	
	signal 	 rowReg           : STD_LOGIC_VECTOR (0 to 15) := "0000000000000000";
	type     column            is array (0 to 3) of std_logic_vector (0 to 3);
	signal   colReg			  : column 						  :=   ("0000",
											                        "0000",
											                        "0000",
											                        "0000");
	
	signal   neighbourVal     : STD_LOGIC_VECTOR (3 downto 0)           := "0000";
	signal   currentVal		  : STD_LOGIC_VECTOR (3 downto 0)           := "0000";	
	signal 	 colctr, rowctr   : STD_LOGIC_VECTOR (1 downto 0)           := "00";
	signal 	 currentColumn, currentRow : STD_LOGIC_VECTOR (1 downto 0)  := "00";
	
	signal   clkctr           : STD_LOGIC_VECTOR (1 downto 0)              := "00"; 				-- Clock counter (mod 4 in design)
	signal   srow             : STD_LOGIC_VECTOR (1 downto 0)              := "00";	
	signal   sreg             : STD_LOGIC_VECTOR (0 to 15)             := "0000000000000000";	-- Register for sending current row to vga

	---VGA
	signal xctr,yctr : std_logic_vector(9 downto 0) := "0000000000";
 	alias rad : std_logic_vector(7 downto 0) is yctr(9 downto 2); -- i bildminnet
 	alias kol : std_logic_vector(7 downto 0) is xctr(9 downto 2);  -- i bildminnet
 	alias ypix : std_logic_vector(1 downto 0) is yctr(1 downto 0); -- storpixel är 4
 	alias xpix : std_logic_vector(1 downto 0) is xctr(1 downto 0);  -- storpixel är 4
	signal hs : std_logic := '1';
	signal vs : std_logic := '1';
	
	type ram_t is array (0 to 3) of std_logic_vector(0 to 15);			--Varje två potens representeras av en byte och vi har fyra på varje rad
	
	constant notsorandomstart : ram_t := ("0000000000100000",
										  "0000000000000000",
										  "0000000000000000",
										  "0000000000000000");	--sätter e 2:a på plats (0,2)
	signal bildminne,tempRam  : ram_t := notsorandomstart;
	
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

	--VGA/bild
	process(clk) begin
    if rising_edge(clk) then
      if rst='1' then
         xctr <= "0000000000";     -- bits 1023 som max, använder bara 799    
      elsif clkctr=3 then
       if xctr=799 then   
         xctr <= "0000000000";
       else
         xctr <= xctr + 1;
       end if;
      end if;
      -- 
      if xctr=656 then        --640+16, se designskiss
        hs <= '0';
      elsif xctr=752 then   --640+16+96, se designskiss
        hs <= '1';
      end if;
    end if;
  end process;

	--VGA/bild
  process(clk) begin
    if rising_edge(clk) then
      if rst='1' then
        yctr <= "0000000000";
      elsif xctr=799 and clkctr=0 then
       if yctr=520 then                  -- 521 i storlek
         yctr <= "0000000000";
       else
         yctr <= yctr + 1;
       end if;
       --
       if yctr=490 then     -- 480+10, se designskiss
         vs <= '0';
       elsif  yctr=492 then   -- 480+10+2, se designskiss
         vs <= '1';
       end if;
      end if;
    end if;
  end process;
  Hsync <= hs;
  Vsync <= vs;

	-- bildminne/spelplan
  process(clk) begin
    if rising_edge(clk) then
      if ypix=0 and xpix=0 and clkctr=0 then
        if kol<100 then
          if rad<25 then
            -- hämta ifrån tiles, sreg
					elsif rad<50 then
						--hämta ifrån tiles, sreg
					elsif rad<75 then
						--hämta ifrån tiles,sreg
					elsif rad<100 then
						--hämta ifrån tiles,sreg
					end if;
				end if;
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
				when direction_right => if colctr = -1 then rowctr <= rowctr + 1;
										end if;
				when direction_left  => if colctr =  4 then rowctr <= rowctr + 1;
										end if;
				when direction_up    => if rowctr = -1 then colctr <= colctr + 1;
										end if;
				when direction_down  => if rowctr =  4 then colctr <= colctr + 1;				
										end if;
				when others => direction <= direction;
			end case;
		end if;
	end process;
	
	process(clk) begin
		if rising_edge(clk) then
			if rst = '1' then
				load_to_mem <= '0';
			elsif load_to_mem = '1' then
				load_to_mem <= '0';
				bildminne <= tempRam;
			end if;
		end if;
	end process;
	--Ladda rad/kolumn reg	
	process(clk) begin
		if rising_edge(clk) then
			if rst = '1' then
				load_row <= '0';
				load_col <= '0';
				rowReg    <= "0000000000000000";
				colReg    <= ("0000",
							  "0000",
							  "0000",
							  "0000");
			elsif load_row = '1' then 
				rowReg    <= tempRam(conv_integer(rowCtr) +1);														  --Ladda nuvarande rad 
			elsif load_col = '1' then
				colReg    <= tempRam(0 to 3)(conv_integer(colctr)*4 to conv_integer(colctr)*4 + 4); 				  -- Ladda alla rader i kolumnen
			end if;
		end if;
	end process;
	
	--Om värdet i raden/kolumnen är noll, gå till nästa rad/kolumn
	process(clk) begin
		if rising_edge(clk) then
			case direction is
				when direction_right|direction_left => currentVal <= rowReg(conv_integer(currentColumn) to conv_integer(currentColumn) + 3);
				when direction_up|direction_down    => currentVal <= colReg(conv_integer(currentRow));
				when others                         => direction <= direction;
			end case;
		end if;
	end process;
	
	--Om värdet i raden/kolumnen är noll, gå till nästa rad/kolumn
	process(clk) begin
		if rising_edge(clk) then
			case direction is
				when direction_right => if currentVal = "00" then currentColumn <= currentColumn - 1;
										end if;
				when direction_left  => if currentVal = "00" then currentColumn <= currentColumn + 1;
										end if;
				when direction_up    => if currentVal = "00" then colctr <= colctr - 1;
										end if;
				when direction_down  => if currentVal = "00" then colctr <= colctr + 1;	
										end if;
				when others 		=> direction <= direction;
			end case;
		end if;
	end process;
	
	--Tar ut grannen radvis/kolumnvis
	process(clk) begin
		if rising_edge(clk) then
			case direction is
				when direction_right => neighbourVal <= rowReg((conv_integer(currentColumn)*4 + 4) to (conv_integer(currentColumn)*4 + 7));
				when direction_left  => neighbourVal <= rowReg((conv_integer(currentColumn)*4 - 4) to (conv_integer(currentColumn)*4 - 7));
				when direction_up    => neighbourVal <= colReg(conv_integer(currentRow) + 1);
				when direction_down  => neighbourVal <= colReg(conv_integer(currentRow) - 1);
				when others 		 =>	direction <= direction;
			end case;
		end if;
	end process;
	
	--Merge
	process(clk) begin
		if rising_edge(clk) then
			case direction is
				when direction_right => if    neighbourVal = "0000" then rowReg(conv_integer(currentColumn)*4 to  conv_integer(currentColumn)*4 + 3) <= "0000";
												                    rowReg(conv_integer(currentColumn)*4 + 4      to conv_integer(currentColumn)*4 + 7) <= currentVal;
									    elsif neighbourVal = currentVal then rowReg(conv_integer(currentColumn)*4 to conv_integer(currentColumn)*4 + 3) <= "0000";
												                            rowReg(conv_integer(currentColumn)*4 + 4 to conv_integer(currentColumn)*4 + 7) <= currentVal + neighbourVal; 
										end if;										
				when direction_left  => if    neighbourVal = "0000" then rowReg(conv_integer(currentColumn)*4 to  conv_integer(currentColumn)*4) <= "0000";
												                    rowReg(conv_integer(currentColumn)*4 - 4 to conv_integer(currentColumn)*4 - 7) <= currentVal;
									    elsif neighbourVal = currentVal then rowReg(conv_integer(currentColumn)*4 to conv_integer(currentColumn)*4 + 3) <= "0000";
												                            rowReg(conv_integer(currentColumn)*4 + 4 to conv_integer(currentColumn)*4 - 7) <= currentVal + neighbourVal; 
										end if;
				when direction_up    => if    neighbourVal = "0000"         then colReg(conv_integer(currentRow))     <= "0000";
												                            colReg(conv_integer(currentRow) + 1) <= currentVal;
									    elsif neighbourVal = currentVal then colReg(conv_integer(currentRow))     <= "0000";
												                            colReg(conv_integer(currentRow) + 1) <= currentVal + neighbourVal; 
										end if;
				when direction_down    => if    neighbourVal = "0000"         then colReg(conv_integer(currentRow))   <= "0000";
												                            colReg(conv_integer(currentRow) - 1) <= currentVal;
									    elsif neighbourVal = currentVal then colReg(conv_integer(currentRow))     <= "0000";
												                            colReg(conv_integer(currentRow) - 1) <= currentVal + neighbourVal;
										end if;
				when others         => direction <= direction;
			end case;
		end if;
	end process;
end Behavioral;

