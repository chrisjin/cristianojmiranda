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

entity tb_imem is
end tb_imem;


architecture tb_imem_srt of tb_imem is
	
	-- Componente flop
	component imem is 
		port(clk, reset: in STD_LOGIC;
			regwritem : in std_logic;
			memtoregm : in std_logic;
			memwritem : in std_logic;
			branchm : in std_logic;
			zerom : in std_logic;
			aluoutm : in std_logic_vector(31 downto 0);
			writedatam : in std_logic_vector(31 downto 0);
			writeregm : in std_logic_vector(4 downto 0);
			pcbranchm : in std_logic_vector(31 downto 0);
			regwritew : out std_logic;
			memtoregw : out std_logic;
			aluoutw : out std_logic_vector(31 downto 0);
			readdataw : out std_logic_vector(31 downto 0);
			writeregw : out std_logic_vector(4 downto 0);
			pcbranch : out std_logic_vector(31 downto 0);
			pcsrcm : out std_logic);
	end component;
	
	
	-- Sinais de testes
	signal clk : std_logic;
	signal reset : std_logic;
	signal regwritem :  std_logic;
	signal memtoregm :  std_logic;
	signal memwritem :  std_logic;
	signal branchm :  std_logic;
	signal zerom :  std_logic;
	signal aluoutm :  std_logic_vector(31 downto 0);
	signal writedatam : std_logic_vector(31 downto 0);
	signal writeregm :  std_logic_vector(4 downto 0);
	signal pcbranchm : std_logic_vector(31 downto 0);
	signal regwritew :  std_logic;
	signal memtoregw :  std_logic;
	signal aluoutw :  std_logic_vector(31 downto 0);
	signal readdataw :  std_logic_vector(31 downto 0);
	signal writeregw :  std_logic_vector(4 downto 0);
	signal pcbranch : std_logic_vector(31 downto 0);
	signal pcsrcm :  std_logic;
	
	
 begin

  -- Bind das portas do component
  imem_0 : imem port map(clk, reset, regwritem, memtoregm, memwritem, branchm,
			zerom, aluoutm, writedatam, writeregm, pcbranchm, regwritew, memtoregw, aluoutw, readdataw, writeregw, pcbranch, pcsrcm);
 
  process 
  
	variable output_line : line;
	
  begin	
	
	write(output_line, String'("------- [tb_imem] Executando suite de  testes ---------------------------------------"));
	writeline(output, output_line);
	
	-- 0x10000000 ate 0x1000FFFC - Global data
	----------------------------------------------------------------------------
	------------------------ TESTE 1 -------------------------------------------
	----------------------------------------------------------------------------
	
	wait for 10 ns;
	
	clk <= '1';
	aluoutm <= X"10000000";
	writedatam <= X"00000111";
	memwritem <= '1';
	wait for 10 ns;
	
	Write(output_line, String'(" Test1 - Testando gravacao de um valor na memoria. "));
	Write(output_line, String'("clk="));
	Write(output_line, clk);
	Write(output_line, String'(", aluoutm="));
	Write(output_line, aluoutm);
	Write(output_line, String'(", writedatam="));
	Write(output_line, writedatam);
	Write(output_line, String'(", readdataw="));
	Write(output_line, readdataw);
	writeline(output, output_line);
	assert readdataw = X"00000111" report "FALHA, era esperado '0x00000111'." severity failure;
	
	
	
	----------------------------------------------------------------------------
	------------------------ END OF TESTS --------------------------------------
	----------------------------------------------------------------------------	
	-- Finaliza a suite de testes
	assert false report "[tb_imem] End of tests. SUCESS execution." severity failure;
	wait;
		
  end process;
  
 end  tb_imem_srt; 

