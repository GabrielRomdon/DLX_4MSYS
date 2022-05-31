if [file exists "work"] {vdel -all}
vlib work

vcom -mixedsvvh -f compile_vhdl.f
#vcom -mixedsvvh -f compile_synth.f
vlog -mixedsvvh -f compile.f

vsim top -coverage +UVM_TESTNAME=normal_test +UVM_VERBOSITY=UVM_LOW
#vsim top -coverage +UVM_TESTNAME=normal_test +UVM_VERBOSITY=UVM_LOW -L /software/dk/nangate45/verilog/qsim10.7c/

puts "\n########## SIMULATION STARTS ##########\n"
run -all
puts "\n##########  SIMULATION ENDS  ##########\n"
exit
