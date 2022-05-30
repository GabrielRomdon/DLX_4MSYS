if [file exists "work"] {vdel -all}
vlib work

vcom -mixedsvvh -f compile_vhdl.f
vlog -mixedsvvh -f compile.f

vsim top -coverage +UVM_TESTNAME=normal_test +UVM_VERBOSITY=UVM_LOW

puts "\n########## SIMULATION STARTS ##########\n"
run -all
puts "\n##########  SIMULATION ENDS  ##########\n"
exit
