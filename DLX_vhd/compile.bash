rm -r work
setmentor
vlib work
vcom 000-globals.vhd
vcom a-Log2.vhd
vcom test_bench/IRAM_for_DPtest.vhd
vcom a.b-DataPath.core/a.b.a-ALU.vhd
vcom a.b-DataPath.core/a.b.c-adder.vhd
vcom a.b-DataPath.core/a.b.c-extender.vhd
vcom a.b-DataPath.core/a.b.c-mem.vhd
vcom a.b-DataPath.core/a.b.c-mux21.vhd
vcom a.b-DataPath.core/a.b.c-register.vhd
vcom a.b-DataPath.core/a.b.c-registerfile.vhd
vcom a.b-DataPath.vhd
vcom a.a-CU_HW.vhd
vcom test_bench/TB_DP_and_CU.vhd
vsim work.DP_CU_TB -t 10ps

