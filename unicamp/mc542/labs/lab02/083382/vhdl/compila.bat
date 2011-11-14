echo Cleaning...
ghdl --clean
ghdl --remove

echo Compiling...
ghdl -a --ieee=synopsys alu.vhd

ghdl -e --ieee=synopsys alu

pause