----------------------------------------------
--
--
-- TestBench - datamem (data memory)
-- Autor: Cristiano J. Miranda (ra: 083382)
--
----------------------------------------------
library std;
library ieee;

use std.textio.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;

-- Memory address
-- 0x00400000 ate 0x0FFFFFFC - Instruction data
-- 0x10000000 ate 0x1000FFFC - Global data
-- 0x10010000 ate 0x7FFFFFFC - Heap and Stack

-- Definicao da entidade Data Memory
entity datamem is
 port(CLK : in std_logic;
	  A : in std_logic_vector(31 downto 0);
	  WE : in std_logic;
	  WD : in std_logic_vector(31 downto 0);
	  RD : out std_logic_vector(31 downto 0));
	  
end datamem;

-- Implementacao da arquitetura datamem_arc para data memory
architecture datamem_arc of datamem is

	-- Banco de registradores(RF): 128 registradores de 32 bits cada
    type reg_type is array (0 to 128) of std_logic_vector(31 downto 0);
	
begin

		-- Escrita sincrona na borda de subida
		rf_write : process(A, WD, CLK, WE)
			variable registers : reg_type;
			variable addr : std_logic_vector(31 downto 0) := X"00000000";
		begin
		
			-- Remove a diferenca
			addr := A - X"10000000";
		
			-- Leitura assincrona no banco de registradores
			RD <= registers(conv_integer(addr(8 downto 0)) / 4);
		
			-- Executa a acao no RF apenas na borda de subida
			if clk'event and clk = '1' then
				
				-- Escrita sincrona habilitada no registrador
				if We = '1' then
				
					-- Escreve no registrador especificado
					registers(conv_integer(addr(8 downto 0)) / 4) := WD;
					
				end if;
				
			end if;
			
		end process rf_write;
		
end datamem_arc;