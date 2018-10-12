config wave -signalnamewidth 1
config list -signalnamewidth 1
config wave -vectorcolor gray -rowmargin 8

# define opcode radix

radix define Opcode {
     7'b0010011 "ALU IMM", -color orange
     7'b0000011 "LOAD", -color cyan
     7'b0010011 "NOP", -color red
     7'b1100111 "JALR", -color green
     7'b0100011 "SD", -color cyan
     7'b0110011 "TYPE_R", -color orange
     7'b0100011 "TYPE_S", -color cyan
     7'b1100111 "TYPE_SB", -color green
     7'b0110111 "TYPE_U", -color cyan
     7'b1101111 "TYPE_UJ", -color green
     7'b1110011 "BREAK", -color red
     -default binary
}

radix define ALU {
     3'b000 "SUM", -color orange
     3'b001 "SHIFT LEFT", -color green
     3'b010 "SUB", -color orange
     3'b011 "LOAD", -color cyan
     3'b100 "XOR", -color green
     3'b101 "SHIFT_RIGHT", -color green
     3'b110 "NOT", -color green
     3'b111 "AND", -color green
     -default binary
}

echo "opcode colors:\nalu ops = orange\nload/store = cyan\nnop/break = read\njump/branch = green\n"

echo "alu colors:\nsum/sub = orange\nbitwise = green\nload = cyan"

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

add wave -group "Control signals" -binary \
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
    -radix Opcode tb_control/control_top/opcode \
    -color white tb_control/control_top/funct7 \
    -color white tb_control/control_top/funct3 \
    -label "rs1" -color gray -unsigned {tb_control/control_top/instruction[19:15]} \
    -label "rs2" -color gray -unsigned {tb_control/control_top/instruction[24:20]} \
    -label "rd"  -color gray -unsigned {tb_control/control_top/instruction[11:7]} \
    -label "instruction" -binary tb_control/control_top/instruction

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
    -color yellow -radix ALU tb_control/control_top/processor/alu/funct \
    -color gray -decimal tb_control/control_top/processor/alu/a \
    tb_control/control_top/processor/alu/b \
    -color cyan tb_control/control_top/processor/alu/result
add wave -group "Sign extend" \
     -label "in" tb_control/control_top/processor/sign_extend/i_num \
     -label "out" -color cyan tb_control/control_top/processor/sign_extend/o_extended \
     -label "opcode" -color gray -radix Opcode tb_control/control_top/processor/sign_extend/opcode 


# ==================================================
# ====---==--==-|| « Multiplexers » ||-==--==---====

add wave -divider "Multiplexers"
add wave -group "MUX PC" -color gray \
    -label "\[0\] alu" tb_control/control_top/processor/mux_PC/i_0 \
    -label "\[1\] reg alu" tb_control/control_top/processor/mux_PC/i_0 \
    -label "sel" -color yellow -unsigned tb_control/control_top/processor/mux_PC/i_select \
    -label "out" -color cyan tb_control/control_top/processor/mux_PC/i_0

add wave -group "MUX ALU A" -color gray \
    -label "\[0\] pc" tb_control/control_top/processor/mux_ALU_A/i_0 \
    -label "\[1\] reg A" tb_control/control_top/processor/mux_ALU_A/i_1 \
    -label "sel" -color yellow -unsigned tb_control/control_top/processor/mux_ALU_A/i_select \
    -label "out" -color cyan tb_control/control_top/processor/mux_ALU_A/o_select

add wave -group "MUX ALU B" -color gray \
    -label "\[0\] reg B" tb_control/control_top/processor/mux_ALU_B/i_0 \
    -label "\[1\] const 4" tb_control/control_top/processor/mux_ALU_B/i_1 \
    -label "\[2\] imm" tb_control/control_top/processor/mux_ALU_B/i_2 \
    -label "\[3\] imm << 1" tb_control/control_top/processor/mux_ALU_B/i_3 \
    -label "sel" -color yellow -unsigned tb_control/control_top/processor/mux_ALU_B/i_select \
    -label "out" -color cyan tb_control/control_top/processor/mux_ALU_B/o_select

add wave -group "MUX Reg File" -color gray \
    -label "\[0\] alu" tb_control/control_top/processor/mux_reg_file/i_0 \
    -label "\[1\] mem" tb_control/control_top/processor/mux_reg_file/i_1 \
    -label "sel" -color yellow -unsigned tb_control/control_top/processor/mux_reg_file/i_select \
    -label "out" -color cyan tb_control/control_top/processor/mux_reg_file/o_select


# ===============================================
# ====---==--==-|| « Registers » ||-==--==---====

add wave -divider "Registers"
add wave -group "PC" \
    -color cyan tb_control/control_top/processor/program_counter/r_data \
    -color green tb_control/control_top/processor/program_counter/w_data \
    -color yellow tb_control/control_top/processor/program_counter/load
add wave -group "Reg File" \
    -color cyan tb_control/control_top/processor/reg_file/registers \
    -color yellow tb_control/control_top/processor/reg_file/reg_write \
    -color white -unsigned tb_control/control_top/processor/reg_file/w_reg \
    -unsigned tb_control/control_top/processor/reg_file/r_reg1 \
    -unsigned tb_control/control_top/processor/reg_file/r_reg2 \
    -color gray tb_control/control_top/processor/reg_file/w_data \
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


