// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==
// -> aricneto                          88,bd88b  88b .d888b, d8888b
//                                     88,P'    88P  ?8b,   d8P' `P
//                                    d88      d88    `?8b 88,b    
//                                   d88'     d88' `?888P' `?888P'
// -> module description:
//        control unit that implements the processor state machine
// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==

// include packages
`include "packages/opcodes.svh"
`include "packages/operations.svh"

import opcodes::*;
import operations::*;

module control_top(  
    // clock and reset
    input logic clk,
    input logic reset
);

// ===-==-=== « control flags » ===-==-=== //
// PC flags
logic PCWrite;
logic PCSource;
logic PCWriteCond;
// final result between PCWrite and PCSource
logic PCStateOut;

// ALU flags
logic ALUSrcA;
logic [1:0] ALUSrcB;
logic [3:0] ALUOp;
logic LoadAOut;

// regfile flags
logic RegWrite;
logic LoadRegA;
logic LoadRegB;
logic MemToReg;

// data memory flags
logic DMemOp;
logic LoadMDR;

// instr. memory flags
logic IMemRead;
logic IRWrite;

logic [31:0] instruction;

processing processor (
    // PC flags
    .PCWrite(PCWrite),
    .PCSource(PCSource),
    .PCWriteCond(PCWriteCond),

    // ALU flags
    .ALUSrcA(ALUSrcA),
    .ALUSrcB(ALUSrcB),
    .ALUOp(ALUOp),
    .LoadAOut(LoadAOut),

    // regfile flags
    .RegWrite(RegWrite),
    .LoadRegA(LoadRegA),
    .LoadRegB(LoadRegB),
    .MemToReg(MemToReg),

    // data memory flags
    .DMemOp(DMemOp),
    .LoadMDR(LoadMDR),

    // instr memory flags
    .IMemRead(IMemRead),
    .IRWrite(IRWrite),

    .instruction_out(instruction),

    // clock and reset
    .clk(clk),
    .reset(reset)
);

logic [6:0] funct7;
logic [2:0] funct3;
logic [6:0] opcode;

assign funct7 = instruction[31:25];
assign funct3 = instruction[14:12];
assign opcode = instruction[6:0];

enum {
    START,
    INSTR_FETCH,
    INSTR_DECODE,
    MEM_ADDRESS_COMP,
    IMM_ARITH,
    EXECUTION_TYPE_R,
    EXECUTION_TYPE_U,
    R_TYPE_COMPL,
    BRANCH_COMPL,
    MEM_ACC_LD,
    MEM_ACC_SD,
    WRITE_BACK
} state, next_state;

always_ff @(posedge clk) begin
    state <= next_state;
end

// todo: add reset
always_comb begin
    // zero all control inputs, then assert only the needed ones
    PCWrite     = 0;
    PCSource    = 0;
    PCWriteCond = 0;
    PCStateOut  = 0;
    ALUSrcA     = 0;
    ALUSrcB     = '0;
    ALUOp       = operations::SUM;
    LoadAOut    = 0;
    RegWrite    = 0;
    LoadRegA    = 0;
    LoadRegB    = 0;
    MemToReg    = 0;
    DMemOp      = 0;
    LoadMDR     = 0;
    IMemRead    = 0;
    IRWrite     = 0;

    case (state)
        START: begin
            next_state = INSTR_FETCH;
        end

        INSTR_FETCH: begin
            IMemRead = 1;
            IRWrite  = 1;
            PCWrite  = 1;
            PCSource = operations::_PC_ALU_OUT;
            ALUSrcA  = operations::_ALA_PC;
            ALUSrcB  = operations::_ALB_CONST4;
            ALUOp    = operations::SUM;

            next_state = INSTR_DECODE; 
        end

        INSTR_DECODE: begin
            LoadRegA = 1;
            LoadRegB = 1;
            LoadAOut = 1;
            ALUSrcA  = operations::_ALA_PC;
            ALUSrcB  = operations::_ALB_IMM2;
            ALUOp    = operations::SUM;

            case (opcode)
                opcodes::LD, opcodes::SD: next_state = MEM_ADDRESS_COMP;
                opcodes::TYPE_S: next_state = MEM_ADDRESS_COMP;
                opcodes::IMM_ARITH: next_state = IMM_ARITH;
                opcodes::TYPE_R: next_state = EXECUTION_TYPE_R;
                opcodes::TYPE_U: next_state = EXECUTION_TYPE_U;
                opcodes::TYPE_SB: next_state = BRANCH_COMPL;
            endcase // todo: add default
        end

        // opcode: « ld » OR « SD »
        MEM_ADDRESS_COMP: begin
            LoadAOut = 1;
            ALUSrcA  = 1;
            ALUSrcB  = operations::_ALB_IMM;
            ALUOp    = operations::SUM;

            case (opcode)
                opcodes::LD: next_state = MEM_ACC_LD;
                opcodes::SD: next_state = MEM_ACC_SD;
            endcase // todo: add default
        end

        // opcode: « r-type »
        EXECUTION_TYPE_R: begin
            LoadAOut = 1;
            ALUSrcA  = operations::_ALA_REG_A;
            ALUSrcB  = operations::_ALB_REG_B;

            case (funct3)
                3'b000: ALUOp = funct7[6:4] == 3'b000 ? operations::SUM : operations::SUB;
                3'b010: ALUOp = operations::SHIFT_LEFT;
                3'b111: ALUOp = operations::AND;
            endcase

            next_state = R_TYPE_COMPL;
        end

        // opcode: « addi, srai, srli, ... »
        IMM_ARITH: begin
            LoadAOut = 1;
            ALUSrcA  = operations::_ALA_REG_A;
            ALUSrcB  = operations::_ALB_IMM;
            
            case (funct3)
                3'b000: ALUOp = operations::SUM;
                3'b101: ALUOp = funct7 == opcodes::F7_SRAI ? operations::SHIFT_RIGHT_A : operations::SHIFT_RIGHT;
                3'b001: ALUOp = operations::SHIFT_LEFT;
                3'b010: ALUOp = operations::LESS;
            endcase

            next_state = R_TYPE_COMPL;
        end
        
        // opcode: « u-type » 
        EXECUTION_TYPE_U: begin
            LoadAOut = 1;
            ALUSrcA = operations::_ALA_REG_A;
            ALUSrcB = operations::_ALB_IMM;
            ALUOp = operations::LOAD;

            next_state = R_TYPE_COMPL;
        end

        // opcode: « beq »
        BRANCH_COMPL: begin
            //PCWriteCond = 1;
            PCSource = operations::_PC_ALU_REG;
            ALUSrcA  = operations::_ALA_REG_A;
            ALUSrcB  = operations::_ALB_REG_B;
            ALUOp    = operations::SUM; // fixme: fix operation

            next_state = INSTR_FETCH;
        end

        // opcode: « ld »
        MEM_ACC_LD: begin
            DMemOp  = 0;
            LoadMDR = 1;

            next_state = WRITE_BACK;
        end

        // opcode: « sd »
        MEM_ACC_SD: begin
            DMemOp = 1;

            next_state = INSTR_FETCH;
        end

        WRITE_BACK: begin
            RegWrite = 1;
            MemToReg = 1;

            next_state = INSTR_FETCH;
        end

        R_TYPE_COMPL: begin
            RegWrite = 1;
            MemToReg = operations::_FW_ALU_OUT;

            next_state = INSTR_FETCH;
        end

        default: begin
            next_state = INSTR_FETCH;
        end
    endcase
end

endmodule: control_top
