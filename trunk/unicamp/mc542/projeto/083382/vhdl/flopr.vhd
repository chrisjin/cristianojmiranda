library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_ARITH.all;


-- flip-flop com reset sincrono
entity flopr is 
	generic (width: integer := 32);
	port (clk, reset: in STD_LOGIC;
		d: in STD_LOGIC_VECTOR(width-1 downto 0);
		q: out STD_LOGIC_VECTOR(width-1 downto 0));
end;


architecture flopr_arc of flopr is
begin
	process (clk, reset, d) begin
		if reset = '1' then 
			q <= CONV_STD_LOGIC_VECTOR(0, width);
		elsif clk'event and clk = '1' then
			q <= d;
		end if;
	end process;
end;