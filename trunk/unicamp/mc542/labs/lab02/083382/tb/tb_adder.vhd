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

entity tb_adder is
end tb_adder;


architecture tb_behavior of tb_adder is
	
	component adder is
		generic (N: integer := 32);
		port (a, b: in STD_LOGIC_VECTOR(N-1 downto 0);
			  cin: in STD_LOGIC;
			  s: out STD_LOGIC_VECTOR(N-1 downto 0);
			  cout: out STD_LOGIC);
	end component;
	
	signal entradaA : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal entradaB : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal entradaC : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal carryIn : std_logic := '0';
	signal resultA : std_logic_vector(31 downto 0);
	signal resultB : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal carryOutA : std_logic;
	signal carryOutB : std_logic;
	
 Begin

  -- Bind das portas
  adder_0 : adder port map (entradaA, entradaB, carryIn, resultA, carryOutA);
  adder_1 : adder port map (resultA, entradaC, carryOutA, resultB, carryOutB);
  
  process 
	variable output_line : line;
  begin
	
	--wait for 10 ns;
	write(output_line, String'("------- [tb_adder] Executando suite de 4 testes ---------------------------------------"));
	writeline(output, output_line);
	
	----------------------------------------------------------------------------
	------------------------ TESTE 1 -------------------------------------------
	----------------------------------------------------------------------------

    -- Setando a massa de teste
    entradaA <= "00000000000000000000000000001010";
    entradaB <= "00000000000000000000000000000001";
	wait for 10 ns;
	
	Write(output_line, String'(" Test1 - Somando 10 + 1, "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", carryIn="));
	Write(output_line, carryIn);
	Write(output_line, String'(", resultaA="));
	Write(output_line, resultA);
	Write(output_line, String'(", carryOutA="));
	Write(output_line, carryOutA);
	writeline(output, output_line);
	assert resultA = "00000000000000000000000000001011" report "A soma nao foi realizada corretamente. Era esperado o resultado 11." severity failure;
	assert carryOutA= '0' report "A soma nao foi realizada corretamente. Era esperado o carryOutA = 0." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 2 -------------------------------------------
	----------------------------------------------------------------------------

	wait for 100 ns;
	
    -- Setando a massa de teste
    entradaA <= "11111111111111111111111111111111";
    entradaB <= "00000000000000000000000000000001";
	wait for 100 ns;
	
	Write(output_line, String'(" Test2 - Testando carry( 11111111111111111111111111111111 + 1). "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", carryIn="));
	Write(output_line, carryIn);
	Write(output_line, String'(", resultaA="));
	Write(output_line, resultA);
	Write(output_line, String'(", carryOutA="));
	Write(output_line, carryOutA);
	writeline(output, output_line);
	assert resultA = "00000000000000000000000000000000" report "A soma nao foi realizada corretamente. Era esperado o resultado 0." severity failure;
	assert carryOutA= '1' report "A soma nao foi realizada corretamente. Era esperado o carryOutA = 1." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 3 -------------------------------------------
	----------------------------------------------------------------------------

	wait for 100 ns;
	
    -- Setando a massa de teste
    entradaA <= "00000000000000000000000000101101";
    entradaB <= "00000000000000000000000001100100";
	wait for 100 ns;
	
	Write(output_line, String'(" Test3 - Somando 45 + 100, "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", carryIn="));
	Write(output_line, carryIn);
	Write(output_line, String'(", resultaA="));
	Write(output_line, resultA);
	Write(output_line, String'(", carryOutA="));
	Write(output_line, carryOutA);
	writeline(output, output_line);
	assert resultA = "00000000000000000000000010010001" report "A soma nao foi realizada corretamente. Era esperado o resultado 145." severity failure;
	assert carryOutA= '0' report "A soma nao foi realizada corretamente. Era esperado o carryOutA = 0." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 4 -------------------------------------------
	----------------------------------------------------------------------------

	wait for 100 ns;
	
    -- Setando a massa de teste
    entradaA <= "11111111111111111111111111111111";
    entradaB <= "00000000000000000000000000000001";
	entradaC <= "10000000000000000000000000000000";
	wait for 200 ns;
	wait for 200 ns;
	
	Write(output_line, String'(" Test4 - Testando carry( 11111111111111111111111111111111 + 1). "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", carryIn="));
	Write(output_line, carryIn);
	Write(output_line, String'(", resultaA="));
	Write(output_line, resultA);
	Write(output_line, String'(", resultaB="));
	Write(output_line, resultB);
	Write(output_line, String'(", carryOutA="));
	Write(output_line, carryOutA);
	Write(output_line, String'(", carryOutB="));
	Write(output_line, carryOutB);
	writeline(output, output_line);
	assert resultA = "00000000000000000000000000000000" report "A soma nao foi realizada corretamente. Era esperado o resultado 0 em resultA." severity failure;
	assert resultB = "10000000000000000000000000000001" report "A soma nao foi realizada corretamente. Era esperado o resultado '10000000000000000000000000000001' em resultB." severity failure;
	assert carryOutA= '1' report "A soma nao foi realizada corretamente. Era esperado o carryOutA = 1." severity failure;
	assert carryOutB= '0' report "A soma nao foi realizada corretamente. Era esperado o carryOutB = 0." severity failure;

	----------------------------------------------------------------------------
	------------------------ END OF TESTS --------------------------------------
	----------------------------------------------------------------------------	
	-- Finaliza a suite de testes
	assert false report "[tb_adder] End of tests. SUCESS execution." severity failure;
	wait;
		
  end process;
  
 end  tb_behavior; 

