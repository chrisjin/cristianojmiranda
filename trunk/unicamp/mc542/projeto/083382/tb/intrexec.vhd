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
		alucontrole in std_logic_vector(2 downto 0);
		alusrce in std_logic;
		regdste in std_logic;
		srcae in std_logic_vector(nbits -1 downto 0);
		srcbe in std_logic_vector(nbits -1 downto 0);
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
	
	-- Componente shift left by 2
	component sl2 is 
		port (a: in STD_LOGIC_VECTOR (31 downto 0);
			y: out STD_LOGIC_VECTOR (31 downto 0));
	end component;


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
	
	-- Componente mux com 2 entradas
	component mux2 generic (width: integer:= 32);
		port(d0, d1: in STD_LOGIC_VECTOR (width-1 downto 0);
			s: in STD_LOGIC;
			y: out STD_LOGIC_VECTOR (width-1 downto 0));
	end component;
	
	-- Componente adder
	component adder
		port(a, b: in STD_LOGIC_VECTOR (31 downto 0);
			y: out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	-- Componente alu
	component alu is
		generic(w : natural := 32; cw: natural := 3);
		port(srca : in std_logic_vector(w-1 downto 0);
			 srcb : in std_logic_vector(w-1 downto 0);
			 alucontrol : in std_logic_vector(cw-1 downto 0);
			 aluresult : out std_logic_vector(w-1 downto 0);
			 zero : out std_logic;
			 overflow : out std_logic;
			 carryout : out std_logic);
	end component;
	
	-- Sinais de testes
	signal srcbe_2 : std_logic_vector(31 downto 0);
	signal aluout : std_logic_vector(31 downto 0);
	signal aluzero : std_logic;
	signal writerege : std_logic_vector(4 downto 0);
	signal sigextout : std_logic_vector(31 downto 0);
	signal adderout : std_logic_vector(31 downto 0);
	signal overflow : out std_logic;
	signal carryout : out std_logic;
	
begin

	-- Bind das portas dos componentes 
	
	-- Mux 1
	mux2_0 : mux2 port map (d0 => srcbe, d1 => signimme, s => alusrce, y => srcbe_2);	
	
	-- ALU
	alu_0 : alu port map (srca => srcae, srcb => srcbe_2, alucontrol => alucontrole, aluresult => aluout, zero => aluzero, overflow => overflow, carryout => carryout);
	
	-- Mux 2
	mux2_1 : mux2 port map ( d0 => rte, d1 => rde, s => regdste, y => writerege);
	
	-- sl2
	sl2_0 : sl2 port map (a => signimme, y => sigextout);
	
	-- adder
	adder_1 : adder port map(a => sigextout, b => pcplus4e, y => adderout);
	
	-- Flip flop para armazenar o bit regwritem
	ffregwritem : process(clk, regwritee)
	begin
	
		if clk'event and clk = '1' then
			regwritem <= regwritee;
		end if;
	
	end process ffregwritem;
	
	-- Flip flop para armazenar o bit memtoregm
	ffmemtoregm : process(clk, memtorege)
	begin 
	
		if clk'event and clk = '1' then
			memtoregm <= memtorege;
		end if;
	
	end process ffmemtoregm;
	
	-- Flip flop para armazenar o bit memwritem
	ffmemwritem : process(clk, memwritee)
	begin 
	
		if clk'event and clk = '1' then
			memwritem <= memwritee;
		end if;
	
	end process ffmemwritem;
	
	-- Flip flop para armazenar o bit branchm
	ffbranchm : process(clk, branchm)
	begin 
	
		if clk'event and clk = '1' then
			branchm <= branche;
		end if;
	
	end process ffbranchm;
	
	-- Flip flop para armazenar o bit zerom
	ffzerom : process(clk, zerom)
	begin 
	
		if clk'event and clk = '1' then
			zerom <= aluzero;
		end if;
	
	end process ffzerom;
	
	-- Flip flop alu out
	ff_aluout : flop port map (clk => clk, d => aluout, q => aluoutm);
	
	-- Flip flop write data m
	ff_writedatam : flop port map (clk => clk, d => writedatae, q => writedatae);

	-- Flip flop write reg m
	ff_writeregm : floprs port map (clk => clk, reset = '0', rstin = '00000', d => writerege, q => writeregm);
	
	-- Flip flop para branch
	ff_branchm : flop port map (clk => clk, d => adderout, q => pcbranchm);

end instrexec_arc;
