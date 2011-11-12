----------------------------------------------
--
--
-- TestBench - ULA ()
-- Autor: Cristiano J. Miranda (ra: 083382)
--
----------------------------------------------
library std;
library ieee;

use std.textio.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
--use ieee.std_logic_textio.all;
--use ieee.std_logic_unsigned.all;

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

	-- Adder component
	component adder is
		generic(N : integer := 32);
		port (a, b: in std_logic_vector(N-1 downto 0);
			  cin: in std_logic;
			  s: out std_logic_vector(N-1 downto 0);
			  cout: out std_logic);
	end component;
	
	-- Signal for result adder
	signal adderSrc : std_logic_vector(w-1 downto 0);
	signal adderResult : std_logic_vector(w-1 downto 0);
	signal carry : std_logic;
	
	
begin

	-- Port map para adder
	adder_0 : adder port map (srca, adderSrc, '0', adderResult, carry);

	-- Main process
	process (alucontrol)
	
		-- Variables
		variable srctemp : std_logic_vector(w-1 downto 0);
		variable resulttemp : std_logic_vector(w-1 downto 0);
		
	begin
		
		-- Evaluate A and B
		if alucontrol = "000" then
			resulttemp := srca and srcb;
			
		-- Evaluate A or B
		elsif alucontrol = "001" then
				resulttemp := srca or srcb;
			
			-- Evaluate A + B
		elsif alucontrol = "010" then
			adderSrc <= srcb;
			resulttemp := adderResult;
			carryout <= carry;
			
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
			adderSrc <= not srcb;
			resulttemp := adderResult;
			carryout <= carry;
			
			-- SLT
		elsif alucontrol = "111" then
			if srca < srcb then
				resulttemp := "11111111111111111111111111111111";
			else
				resulttemp := "00000000000000000000000000000000";
			end if;
				
		end if;
		
		-- Verifica flag zero
		if (resulttemp = "00000000000000000000000000000000") then
			zero <= '1';
		else 
			zero <= '0';
		end if;
		
		-- Seta o resultado
		aluresult <= resulttemp;		
		
	end process;
		
end behavior;