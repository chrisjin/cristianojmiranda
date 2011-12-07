echo Cleaning...
ghdl --clean
ghdl --remove

echo Compiling...
ghdl -a --ieee=synopsys rf.vhd
ghdl -a --ieee=synopsys adder.vhd
ghdl -a --ieee=synopsys flop.vhd
ghdl -a --ieee=synopsys flopr.vhd
ghdl -a --ieee=synopsys floprs.vhd
ghdl -a --ieee=synopsys mux2.vhd
ghdl -a --ieee=synopsys sl2.vhd
ghdl -a --ieee=synopsys alu.vhd
ghdl -a --ieee=synopsys signext.vhd
ghdl -a --ieee=synopsys controller.vhd
ghdl -a --ieee=synopsys datamem.vhd
ghdl -a --ieee=synopsys instrmem.vhd
ghdl -a --ieee=synopsys instrfetch.vhd
ghdl -a --ieee=synopsys instrdec.vhd
ghdl -a --ieee=synopsys instrexec.vhd
ghdl -a --ieee=synopsys imem.vhd
ghdl -a --ieee=synopsys instrwb.vhd
ghdl -a --ieee=synopsys datapath.vhd
ghdl -a --ieee=synopsys mips.vhd
ghdl -a --ieee=synopsys tb_adder.vhd
ghdl -a --ieee=synopsys tb_flop.vhd
ghdl -a --ieee=synopsys tb_flopr.vhd
ghdl -a --ieee=synopsys tb_floprs.vhd
ghdl -a --ieee=synopsys tb_rf.vhd
ghdl -a --ieee=synopsys tb_instrfetch.vhd
ghdl -a --ieee=synopsys tb_instrmem.vhd
ghdl -a --ieee=synopsys tb_imem.vhd

ghdl -e --ieee=synopsys rf
ghdl -e --ieee=synopsys adder
ghdl -e --ieee=synopsys flop
ghdl -e --ieee=synopsys flopr
ghdl -e --ieee=synopsys floprs
ghdl -e --ieee=synopsys sl2
ghdl -e --ieee=synopsys mux2
ghdl -e --ieee=synopsys alu
ghdl -e --ieee=synopsys signext
ghdl -e --ieee=synopsys controller
ghdl -e --ieee=synopsys datamem
ghdl -e --ieee=synopsys instrmem
ghdl -e --ieee=synopsys instrfetch
ghdl -e --ieee=synopsys instrdec
ghdl -e --ieee=synopsys instrexec
ghdl -e --ieee=synopsys imem
ghdl -e --ieee=synopsys instrwb
ghdl -e --ieee=synopsys datapath
ghdl -e --ieee=synopsys mips
ghdl -e --ieee=synopsys tb_adder
ghdl -e --ieee=synopsys tb_flop
ghdl -e --ieee=synopsys tb_flopr
ghdl -e --ieee=synopsys tb_floprs
ghdl -e --ieee=synopsys tb_rf
ghdl -e --ieee=synopsys tb_instrmem
ghdl -e --ieee=synopsys tb_instrfetch
ghdl -e --ieee=synopsys tb_imem

echo Running...
--ghdl -r --ieee=synopsys tb_flop
--ghdl -r --ieee=synopsys tb_flopr
--ghdl -r --ieee=synopsys tb_floprs
--ghdl -r --ieee=synopsys tb_adder
--ghdl -r --ieee=synopsys tb_rf
--ghdl -r --ieee=synopsys tb_instrmem
--ghdl -r --ieee=synopsys tb_instrfetch
ghdl -r --ieee=synopsys tb_imem

pause