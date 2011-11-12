
library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.ALL;

-- Entidade adder
entity adder is
	generic (N: integer := 8);
	port (a, b: in STD_LOGIC_VECTOR(N-1 downto 0);
		  cin: in STD_LOGIC;
		  s: out STD_LOGIC_VECTOR(N-1 downto 0);
		  cout: out STD_LOGIC);
end;

-- Architecture synth of Adder
architecture arc1adder of adder is
begin
	process(a, b, cin)
		variable result: STD_LOGIC_VECTOR(N downto 0);
	begin
	
		result := ("0" & a) + ("0" & b) + cin;
		s <= result (N-1 downto 0);
		cout <= result (N);
		
	end process;
end arc1adder;