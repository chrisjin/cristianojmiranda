library IEEE; 
use IEEE.STD_LOGIC_1164.all;

-- single cycle control decoder
entity controller is 
	port (op, funct : in STD_LOGIC_VECTOR(5 downto 0);
		  regwrited : out std_logic;
		  memtoregd : out std_logic;
		  memwrited : out std_logic;
		  branchd : out std_logic;
		  alucontrold : out std_logic_vector(2 downto 0);
		  alusrcd : out std_logic_vector(2 downto 0);
		  regdstd : out std_logic);
end;

-- arcquitetura controller
architecture controller_arc of controller is
	signal controls: STD_LOGIC_VECTOR(8 downto 0);
begin

	-- Controle
	process(op)
	begin
		case op is
			when "000000" => controls <= "110000010"; -- Rtyp
			when "100011" => controls <= "101001000"; -- LW
			when "101011" => controls <= "001010000"; -- SW
			when "000100" => controls <= "000100001"; -- BEQ
			when "001000" => controls <= "101000000"; -- ADDI
			when "000010" => controls <= "000000100"; -- J
			when others => controls <= "---------"; -- illegal op
		end case;
	end process;

	-- controller para alu
	process (controls, funct) 
	begin
	
		case controls(1 downto 0) is
			when "00" => alucontrold <= "010"; -- add (for 1b/sb/addi)
			when "01" => alucontrold <= "110"; -- sub (for beq)
			when others => 
			
			case funct is -- R-type instructions
				when "100000" => alucontrold <= "010"; -- add
				when "100010" => alucontrold <= "110"; -- sub
				when "100100" => alucontrold <= "000"; -- and
				when "100101" => alucontrold <= "001"; -- or
				when "101010" => alucontrold <= "111"; -- slt
				when others => alucontrold <= "---"; -- ???
			end case;
		end case;
	end process;
		
end;