vlib work

#Include files and compile them
vcom "mlite_pack.vhd"
vcom "my_package.vhd"
vcom "alu.vhd"
vcom "mult.vhd"
vcom "shifter.vhd"
vcom "testbench.vhd"

# Start simulation
vsim work.testbench

# Draw waves

# Run simulation
run 2000000 ns

quit
