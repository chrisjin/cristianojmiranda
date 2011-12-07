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

entity tb_adder is
end tb_adder;


architecture tb_adder_srt of tb_adder is
	
	-- Componente adder
	component adder is
		port (a, b: in STD_LOGIC_VECTOR(31 downto 0);
			y: out STD_LOGIC_VECTOR(31 downto 0));
	end component;
	
	
	-- Sinais de testes
	signal entradaA: STD_LOGIC_vector(31 downto 0);
	signal entradaB: std_logic_vector(31 downto 0);
	signal saida: std_logic_vector(31 downto 0);
	
	
 begin

  -- Bind das portas do component
  adder_0 : adder port map (entradaA, entradaB, saida);
 
  process 
  
	variable output_line : line;
	
  begin	
	
	write(output_line, String'("------- [tb_adder] Executando suite de 2 testes ---------------------------------------"));
	writeline(output, output_line);
	
	----------------------------------------------------------------------------
	------------------------ TESTE 1 -------------------------------------------
	----------------------------------------------------------------------------
	
	entradaA <= "00000000000000000000000000001010";
	entradaB <= "00000000000000000000000000000010";
	wait for 10 ns;
	
	Write(output_line, String'(" Test1 - Testando soma de 10 + 2. "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", saida="));
	Write(output_line, saida);
	writeline(output, output_line);
	assert saida = "00000000000000000000000000001100" report "FALHA, era esperado '00000000000000000000000000001100'." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 2 -------------------------------------------
	----------------------------------------------------------------------------
	
	entradaA <= "10000000000000000000000000001010";
	entradaB <= "00000000000000000000000000000010";
	wait for 10 ns;
	
	Write(output_line, String'(" Test2 - Testando soma de 10000000000000000000000000001010 + 00000000000000000000000000000010. "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", saida="));
	Write(output_line, saida);
	writeline(output, output_line);
	assert saida = "10000000000000000000000000001100" report "FALHA, era esperado '10000000000000000000000000001100'." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ END OF TESTS --------------------------------------
	----------------------------------------------------------------------------	
	-- Finaliza a suite de testes
	assert false report "[tb_instrfetch] End of tests. SUCESS execution." severity failure;
	wait;
		
  end process;
  
 end  tb_adder_srt; 

