config wave -signalnamewidth 1
config list -signalnamewidth 1
config wave -vectorcolor yellow -rowmargin 8


# clock/reset
add wave sim:/tb_control/control_top/reset
add wave sim:/tb_control/control_top/clk
add wave -color cyan -label "PC" sim:/tb_control/control_top/processor/program_counter/r_data
add wave -color yellow -label "state" sim:/tb_control/control_top/state

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

add wave -group "Instruction" -radix binary \
    sim:/tb_control/control_top/instruction \
    sim:/tb_control/control_top/funct7 \
    sim:/tb_control/control_top/funct3 \
    sim:/tb_control/control_top/opcode \
    -label "imm" -decimal {sim:/tb_control/control_top/instruction[31:20]}

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
add wave -group "Sign extend" sim:/tb_control/control_top/processor/sign_extend/*


# ==================================================
# ====---==--==-|| « Multiplexers » ||-==--==---====

add wave -divider "Multiplexers"
add wave -group "MUX PC" -color green \
    -label "\[0\] alu" sim:/tb_control/control_top/processor/mux_PC/i_0 \
    -label "\[1\] reg alu" sim:/tb_control/control_top/processor/mux_PC/i_0 \
    -label "sel" -color red -unsigned sim:/tb_control/control_top/processor/mux_PC/i_select \
    -label "out" -color yellow sim:/tb_control/control_top/processor/mux_PC/i_0

add wave -group "MUX ALU A" -color green \
    -label "\[0\] pc" sim:/tb_control/control_top/processor/mux_ALU_A/i_0 \
    -label "\[1\] reg A" sim:/tb_control/control_top/processor/mux_ALU_A/i_1 \
    -label "sel" -color red -unsigned sim:/tb_control/control_top/processor/mux_ALU_A/i_select \
    -label "out" -color yellow sim:/tb_control/control_top/processor/mux_ALU_A/o_select

add wave -group "MUX ALU B" -color green \
    -label "\[0\] reg B" sim:/tb_control/control_top/processor/mux_ALU_B/i_0 \
    -label "\[1\] const 4" sim:/tb_control/control_top/processor/mux_ALU_B/i_1 \
    -label "\[2\] imm" sim:/tb_control/control_top/processor/mux_ALU_B/i_2 \
    -label "\[3\] imm << 1" sim:/tb_control/control_top/processor/mux_ALU_B/i_3 \
    -label "sel" -color red -unsigned sim:/tb_control/control_top/processor/mux_ALU_B/i_select \
    -label "out" -color yellow sim:/tb_control/control_top/processor/mux_ALU_B/o_select

add wave -group "MUX Reg File" -color green \
    -label "\[0\] alu" sim:/tb_control/control_top/processor/mux_reg_file/i_0 \
    -label "\[1\] mem" sim:/tb_control/control_top/processor/mux_reg_file/i_1 \
    -label "sel" -color red -unsigned sim:/tb_control/control_top/processor/mux_reg_file/i_select \
    -label "out" -color yellow sim:/tb_control/control_top/processor/mux_reg_file/o_select


# ===============================================
# ====---==--==-|| « Registers » ||-==--==---====

add wave -divider "Registers"
add wave -group "PC" \
    -color cyan sim:/tb_control/control_top/processor/program_counter/r_data \
    -color green sim:/tb_control/control_top/processor/program_counter/w_data \
    -color yellow sim:/tb_control/control_top/processor/program_counter/load
add wave -group "Reg File" \
    -color cyan sim:/tb_control/control_top/processor/reg_file/registers \
    -color red sim:/tb_control/control_top/processor/reg_file/reg_write \
    -color yellow -unsigned sim:/tb_control/control_top/processor/reg_file/w_reg \
    -unsigned sim:/tb_control/control_top/processor/reg_file/r_reg1 \
    -unsigned sim:/tb_control/control_top/processor/reg_file/r_reg2 \
    -color green sim:/tb_control/control_top/processor/reg_file/w_data \
    -decimal sim:/tb_control/control_top/processor/reg_file/r_data1 \
    -decimal sim:/tb_control/control_top/processor/reg_file/r_data2 
add wave -group "Instr Reg" -binary sim:/tb_control/control_top/processor/instr_reg/*
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
     -notrigger sim:/tb_control/control_top/next_state 
# pc
# add list  clk -notrigger sim:/tb_control/control_top/processor/pc_data
# alu
# add list sim:/tb_control/control_top/processor/alu/a 
# add list sim:/tb_control/control_top/processor/alu/b 
# add list -width 10 sim:/tb_control/control_top/processor/alu/ops 
# add list sim:/tb_control/control_top/processor/alu/result 


