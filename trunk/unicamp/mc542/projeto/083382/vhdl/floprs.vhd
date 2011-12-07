library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_ARITH.all;


-- flip-flop com reset sincrono e entrada de reset
entity floprs is 
	generic (width: integer := 32);
	port (clk, reset: in STD_LOGIC;
		rstin : in STD_LOGIC_VECTOR(width-1 downto 0);
		d: in STD_LOGIC_VECTOR(width-1 downto 0);
		q: out STD_LOGIC_VECTOR(width-1 downto 0));
end;


architecture floprs_arc of floprs is
begin
	process (clk, reset, d) begin
		if reset = '1' then 
			q <= rstin;
		elsif clk'event and clk = '1' then
			q <= d;
		end if;
	end process;
end;