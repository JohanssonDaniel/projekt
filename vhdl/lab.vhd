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
		   ca,cb,cc,cd,ce,cf,cg,dp, Hsync,Vsync : out  STD_LOGIC;
	       an : out  STD_LOGIC_VECTOR (3 downto 0));
end lab;

