onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_dlx/U1/CLK
add wave -noupdate /tb_dlx/U1/RST
add wave -noupdate /tb_dlx/U1/PC_BUS
add wave -noupdate /tb_dlx/U1/current_PC
add wave -noupdate /tb_dlx/U1/next_IW
add wave -noupdate /tb_dlx/U1/current_IW
add wave -noupdate -group {Control signals} /tb_dlx/U1/IR_LATCH_EN
add wave -noupdate -group {Control signals} /tb_dlx/U1/NPC_LATCH_EN
add wave -noupdate -group {Control signals} /tb_dlx/U1/RegA_LATCH_EN
add wave -noupdate -group {Control signals} /tb_dlx/U1/RegB_LATCH_EN
add wave -noupdate -group {Control signals} /tb_dlx/U1/RegIMM_LATCH_EN
add wave -noupdate -group {Control signals} /tb_dlx/U1/SIGNED_IMM
add wave -noupdate -group {Control signals} /tb_dlx/U1/MUXA_SEL
add wave -noupdate -group {Control signals} /tb_dlx/U1/MUXB_SEL
add wave -noupdate -group {Control signals} /tb_dlx/U1/ALU_OUTREG_EN
add wave -noupdate -group {Control signals} /tb_dlx/U1/EQ_COND
add wave -noupdate -group {Control signals} /tb_dlx/U1/IS_JUMP
add wave -noupdate -group {Control signals} /tb_dlx/U1/ALU_OPCODE
add wave -noupdate -group {Control signals} /tb_dlx/U1/JUMP_EN
add wave -noupdate -group {Control signals} /tb_dlx/U1/PC_LATCH_EN
add wave -noupdate -group {Control signals} /tb_dlx/U1/WB_MUX_SEL
add wave -noupdate -group {Control signals} /tb_dlx/U1/RF_WE
add wave -noupdate -group RegisterFile /tb_dlx/U1/DP/RF/ADD_WR
add wave -noupdate -group RegisterFile /tb_dlx/U1/DP/RF/ADD_RD1
add wave -noupdate -group RegisterFile /tb_dlx/U1/DP/RF/ADD_RD2
add wave -noupdate -group RegisterFile /tb_dlx/U1/DP/RF/DATAIN
add wave -noupdate -group RegisterFile /tb_dlx/U1/DP/RF/OUT1
add wave -noupdate -group RegisterFile /tb_dlx/U1/DP/RF/OUT2
add wave -noupdate -group RegisterFile -expand /tb_dlx/U1/DP/RF/REGISTERS
add wave -noupdate -group DataPath /tb_dlx/U1/DP/IR_IN
add wave -noupdate -group DataPath /tb_dlx/U1/DP/PC_BUS
add wave -noupdate -group DataPath /tb_dlx/U1/DP/current_PC
add wave -noupdate -group DataPath /tb_dlx/U1/DP/next_PC
add wave -noupdate -group DataPath /tb_dlx/U1/DP/current_NPC
add wave -noupdate -group DataPath /tb_dlx/U1/DP/next_NPC
add wave -noupdate -group DataPath /tb_dlx/U1/DP/current_IW
add wave -noupdate -group DataPath /tb_dlx/U1/DP/WB1_IN
add wave -noupdate -group DataPath /tb_dlx/U1/DP/WB2_IN
add wave -noupdate -group DataPath /tb_dlx/U1/DP/WB2_OUT
add wave -noupdate -group DataPath /tb_dlx/U1/DP/WB3_OUT
add wave -noupdate -group DataPath /tb_dlx/U1/DP/IMM_IN
add wave -noupdate -group DataPath /tb_dlx/U1/DP/A_OUT
add wave -noupdate -group DataPath /tb_dlx/U1/DP/B_OUT
add wave -noupdate -group DataPath /tb_dlx/U1/DP/IMM_OUT
add wave -noupdate -group DataPath /tb_dlx/U1/DP/PC_MUX_SEL
add wave -noupdate -group DataPath /tb_dlx/U1/DP/branch_taken
add wave -noupdate -group DataPath /tb_dlx/U1/DP/WB_DATA
add wave -noupdate -group DataPath /tb_dlx/U1/DP/ALU_OP1
add wave -noupdate -group DataPath /tb_dlx/U1/DP/ALU_OP2
add wave -noupdate -group DataPath /tb_dlx/U1/DP/next_ALU_OUT
add wave -noupdate -group DataPath /tb_dlx/U1/DP/current_ALU_OUT
add wave -noupdate -group DataPath /tb_dlx/U1/DP/current_ALU_OUT2
add wave -noupdate -group DataPath /tb_dlx/U1/DP/current_RAM_OUT
add wave -noupdate -group ControlUnit /tb_dlx/U1/CU/IR_IN
add wave -noupdate -group ControlUnit /tb_dlx/U1/CU/cw_mem
add wave -noupdate -group ControlUnit /tb_dlx/U1/CU/IR_opcode
add wave -noupdate -group ControlUnit /tb_dlx/U1/CU/IR_func
add wave -noupdate -group ControlUnit -radix binary /tb_dlx/U1/CU/cw
add wave -noupdate -group ControlUnit -radix binary /tb_dlx/U1/CU/cw1
add wave -noupdate -group ControlUnit -radix binary /tb_dlx/U1/CU/cw2
add wave -noupdate -group ControlUnit -radix binary /tb_dlx/U1/CU/cw3
add wave -noupdate -group ControlUnit -radix binary /tb_dlx/U1/CU/cw4
add wave -noupdate -group ControlUnit -radix binary /tb_dlx/U1/CU/cw5
add wave -noupdate -group ControlUnit /tb_dlx/U1/CU/aluOpcode_i
add wave -noupdate -group ControlUnit /tb_dlx/U1/CU/aluOpcode1
add wave -noupdate -group DRAM /tb_dlx/DMEM/EN
add wave -noupdate -group DRAM /tb_dlx/DMEM/RD
add wave -noupdate -group DRAM /tb_dlx/DMEM/WR
add wave -noupdate -group DRAM /tb_dlx/DMEM/ADDR
add wave -noupdate -group DRAM /tb_dlx/DMEM/DATA_IN
add wave -noupdate -group DRAM /tb_dlx/DMEM/DATA_OUT
add wave -noupdate -group DRAM /tb_dlx/DMEM/DATAMEM
add wave -noupdate -group IRAM /tb_dlx/IMEM/Addr
add wave -noupdate -group IRAM /tb_dlx/IMEM/Dout
add wave -noupdate -group IRAM /tb_dlx/IMEM/IRAM_mem
add wave -noupdate -group IRAM /tb_dlx/IMEM/Addr_shifted
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {116800 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 212
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {117600 ps} {134340 ps}
