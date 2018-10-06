config wave -signalnamewidth 1
config list -signalnamewidth 1
config wave -vectorcolor yellow

# clock/reset
add wave -divider "Clock/Reset"

add wave sim:/tb_control/control_top/clk
add wave sim:/tb_control/control_top/reset

add wave -divider ""

# control signals
add wave -divider "Control"

add wave -group "Control signals" \
    sim:/tb_control/control_top/processor/PCWrite \
    sim:/tb_control/control_top/processor/PCWrite \
    sim:/tb_control/control_top/processor/PCWriteCond \
    sim:/tb_control/control_top/processor/PCSource \
    sim:/tb_control/control_top/processor/ALUSrcA \
    sim:/tb_control/control_top/processor/ALUSrcB \
    sim:/tb_control/control_top/processor/ALUOp \
    sim:/tb_control/control_top/processor/LoadAOut \
    sim:/tb_control/control_top/processor/RegWrite \
    sim:/tb_control/control_top/processor/LoadRegA \
    sim:/tb_control/control_top/processor/LoadRegB \
    sim:/tb_control/control_top/processor/MemToReg \
    sim:/tb_control/control_top/processor/DMemOp \
    sim:/tb_control/control_top/processor/LoadMDR \
    sim:/tb_control/control_top/processor/IMemRead \
    sim:/tb_control/control_top/processor/IRWrite

add wave -group "Instruction" \
    sim:/tb_control/control_top/instruction \
    sim:/tb_control/control_top/funct7 \
    sim:/tb_control/control_top/funct3 \
    sim:/tb_control/control_top/opcode

# processing signals

add wave -divider "States"
add wave -group "States" \
    sim:/tb_control/control_top/state \
    sim:/tb_control/control_top/next_state

add wave -divider "ALU"
add wave -group "ALU" \
    sim:/tb_control/control_top/processor/alu/funct \
    sim:/tb_control/control_top/processor/alu/a \
    sim:/tb_control/control_top/processor/alu/b \
    sim:/tb_control/control_top/processor/alu/result \
    sim:/tb_control/control_top/processor/alu/res

add wave -divider "Multiplexers"
add wave -group "MUX PC" sim:/tb_control/control_top/processor/mux_PC/*
add wave -group "MUX ALU A" sim:/tb_control/control_top/processor/mux_ALU_A/*
add wave -group "MUX ALU B" sim:/tb_control/control_top/processor/mux_ALU_B/*
add wave -group "MUX Reg File" sim:/tb_control/control_top/processor/mux_reg_file/*

add wave -divider "Registers"
add wave -group "PC" sim:/tb_control/control_top/processor/program_counter/*
add wave -group "Reg File" sim:/tb_control/control_top/processor/reg_file/registers
add wave -group "Instr Reg" sim:/tb_control/control_top/processor/instr_reg/*
add wave -group "Reg Mem Data" sim:/tb_control/control_top/processor/reg_mem_data/*
add wave -group "Reg ALU A" sim:/tb_control/control_top/processor/reg_ALU_a/*
add wave -group "Reg ALU B" sim:/tb_control/control_top/processor/reg_ALU_b/*

# watch signals
::add watch sim:/tb_control/control_top/processor/program_counter/r_data -radix decimal -radixenum default
::add watch sim:/tb_control/control_top/processor/alu/b -radix decimal -radixenum default
::add watch sim:/tb_control/control_top/processor/alu/result -radix decimal -radixenum default
::add watch sim:/tb_control/control_top/state -radix default -radixenum default
::add watch sim:/tb_control/control_top/processor/reg_file/registers -radix decimal -radixenum default
::add watch sim:/tb_control/control_top/processor/alu/ops -radix default -radixenum default
::add watch sim:/tb_control/control_top/processor/alu/a -radix decimal -radixenum default

# state machine list
add list -width 30 \
    sim:/tb_control/control_top/state \
    sim:/tb_control/control_top/next_state 
# pc
# add list  clk -notrigger sim:/tb_control/control_top/processor/pc_data
# alu
# add list sim:/tb_control/control_top/processor/alu/a 
# add list sim:/tb_control/control_top/processor/alu/b 
# add list -width 10 sim:/tb_control/control_top/processor/alu/ops 
# add list sim:/tb_control/control_top/processor/alu/result 


