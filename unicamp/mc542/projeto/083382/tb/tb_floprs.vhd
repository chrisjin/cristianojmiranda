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

entity tb_floprs is
end tb_floprs;


architecture tb_floprs_srt of tb_floprs is
	
	-- Componente flopr
	component floprs is 
		generic (width: integer := 8);
		port (clk, reset: in STD_LOGIC;
			rstin : in STD_LOGIC_VECTOR(width-1 downto 0);
			d: in STD_LOGIC_VECTOR(width-1 downto 0);
			q: out STD_LOGIC_VECTOR(width-1 downto 0));
	end component;
	
	-- Sinais de testes
	signal clk : std_logic;
	signal reset : std_logic;
	signal rstin : STD_LOGIC_VECTOR(7 downto 0);
	signal d : STD_LOGIC_VECTOR(7 downto 0);
	signal q : STD_LOGIC_VECTOR(7 downto 0);
	
 begin

  -- Bind das portas do component
  floprs_0 : floprs port map(clk, reset, rstin, d, q);
 
  process 
  
	variable output_line : line;
	
  begin	
	
	write(output_line, String'("------- [tb_flopr] Executando suite de 5 testes ---------------------------------------"));
	writeline(output, output_line);
	
	----------------------------------------------------------------------------
	------------------------ TESTE 1 -------------------------------------------
	----------------------------------------------------------------------------
	
	clk <= '1';
	reset <= '0';
	d <= "00000001";
	rstin <= "00001000";
	wait for 10 ns;
	
	Write(output_line, String'(" Test1 - Testando atribuicao de '00000001' no flip flop. "));
	Write(output_line, String'("clk="));
	Write(output_line, clk);
	Write(output_line, String'("reset="));
	Write(output_line, reset);
	Write(output_line, String'(", d="));
	Write(output_line, d);
	Write(output_line, String'(", rstin="));
	Write(output_line, rstin);
	Write(output_line, String'(", q="));
	Write(output_line, q);
	writeline(output, output_line);
	assert q = "00000001" report "FALHA, era esperado '00000001'." severity failure;
	
	-- Lock flop
	clk <= '0';
	wait for 2 ns;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 2 -------------------------------------------
	----------------------------------------------------------------------------
	d <= "00000011";
	wait for 10 ns;
	
	Write(output_line, String'(" Test2 - Testando atribuicao de '00000011' na entrada do flip flop sem que ele seja liberado o valor anterior deve ser mantido. "));
	Write(output_line, String'("clk="));
	Write(output_line, clk);
	Write(output_line, String'("reset="));
	Write(output_line, reset);
	Write(output_line, String'(", d="));
	Write(output_line, d);
	Write(output_line, String'(", rstin="));
	Write(output_line, rstin);
	Write(output_line, String'(", q="));
	Write(output_line, q);
	writeline(output, output_line);
	assert q = "00000001" report "FALHA, era esperado '00000001'." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 3 -------------------------------------------
	----------------------------------------------------------------------------
	
	clk <= '1';
	wait for 10 ns;
	
	Write(output_line, String'(" Test3 - Testando atribuicao de '00000011' da entrada do flip flop liberando o clock. O valor deve ser alterado. "));
	Write(output_line, String'("clk="));
	Write(output_line, clk);
	Write(output_line, String'("reset="));
	Write(output_line, reset);
	Write(output_line, String'(", d="));
	Write(output_line, d);
	Write(output_line, String'(", rstin="));
	Write(output_line, rstin);
	Write(output_line, String'(", q="));
	Write(output_line, q);
	writeline(output, output_line);
	assert q = "00000011" report "FALHA, era esperado '00000011'." severity failure;
	
	
	----------------------------------------------------------------------------
	------------------------ TESTE 4 -------------------------------------------
	----------------------------------------------------------------------------
	
	clk <= '0';
	reset <= '1';
	wait for 10 ns;
	
	Write(output_line, String'(" Test4 - Testando reset.. "));
	Write(output_line, String'("clk="));
	Write(output_line, clk);
	Write(output_line, String'("reset="));
	Write(output_line, reset);
	Write(output_line, String'(", d="));
	Write(output_line, d);
	Write(output_line, String'(", rstin="));
	Write(output_line, rstin);
	Write(output_line, String'(", q="));
	Write(output_line, q);
	writeline(output, output_line);
	assert q = "00001000" report "FALHA, era esperado '00001000'." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 5 -------------------------------------------
	----------------------------------------------------------------------------
	
	clk <= '1';
	reset <= '0';
	wait for 10 ns;
	
	Write(output_line, String'(" Test5 - Testando bloqueando reset, habilitando o clock. "));
	Write(output_line, String'("clk="));
	Write(output_line, clk);
	Write(output_line, String'("reset="));
	Write(output_line, reset);
	Write(output_line, String'(", d="));
	Write(output_line, d);
	Write(output_line, String'(", rstin="));
	Write(output_line, rstin);
	Write(output_line, String'(", q="));
	Write(output_line, q);
	writeline(output, output_line);
	assert q = "00000011" report "FALHA, era esperado '00000011'." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ END OF TESTS --------------------------------------
	----------------------------------------------------------------------------	
	-- Finaliza a suite de testes
	assert false report "[tb_flopr] End of tests. SUCESS execution." severity failure;
	wait;
		
  end process;
  
 end  tb_floprs_srt; 

