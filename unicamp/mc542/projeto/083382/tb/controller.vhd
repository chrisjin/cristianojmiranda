library IEEE; 
use IEEE.STD_LOGIC_1164.all;

-- single cycle control decoder
entity controller is 
	port (op, funct: in STD_LOGIC_VECTOR (5 downto 0);
		  regwrited out std_logic;
		  memtoregd out std_logic;
		  memwrited out std_logic;
		  branchd out std_logic;
		  alucontrold out std_logic(2 downto 0);
		  alusrcd out std_logic(2 downto 0);
		  regdstd out std_logic);
end;

-- arcquitetura controller
architecture controller_arc of controller is
	
	component aludec
		port (funct: in STD_LOGIC_VECTOR (5 downto 0);
		aluop: in STD_LOGIC_VECTOR (1 downto 0);
		alucontrol: out STD_LOGIC_VECTOR (2 downto 0));
	end component;
	
	
	signal aluop: STD_LOGIC_VECTOR (1 downto 0);
	signal branch: STD_LOGIC;
	
begin
		aludec_0: aludec port map (funct, aluop, alucontrol);
end;