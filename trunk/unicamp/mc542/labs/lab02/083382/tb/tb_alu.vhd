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

entity tb_alu is
end tb_alu;


architecture tb_alu_behavior of tb_alu is
 
    -- Componente ALU
	component alu is
		generic(w : natural := 32; cw: natural := 3);
		port(srca : in std_logic_vector(w-1 downto 0);
			 srcb : in std_logic_vector(w-1 downto 0);
			 alucontrol : in std_logic_vector(cw-1 downto 0);
			 aluresult : out std_logic_vector(w-1 downto 0);
			 zero : out std_logic;
			 overflow : out std_logic;
			 carryout : out std_logic);
	end component;
	
	-- Sinais de testes
	signal entradaA : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal entradaB : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal resultado : std_logic_vector(31 downto 0);
	signal controle : std_logic_vector(2 downto 0) := "000";
	signal isZero : std_logic;
	signal isOverflow : std_logic;
	signal carry : std_logic;
	
 begin

  -- Bind das portas da ALU
  alu_0 : alu port map (entradaA, entradaB, controle, resultado, isZero, isOverflow, carry);
 
  process 
  
	variable output_line : line;
	
  begin

	--wait for 500 ns;
	
	write(output_line, String'("------- [tb_alu] Executando suite de * testes ---------------------------------------"));
	writeline(output, output_line);
	
	----------------------------------------------------------------------------
	------------------------ TESTE 1 -------------------------------------------
	----------------------------------------------------------------------------
	
	wait for 10 ns;
	
    
	entradaA <= "00000000000000000000000000010101";
	entradaB <= "00000000000000000000000000011100";
	
	-- Setando operacao A and B
	controle <= "000";
	
	wait for 100 ns;
	
	Write(output_line, String'(" Test1 - Testando A and B. "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", controle="));
	Write(output_line, controle);
	Write(output_line, String'(", resultado="));
	Write(output_line, resultado);
	writeline(output, output_line);
	assert resultado = "00000000000000000000000000010100" report "FALHA, era esperado '00000000000000000000000000010100'." severity failure;
	assert isZero = '0' report "FALHA, era esperado zero = '0'." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 2 -------------------------------------------
	----------------------------------------------------------------------------
	
    
	entradaA <= "00000000000000000000000000010101";
	entradaB <= "00000000000000000000000000000000";
	
	-- Setando operacao A and B
	controle <= "000";
	
	wait for 100 ns;
	
	Write(output_line, String'(" Test2 - Testando A and B. "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", controle="));
	Write(output_line, controle);
	Write(output_line, String'(", resultado="));
	Write(output_line, resultado);
	writeline(output, output_line);
	assert resultado = "00000000000000000000000000000000" report "FALHA, era esperado '00000000000000000000000000000000'." severity failure;
	assert isZero = '1' report "FALHA, era esperado zero = '1'." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 3 -------------------------------------------
	----------------------------------------------------------------------------
	
    
	entradaA <= "11111111111111111111111111111111";
	entradaB <= "00000000000000000000000000000000";
	
	-- Setando operacao A and B
	controle <= "000";
	
	wait for 100 ns;
	
	Write(output_line, String'(" Test3 - Testando A and B. "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", controle="));
	Write(output_line, controle);
	Write(output_line, String'(", resultado="));
	Write(output_line, resultado);
	writeline(output, output_line);
	assert resultado = "00000000000000000000000000000000" report "FALHA, era esperado '00000000000000000000000000000000'." severity failure;
	assert isZero = '1' report "FALHA, era esperado zero = '1'." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 4 -------------------------------------------
	----------------------------------------------------------------------------
	
    
	entradaA <= "11111111111111111111111111111111";
	entradaB <= "11111111111111111111111111111111";
	
	-- Setando operacao A and B
	controle <= "000";
	
	wait for 100 ns;
	
	Write(output_line, String'(" Test4 - Testando A and B. "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", controle="));
	Write(output_line, controle);
	Write(output_line, String'(", resultado="));
	Write(output_line, resultado);
	writeline(output, output_line);
	assert resultado = "11111111111111111111111111111111" report "FALHA, era esperado '11111111111111111111111111111111'." severity failure;
	assert isZero = '0' report "FALHA, era esperado zero = '0'." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 5 -------------------------------------------
	----------------------------------------------------------------------------
	
	wait for 100 ns;
	
    
	entradaA <= "00000000000000000000000000010101";
	entradaB <= "00000000000000000000000000011100";
	
	-- Setando operacao A or B
	controle <= "001";
	
	wait for 100 ns;
	
	Write(output_line, String'(" Test5 - Testando A or B. "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", controle="));
	Write(output_line, controle);
	Write(output_line, String'(", resultado="));
	Write(output_line, resultado);
	writeline(output, output_line);
	assert resultado = "00000000000000000000000000011101" report "FALHA, era esperado '00000000000000000000000000011101'." severity failure;
	assert isZero = '0' report "FALHA, era esperado zero = '0'." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 6 -------------------------------------------
	----------------------------------------------------------------------------
	
	wait for 10 ns;
	
    
	entradaA <= "00000000000000000000000000010101";
	entradaB <= "00000000000000000000000000000000";
	
	-- Setando operacao A or B
	controle <= "001";
	
	wait for 100 ns;
	
	Write(output_line, String'(" Test6 - Testando A or B. "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", controle="));
	Write(output_line, controle);
	Write(output_line, String'(", resultado="));
	Write(output_line, resultado);
	writeline(output, output_line);
	assert resultado = "00000000000000000000000000010101" report "FALHA, era esperado '00000000000000000000000000010101'." severity failure;
	assert isZero = '0' report "FALHA, era esperado zero = '0'." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 7 -------------------------------------------
	----------------------------------------------------------------------------
	
	wait for 10 ns;
	
    
	entradaA <= "11111111111111111111111111111111";
	entradaB <= "00000000000000000000000000000000";
	
	-- Setando operacao A or B
	controle <= "001";
	
	wait for 100 ns;
	
	Write(output_line, String'(" Test7 - Testando A or B. "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", controle="));
	Write(output_line, controle);
	Write(output_line, String'(", resultado="));
	Write(output_line, resultado);
	writeline(output, output_line);
	assert resultado = "11111111111111111111111111111111" report "FALHA, era esperado '11111111111111111111111111111111'." severity failure;
	assert isZero = '0' report "FALHA, era esperado zero = '0'." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 8 -------------------------------------------
	----------------------------------------------------------------------------
	
	wait for 10 ns;
	
    
	entradaA <= "11111111111111111111111111111111";
	entradaB <= "11111111111111111111111111111111";
	
	-- Setando operacao A or B
	controle <= "001";
	
	wait for 100 ns;
	
	Write(output_line, String'(" Test8 - Testando A or B. "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", controle="));
	Write(output_line, controle);
	Write(output_line, String'(", resultado="));
	Write(output_line, resultado);
	writeline(output, output_line);
	assert resultado = "11111111111111111111111111111111" report "FALHA, era esperado '11111111111111111111111111111111'." severity failure;
	assert isZero = '0' report "FALHA, era esperado zero = '0'." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 9 -------------------------------------------
	----------------------------------------------------------------------------
	
	-- Setando 320
	entradaA <= "00000000000000000000000101000000";
	
	-- Setando 80
	entradaB <= "00000000000000000000000001010000";
	
	-- Setando operacao A + B
	controle <= "010";
	
	wait for 100 ns;
	
	Write(output_line, String'(" Test9 - Testando A + B. "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", controle="));
	Write(output_line, controle);
	Write(output_line, String'(", resultado="));
	Write(output_line, resultado);
	Write(output_line, String'(", carry="));
	Write(output_line, carry);
	Write(output_line, String'(", isOverflow="));
	Write(output_line, isOverflow);
	writeline(output, output_line);
	assert resultado = "00000000000000000000000110010000" report "FALHA, era esperado '00000000000000000000000110010000' = D400." severity failure;
	assert isZero = '0' report "FALHA, era esperado zero = '0'." severity failure;
	assert carry = '0' report "FALHA, não deveria ter ocorrido carry." severity failure;
	assert isOverflow = '0' report "FALHA, nao deveria ter ocorrido overflow." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 10 -------------------------------------------
	----------------------------------------------------------------------------
	
	entradaA <= "11111111111111111111111111111111";
	entradaB <= "00000000000000000000000000000001";
	
	-- Setando operacao A + B
	controle <= "010";
	
	wait for 100 ns;
	
	Write(output_line, String'(" Test10 - Testando A + B. "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", controle="));
	Write(output_line, controle);
	Write(output_line, String'(", resultado="));
	Write(output_line, resultado);
	Write(output_line, String'(", carry="));
	Write(output_line, carry);
	Write(output_line, String'(", isZero="));
	Write(output_line, isZero);
	Write(output_line, String'(", isOverflow="));
	Write(output_line, isOverflow);
	writeline(output, output_line);
	assert resultado = "00000000000000000000000000000000" report "FALHA, era esperado '00000000000000000000000000000000'." severity failure;
	assert isZero = '1' report "FALHA, era esperado zero = '1'." severity failure;
	assert carry = '1' report "FALHA, deveria ter ocorrido carry." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 11 -------------------------------------------
	----------------------------------------------------------------------------

	-- Simulando overflow
	entradaA <= "11111111111111111111111111111111";
	entradaB <= "11110000000000000000000000000001";
	
	-- Setando operacao A + B
	controle <= "010";
	
	wait for 100 ns;
	
	Write(output_line, String'(" Test11 - Testando overflow A + B. "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", controle="));
	Write(output_line, controle);
	Write(output_line, String'(", resultado="));
	Write(output_line, resultado);
	Write(output_line, String'(", carry="));
	Write(output_line, carry);
	Write(output_line, String'(", isZero="));
	Write(output_line, isZero);
	Write(output_line, String'(", isOverflow="));
	Write(output_line, isOverflow);
	writeline(output, output_line);
	assert resultado = "11110000000000000000000000000000" report "FALHA, era esperado '11110000000000000000000000000000'." severity failure;
	assert isZero = '0' report "FALHA, era esperado zero = '0'." severity failure;
	assert carry = '1' report "FALHA, deveria ter ocorrido carry." severity failure;
	assert isOverflow = '1' report "FALHA, deveria ter ocorrido overflow." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 12 -------------------------------------------
	----------------------------------------------------------------------------

	-- Simulando overflow
	entradaA <= "11111111111111111111111110000000";
	entradaB <= "00000000000000000000011111111111";
	
	-- Setando operacao A + B
	controle <= "010";
	
	wait for 100 ns;
	
	Write(output_line, String'(" Test12 - Testando overflow A + B. "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", controle="));
	Write(output_line, controle);
	Write(output_line, String'(", resultado="));
	Write(output_line, resultado);
	Write(output_line, String'(", carry="));
	Write(output_line, carry);
	Write(output_line, String'(", isZero="));
	Write(output_line, isZero);
	Write(output_line, String'(", isOverflow="));
	Write(output_line, isOverflow);
	writeline(output, output_line);
	assert resultado = "00000000000000000000011101111111" report "FALHA, era esperado '00000000000000000000011101111111'." severity failure;
	assert isZero = '0' report "FALHA, era esperado zero = '0'." severity failure;
	assert carry = '1' report "FALHA, deveria ter ocorrido carry." severity failure;
	assert isOverflow = '1' report "FALHA, deveria ter ocorrido overflow." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 13 -------------------------------------------
	----------------------------------------------------------------------------

	wait for 100 ns;
	
	-- Alterando valores de entrada.
	entradaA <= "00000000000101010000000000000000";
	entradaB <= "10101010101010100101010101010101";
	
	-- Setando operacao nop
	controle <= "011";
	
	wait for 100 ns;
	
	Write(output_line, String'(" Test13 - Testando nop. "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", controle="));
	Write(output_line, controle);
	Write(output_line, String'(", resultado="));
	Write(output_line, resultado);
	Write(output_line, String'(", carry="));
	Write(output_line, carry);
	Write(output_line, String'(", isZero="));
	Write(output_line, isZero);
	Write(output_line, String'(", isOverflow="));
	Write(output_line, isOverflow);
	writeline(output, output_line);
	assert resultado = "00000000000000000000011101111111" report "FALHA, era esperado '00000000000000000000011101111111'." severity failure;
	assert isZero = '0' report "FALHA, era esperado zero = '0'." severity failure;
	assert carry = '1' report "FALHA, deveria ter ocorrido carry." severity failure;
	assert isOverflow = '1' report "FALHA, deveria ter ocorrido overflow." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 14 -------------------------------------------
	----------------------------------------------------------------------------
	
	-- Alterando valores de entrada.
	entradaA <= "00001100000101010000000000000000";
	entradaB <= "00101010101010100101010101010100";
	
	-- Setando operacao nop
	controle <= "011";
	
	wait for 100 ns;
	
	Write(output_line, String'(" Test14 - Testando nop novamente. "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", controle="));
	Write(output_line, controle);
	Write(output_line, String'(", resultado="));
	Write(output_line, resultado);
	Write(output_line, String'(", carry="));
	Write(output_line, carry);
	Write(output_line, String'(", isZero="));
	Write(output_line, isZero);
	Write(output_line, String'(", isOverflow="));
	Write(output_line, isOverflow);
	writeline(output, output_line);
	assert resultado = "00000000000000000000011101111111" report "FALHA, era esperado '00000000000000000000011101111111'." severity failure;
	assert isZero = '0' report "FALHA, era esperado zero = '0'." severity failure;
	assert carry = '1' report "FALHA, deveria ter ocorrido carry." severity failure;
	assert isOverflow = '1' report "FALHA, deveria ter ocorrido overflow." severity failure;
	
	
	----------------------------------------------------------------------------
	------------------------ TESTE 15 -------------------------------------------
	----------------------------------------------------------------------------
	
	-- Alterando valores de entrada.
	entradaA <= "00000000000000000000000000000001";
	entradaB <= "11111111111111111111111111111110";
	
	-- Setando operacao A and not B
	controle <= "100";
	
	wait for 100 ns;
	
	Write(output_line, String'(" Test15 - Testando A and not B. "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", controle="));
	Write(output_line, controle);
	Write(output_line, String'(", resultado="));
	Write(output_line, resultado);
	Write(output_line, String'(", carry="));
	Write(output_line, carry);
	Write(output_line, String'(", isZero="));
	Write(output_line, isZero);
	Write(output_line, String'(", isOverflow="));
	Write(output_line, isOverflow);
	writeline(output, output_line);
	assert resultado = "00000000000000000000000000000001" report "FALHA, era esperado '00000000000000000000000000000001'." severity failure;
	assert isZero = '0' report "FALHA, era esperado zero = '0'." severity failure;
	assert carry = '0' report "FALHA, não deveria ter ocorrido carry." severity failure;
	assert isOverflow = '0' report "FALHA, não deveria ter ocorrido overflow." severity failure;
	
	
	----------------------------------------------------------------------------
	------------------------ TESTE 16 -------------------------------------------
	----------------------------------------------------------------------------
	
	-- Alterando valores de entrada.
	entradaA <= "11111111111111111111111111111110";
	entradaB <= "00000000000000000000000000000001";
	
	-- Setando operacao A and not B
	controle <= "100";
	
	wait for 100 ns;
	
	Write(output_line, String'(" Test16 - Testando A and not B. "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", controle="));
	Write(output_line, controle);
	Write(output_line, String'(", resultado="));
	Write(output_line, resultado);
	Write(output_line, String'(", carry="));
	Write(output_line, carry);
	Write(output_line, String'(", isZero="));
	Write(output_line, isZero);
	Write(output_line, String'(", isOverflow="));
	Write(output_line, isOverflow);
	writeline(output, output_line);
	assert resultado = "11111111111111111111111111111110" report "FALHA, era esperado '11111111111111111111111111111110'." severity failure;
	assert isZero = '0' report "FALHA, era esperado zero = '0'." severity failure;
	assert carry = '0' report "FALHA, não deveria ter ocorrido carry." severity failure;
	assert isOverflow = '0' report "FALHA, não deveria ter ocorrido overflow." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 17 -------------------------------------------
	----------------------------------------------------------------------------
	
	-- Alterando valores de entrada.
	entradaA <= "00000000000000000000000000000001";
	entradaB <= "00000000000000000000000000000001";
	
	-- Setando operacao A and not B
	controle <= "100";
	
	wait for 100 ns;
	
	Write(output_line, String'(" Test17 - Testando A and not B. "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", controle="));
	Write(output_line, controle);
	Write(output_line, String'(", resultado="));
	Write(output_line, resultado);
	Write(output_line, String'(", carry="));
	Write(output_line, carry);
	Write(output_line, String'(", isZero="));
	Write(output_line, isZero);
	Write(output_line, String'(", isOverflow="));
	Write(output_line, isOverflow);
	writeline(output, output_line);
	assert resultado = "00000000000000000000000000000000" report "FALHA, era esperado '00000000000000000000000000000000'." severity failure;
	assert isZero = '1' report "FALHA, era esperado zero = '1'." severity failure;
	assert carry = '0' report "FALHA, não deveria ter ocorrido carry." severity failure;
	assert isOverflow = '0' report "FALHA, não deveria ter ocorrido overflow." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 18 -------------------------------------------
	----------------------------------------------------------------------------
	
	-- Alterando valores de entrada.
	entradaA <= "00000000000000000000000000000001";
	entradaB <= "00000000000000000000000000000001";
	
	-- Setando operacao A and not B
	controle <= "101";
	
	wait for 100 ns;
	
	Write(output_line, String'(" Test18 - Testando A or not B. "));
	Write(output_line, String'("entradaA="));
	Write(output_line, entradaA);
	Write(output_line, String'(", entradaB="));
	Write(output_line, entradaB);
	Write(output_line, String'(", controle="));
	Write(output_line, controle);
	Write(output_line, String'(", resultado="));
	Write(output_line, resultado);
	Write(output_line, String'(", carry="));
	Write(output_line, carry);
	Write(output_line, String'(", isZero="));
	Write(output_line, isZero);
	Write(output_line, String'(", isOverflow="));
	Write(output_line, isOverflow);
	writeline(output, output_line);
	assert resultado = "11111111111111111111111111111111" report "FALHA, era esperado '11111111111111111111111111111111'." severity failure;
	assert isZero = '0' report "FALHA, era esperado zero = '0'." severity failure;
	assert carry = '0' report "FALHA, não deveria ter ocorrido carry." severity failure;
	assert isOverflow = '0' report "FALHA, não deveria ter ocorrido overflow." severity failure;

	----------------------------------------------------------------------------
	------------------------ END OF TESTS --------------------------------------
	----------------------------------------------------------------------------	
	-- Finaliza a suite de testes
	assert false report "End o tests. SUCESS execution." severity failure;
	wait;
		
  end process;
  
 end  tb_alu_behavior; 

