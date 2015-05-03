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

entity lab is
    Port ( clk,rst : in  STD_LOGIC;
           seg: out  STD_LOGIC_VECTOR(7 downto 0);
           an : out  STD_LOGIC_VECTOR (3 downto 0));
end lab;

architecture simple of lab is

  	component leddriver --NÅT ANNAT
    	Port ( clk,rst : in  STD_LOGIC);
  	end component;
	
	SIGNAL readBuss : STD_LOGIC;
	signal pFLAG 			: STD_LOGIC; 						--FLAGGA SÄTTS NÄR PC SKA INKREMENTERAS

	signal x,s8    : std_logic_vector(7 downto 0);
	signal sALU    : std_logic_vector(8 downto 0);
	signal Z,N,C,V : std_logic;

	signal PC,ASR 			: STD_LOGIC_VECTOR(7 downto 0) 	:= 	X"00"; 		-- VÄRDE FÖR PC
	signal HR,IR,AR,BUSS 	: STD_LOGIC_VECTOR(15 downto 0) :=	X"0000";	-- BUSS I HEX 
	
	--Väljer ut korrekt bitar i IR (Instruktions registret)
	alias OP 			: std_logic_vector(3 downto 0) is IR(15 downto 12);
	alias GRx 		: std_logic_vector(1 downto 0) is IR(11 downto 10);
	alias M				: std_logic_vector(1 downto 0) is IR(9 downto 8);
	alias Adr			: std_logic_vector(7 downto 0) is IR(7 downto 0);

	signal GR0, GR1, GR2, GR3		: STD_LOGIC_VECTOR(15 downto 0)	:=	X"0000";	-- GR

	signal myPC, mySPC	: STD_LOGIC_VECTOR(7 downto 0) 	:= X"00";
	signal myMRow		: STD_LOGIC_VECTOR(27 downto 0) 		:= X"0000000";
	alias myADR			: std_logic_vector(6 downto 0) is myMRow(6 downto 0);
	alias SEQ			: std_logic_vector(3 downto 0) is myMRow(10 downto 7);
	alias LC			: std_logic_vector(1 downto 0) is myMRow(12 downto 11);
	alias P				: std_logic is myMRow(13);
	alias S				: std_logic is myMRow(14);
	alias FB			: std_logic_vector(2 downto 0) is myMRow(17 downto 15);
	alias TB			: std_logic_vector(2 downto 0) is myMRow(20 downto 18);	
	alias ALU			: std_logic_vector(3 downto 0) is myMRow(24 downto 21);
	
	type   k_1     is array (0 to 15) of STD_LOGIC_VECTOR (7 downto 0);
	type   k_2     is array (0 to 3)  of STD_LOGIC_VECTOR (7 downto 0);
	constant k1 : k_1 := (X"30",
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

	signal k2 : k_2 := (	X"00",
				X"01",
				X"02",
				X"03");
	
	type mem is array (0 to 255) of std_logic_vector(15 downto 0);
	type instructionMem is array (0 to 127) of std_logic_vector(27 downto 0);
	
	constant instructionset : instructionMem := ( X"00f8000",  -- Laddsekvens
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
	-- constant lab1upg2 : mem := 				(X"0c00",
							-- X"1c0f",
							-- X"2d03",
							-- X"0004",
							-- X"3dc5",
							-- X"0001",
							-- X"4d07",
							-- X"000f",
							-- X"5c03",
							-- X"6003",
							-- X"7003",
							-- X"8000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0c00",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000",
							-- X"0000");
	
	signal PM : mem := lab1upg2;
	signal myM : instructionMem := instructionset;
begin
	--myPC
	process(clk,rst) begin
		if rising_edge(clk) then
			if rst = '1' then
				myPC <= X"00";
			elsif readBuss = '0' then 
				case SEQ is
					when "0000" => myPC <= myPC + 1; 
					when "0001" => myPC <= k1(conv_integer(OP));
					when "0010" => myPC <= k2(conv_integer(M));
					when "0011" => myPC <= X"00";
					when others => myPC <= myPC;
				end case;
			else
				myPC <= myPC;
			end if;
		end if;
	end process;

	--myMRow
	process(clk,rst) begin
		if rising_edge(clk) then
			if rst = '1' then
				myMRow <= myM(0);
			elsif readBuss = '0' then 
				myMROW <= myM(conv_integer(myPC));
			else 
				myMROW <= myMROW;
			end if;
		end if;
	end process;

	--PM
	process(clk,rst) begin
		if rising_edge(clk) then
			--if FB = "010" then 
				--PM(conv_integer(ASR)) <= BUSS;
			if FB = "010" and readBuss = '1' then 
				PM(conv_integer(ASR)) <= BUSS;
			end if;
		end if;
	end process;

	 --BUSSEN
	 process(clk,rst) begin
		if rising_edge(clk) then
			 if rst = '1' then
				 BUSS <= X"0000";
				 readBuss <= '0';
			 elsif readBuss = '1' then
				readBuss <= '0';
			 else
				readBuss <= '1';
				 case TB is
					 when "001" => BUSS <= IR;
					 when "010" => BUSS <= PM(conv_integer(ASR));
					 when "011" => BUSS <= std_logic_vector(resize(UNSIGNED(PC),BUSS'LENGTH));
					 when "100" => BUSS <= AR;
					 when "101" => BUSS <= HR;
					 when "110" => 	if 		GRx = "00" then BUSS <= GR0;
									 elsif	GRx = "01" then BUSS <= GR1;
									 elsif	GRx = "10" then BUSS <= GR2;
									 else					BUSS <= GR3;
									 end if;
					 when others => null;
				 end case;
			end if;
		end if;
	end process;
	
	--ALU
	process(clk)
		begin
		if rising_edge(clk) then
			if readBuss = '1' then 
				case ALU is
					when "0001" => AR <= BUSS; 
					when "0011" => AR <= "0000000000000000";
					when "0100" => AR <= AR + BUSS;
					when "0101" => AR <= AR - BUSS;
					when "0110" => AR <= AR and BUSS;
					when "0111" => AR <= AR or BUSS;
					when "1000" => AR <= AR + BUSS; --samma som "0100"
					when others => null;
				end case;
			else
				case ALU is 
					when "1001" => 	AR(15 downto 12) <= AR(11 downto 8);       	--Logic shift left
									AR(11 downto 8)  <= AR(7 downto 4);
									AR(7 downto 4)   <= AR(3 downto 0);
									AR(3 downto 0)   <= X"0";
					--ANVÄNDER INTE ARHR ETT STEG HÖGER
					when "1011" => 	AR(3 downto 0)   <= AR(7 downto 4);  		--Logic shift right
									AR(7 downto 4)   <= AR(11 downto 8);
									AR(11 downto 8)  <= AR(15 downto 12);
									AR(15 downto 12) <= X"0";
					when others => null;
				end case;
			
			--V <= AR(15) xor AR(14);
			--Z <= '1' when AR = 0 else '0';
			--N <= AR(7);
			end if;
		end if;
	end process;

	--PC
	process(clk,rst) begin
    if rising_edge(clk) then
			if rst='1' then
				PC <= X"00";
			elsif pFLAG = '1' and not readBuss = '1' then
				PC <= PC + 1;
			elsif (FB = "011") and readBuss = '1' then
				PC <= std_logic_vector(resize(UNSIGNED(BUSS),PC'LENGTH));
				end if;
			else
				PC <= PC;
		end if;
	end process;

	--ASR FB(ADRESS REGISTER HÄMTAR FRÅN PM)
	process(clk,rst)
		begin
		if rising_edge(clk) then
			if rst='1' then
				ASR <= X"00";
			elsif ((FB = "111") and (readBuss = '1')) then
				ASR <= std_logic_vector(resize(UNSIGNED(BUSS),ASR'LENGTH));
			end if;
		end if;
	end process;

	--HR (HJÄLP REGISTER)
	process(clk,rst)
		begin
		if rising_edge(clk) then
			if rst='1' then
				HR <= X"0000";
			elsif ((FB="101") and (readBuss = '1')) then
				HR <= BUSS;
			end if;
		end if;
	end process;


	--IR (INSTRUKTIONS REGISTER)
	process(clk,rst)
		begin
		if rising_edge(clk) then
			if rst='1' then
				IR <= X"0000";
			elsif ((FB = "001") and (readBuss = '1')) then
				IR <= BUSS;
			end if;
		end if;
	end process;


	--MUX
	process(clk,rst) begin
		if rising_edge(clk) then
			if rst='1' then
				GR0 <= X"0000";
				GR1 <= X"0000";
				GR2 <= X"0000";
				GR3 <= X"0000";
			elsif ((FB = "110") and (readBuss = '1')) then
				case GRx is
					when "00" => GR0 <= BUSS;
					when "01" => GR1 <= BUSS;
					when "10" => GR2 <= BUSS;
					when "11" => GR3 <= BUSS;
					when others => null;
				end case;
			end if;
		end if;
	end process;

end simple;
