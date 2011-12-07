library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_ARITH.all;


--MIPS imem (datapah com o instruction memory phase)
entity imem is 
	port(clk, reset: in STD_LOGIC;
		regwritem : in std_logic;
		memtoregm : in std_logic;
		memwritem : in std_logic;
		branchm : in std_logic;
		zerom : in std_logic;
		aluoutm : in std_logic_vector(31 downto 0);
		writedatam : in std_logic_vector(31 downto 0);
		writeregm : in std_logic_vector(4 downto 0);
		pcbranchm : in std_logic_vector(31 downto 0);
		regwritew : out std_logic;
		memtoregw : out std_logic;
		aluoutw : out std_logic_vector(31 downto 0);
		readdataw : out std_logic_vector(31 downto 0);
		writeregw : out std_logic_vector(4 downto 0);
		pcbranch : out std_logic_vector(31 downto 0);
		pcsrcm : out std_logic);
end;

-- Intruction memory path architecture
architecture imem_arc of imem is

	-- Componente flop
	component flop generic (width: integer := 32);
		port(clk : in STD_LOGIC;
			d: in STD_LOGIC_VECTOR (width-1 downto 0);
			q: out STD_LOGIC_VECTOR (width-1 downto 0));
	end component;
	
	-- Componente floprs
	component floprs generic (width: integer := 5);
		port(clk, reset: in STD_LOGIC;
			rstin : in STD_LOGIC_VECTOR(width-1 downto 0);
			d: in STD_LOGIC_VECTOR (width-1 downto 0);
			q: out STD_LOGIC_VECTOR (width-1 downto 0));
	end component;
	
	-- Componente entidade Data Memory
	component datamem is
	 port(CLK : in std_logic;
		  A : in std_logic_vector(31 downto 0);
		  WE : in std_logic;
		  WD : in std_logic_vector(31 downto 0);
		  RD : out std_logic_vector(31 downto 0));
	end component;
	
	-- Sinais de testes
	signal memout : std_logic_vector(31 downto 0);

	
begin

	-- Atualiza pc branch
	pcbranch <= pcbranchm;

	-- Bind das portas dos componentes 
	datamem_0 : datamem port map (clk => clk, a => aluoutm, we => memwritem, wd => writedatam, rd => memout);
	
	-- Flip flop para armazenar o pcsrcm
	ffpcsrcm : process(clk, branchm, zerom)
	begin 
	
		if clk'event and clk = '1' then
			pcsrcm <= branchm and zerom;
		end if;
	
	end process ffpcsrcm;
	
	-- Flip flop para armazenar o bit regwritew
	ffregwritew : process(clk, regwritem)
	begin
	
		if clk'event and clk = '1' then
			regwritew <= regwritem;
		end if;
	
	end process ffregwritew;
	
	-- Flip flop para armazenar o bit memtoregw
	ffmemtoregw : process(clk, memtoregm)
	begin 
	
		if clk'event and clk = '1' then
			memtoregw <= memtoregm;
		end if;
	
	end process ffmemtoregw;
	

	-- Flip flop writeregw
	ff_writeregw : floprs port map (clk => clk, reset = '0', rstin = '00000', d => writeregm, q => writeregw);
	
	-- Flip flop para readdataw
	ff_readdataw : flop port map (clk => clk, d => memout, q => readdataw);
	
	-- Flip flop para readdataw
	ff_aluoutw : flop port map (clk => clk, d => aluoutm, q => aluoutw);
	

end instrexec_arc;
