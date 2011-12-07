library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_ARITH.all;


--MIPS instrwb (write back)
entity instrwb is 
	port(clk, reset: in STD_LOGIC;
		regwritew: in std_logic;
		memtoregw: in std_logic;
		aluoutw: in std_logic_vector(31 downto 0);
		readdataw: in std_logic_vector(31 downto 0);
		writeregw: in std_logic_vector(4 downto 0);
		regwritewb: out std_logic;
		writeregwb : out std_logic_vector(4 downto 0);
		resultgwb : out std_logic_vector(31 downto 0));
end;

-- Intruction write back arc 
architecture instrwb_arc of instrwb is

	-- Multiplexador com duas entradas
	component mux2 is
		generic (width: integer:=32);
		port (d0, d1: in STD_LOGIC_VECTOR(width-1 downto 0);
			s: in STD_LOGIC;
			y: out STD_LOGIC_VECTOR(width-1 downto 0));
	end component;

begin

	-- Mux alterna entre aluoutw e regdataw
	mux2_0 : mux2 port map (d0 => aluoutw, d1 => readdataw, s => memtoregw, y => resultgwb);
	
	regwritewb <= regwritew;
	writeregwb <= writeregw;
	
end instrwb_arc;
