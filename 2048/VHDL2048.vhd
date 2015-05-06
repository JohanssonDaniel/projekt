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

entity VHDL2048 is
    Port ( 
    	clk,rst : in  STD_LOGIC
    	);
end VHDL2048;

architecture Behavorial of VHDL2048 is

-- Component Declaration
  COMPONENT myPC is
		port(
			clk,rst : in STD_LOGIC;
			k1,k2 : in STD_LOGIC_VECTOR(7 downto 0);
			SEQ : in STD_LOGIC_VECTOR(3 downto 0);
			myPC_out : out STD_LOGIC_VECTOR(7 downto 0)
		);
	end COMPONENT;
  
  COMPONENT myMem
      	port(
		myPC : in std_logic_vector(7 downto 0);
		myMem_out : out std_logic_vector(27 downto 0)
	);
  END COMPONENT;
  
  component PC
  	port(
  		clk,rst : in STD_LOGIC;
		P : in STD_LOGIC;
		buss_data : in STD_LOGIC_VECTOR(15 downto 0);
		FB : in std_logic_vector(2 downto 0);
		PC_out : out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;
	
	component general_reg port(
		clk,rst : in STD_LOGIC;
		FB : in STD_LOGIC_VECTOR(2 downto 0);
		BUSS : in STD_LOGIC_VECTOR(15 downto 0);
		reg_out : out STD_LOGIC_VECTOR(15 downto 0)
	);
	end component;
	
	component pm port(
		clk,rst : in STD_LOGIC;
		TB,FB : in STD_LOGIC_VECTOR(2 downto 0);
		BUSS : in STD_LOGIC_VECTOR(15 downto 0);
		PM_OUT : out STD_LOGIC_VECTOR(15 downto 0)
	);
	end component;
	
	component ALU port(
		clk,rst : in STD_LOGIC;
		aluInstruction : in STD_LOGIC_VECTOR(3 downto 0); 		--Instruktion
		BUSS : in STD_LOGIC_VECTOR(15 downto 0); 	--data från buss
		Z,N,C,V : out std_logic;				--Flaggor
		AR : out STD_LOGIC_VECTOR(15 downto 0)  	-- Uträknad data
	);
	end component;
	
	component MUX port(
		clk,rst : in STD_LOGIC;
		GRx : in std_logic_vector(1 downto 0);
		FB : in STD_LOGIC_VECTOR(2 downto 0);
		BUSS : in STD_LOGIC_VECTOR(15 downto 0);
		MUX_out : out STD_LOGIC_VECTOR(15 downto 0)
	);
	end component;
	
	component k1 port(
		clk,rst : in STD_LOGIC;
		op : in STD_LOGIC_VECTOR(3 downto 0);
		k1_out : out STD_LOGIC_VECTOR(7 downto 0)
	);
	end component;
	
	component k2 port(
		clk,rst : in STD_LOGIC;
		m : in STD_LOGIC_VECTOR(1 downto 0);
		k2_out : out STD_LOGIC_VECTOR(7 downto 0)
	);
	end component;
  
  	SIGNAL k1_out,k2_out : std_logic_vector(7 downto 0) := X"00";

	SIGNAL my_pc : std_logic_vector(7 downto 0) := X"00";
	  	
  	signal myMemRow			: std_logic_vector(27 downto 0) 	:= X"0000000";
	alias myADR			: std_logic_vector(6 downto 0) is myMemRow(6 downto 0);
	alias SEQ			: std_logic_vector(3 downto 0) is myMemRow(10 downto 7);
	alias LC			: std_logic_vector(1 downto 0) is myMemRow(12 downto 11);
	alias P				: std_logic is myMemRow(13);
	alias S				: std_logic is myMemRow(14);
	alias FB			: std_logic_vector(2 downto 0) is myMemRow(17 downto 15);
	alias TB			: std_logic_vector(2 downto 0) is myMemRow(20 downto 18);	
	alias aluInstruction		: std_logic_vector(3 downto 0) is myMemRow(24 downto 21);
	
	signal BUSS			: std_logic_vector(15 downto 0) := X"0000";
	
	signal PM_out 			: std_logic_vector(15 downto 0) := X"0000";
	
	signal PC_out 			: std_logic_vector(7 downto 0) := X"00";
	
	signal IR_out			: std_logic_vector(15 downto 0) := X"0000";
	alias OP 			: std_logic_vector(3 downto 0) is IR_out(15 downto 12);
	alias GRx 			: std_logic_vector(1 downto 0) is IR_out(11 downto 10);
	alias M				: std_logic_vector(1 downto 0) is IR_out(9 downto 8);
	alias Adr			: std_logic_vector(7 downto 0) is IR_out(7 downto 0);
	
	signal AR 			:std_logic_vector(15 downto 0) := X"0000";
	
	signal Z,N,C,V 			: std_logic;
	
	signal MUX_out			: std_logic_vector(15 downto 0) := X"0000";
  
BEGIN
	
  	-- Component Instantiation
  	my_pc_comp : myPC PORT MAP(
  		clk => clk,
  		rst => rst,
  		k1 => k1_out,
  		k2 => k2_out,
  		SEQ => SEQ,
  		myPC_out => my_pc
  	);
  	my_mem_comp : myMem PORT MAP(
  		myPC => my_pc,
  		myMem_out => myMemRow
  	);
  	
  	pm_comp : pm PORT MAP(
		clk => clk,
		rst => rst,
		TB => TB,
		FB => FB,
		BUSS => BUSS,
		PM_out => PM_out

  	);
  	
  	pc_comp : PC PORT MAP(
  		clk => clk,
  		rst => rst,
		P => P,
		buss_data => BUSS,
		FB => FB,
		PC_out => PC_out
  	);
  	
  	ir_comp : general_reg PORT MAP(
  		clk => clk,
  		rst => rst,
  		FB => FB,
  		BUSS => BUSS,
  		reg_out => IR_out
  	);
  	
  	alu_comp : ALU PORT MAP(
		clk => clk,
		rst => rst,
		aluInstruction => aluInstruction,		--Instruktion
		BUSS => BUSS, 	--data från buss
		Z => Z,
		N => N,
		C => C,
		V => V,				--Flaggor
		AR => AR  	-- Uträknad data
  	
  	);
  	
  	grx_mux_comp : MUX PORT MAP(
  		clk => clk,
  		rst => rst,
		GRx => GRx,
		FB => FB,
		BUSS => BUSS,
		MUX_out => MUX_out
  	);
  	
  	k1_comp : k1 PORT MAP(
  		clk=> clk,
  		rst => rst,
		OP => OP,
		k1_out => k1_out
  	);
  	
  	k2_comp : k2 PORT MAP(
  		clk=> clk,
  		rst => rst,
		M => M,
		k2_out => k2_out
  	);
  	
  	BUSS <= IR_out 							when TB = "001" else
		PM_OUT 							when TB = "010" else
  		std_logic_vector(resize(UNSIGNED(PC_out),BUSS'LENGTH)) 	when TB = "011" else
  		AR							when TB = "100" else
  		MUX_out							when TB = "110" else
  		X"0000";
  	
end Behavorial;
