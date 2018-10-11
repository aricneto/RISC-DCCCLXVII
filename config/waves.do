config wave -signalnamewidth 1
config list -signalnamewidth 1
config wave -vectorcolor yellow -rowmargin 8

# state machine list
add list -width 30 \
    tb_control/control_top/state \
     -notrigger tb_control/control_top/next_state 

# clock/reset
add wave tb_control/control_top/reset
add wave tb_control/control_top/clk
add wave -color cyan -label "PC" tb_control/control_top/processor/program_counter/r_data
add wave -color yellow -label "state" tb_control/control_top/state

add wave -divider ""

# control signals
add wave -divider "Control"

add wave -group "Control signals" \
    tb_control/control_top/processor/PCWrite \
    tb_control/control_top/processor/PCWrite \
    tb_control/control_top/processor/PCWriteCond \
    tb_control/control_top/processor/PCSource \
    tb_control/control_top/processor/ALUSrcA \
    tb_control/control_top/processor/ALUSrcB \
    tb_control/control_top/processor/ALUOp \
    tb_control/control_top/processor/LoadAOut \
    tb_control/control_top/processor/RegWrite \
    tb_control/control_top/processor/LoadRegA \
    tb_control/control_top/processor/LoadRegB \
    tb_control/control_top/processor/MemToReg \
    tb_control/control_top/processor/DMemOp \
    tb_control/control_top/processor/LoadMDR \
    tb_control/control_top/processor/IMemRead \
    tb_control/control_top/processor/IRWrite

add wave -group "Instruction" -radix binary \
    tb_control/control_top/instruction \
    tb_control/control_top/funct7 \
    tb_control/control_top/funct3 \
    tb_control/control_top/opcode \
    -label "rs1" -color cyan -decimal {tb_control/control_top/instruction[19:15]} \
    -label "rs2" -color cyan -decimal {tb_control/control_top/instruction[24:20]} \
    -label "rd"  -color cyan -decimal {tb_control/control_top/instruction[11:7]}

add wave -group "Immediate" -decimal \
    -label "type i" {tb_control/control_top/instruction[31:20]} \
    -label "type s" {tb_control/control_top/instruction[31:25] & tb_control/control_top/instruction[11:7]} \
    -label "type sb" {tb_control/control_top/instruction[31] & tb_control/control_top/instruction[7] & tb_control/control_top/instruction[30:25] & tb_control/control_top/instruction[11:8]} \
    -label "type u" {tb_control/control_top/instruction[31:12]} \
    -label "type uj" {tb_control/control_top/instruction[31] & tb_control/control_top/instruction[20:12] & tb_control/control_top/instruction[21] & tb_control/control_top/instruction[30:22]}

# processing signals

add wave -divider "States"
add wave -group "States" \
    tb_control/control_top/state \
    tb_control/control_top/next_state

add wave -divider "ALU"
add wave -group "ALU" \
    tb_control/control_top/processor/alu/funct \
    tb_control/control_top/processor/alu/a \
    tb_control/control_top/processor/alu/b \
    tb_control/control_top/processor/alu/result \
    tb_control/control_top/processor/alu/res
add wave -group "Sign extend" tb_control/control_top/processor/sign_extend/*


# ==================================================
# ====---==--==-|| « Multiplexers » ||-==--==---====

add wave -divider "Multiplexers"
add wave -group "MUX PC" -color green \
    -label "\[0\] alu" tb_control/control_top/processor/mux_PC/i_0 \
    -label "\[1\] reg alu" tb_control/control_top/processor/mux_PC/i_0 \
    -label "sel" -color red -unsigned tb_control/control_top/processor/mux_PC/i_select \
    -label "out" -color yellow tb_control/control_top/processor/mux_PC/i_0

add wave -group "MUX ALU A" -color green \
    -label "\[0\] pc" tb_control/control_top/processor/mux_ALU_A/i_0 \
    -label "\[1\] reg A" tb_control/control_top/processor/mux_ALU_A/i_1 \
    -label "sel" -color red -unsigned tb_control/control_top/processor/mux_ALU_A/i_select \
    -label "out" -color yellow tb_control/control_top/processor/mux_ALU_A/o_select

add wave -group "MUX ALU B" -color green \
    -label "\[0\] reg B" tb_control/control_top/processor/mux_ALU_B/i_0 \
    -label "\[1\] const 4" tb_control/control_top/processor/mux_ALU_B/i_1 \
    -label "\[2\] imm" tb_control/control_top/processor/mux_ALU_B/i_2 \
    -label "\[3\] imm << 1" tb_control/control_top/processor/mux_ALU_B/i_3 \
    -label "sel" -color red -unsigned tb_control/control_top/processor/mux_ALU_B/i_select \
    -label "out" -color yellow tb_control/control_top/processor/mux_ALU_B/o_select

add wave -group "MUX Reg File" -color green \
    -label "\[0\] alu" tb_control/control_top/processor/mux_reg_file/i_0 \
    -label "\[1\] mem" tb_control/control_top/processor/mux_reg_file/i_1 \
    -label "sel" -color red -unsigned tb_control/control_top/processor/mux_reg_file/i_select \
    -label "out" -color yellow tb_control/control_top/processor/mux_reg_file/o_select


# ===============================================
# ====---==--==-|| « Registers » ||-==--==---====

add wave -divider "Registers"
add wave -group "PC" \
    -color cyan tb_control/control_top/processor/program_counter/r_data \
    -color green tb_control/control_top/processor/program_counter/w_data \
    -color yellow tb_control/control_top/processor/program_counter/load
add wave -group "Reg File" \
    -color cyan tb_control/control_top/processor/reg_file/registers \
    -color red tb_control/control_top/processor/reg_file/reg_write \
    -color yellow -unsigned tb_control/control_top/processor/reg_file/w_reg \
    -unsigned tb_control/control_top/processor/reg_file/r_reg1 \
    -unsigned tb_control/control_top/processor/reg_file/r_reg2 \
    -color green tb_control/control_top/processor/reg_file/w_data \
    -decimal tb_control/control_top/processor/reg_file/r_data1 \
    -decimal tb_control/control_top/processor/reg_file/r_data2 
add wave -group "Instr Reg" -binary tb_control/control_top/processor/instr_reg/*
add wave -group "Reg Mem Data" tb_control/control_top/processor/reg_mem_data/*
add wave -group "Reg ALU A" tb_control/control_top/processor/reg_ALU_a/*
add wave -group "Reg ALU B" tb_control/control_top/processor/reg_ALU_b/*

# watch signals
# ::add watch tb_control/control_top/processor/program_counter/r_data -radix decimal -radixenum # default
# ::add watch tb_control/control_top/processor/alu/b -radix decimal -radixenum default
# ::add watch tb_control/control_top/processor/alu/result -radix decimal -radixenum default
# ::add watch tb_control/control_top/state -radix default -radixenum default
# ::add watch tb_control/control_top/processor/reg_file/registers -radix decimal -radixenum # default
# ::add watch tb_control/control_top/processor/alu/ops -radix default -radixenum default
# ::add watch tb_control/control_top/processor/alu/a -radix decimal -radixenum default

# pc
# add list  clk -notrigger tb_control/control_top/processor/pc_data
# alu
# add list tb_control/control_top/processor/alu/a 
# add list tb_control/control_top/processor/alu/b 
# add list -width 10 tb_control/control_top/processor/alu/ops 
# add list tb_control/control_top/processor/alu/result 


