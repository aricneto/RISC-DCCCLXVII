// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==
// -> aricneto                          88,bd88b  88b .d888b, d8888b
//                                     88,P'    88P  ?8b,   d8P' `P
//                                    d88      d88    `?8b 88,b    
//                                   d88'     d88' `?888P' `?888P'
// -> package description:
//        implements global opcode parameters
// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==

`ifndef _opcodes_svh_
`define _opcodes_svh_

package opcodes;

//          ╔═╗╔═╗╔═╗╔═╗╔╦╗╔═╗╔═╗
//          ║ ║╠═╝║  ║ ║ ║║║╣ ╚═╗
//          ╚═╝╩  ╚═╝╚═╝═╩╝╚═╝╚═╝
//          -> opcodes

// opcode for r-type instructions
parameter TYPE_R = 7'b0110011;

// opcode for arithmetic i-type instructions
parameter IMM_ARITH = 7'b0010011;

// opcode for i-type instructions
parameter ADDI  = 7'b0010011;
parameter SRLI  = 7'b0010011;
parameter SRAI  = 7'b0010011;
parameter SLLI  = 7'b0010011;
parameter SLTI  = 7'b0010011;
parameter JALR  = 7'b1100111;
parameter SD    = 7'b0100011;
parameter LD    = 7'b0000011;
parameter LW    = 7'b0000011;
parameter LBU   = 7'b0000011;
parameter LH    = 7'b0000011;
parameter NOP   = 7'b0010011;
parameter BREAK = 7'b1110011;

// opcode for s-type instructions
parameter TYPE_S = 7'b0100011;

// opcode for sb-type instructions
parameter TYPE_SB = 7'b1100011;

// opcode for u-type instructions
parameter TYPE_U = 7'b0110111;

// opcode for uj-type instructions
parameter TYPE_UJ = 7'b1101111;


//          ╔═╗╦ ╦╔╗╔╔═╗╔╦╗
//          ╠╣ ║ ║║║║║   ║ 
//          ╚  ╚═╝╝╚╝╚═╝ ╩ 3
//          -> funct3 codes

parameter F3_JALR = 3'b000;

parameter F3_BEQ  = 3'b000;
parameter F3_BNE  = 3'b001;
parameter F3_BGE  = 3'b101;
parameter F3_BLT  = 3'b100;

parameter F3_LD   = 3'b011;
parameter F3_LW   = 3'b010;
parameter F3_LH   = 3'b001;
parameter F3_LBU  = 3'b100;

parameter F3_SD   = 3'b111;
parameter F3_SW   = 3'b010;
parameter F3_SH   = 3'b001;
parameter F3_SB   = 3'b000;

parameter F3_ADDI = 3'b000;
parameter F3_SLTI = 3'b010;
parameter F3_SLLI = 3'b001;
parameter F3_SRLI = 3'b101;
parameter F3_SRAI = 3'b101;

parameter F3_ADD  = 3'b000;
parameter F3_SUB  = 3'b000;
parameter F3_SLL  = 3'b001;
parameter F3_SLT  = 3'b010;
parameter F3_AND  = 3'b111;


//          ╔═╗╦ ╦╔╗╔╔═╗╔╦╗
//          ╠╣ ║ ║║║║║   ║ 
//          ╚  ╚═╝╝╚╝╚═╝ ╩ 7
//          -> funct7 codes

parameter F7_SLLI = 7'b0000000;
parameter F7_SRLI = 7'b0000000;
parameter F7_SRAI = 7'b0100000;
parameter F7_ADD  = 7'b0000000;
parameter F7_SUB  = 7'b0100000;
parameter F7_SLL  = 7'b0000000;
parameter F7_SLT  = 7'b0000000;
parameter F7_AND  = 7'b0000000;

endpackage

`endif