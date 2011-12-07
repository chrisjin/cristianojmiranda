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

entity tb_datamem is
end tb_datamem;


architecture tb_datamem_srt of tb_datamem is
	
	-- Componente flop
	component datamem is
	 port(CLK : in std_logic;
		  A : in std_logic_vector(31 downto 0);
		  WE : in std_logic;
		  WD : in std_logic_vector(31 downto 0);
		  RD : out std_logic_vector(31 downto 0));
		  
	end component;

	
	
	-- Sinais de testes
	signal clk : std_logic;
	signal we : std_logic;
	signal addr : STD_LOGIC_VECTOR(31 downto 0) := X"10000000";
	signal wd : STD_LOGIC_VECTOR(31 downto 0);
	signal rd : STD_LOGIC_VECTOR(31 downto 0);
	
 begin

  -- Bind das portas do component
  datamem_0 : datamem port map(clk, addr, we, wd, rd);
 
  process 
  
	variable output_line : line;
	
  begin	
	
	write(output_line, String'("------- [tb_datamem] Executando suite de 2 testes ---------------------------------------"));
	writeline(output, output_line);
	
	----------------------------------------------------------------------------
	------------------------ TESTE 1 -------------------------------------------
	----------------------------------------------------------------------------
	
	clk <= '1';
	we <= '1';
	addr <= X"10000000";
	wd <= X"0000000A";
	wait for 10 ns;
	
	clk <= '0';
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	
	Write(output_line, String'(" Test1 - Testando escrina no datamemory"));
	Write(output_line, String'("clk="));
	Write(output_line, clk);
	Write(output_line, String'(", we="));
	Write(output_line, we);
	Write(output_line, String'(", addr="));
	Write(output_line, addr);
	Write(output_line, String'(", wd="));
	Write(output_line, wd);
	Write(output_line, String'(", rd="));
	Write(output_line, rd);
	writeline(output, output_line);
	assert rd = "00000000000000000000000000001010" report "FALHA, era esperado '00000000000000000000000000001010'." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ TESTE 2 -------------------------------------------
	----------------------------------------------------------------------------
	
	clk <= '0';
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	
	clk <= '1';
	we <= '1';
	addr <= X"10000004";
	wd <= X"00000002";
	wait for 10 ns;
	
	clk <= '0';
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	
	Write(output_line, String'(" Test2 - Testando escrina no datamemory registrador 2"));
	Write(output_line, String'("clk="));
	Write(output_line, clk);
	Write(output_line, String'(", we="));
	Write(output_line, we);
	Write(output_line, String'(", addr="));
	Write(output_line, addr);
	Write(output_line, String'(", wd="));
	Write(output_line, wd);
	Write(output_line, String'(", rd="));
	Write(output_line, rd);
	writeline(output, output_line);
	assert rd = "00000000000000000000000000000010" report "FALHA, era esperado '00000000000000000000000000000010'." severity failure;
	
	----------------------------------------------------------------------------
	------------------------ END OF TESTS --------------------------------------
	----------------------------------------------------------------------------	
	-- Finaliza a suite de testes
	assert false report "[tb_datamem] End of tests. SUCESS execution." severity failure;
	wait;
		
  end process;
  
 end  tb_datamem_srt; 

