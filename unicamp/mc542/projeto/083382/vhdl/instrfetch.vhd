library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_ARITH.all;


--MIPS instrfetch
entity instrfetch is 
	generic(nbits : positive := 32);
	port(clk, reset: in STD_LOGIC;
		pcsrcm: in STD_LOGIC;
		pcbranchm: in STD_LOGIC_vector(nbits-1 downto 0);
		intrd: out std_logic_vector(nbits -1 downto 0);
		pcplus4d: out std_logic_vector(nbits -1 downto 0));
end;

-- Intruction Fetch architecture
architecture instrfetch_arc of instrfetch is

	-- Componente adder
	component adder
		port(a, b: in STD_LOGIC_VECTOR (31 downto 0);
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

	-- Componente mux com 2 entradas
	component mux2 generic (width: integer:= 32);
		port(d0, d1: in STD_LOGIC_VECTOR (width-1 downto 0);
			s: in STD_LOGIC;
			y: out STD_LOGIC_VECTOR (width-1 downto 0));
	end component;
	
	-- Componente instruction memory (contem a memoria de instrucoes a serem executadas)
	component instrmem is
		port(addr : in std_logic_vector(31 downto 0);
			rd : out std_logic_vector(31 downto 0));
	end component;

	
	-- Sinais de testes
	signal pcnext : std_logic_vector(31 downto 0);
	signal pcf : std_logic_vector(31 downto 0);
	signal rd : std_logic_vector(31 downto 0);
	signal pcplus4f : std_logic_vector(31 downto 0);
	
	
begin

	-- Bind das portas dos componentes 
	
	-- mux
	mux_0 : mux2 port map (d0 => pcplus4f, d1 => pcbranchm, s => pcsrcm, y => pcnext);
	
	-- pc register
	pc : floprs port map (clk => clk, reset => reset, rstin => X"00400000", d => pcnext, q => pcf);
	
	-- Instruction memory
	inst_memory : instrmem port map (addr => pcf, rd => rd);
	
	-- adder 4
	add_4 : adder port map( a => pcf, b => X"00000004", y => pcplus4f);
	
	-- reg if
	reg_if : flop port map (clk => clk, d => rd, q => intrd);
	
	-- reg id
	reg_id : flop port map ( clk => clk, d => pcplus4f, q => pcplus4d);

end instrfetch_arc;
