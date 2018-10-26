// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==
// -> aricneto                          88,bd88b  88b .d888b, d8888b
//                                     88,P'    88P  ?8b,   d8P' `P
//                                    d88      d88    `?8b 88,b    
//                                   d88'     d88' `?888P' `?888P'
// -> package description:
//        implements global function (mux, alu op) operations
// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==

`ifndef _operations_svh_
`define _operations_svh_

package operations;

// ALU ops
enum {SUM, SHIFT_LEFT, SUB, LOAD, XOR, SHIFT_RIGHT, NOT, AND, SHIFT_LEFT_A, SHIFT_RIGHT_A, LESS} ops_alu;

// ALUSrcB MUX
enum {_ALB_REG_B, _ALB_CONST4, _ALB_IMM, _ALB_IMM2} mux_ALUSrcB;

// ALUSrcA MUX
enum {_ALA_PC, _ALA_REG_A, _ALA_ZERO} mux_ALUSrcA;

// PC MUX
enum {_PC_ALU_OUT, _PC_ALU_REG} mux_PCSource;

// File Write MUX: alu_out, mem_out
enum {_FW_ALU_OUT, _FW_MEM_OUT, _FW_PC_4} mux_FileWrite;

// Load splicer control
enum {SPL_LD, SPL_LW, SPL_LH, SPL_LBU} splice_load;

// Store splicer control
enum {SPL_SD, SPL_SW, SPL_SH, SPL_SB} splice_store;

endpackage

`endif