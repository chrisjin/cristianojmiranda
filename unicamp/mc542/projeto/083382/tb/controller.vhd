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
		  alusrcd : out std_logic;
		  regdstd : out std_logic);
end;

-- arcquitetura controller
architecture controller_arc of controller is
	signal controls: STD_LOGIC_VECTOR(8 downto 0);
	signal R_TYPE	: STD_LOGIC;
	signal LW		: STD_LOGIC;
	signal SW		: STD_LOGIC;
	signal BEQ		: STD_LOGIC;
	signal LUI		: STD_LOGIC;
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
	
	--
	process (OP) 
	begin
	
		R_TYPE <= not OP(5) and not OP(4) and not OP(3) and not OP(2) and not OP(1) and not OP(0);
		LW <= OP(5) and not OP(4) and not OP(3) and not OP(2) and OP(1) and OP(0);
		SW <= OP(5) and not OP(4) and 	OP(3) and not OP(2) and OP(1) and OP(0);
		BEQ <= not OP(5) and not OP(4) and not OP(3) and OP(2) and not OP(1) and not OP(0);
		LUI <= not OP(5) and not OP(4) and OP(3) and OP(2) and  OP(1) and OP(0);
	 
		regwrited	<= R_TYPE or LW or LUI;		
		memtoregd	<= LW;		
		branchd		<= BEQ;	
--		MemRead		<= LW or LUI;
		memwrited	<= SW;
		regdstd		<= R_TYPE;
		alusrcd		<= LW or SW or LUI;
--		ALUOp0		<= BEQ;
--		ALUOp1		<= R_TYPE;
--		ALUOp2		<= LUI;
	
	end process;
		
end;