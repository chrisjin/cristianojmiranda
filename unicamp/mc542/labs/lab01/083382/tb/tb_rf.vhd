----------------------------------------------
--
--
-- TestBench - RF (Register File)
-- Autor: Cristiano J. Miranda (ra: 083382)
--
----------------------------------------------
library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;

entity tb_rf is
end tb_rf;


architecture tb_behavior of tb_rf is
 
	component rf is
      port(A1 : in std_logic_vector(4 downto 0);
		   A2 : in std_logic_vector(4 downto 0);
		   A3 : in std_logic_vector(4 downto 0);
		   WD3 : in std_logic_vector(31 downto 0);
		   clk : in std_logic;
		   We3 : in std_logic;
		   RD1 : out std_logic_vector(31 downto 0);
		   RD2 : out std_logic_vector(31 downto 0));
	End Component;
	
	signal a1 : std_logic_vector(4 downto 0) := "00000";
	signal a2 : std_logic_vector(4 downto 0) := "00000";
	signal a3 : std_logic_vector(4 downto 0) := "00000";
	signal wd3 : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal clk : std_logic := '1';
	signal we3 : std_logic := '0';
	signal rd1 : std_logic_vector(31 downto 0);
    signal rd2 : std_logic_vector(31 downto 0);

    signal erro : boolean := false;         -- para terminar a simulacao
	
 Begin

  -- Bind das portas

  rf_0 : rf port map (a1, a2, a3, wd3, clk , we3, rd1, rd2);
 
  clk <= not clk after 10 ns;               -- gera o sinall de clock

  
  process 
  variable output_line : line;
  begin

	--wait for 500 ns;
	
	write(output_line, String'("------- Executando suite de 10 testes ---------------------------------------"));
	writeline(output, output_line);
	
	----------------------------------------------------------------------------
	------------------------ TESTE 1 -------------------------------------------
	----------------------------------------------------------------------------

   -- Escrevendo um valor no registrador 00100
	a3 <= "00100";
	wd3 <= "00000000000000000000000000001010";
	we3 <= '1';
	wait for 100 ns;
	
	-- Desabilitando escrita
	we3 <= '0' after 10 ns;
	
	-- Lendo o valor escrito em 00100
	a1 <= a3;
	a2 <= "00000" after 10 ns;
	wait for 200 ns;
	
	Write(output_line, String'(" Test1 - Escrevendo no registrador 00100. "));
	Write(output_line, String'("A1="));
	Write(output_line, a1);
	Write(output_line, String'(", WD3="));
	Write(output_line, wd3);
	Write(output_line, String'(", RD1="));
	Write(output_line, rd1);
	writeline(output, output_line);
	assert rd1 = wd3 report "Nao gravou o registro corretamente" severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 2 -------------------------------------------
	----------------------------------------------------------------------------
	
	-- Escrevendo um valor no registrador 00101
	a3 <= "00101" after 1 ns;
	wd3 <= "00000000000000000000000000001011" after 1 ns;
	we3 <= '1' after 1 ns;
	wait for 100 ns;
		
	-- Lendo o valor escrito em 00100
	a1 <= a3;
	wait for 100 ns;
	
	-- Desabilita escrita
	we3 <= '0' after 100 ns;
	
	Write(output_line, String'(" Test2 - Escrevendo no registrador 00101. "));
	Write(output_line, String'("A1="));
	Write(output_line, a1);
	Write(output_line, String'(", WD3="));
	Write(output_line, wd3);
	Write(output_line, String'(", RD1="));
	Write(output_line, rd1);
	writeline(output, output_line);
	assert rd1 = wd3 report "Nao gravou o registro corretamente" severity failure;
	wait for 10 ns;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 3 -------------------------------------------
	----------------------------------------------------------------------------
	
	a2 <= "00100" after 1 ns;
	wait for 100 ns;
	
	Write(output_line, String'(" Test3 - Verificando se o valor do registrador 00100 foi mantido. "));
	Write(output_line, String'("A2="));
	Write(output_line, a2);
	Write(output_line, String'(" RD2="));
	Write(output_line, rd2);
	Write(output_line, String'(", RD1="));
	Write(output_line, rd1);
	writeline(output, output_line);
	assert rd2 = "00000000000000000000000000001010" report "Valor do registrador 00100 não foi mantido." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 4 -------------------------------------------
	----------------------------------------------------------------------------
	
	-- Escrevendo um valor no registrador 00111
	a3 <= "00111" after 1 ns;
	wd3 <= "00000001110000000000000000001011";
	we3 <= '1' after 10 ns;
	wait for 100 ns;
		
	-- Lendo o valor escrito em 00111
	a1 <= a3 after 10 ns;
	
	-- Desabilita escrita
	we3 <= '0' after 10 ns;
	wait for 100 ns;
	wait for 100 ns;
	
	Write(output_line, String'(" Test4 - Escrevendo no registrador 00111. "));
	Write(output_line, String'("A1="));
	Write(output_line, a1);
	Write(output_line, String'(", WD3="));
	Write(output_line, wd3);
	Write(output_line, String'(", RD1="));
	Write(output_line, rd1);
	writeline(output, output_line);
	assert rd1 = wd3 report "Nao gravou o registro corretamente" severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 5 -------------------------------------------
	----------------------------------------------------------------------------
	
	-- Lendo o valor escrito em 00100
	a1 <= "00100" after 1 ns;
	a2 <= "00100" after 1 ns;
	wait for 100 ns;
	wait for 100 ns;
	
	Write(output_line, String'(" Test5 - Verificando se o valor do registrador 00100 foi mantido. "));
	Write(output_line, String'("A2="));
	Write(output_line, a2);
	Write(output_line, String'(", RD2="));
	Write(output_line, rd2);
	writeline(output, output_line);
	assert rd2 = "00000000000000000000000000001010" report "Valor do registrador 00100 não foi mantido." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 6 -------------------------------------------
	----------------------------------------------------------------------------
	
	-- Limpando o valor do registrador 00100
	a3 <= "00100";
	wd3 <= "00000000000000000000000000000000";
	we3 <= '1';
	wait for 100 ns;
		
	-- Lendo o valor escrito em 00111
	a1 <= a3;
	a2 <= a3 after 10 ns;

	--wait for 100 ns;
	
	-- Desabilita escrita
	we3 <= '0' after 10 ns;
	
	Write(output_line, String'(" Test6 - Verificando se o valor do registrador 00100 foi realmente limpo. "));
	Write(output_line, String'(" A2="));
	Write(output_line, a2);
	Write(output_line, String'(", RD2="));
	Write(output_line, rd2);
	writeline(output, output_line);
	assert rd2 = "00000000000000000000000000000000" report "Valor do registrador 00100 não foi limpo." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 7 -------------------------------------------
	----------------------------------------------------------------------------
	
	a1 <= "00000" after 1 ns;
	wait for 100 ns;
	
	Write(output_line, String'(" Test7 - Verificando se o valor do registrador 00000 esta zerado. "));
	Write(output_line, String'(" A1="));
	Write(output_line, a1);
	Write(output_line, String'(", RD1="));
	Write(output_line, rd1);
	writeline(output, output_line);
	assert rd1 = "00000000000000000000000000000000" report "Valor do registrador 00100 não foi limpo." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 8 -------------------------------------------
	----------------------------------------------------------------------------
	
	-- Escrevendo um valor no registrador 00001
	a3 <= "00001" after 1 ns;
	wd3 <= "11001100000000000000000000110011";
	we3 <= '1' after 10 ns;
	wait for 100 ns;
		
	-- Lendo o valor escrito em 00111
	a2 <= a3 after 10 ns;
	
	-- Desabilita escrita
	we3 <= '0' after 10 ns;
	wait for 100 ns;
	wait for 100 ns;
	
	Write(output_line, String'(" Test8 - Escrevendo no registrador 00001. "));
	Write(output_line, String'("A2="));
	Write(output_line, a2);
	Write(output_line, String'(", WD3="));
	Write(output_line, wd3);
	Write(output_line, String'(", RD2="));
	Write(output_line, rd2);
	writeline(output, output_line);
	assert rd2 = wd3 report "Nao gravou o registro corretamente" severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 9 -------------------------------------------
	----------------------------------------------------------------------------
	
	wait for 100 ns;
	
	-- Seta o valor do registrador 00000
	a3 <= "00000";
	wd3 <= "00000000000000000000000000111100";
	we3 <= '1';
	wait for 100 ns;
		
	-- Lendo o valor escrito em 00000
	a1 <= a3;
	a2 <= a3;
	wait for 100 ns;
	
	-- Desabilita escrita
	we3 <= '0' after 10 ns;
	
	Write(output_line, String'(" Test9 - Verificando se o valor do registrador 00000 foi alterado. "));
	Write(output_line, String'(" A2="));
	Write(output_line, a2);
	Write(output_line, String'(", RD2="));
	Write(output_line, rd2);
	writeline(output, output_line);
	assert rd2 = "00000000000000000000000000000000" report "Valor do registrador 00000 não deveria ter sido alterado." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 10 -------------------------------------------
	----------------------------------------------------------------------------
	
	--wait for 100 ns;
	
	-- Seta o valor do registrador 11111
	a3 <= "11111";
	wd3 <= "11111111111111111111111111111111";
	we3 <= '1';
	wait for 100 ns;
		
	-- Lendo o valor escrito em 00000
	a1 <= "10000";
	a2 <= a3;
	wait for 100 ns;
	
	-- Desabilita escrita
	we3 <= '0' after 10 ns;
	
	-- Seta o valor do registrador 11111
	a3 <= "10000";
	wd3 <= "10000000000000000000000000000001";
	we3 <= '1';
	wait for 100 ns;
	
	-- Desabilita escrita
	we3 <= '0' after 10 ns;
	
	Write(output_line, String'(" Test10 - Verificando se o valor do registrador 11111 foi setado para 11111111111111111111111111111111. "));
	Write(output_line, String'(" A1="));
	Write(output_line, a1);
	Write(output_line, String'(", A2="));
	Write(output_line, a2);
	Write(output_line, String'(", RD1="));
	Write(output_line, rd1);
	Write(output_line, String'(", RD2="));
	Write(output_line, rd2);
	Write(output_line, String'(", WD3="));
	Write(output_line, wd3);
	writeline(output, output_line);
	
	assert rd1 = "10000000000000000000000000000001" report "Valor do registrador 11111 não foi atualizado." severity failure;
	assert rd2 = "11111111111111111111111111111111" report "Valor do registrador 10000 não foi atualizado." severity failure;

	----------------------------------------------------------------------------
	------------------------ END OF TESTS --------------------------------------
	----------------------------------------------------------------------------	
	-- Finaliza a suite de testes
	assert false report "End o tests." severity failure;
	wait;
		
  end process;
  
 end  tb_behavior; 

