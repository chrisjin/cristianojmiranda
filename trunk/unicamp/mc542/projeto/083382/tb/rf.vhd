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
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;

-- Definicao da entidade register file
entity rf is
 port(A1 : in std_logic_vector(4 downto 0);
	  A2 : in std_logic_vector(4 downto 0);
	  A3 : in std_logic_vector(4 downto 0);
	  WD3 : in std_logic_vector(31 downto 0);
	  clk : in std_logic;
	  We3 : in std_logic;
	  RD1 : out std_logic_vector(31 downto 0);
	  RD2 : out std_logic_vector(31 downto 0));
	  
end rf;

-- Implementacao da arquitetura Behavior para RF
architecture rtl of rf is

	-- Banco de registradores(RF): 64 registradores de 32 bits cada
    type reg_type is array (0 to 31) of std_logic_vector(31 downto 0);
	
begin

		-- Escrita sincrona na borda de subida
		rf_write : process(A3, WD3, clk, We3)
			variable output_line : line;
			variable registers : reg_type;
		begin
		
			registers(0) := (others => '0');
		
			-- Leitura assincrona no banco de registradores
			RD1 <= registers(conv_integer(A1));
			RD2 <= registers(conv_integer(A2));
		
			-- Executa a acao no RF apenas na borda de subida
			if clk'event and clk = '1' then
				
				-- Escrita sincrona habilitada no registrador
				if We3 = '1' then
				
				    -- Armazena o valor no registrador com excessao de r0
					if conv_integer(A3) /= 0 then
						-- Escreve no registrador especificado
						registers(conv_integer(A3)) := WD3;
					end if;
					
					-- Para verificar se esta de fato alterando o valor do retorno
					--registers(conv_integer(A3)) := "11111111111111111111111111111111";
					
				end if;
				
			end if;
			
		end process rf_write;
		
end rtl;