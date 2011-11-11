echo Cleaning...
ghdl --clean
ghdl --remove

echo Compiling...
ghdl -a --ieee=synopsys rf.vhd
ghdl -a --ieee=synopsys tb_rf.vhd

ghdl -e --ieee=synopsys rf
ghdl -e --ieee=synopsys tb_rf

echo Running...
ghdl -r --ieee=synopsys tb_rf

pause