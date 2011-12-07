library std;
library ieee;

use std.textio.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;

-- mips 
entity mips is
	generic(nbits : positive := 32);
	port(instruction : in std_logic_vector(nbits -1 downto 0);
		data : in std_logic_vector(nbits -1 downto 0);
		clk : in std_logic;
		reset : in std_logic;
		pcf : out std_logic_vector(nbits -1 downto 0);
		aluoutm : out std_logic_vector(nbits -1 downto 0);
		writedatam : out std_logic_vector(nbits -1 downto 0);
		memwritem : out std_logic);
end mips;

architecture mips_behavior of mips is

	-- Datapath do processador
	component datapath is 
		port(clk, reset: in STD_LOGIC);
	end component;

begin

	-- Binda das entradas do mips
	datapath_0 : datapath port map (clk => clk, reset => reset);


end mips_behavior;