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
use ieee.std_logic_arith.all;

-- Definicao da entidade alu (arithimethic logic unit)
--  alucontrol definitions
--  000 A AND B
--  001 A OR B
--  010 A + B
--  011 not used
--  100 A AND not B
--  101 A OR not B
--  110 A - B
--  111 SLT
--
entity alu is
	generic(w : natural := 32; cw: natural := 3);
	port(srca : in std_logic_vector(w-1 downto 0);
		 srcb : in std_logic_vector(w-1 downto 0);
		 alucontrol : in std_logic_vector(cw-1 downto 0);
		 aluresult : out std_logic_vector(w-1 downto 0);
		 zero : out std_logic;
		 overflow : out std_logic;
		 carryout : out std_logic);
end alu;

-- Implementacao da arquitetura Behavior para ALU
architecture behavior of alu is
	
	-- Signal for result adder
	signal adderResult : std_logic_vector(w-1 downto 0);
	signal carry : std_logic;
	
	
begin

	-- Main process
	process (alucontrol, srca, srcb)
	
		-- Variables
		variable srctemp : std_logic_vector(w-1 downto 0);
		variable resulttemp : std_logic_vector(w-1 downto 0);
		variable resultAdd: STD_LOGIC_VECTOR(w downto 0);
		
	begin
	
		-- NOP
		if alucontrol /= "011" then
			overflow <= '0';
			carryout <= '0';
		end if;
		
		-- Evaluate A and B
		if alucontrol = "000" then
			resulttemp := srca and srcb;
			
		-- Evaluate A or B
		elsif alucontrol = "001" then
				resulttemp := srca or srcb;
			
			-- Evaluate A + B
		elsif alucontrol = "010" then
			resultAdd :=  unsigned("0" & srca) + unsigned("0" & srcb);
			resulttemp := resultAdd(w-1 downto 0);
			carryout <= resultAdd(w);
			-- Se ocorreu carry, certamente ocorreu overflow
			overflow <= resultAdd(w);
			--overflow <= resultAdd(w) XOR srca(w-1) XOR srcb(w-1) XOR resultAdd(w-1);
			
		-- Do nothing
		elsif alucontrol = "011" then
			resulttemp := srca and srcb;
			
		-- Evaluate A and not B
		elsif alucontrol =  "100" then
			srctemp := not srcb;
			resulttemp := srca and srctemp;
			
		-- Evaluate A or not B
		elsif alucontrol =  "101" then
			srctemp := not srcb;
			resulttemp := srca or srctemp;
			
		-- Evaluate A - B
		elsif alucontrol = "110" then 
			resultAdd :=  unsigned("0" & srca) - unsigned("0" & srcb);
			resulttemp := resultAdd(w-1 downto 0);
			carryout <= resultAdd(w);
			-- Se ocorreu carry, certamente ocorreu overflow
			overflow <= resultAdd(w);
			
		-- SLT
		elsif alucontrol = "111" then
			if srca < srcb then
				resulttemp := "11111111111111111111111111111111";
			else
				resulttemp := "00000000000000000000000000000000";
			end if;
				
		end if;
		
		-- NOP
		if alucontrol /= "011" then
		
			-- Verifica flag zero
			if resulttemp = "00000000000000000000000000000000" then
				zero <= '1';
			else 
				zero <= '0';
			end if;
			
			-- Seta o resultado
			aluresult <= resulttemp;
		
		end if;
		
	end process;
		
end behavior;