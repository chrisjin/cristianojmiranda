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

entity tb_instrmem is
end tb_instrmem;


architecture tb_instrmem_behavior of tb_instrmem is
	
	-- Componente instruction memory
	component instrmem is
	 port(addr : in std_logic_vector(31 downto 0);
		  rd : out std_logic_vector(31 downto 0));
	end component;
	
	
	-- Sinais de testes
	signal addrA : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal resultado : std_logic_vector(31 downto 0);
	
 begin

  -- Bind das portas da ALU
  instrmem_0 : instrmem port map (addrA, resultado);
 
  process 
  
	variable output_line : line;
	
  begin

	--wait for 500 ns;
	
	write(output_line, String'("------- [tb_instrmem] Executando suite de 2 testes ---------------------------------------"));
	writeline(output, output_line);
	
	----------------------------------------------------------------------------
	------------------------ TESTE 1 -------------------------------------------
	----------------------------------------------------------------------------
	
	-- Setando endereço a ser lido
	addrA <= X"00400000";
	
	wait for 100 ns;
	
	Write(output_line, String'(" Test1 - Testando leitura de endereco "));
	Write(output_line, String'("addrA="));
	Write(output_line, addrA);
	Write(output_line, String'(", resultado="));
	Write(output_line, resultado);
	writeline(output, output_line);
	assert resultado = "10001110000010000000000000000000" report "FALHA, era esperado '10001110000010000000000000000000'." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 2 -------------------------------------------
	----------------------------------------------------------------------------
	
	-- Setando endereço a ser lido
	addrA <= X"00400004";
	
	wait for 100 ns;
	
	Write(output_line, String'(" Test2 - Testando leitura de endereco "));
	Write(output_line, String'("addrA="));
	Write(output_line, addrA);
	Write(output_line, String'(", resultado="));
	Write(output_line, resultado);
	writeline(output, output_line);
	assert resultado = "10101101000010010000000000000100" report "FALHA, era esperado '10101101000010010000000000000100'." severity failure;


	----------------------------------------------------------------------------
	------------------------ END OF TESTS --------------------------------------
	----------------------------------------------------------------------------	
	-- Finaliza a suite de testes
	assert false report "[tb_instrmem] End of tests. SUCESS execution." severity failure;
	wait;
		
  end process;
  
 end  tb_instrmem_behavior; 

