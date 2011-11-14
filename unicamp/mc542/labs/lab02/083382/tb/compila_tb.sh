ghdl --clean
ghdl --remove

ghdl -a --ieee=synopsys adder.vhd
ghdl -a --ieee=synopsys alu.vhd
ghdl -a --ieee=synopsys tb_adder.vhd
ghdl -a --ieee=synopsys tb_alu.vhd

ghdl -e --ieee=synopsys adder
ghdl -e --ieee=synopsys alu