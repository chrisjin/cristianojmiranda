library IEEE; 
use IEEE.STD_LOGIC_1164.all;


-- Multiplexador com duas entradas
entity mux2 is
generic (width: integer:=32);
	port (d0, d1: in STD_LOGIC_VECTOR(width-1 downto 0);
		s: in STD_LOGIC;
		y: out STD_LOGIC_VECTOR(width-1 downto 0));
end;


architecture behave of mux2 is
begin
	process(d0, d1, s) begin
	
		if s = '0' then
			y <= d0;
		else
			y <= d1;
		end if;
		
	end process;
end;