if [file exists "work"] {
    vdel -all
}

vlib work

vcom -mixedsvvh -f compile_vhdl.f
vlog -mixedsvvh -f compile.f

vsim work.alu_tb

#do wave.do

puts "\n########## SIMULATION STARTS ##########\n"
run -all
puts "\n##########  SIMULATION ENDS  ##########\n"
exit
