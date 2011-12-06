library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_ARITH.all;


-- flip-flop com reset sincrono
entity flop is 
	generic (width: integer := 32);
	port (clk: in STD_LOGIC;
		d: in STD_LOGIC_VECTOR(width-1 downto 0);
		q: out STD_LOGIC_VECTOR(width-1 downto 0));
end;


architecture flop_arc of flop is
begin
	process (clk, d) begin
	
		if clk'event and clk = '1' then
			q <= d;
		end if;
		
	end process;
end;