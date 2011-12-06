----------------------------------------------
--
--
-- TestBench - ALU (Arithmetic Logic Unit)
-- Autor: Cristiano J. Miranda (ra: 083382)
--
----------------------------------------------
library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;

entity tb_instrfetch is
end tb_instrfetch;


architecture tb_instrfetch_behavior of tb_instrfetch is
	
	-- Componente instruction fetch	
	component instrfetch is 
		generic(nbits : positive := 32);
		port(clk, reset: in STD_LOGIC;
			pcsrcm: in STD_LOGIC;
			pcbranchm: in STD_LOGIC_vector(nbits-1 downto 0);
			intrd: out std_logic_vector(nbits -1 downto 0);
			pcplus4d: out std_logic_vector(nbits -1 downto 0));
	end component;
	
	
	-- Sinais de testes
	signal clk : STD_LOGIC := '0';
	signal reset: STD_LOGIC := '1';
	signal pcsrcm: STD_LOGIC := '0';
	signal pcbranchm: STD_LOGIC_vector(31 downto 0);
	signal intrd: std_logic_vector(31 downto 0);
	signal pcplus4d: std_logic_vector(31 downto 0);
	
	
 begin

  -- Bind das portas do component
  intrfetch : instrfetch port map (clk, reset, pcsrcm, pcbranchm, intrd, pcplus4d);
 
  process 
  
	variable output_line : line;
	
  begin	
	
	write(output_line, String'("------- [tb_instrfetch] Executando suite de * testes ---------------------------------------"));
	writeline(output, output_line);
	
	wait for 10 ns;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 1 -------------------------------------------
	----------------------------------------------------------------------------
	
	-- Resetando instruction fetch
	clk <= '1';
	reset <= '1';
	pcsrcm <= '0';
	
	wait for 10 ns;
	
	Write(output_line, String'(" Test1 - Testando instruction fetch reset. "));
	Write(output_line, String'("reset="));
	Write(output_line, reset);
	Write(output_line, String'(", instrd="));
	Write(output_line, intrd);
	Write(output_line, String'(", pcplus4d="));
	Write(output_line, pcplus4d);
	writeline(output, output_line);
	assert intrd = "10001110000010000000000000000000" report "FALHA, era esperado '10001110000010000000000000000000'." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 2 -------------------------------------------
	----------------------------------------------------------------------------
	
	--wait for 10 ns;
	
	-- Incrementando o proximo contador
	
	--clk <= '0' after 50 ns, '1' after 100 ns;
	--clk <= '0' after 50 ns, '1' after 90 ns;
	--clk <= '0';
	reset <= '0';
	pcsrcm <= '0';
	--clk <= '1';
	
	wait for 500 ns;
	
	Write(output_line, String'(" Test2 - Testando pc update. "));
	Write(output_line, String'("reset="));
	Write(output_line, reset);
	Write(output_line, String'(", instrd="));
	Write(output_line, intrd);
	Write(output_line, String'(", pcplus4d="));
	Write(output_line, pcplus4d);
	writeline(output, output_line);
	assert intrd = "10101101000010010000000000000100" report "FALHA, era esperado '10101101000010010000000000000100'." severity failure;


	----------------------------------------------------------------------------
	------------------------ END OF TESTS --------------------------------------
	----------------------------------------------------------------------------	
	-- Finaliza a suite de testes
	assert false report "[tb_instrfetch] End of tests. SUCESS execution." severity failure;
	wait;
		
  end process;
  
 end  tb_instrfetch_behavior; 

