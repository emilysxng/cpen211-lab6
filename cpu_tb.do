onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_tb/in
add wave -noupdate /cpu_tb/clk
add wave -noupdate /cpu_tb/load
add wave -noupdate /cpu_tb/out
add wave -noupdate /cpu_tb/N
add wave -noupdate /cpu_tb/V
add wave -noupdate /cpu_tb/Z
add wave -noupdate /cpu_tb/w
add wave -noupdate /cpu_tb/reset
add wave -noupdate /cpu_tb/s
add wave -noupdate /cpu_tb/nsel
add wave -noupdate /cpu_tb/opcode
add wave -noupdate /cpu_tb/Rn
add wave -noupdate /cpu_tb/Rd
add wave -noupdate /cpu_tb/Rm
add wave -noupdate /cpu_tb/expected_opcode
add wave -noupdate /cpu_tb/expected_Rd
add wave -noupdate /cpu_tb/expected_Rm
add wave -noupdate /cpu_tb/expected_Rn
add wave -noupdate /cpu_tb/op
add wave -noupdate /cpu_tb/shift
add wave -noupdate /cpu_tb/expected_op
add wave -noupdate /cpu_tb/expected_shift
add wave -noupdate /cpu_tb/expected_ALUop
add wave -noupdate /cpu_tb/ALUop
add wave -noupdate /cpu_tb/vsel
add wave -noupdate /cpu_tb/expected_imm8
add wave -noupdate /cpu_tb/imm8
add wave -noupdate /cpu_tb/expected_sximm8
add wave -noupdate /cpu_tb/sximm8
add wave -noupdate /cpu_tb/expected_in
add wave -noupdate /cpu_tb/current_instruction
add wave -noupdate /cpu_tb/err
add wave -noupdate /cpu_tb/asel
add wave -noupdate /cpu_tb/bsel
add wave -noupdate /cpu_tb/loada
add wave -noupdate /cpu_tb/loadb
add wave -noupdate /cpu_tb/loadc
add wave -noupdate /cpu_tb/write
add wave -noupdate /cpu_tb/loads
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {400 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {1 ns}
