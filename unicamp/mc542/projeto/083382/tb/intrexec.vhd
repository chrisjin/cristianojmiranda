library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_ARITH.all;


--MIPS instrexec
entity instrexec is 
	generic(nbits : positive := 32);
	port(clk, reset: in STD_LOGIC;
		regwritee in std_logic;
		memtorege in std_logic;
		memwritee in std_logic;
		branche in std_logic;
		alucontrole in std_logic(2 downto 0);
		regdste in std_logic;
		rte in std_logic_vector(nbits -1 downto 0);
		rde in std_logic_vector(nbits -1 downto 0);
		signimme in std_logic_vector(nbits -1 downto 0);
		pcplus4e in std_logic_vector(nbits -1 downto 0);
		regwritem out std_logic;
		memtoregm out std_logic;
		memwritem out std_logic;
		branchm out std_logic;
		zerom out std_logic;
		aluoutm out std_logic_vector(nbits -1 downto 0);
		writedatam out std_logic_vector(nbits -1 downto 0);
		writeregm out std_logic_vector(nbits -1 downto 0);
		pcbranchm out std_logic_vector(nbits -1 downto 0));
end;

-- Intruction Decode architecture
architecture instrexec_arc of instrexec is

	-- Componente register file
	component rf is
	 port(A1 : in std_logic_vector(4 downto 0);
		  A2 : in std_logic_vector(4 downto 0);
		  A3 : in std_logic_vector(4 downto 0);
		  WD3 : in std_logic_vector(31 downto 0);
		  clk : in std_logic;
		  We3 : in std_logic;
		  RD1 : out std_logic_vector(31 downto 0);
		  RD2 : out std_logic_vector(31 downto 0));
		  
	end component;
	
	-- Componente signal extend
	component signext is 
		port(a: in STD_LOGIC_VECTOR (15 downto 0);
			y: out STD_LOGIC_VECTOR (31 downto 0));
	end component;

	-- Componente flop
	component flop generic (width: integer := 32);
		port(clk : in STD_LOGIC;
			d: in STD_LOGIC_VECTOR (width-1 downto 0);
			q: out STD_LOGIC_VECTOR (width-1 downto 0));
	end component;
	
	-- Componente floprs
	component floprs generic (width: integer := 32);
		port(clk, reset: in STD_LOGIC;
			rstin : in STD_LOGIC_VECTOR(width-1 downto 0);
			d: in STD_LOGIC_VECTOR (width-1 downto 0);
			q: out STD_LOGIC_VECTOR (width-1 downto 0));
	end component;
	
	-- Sinais de testes
	signal rd1 : std_logic_vector(31 downto 0);
	signal rd2 : std_logic_vector(31 downto 0);
	signal sigext : std_logic_vector(31 downto 0);
	
	
begin

	-- Bind das portas dos componentes 
	
	-- Register file
	rt_0 : rt port map(a1 => intrd(25 downto 21), a2 => intrd(20 downto 16), a3 => writeregw, wd3 => wd3, clk => clk, we3 => we3, rd1 => rd1, rd2 => rd2);
	
	-- Signal extend
	signext_0 : signext port map (a => intrd(15 downto 0), y => sigext);

end instrexec_arc;
