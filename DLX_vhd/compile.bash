rm -r work
setmentor
vlib work
vcom 000-globals.vhd
vcom a-Log2.vhd
vcom a.c-IRAM.vhd
vcom a.b-DataPath.core/a.b.a-ALU.vhd
vcom a.b-DataPath.core/a.b.c-adder.vhd
vcom a.b-DataPath.core/a.b.c-extender.vhd
vcom a.b-DataPath.core/a.b.c-mem.vhd
vcom a.b-DataPath.core/a.b.c-mux21.vhd
vcom a.b-DataPath.core/a.b.c-register.vhd
vcom a.b-DataPath.core/a.b.c-registerfile.vhd
vcom DP_test/DP_for_testing.vhd
vcom DP_test/DP_CU_for_testing.vhd
vcom DP_test/DP_CU_TB.vhd
vsim work.DP_CU_TB -t 10ps
