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

entity tb_alu is
end tb_alu;


architecture tb_alu_behavior of tb_alu is
 
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
	------------------------ END OF TESTS --------------------------------------
	----------------------------------------------------------------------------	
	-- Finaliza a suite de testes
	assert false report "End o tests." severity failure;
	wait;
		
  end process;
  
 end  tb_alu_behavior; 

