----------------------------------------------
--
--
-- Instruction Memory (armazena as intrucoes a serem executadas)
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

-- MIPS register set
--$0 		0 		the constant value 0
--$at 		1 		assembler temporary
--$v0:$v1 	2:3 	procedure return values
--$a0:$a3 	4:7 	procedure arguments
--$t0:$t7 	8:15 	temporary variables
--$s0:$s7 	16:23 	saved variables
--$t8:$t9 	24:25 	temporary variables
--$k0:$k1 	26:27 	operating system (OS) temporaries
--$gp 		28 		global pointer
--$sp 		29 		stack pointer
--$fp 		30 		frame pointer
--$ra 		31 		procedure return address


-- Memory address
-- 0x00400000 ate 0x0FFFFFFC - Instruction data
-- 0x10000000 ate 0x1000FFFC - Global data
-- 0x10010000 ate 0x7FFFFFFC - Heap and Stack

-- Intruction Memory
entity instrmem is
 port(addr : in std_logic_vector(31 downto 0);
	  rd : out std_logic_vector(31 downto 0));
end instrmem;

-- Instruções a serem adicionadas
--load, store, add, addi, addu, sub, subi, subu, and, or, xor, slt, sltu, j, jal, beq

-- Implementacao da arquitetura para instrmem
architecture instrmem_arc of instrmem is	
begin

		process(addr) begin
		
			case addr is
				
				-- Load posicao 0x10000000 no registrador $t0
				-- Antes deve ser carregado o endereço 0x10000000 no registrador $s0
				-- lw $t0, 0($s0)
				-- lw opcode: 100011,       
				-- rs = 10000 -- address - $s0
				-- rt = 01000 - $t0
				-- offset = 0000000000000000
				-- 							00000000000000000000000000000000
				when X"00400000" => rd <= "10001110000010000000000000000000";
				
				-- Store word na memoria (carrega na posicao 0x10000004 o valor de $t1)
				-- Antes deve ser carregado o endereço 0x10000000 no registrador $s0
				-- sw $t1, 4($s0)
				-- sw opcode: 101011
				-- rs: $t0: 01000
				-- rt: ($t1) = 9: 01001
				-- imm: (offset): 4 = 0000000000000100
				-- 							00000000000000000000000000000000
				when X"00400004" => rd <= "10101101000010010000000000000100";
				
				-- Add
				-- add $t2, $t3, $t4
				-- R-type opcode: 000000
				-- rd = $t2(10): 01010
				-- rs = $t3(11): 01011
				-- rt = $t3(12): 01100				
				-- shmt = 00000
				-- Function: 100001
				-- 						   00000000000000000000000000000000
				when X"00400008" => rd <= "00000001010010110110000000100001";
				
				-- Addi t2 = t1 + 10
				-- addi $t2, $t1, 0x0000000A
				-- Addi opcode: 001000
				-- rs = $t1(9): 01001
				-- rt = $t2(10): 01010
				-- immd: 10: 0000000000001010
				-- 						   00000000000000000000000000000000
				when X"0040000C" => rd <= "00100001001010100000000000001010";
					
				-- Outras posições não carregadas
				when others => rd <= "11111111111111111111111111111111";
				
			end case;
			
		end process;
		
end instrmem_arc;