library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_ARITH.all;


-- MIPS datapath
entity datapath is 
	port(clk, reset: in STD_LOGIC);
end;

architecture datapath_arc of datapath is

	-- Instruction fetch
	component instrfetch is 
		generic(nbits : positive := 32);
		port(clk, reset: in STD_LOGIC;
			pcsrcm: in STD_LOGIC;
			pcbranchm: in STD_LOGIC_vector(nbits-1 downto 0);
			intrd: out std_logic_vector(nbits -1 downto 0);
			pcplus4d: out std_logic_vector(nbits -1 downto 0));
	end component;
	
	-- Instruction decode
	component instrdec is 
		generic(nbits : positive := 32);
		port(clk, reset: in STD_LOGIC;
			intrd: in std_logic_vector(nbits -1 downto 0);
			pcplus4d: in std_logic_vector(nbits -1 downto 0);
			writeregw : in std_logic_vector(4 downto 0);
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
	end component;
	
	-- Instruction execute
	component instrexec is 
		generic(nbits : positive := 32);
		port(clk, reset: in STD_LOGIC;
			regwritee: in std_logic;
			memtorege: in std_logic;
			memwritee: in std_logic;
			branche: in std_logic;
			alucontrole: in std_logic_vector(2 downto 0);
			alusrce: in std_logic;
			regdste: in std_logic;
			srcae: in std_logic_vector(nbits -1 downto 0);
			srcbe: in std_logic_vector(nbits -1 downto 0);
			rte: in std_logic_vector(nbits -1 downto 0);
			rde: in std_logic_vector(nbits -1 downto 0);
			signimme: in std_logic_vector(nbits -1 downto 0);
			pcplus4e: in std_logic_vector(nbits -1 downto 0);
			regwritem: out std_logic;
			memtoregm: out std_logic;
			memwritem: out std_logic;
			branchm: out std_logic;
			zerom: out std_logic;
			aluoutm: out std_logic_vector(nbits -1 downto 0);
			writedatam: out std_logic_vector(nbits -1 downto 0);
			writeregm: out std_logic_vector(nbits -1 downto 0);
			pcbranchm: out std_logic_vector(nbits -1 downto 0));
	end component;

	-- Instruction memory
	component imem is 
		port(clk, reset: in STD_LOGIC;
			regwritem: in std_logic;
			memtoregm: in std_logic;
			memwritem: in std_logic;
			branchm: in std_logic;
			zerom: in std_logic;
			aluoutm: in std_logic_vector(31 downto 0);
			writedatam: in std_logic_vector(31 downto 0);
			writeregm: in std_logic_vector(4 downto 0);
			pcbranchm: in std_logic_vector(31 downto 0);
			regwritew: out std_logic;
			memtoregw: out std_logic;
			aluoutw: out std_logic_vector(31 downto 0);
			readdataw: out std_logic_vector(31 downto 0);
			writeregw: out std_logic_vector(4 downto 0);
			pcbranch: out std_logic_vector(31 downto 0);
			pcsrcm: out std_logic);
	end component;


	-- Instruction write back
	component instrwb is 
		port(clk, reset: in STD_LOGIC;
			regwritew: in std_logic;
			memtoregw: in std_logic;
			aluoutw: in std_logic_vector(31 downto 0);
			readdataw: in std_logic_vector(31 downto 0);
			writeregw: in std_logic_vector(4 downto 0);
			regwritewb: out std_logic;
			writeregwb: out std_logic_vector(4 downto 0);
			resultgwb: out std_logic_vector(31 downto 0));
	end component;
	
	
	-- Sinais internos ao mips
	signal pcsrcm : std_logic;
	signal pcbranchm: STD_LOGIC_vector(31 downto 0);
	signal intrd : std_logic_vector(31 downto 0);
	signal pcplus4d: std_logic_vector(31 downto 0);
	signal writeregw: std_logic_vector(4 downto 0);
	signal wd3 : std_logic_vector(31 downto 0);
	signal we3 : std_logic;
	signal regwritee : std_logic;
	signal memtorege : std_logic;
	signal memwritee : std_logic;
	signal branche : std_logic;
	signal alucontrole : std_logic_vector(2 downto 0);
	signal alusrce : std_logic;
	signal regdste : std_logic;
	signal srcae : std_logic_vector(31 downto 0);
	signal srcbe : std_logic_vector(31 downto 0);
	signal rte : std_logic_vector(31 downto 0);
	signal rde : std_logic_vector(31 downto 0);
	signal signimme : std_logic_vector(31 downto 0);
	signal pcplus4e : std_logic_vector(31 downto 0);
	signal regwritem : std_logic;
	signal memtoregm : std_logic;
	signal memwritem : std_logic;
	signal branchm : std_logic;
	signal zerom : std_logic;
	signal aluoutm : std_logic_vector(31 downto 0);
	signal writedatam : std_logic_vector(31 downto 0);
	signal writeregm : std_logic_vector(4 downto 0);
	signal memtoregw : std_logic;
	signal aluoutw : std_logic_vector(31 downto 0);
	signal readdataw : std_logic_vector(31 downto 0);
	signal regwritew : std_logic;

begin

	-- instruction fetch
	instrfetch_0 : instrfetch port map(clk => clk, reset => reset, pcsrcm => pcsrcm, pcbranchm => pcbranchm, intrd => intrd, pcplus4d => pcplus4d);
	
	-- instruction decode
	instrdec_0 : instrdec port map (clk => clk, reset => reset, intrd => intrd, pcplus4d => pcplus4d, writeregw => writeregw, wd3 => wd3, we3 => we3, 
		regwritee => regwritee, memtorege => memtorege, memwritee => memwritee, branche => branche, alucontrole => alucontrole, alusrce => alusrce, 
		regdste => regdste, srcae => srcae, srcbe => srcbe, rte => rte, rde => rde, signimme => signimme, pcplus4e => pcplus4e);
	
	-- instruction execute
	instrexec_0 : instrexec port map (clk => clk, reset => reset, regwritee => regwritee, memtorege => memtorege, memwritee => memwritee, branche => branche,
		alucontrole => alucontrole, alusrce => alusrce, regdste => regdste, srcae => srcae, srcbe => srcbe, rte => rte, rde => rde, signimme => signimme, 
		pcplus4e => pcplus4e, regwritem => regwritem, memtoregm => memtoregm, memwritem => memwritem, branchm => branchm, zerom => zerom, aluoutm => aluoutm,
		writedatam => writedatam, writeregm => writeregm, pcbranchm => pcbranchm);
		
	-- instruction memory read
	imem_0 : imem port map (clk => clk, reset => reset, regwritem => regwritem, memtoregm => memtoregm, memwritem => memwritem, branchm => branchm, 
		zerom => zerom, aluoutm => aluoutm, writedatam => writedatam, writeregm => writeregm, pcbranchm => pcbranchm, regwritew => regwritew,
		memtoregw => memtoregw, aluoutw => aluoutw, readdataw => readdataw, writeregw => writeregw, pcbranch => pcbranchm, pcsrcm => pcsrcm);
	
	-- instruction write back
	instrwb_0 : instrwb port map (clk => clk, reset => reset, regwritew => regwritew, memtoregw => memtoregw, aluoutw => aluoutw, readdataw => readdataw,
		writeregw => writeregw, regwritewb => we3, writeregwb =>  writeregw, resultgwb => wd3);
	
end datapath_arc;