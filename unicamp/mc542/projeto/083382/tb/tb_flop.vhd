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

entity tb_flop is
end tb_flop;


architecture tb_flop_srt of tb_flop is
	
	-- Componente flop
	component flop is 
		generic (width: integer := 8);
		port (clk: in STD_LOGIC;
			d: in STD_LOGIC_VECTOR(width-1 downto 0);
			q: out STD_LOGIC_VECTOR(width-1 downto 0));
	end component;
	
	
	-- Sinais de testes
	signal clk : std_logic;
	signal d : STD_LOGIC_VECTOR(7 downto 0);
	signal q : STD_LOGIC_VECTOR(7 downto 0);
	
 begin

  -- Bind das portas do component
  flop_0 : flop port map(clk, d, q);
 
  process 
  
	variable output_line : line;
	
  begin	
	
	write(output_line, String'("------- [tb_flop] Executando suite de 2 testes ---------------------------------------"));
	writeline(output, output_line);
	
	----------------------------------------------------------------------------
	------------------------ TESTE 1 -------------------------------------------
	----------------------------------------------------------------------------
	
	clk <= '1';
	d <= "00000001";
	wait for 10 ns;
	
	Write(output_line, String'(" Test1 - Testando atribuicao de '00000001' no flip flop. "));
	Write(output_line, String'("clk="));
	Write(output_line, clk);
	Write(output_line, String'(", d="));
	Write(output_line, d);
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
	Write(output_line, String'(", d="));
	Write(output_line, d);
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
	Write(output_line, String'(", d="));
	Write(output_line, d);
	Write(output_line, String'(", q="));
	Write(output_line, q);
	writeline(output, output_line);
	assert q = "00000011" report "FALHA, era esperado '00000011'." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ END OF TESTS --------------------------------------
	----------------------------------------------------------------------------	
	-- Finaliza a suite de testes
	assert false report "[tb_instrfetch] End of tests. SUCESS execution." severity failure;
	wait;
		
  end process;
  
 end  tb_flop_srt; 

