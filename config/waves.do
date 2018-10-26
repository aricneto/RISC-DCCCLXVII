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

radix define Register {
     5'd0 "[x0] zero", -color red
     5'd1 "[x1] ra", -color coral
     5'd2 "[x2] sp", -color orange
     5'd3 "[x3] gp", -color goldenrod
     5'd4 "[x4] tp", -color "aquamarine"
     5'd5 "[x5] t0", -color "aquamarine"
     5'd6 "[x6] t1", -color "aquamarine"
     5'd7 "[x7] t2", -color "aquamarine"
     5'd8 "[x8] s0/fp", -color "violet"
     5'd9 "[x9] s1", -color "violet"
     5'd10 "[x10] a0", -color "spring green"
     5'd11 "[x11] a1", -color "spring green"
     5'd12 "[x12] a2", -color "spring green"
     5'd13 "[x13] a3", -color "spring green"
     5'd14 "[x14] a4", -color "spring green"
     5'd15 "[x15] a5", -color "spring green"
     5'd16 "[x16] a6", -color "spring green"
     5'd17 "[x17] a7", -color "spring green"
     5'd18 "[x18] s2", -color "violet"
     5'd19 "[x19] s3", -color "violet"
     5'd20 "[x20] s4", -color "violet"
     5'd21 "[x21] s5", -color "violet"
     5'd22 "[x22] s6", -color "violet"
     5'd23 "[x23] s7", -color "violet"
     5'd24 "[x24] s8", -color "violet"
     5'd25 "[x25] s9", -color "violet"
     5'd26 "[x26] s10", -color "violet"
     5'd27 "[x27] s11", -color "violet"
     5'd28 "[x28] t3", -color "aquamarine"
     5'd29 "[x29] t4", -color "aquamarine"
     5'd30 "[x30] t5", -color "aquamarine"
     5'd31 "[x31] t6", -color "aquamarine"
     -default binary
}

radix define States {
     7'd0 "START", 
     7'd1 "FETCH", -color yellow
     7'd2 "DECODE", -color "spring green"
     7'd3 "MEM ADDRESS COMP",  -color white
     7'd4 "IMM ARITH", -color white
     7'd5 "EXECUTION TYPE R", -color white
     7'd6 "EXECUTION TYPE U", -color white
     7'd7 "ARITH COMPL", -color white
     7'd8 "BRANCH COMPL", -color violet
     7'd9 "MEM ACC LD", -color white
     7'd10 "WAIT READ DATA MEM", -color white
     7'd11 "WAIT READ INSTR MEM", -color white
     7'd12 "MEM ACC SD", -color white
     7'd13 "WRITE BACK" -color white
     7'd14 "JUMP COMPL JAL" -color violet
     7'd15 "JUMP COMPL JALR" -color violet
     7'd16 "JUMP EXEC" -color white
     7'd17 "TREAT BREAK" -color white
     7'd18 "END" -color red
     7'd19 "EXCEPT_OPCODE" -color red
     7'd20 "EXCEPT_OVERFLOW" -color red
     7'd21 "WAIT_READ_EXCEP" -color white
     -default decimal
     -defaultcolor cyan
}

radix define ALU {
     4'b0000 "SUM", -color orange
     4'b0001 "SHIFT LEFT", -color green
     4'b0010 "SUB", -color orange
     4'b0011 "LOAD", -color cyan
     4'b0100 "XOR", -color green
     4'b0101 "SHIFT_RIGHT", -color green
     4'b0110 "NOT", -color green
     4'b0111 "AND", -color green
     4'b1000 "SHIFT_LEFT_A", -color green
     4'b1001 "SHIFT_RIGHT_A", -color green
     -default binary
}

# {funct7, funct3, opcode}
radix define Instruction {
     // r-type
     17'b0000000_000_0110011 "ADD", -color orange
     17'b0100000_000_0110011 "SUB", -color orange
     17'b0000000_111_0110011 "AND", -color orange
     17'b0000000_010_0110011 "SLT", -color orange
     // i-type
     17'b???????_000_0010011 "ADDI", -color violet
     17'b0000000_101_0010011 "SRLI", -color violet
     17'b0100000_101_0010011 "SRAI", -color violet
     17'b0000000_001_0010011 "SLLI", -color violet
     17'b???????_010_0010011 "SLTI", -color violet
     17'b???????_000_1100111 "JALR", -color cyan
     17'b???????_011_0000011 "LD", -color yellow
     17'b???????_010_0000011 "LW", -color yellow
     17'b???????_100_0000011 "LBU", -color yellow
     17'b???????_001_0000011 "LH", -color yellow
     17'b???????_000_0010011 "NOP", -color green
     17'b???????_000_1110011 "BREAK", -color red
     // s-type
     17'b???????_111_0100011 "SD", -color "spring green"
     17'b???????_010_0100011 "SW", -color "spring green"
     17'b???????_001_0100011 "SH", -color "spring green"
     17'b???????_000_0100011 "SB", -color "spring green"
     // sb-type
     17'b???????_000_1100011 "BEQ", -color cyan
     17'b???????_001_1100011 "BNE", -color cyan
     17'b???????_101_1100011 "BGE", -color cyan
     17'b???????_100_1100011 "BLT", -color cyan
     // u-type
     17'b???????_???_0110111 "LUI", -color yellow
     // j-type
     17'b???????_???_1101111 "JAL", -color cyan
     -default binary
}

echo "==---==--===---==--=-==---==--=-|| «  » ||-=--==---==-=--==---===--==---==\n"
echo "````````````````````````````88bd88b``88b``d888b,`d8888b"
echo "````````````````````````````88P'`````88P`?8b,```d8P'``P"
echo "```````````````````````````d88``````d88`````?8b`88b````"
echo "``````````````````````````d88'`````d88'``?888P'``?888P'"
echo "\nWelcome to the RISC-DCCCLXVII architecture"
echo "\nIf you want to have a better view of the states, right click the bottom state wave on the wave list, and on \"radix\", select \"Numeric Enums\""

# state machine list
add list -width 30 \
    tb_control/control_top/state \
     -notrigger tb_control/control_top/next_state 

# clock/reset
add wave tb_control/control_top/reset
add wave tb_control/control_top/clk

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
    -label "rs1" -color white -radix Register {tb_control/control_top/instruction[19:15]} \
    -label "rs2" -color white -radix Register {tb_control/control_top/instruction[24:20]} \
    -label "rd"  -color white -radix Register {tb_control/control_top/instruction[11:7]} \
    -label "instruction" -binary tb_control/control_top/instruction

add wave -group "Immediate" -decimal \
    -label "type i" {tb_control/control_top/instruction[31:20]} \
    -label "type s" {tb_control/control_top/instruction[31:25] & tb_control/control_top/instruction[11:7]} \
    -label "type sb" {tb_control/control_top/instruction[31] & tb_control/control_top/instruction[7] & tb_control/control_top/instruction[30:25] & tb_control/control_top/instruction[11:8]} \
    -label "type u" {tb_control/control_top/instruction[31:12]} \
    -label "type uj" {tb_control/control_top/instruction[31] & tb_control/control_top/instruction[19:12] & tb_control/control_top/instruction[20] & tb_control/control_top/instruction[30:21]}

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
add wave -group "Reg ALUOut" \
     tb_control/control_top/processor/alu_out/load \
     tb_control/control_top/processor/alu_out/w_data \
     -color cyan tb_control/control_top/processor/alu_out/r_data

# ==================================================
# ====---==--==-|| « Multiplexers » ||-==--==---====

add wave -divider "Multiplexers"
add wave -group "MUX PC" -color gray \
    -label "\[0\] alu" tb_control/control_top/processor/mux_PC/i_0 \
    -label "\[1\] reg alu" tb_control/control_top/processor/mux_PC/i_0 \
    -label "\[2\] except" tb_control/control_top/processor/mux_PC/i_1 \
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
    -label "\[2\] PC" tb_control/control_top/processor/mux_reg_file/i_2 \
    -label "sel" -color yellow -unsigned tb_control/control_top/processor/mux_reg_file/i_select \
    -label "out" -color cyan tb_control/control_top/processor/mux_reg_file/o_select

add wave -group "MUX Mem Src" tb_control/control_top/processor/mux_mem_src/*
add wave -group "MUX Reg File" tb_control/control_top/processor/mux_cause/*


# ===============================================
# ====---==--==-|| « Registers » ||-==--==---====

add wave -divider "Registers"
add wave -group "PC" \
    -color cyan tb_control/control_top/processor/program_counter/r_data \
    -color green tb_control/control_top/processor/program_counter/w_data \
    -color yellow tb_control/control_top/processor/program_counter/load
add wave -group "Reg File" \
    -color cyan -decimal tb_control/control_top/processor/reg_file/registers \
    -color yellow tb_control/control_top/processor/reg_file/reg_write \
    -color green -radix Register tb_control/control_top/processor/reg_file/w_reg \
    -radix Register tb_control/control_top/processor/reg_file/r_reg1 \
    -radix Register tb_control/control_top/processor/reg_file/r_reg2 \
    -color gray -decimal tb_control/control_top/processor/reg_file/w_data \
    -decimal tb_control/control_top/processor/reg_file/r_data1 \
    -decimal tb_control/control_top/processor/reg_file/r_data2 
add wave -group "Instr Reg" -binary tb_control/control_top/processor/instr_reg/*
add wave -group "Reg Mem Data" tb_control/control_top/processor/reg_mem_data/*
add wave -group "Reg ALU A" tb_control/control_top/processor/reg_ALU_a/*
add wave -group "Reg ALU B" tb_control/control_top/processor/reg_ALU_b/*
add wave -group "Reg EPC" tb_control/control_top/processor/reg_epc/*
add wave -group "Reg Cause" tb_control/control_top/processor/reg_cause/*


# ===============================================
# ====---==--==-|| « Memory » ||-==--==---====

add wave -divider "Memory"
add wave -group "Mem Instruction" \
     -color cyan tb_control/control_top/processor/memory_instr/raddress \
     -color white tb_control/control_top/processor/memory_instr/waddress \
     tb_control/control_top/processor/memory_instr/data_in \
     -color cyan tb_control/control_top/processor/memory_instr/data_out \
     tb_control/control_top/processor/memory_instr/write

add wave -group "Mem Data" \
     -color cyan tb_control/control_top/processor/memory_data/raddress \
     -color white tb_control/control_top/processor/memory_data/waddress \
     tb_control/control_top/processor/memory_data/data_in \
     -color cyan tb_control/control_top/processor/memory_data/data_out \
     tb_control/control_top/processor/memory_data/write

add wave -group "Splice Store" -decimal tb_control/control_top/processor/store_splicer/*
add wave -group "Splice Load" -decimal tb_control/control_top/processor/load_splicer/*

quietly WaveActivateNextPane
add wave -color cyan -radix States -label "state" tb_control/control_top/state
add wave -radix Instruction -label "instruction" {tb_control/control_top/instruction[31:25] & tb_control/control_top/instruction[14:12] & tb_control/control_top/instruction[6:0]}
add wave -decimal -color "pale green" -decimal tb_control/control_top/processor/reg_file/registers
add wave -unsigned -color "Cornflower Blue" -label "PC" tb_control/control_top/processor/program_counter/r_data
add wave tb_control/control_top/clk

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


