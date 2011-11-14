echo Cleaning...
ghdl --clean
ghdl --remove

echo Compiling...
ghdl -a --ieee=synopsys adder.vhd
ghdl -a --ieee=synopsys alu.vhd
ghdl -a --ieee=synopsys tb_adder.vhd
ghdl -a --ieee=synopsys tb_alu.vhd

ghdl -e --ieee=synopsys adder
ghdl -e --ieee=synopsys alu

ghdl -e --ieee=synopsys tb_adder
ghdl -e --ieee=synopsys tb_alu

pause