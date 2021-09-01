onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /alu_tb/aw/ALU_DUT/FUNC
add wave -noupdate -radix binary /alu_tb/aw/ALU_DUT/DATA1
add wave -noupdate -radix binary /alu_tb/aw/ALU_DUT/DATA2
add wave -noupdate -radix binary /alu_tb/aw/ALU_DUT/OUTALU
TreeUpdate [SetDefaultTree]
WaveRestoreCursors
quietly wave cursor active 0
configure wave -namecolwidth 229
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {184 ns}
