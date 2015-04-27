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
		   AN : out  STD_LOGIC_VECTOR (3 downto 0);
  		   SEG : out STD_LOGIC_VECTOR (7 downto 0);
  		   LED : out STD_LOGIC_VECTOR (2 downto 0);
 		   MISO, MISO2 : in  std_logic;        -- Master In Slave Out, JA3
 		   SW          : in  std_logic_vector (2 downto 0);  -- Switches 2, 1, and 0
 		   SS, SS2     : out std_logic;        -- Slave Select, Pin 1, Port JA
		   MOSI, MOSI2 : out std_logic;        -- Master Out Slave In, Pin 2, Port JA
		   SCLK, SCLK2 : out std_logic         -- Serial Clock, Pin 4, Port JA
);
end lab;

architecture Behavioral of lab is
component PmodJSTK_Demo
    port (CLK      : in  std_logic;     -- 100Mhz onboard clock
          RST      : in  std_logic;     -- Button D
          MISO     : in  std_logic;     -- Master In Slave Out, JA3
          SW       : in  std_logic_vector (2 downto 0);  -- Switches 2, 1, and 0
          SS       : out std_logic;     -- Slave Select, Pin 1, Port JA
          MOSI     : out std_logic;     -- Master Out Slave In, Pin 2, Port JA
          SCLK     : out std_logic;     -- Serial Clock, Pin 4, Port JA
          LED      : out std_logic_vector (2 downto 0);  -- LEDs 2, 1, and 0
          posDataX : out std_logic_vector(9 downto 0);
          posDataY : out std_logic_vector(9 downto 0));
	  SEG : out STD_LOGIC_VECTOR (7 downto 0);	
  end component;



	component leddriver
    Port ( clk,rst : in  STD_LOGIC; 
           --seg : out STD_LOGIC_VECTOR (7 downto 0);
	--ca,cb,cc,cd,ce,cf,cg,dp: out  STD_LOGIC;
           an : out  STD_LOGIC_VECTOR (3 downto 0);
           ledvalue : in  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	signal joyReg : std_logic_vector (15 downto 0);
begin
	jstk : PmodJSTK_Demo port map (
    CLK      => clk,
    RST      => rst,
    MISO     => MISO,
    SW       => SW,
    SS       => SS,
    MOSI     => MOSI,
    SCLK     => SCLK,
    posDataX => posDataX,
    posDataY => posDataY,
    LED      => LED);

  jstk2 : PmodJSTK_Demo port map (
    CLK      => clk,
    RST      => rst,
    MISO     => MISO2,
    SW       => SW,
    SS       => SS2,
    MOSI     => MOSI2,
    SCLK     => SCLK2,
    posDataX => posDataX2,
    posDataY => posDataY2,
    LED      => LED2);
end Behavioral;
				
