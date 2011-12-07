library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_ARITH.all;


--MIPS instrdec
entity instrdec is 
	generic(nbits : positive := 32);
	port(clk, reset: in STD_LOGIC;
		intrd: in std_logic_vector(nbits -1 downto 0);
		pcplus4d: in std_logic_vector(nbits -1 downto 0);
		writeregw: in std_logic_vector(4 downto 0);
		wd3: in std_logic_vector(nbits -1 downto 0);
		we3: in std_logic;
		regwritee: out std_logic;
		memtorege: out std_logic;
		memwritee: out std_logic;
		branche: out std_logic;
		alucontrole: out std_logic_vector(2 downto 0);
		alusrce: out std_logic;
		regdste: out std_logic;
		srcae: out std_logic_vector(nbits -1 downto 0);
		srcbe: out std_logic_vector(nbits -1 downto 0);
		rte: out std_logic_vector(nbits -1 downto 0);
		rde: out std_logic_vector(nbits -1 downto 0);
		signimme: out std_logic_vector(nbits -1 downto 0);
		pcplus4e: out std_logic_vector(nbits -1 downto 0));
end;

-- Intruction Decode architecture
architecture instrdec_arc of instrdec is

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
	
	component controller is 
		port (op, funct: in STD_LOGIC_VECTOR (5 downto 0);
			  regwrited: out std_logic;
			  memtoregd: out std_logic;
			  memwrited: out std_logic;
			  branchd: out std_logic;
			  alucontrold : out std_logic_vector(2 downto 0);
			  alusrcd: out std_logic;
			  regdstd: out std_logic);
	end component;
	
	-- Sinais internos
	signal rd1 : std_logic_vector(31 downto 0);
	signal rd2 : std_logic_vector(31 downto 0);
	signal sigext : std_logic_vector(31 downto 0);
	signal regwrited : std_logic;
	signal memtoregd : std_logic;
	signal memwrited : std_logic;
	signal branchd : std_logic;
	signal alucontrold : std_logic_vector(2 downto 0);
	signal alusrcd : std_logic;
	signal regdstd : std_logic;
	
	
begin

	-- Bind das portas dos componentes 
	
	-- Register file
	rf_0 : rf port map(a1 => intrd(25 downto 21), a2 => intrd(20 downto 16), a3 => writeregw, wd3 => wd3, clk => clk, we3 => we3, rd1 => rd1, rd2 => rd2);
	
	-- Signal extend
	signext_0 : signext port map (a => intrd(15 downto 0), y => sigext);

	-- Controller
	controller_0 : controller port map (op => intrd(31 downto 26), funct => intrd(5 downto 0), regwrited => regwrited, memtoregd => memtoregd, memwrited => memwrited, branchd => branchd, alucontrold => alucontrold, alusrcd => alusrcd, regdstd => regdstd);
	
	-- Flip flop para armazenar o bit regwritee
	ffregwritee : process(clk, regwrited)
	begin
	
		if clk'event and clk = '1' then
			regwritee <= regwrited;
		end if;
	
	end process ffregwritee;
	
	-- Flip flop para armazenar o bit memtorege
	ffmemtorege : process(clk, memtoregd)
	begin 
	
		if clk'event and clk = '1' then
			memtorege <= memtoregd;
		end if;
	
	end process ffmemtorege;
	
	-- Flip flop para armazenar o bit memwritem
	ffmemwritee : process(clk, memwrited)
	begin 
	
		if clk'event and clk = '1' then
			memwritee <= memwrited;
		end if;
	
	end process ffmemwritee;
	
	-- Flip flop para armazenar o bit branchm
	ffbranche : process(clk, branchd)
	begin 
	
		if clk'event and clk = '1' then
			branche <= branchd;
		end if;
	
	end process ffbranche;
	
	-- Flip flop para armazenar o bit alucontrold
	ffalucontrole : process(clk, alucontrold)
	begin 
	
		if clk'event and clk = '1' then
			alucontrole <= alucontrold;
		end if;
	
	end process ffalucontrole;
	
	-- Flip flop para armazenar o bit alusrce
	ffalusrce : process(clk, alusrcd)
	begin 
	
		if clk'event and clk = '1' then
			alusrce <= alusrcd;
		end if;
	
	end process ffalusrce;
	
	-- Flip flop para armazenar o bit regdste
	ffregdste : process(clk, regdstd)
	begin 
	
		if clk'event and clk = '1' then
			regdste <= regdstd;
		end if;
	
	end process ffregdste;
	

end instrdec_arc;
