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
logic [1:0] MemToReg;

// data memory flags
logic DMemOp;
logic LoadMDR;
logic [1:0] LoadSplice;
logic [1:0] StoreSplice;

// instr. memory flags
logic IMemRead;
logic IRWrite;

logic [31:0] instruction;
logic alu_zero;
logic alu_equal;
logic alu_greater;
logic alu_less;

processing processor (
    // PC flags
    .PCWrite(PCWrite),
    .PCSource(PCSource),
    .PCWriteState(PCWriteState),
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
    .LoadSplice(LoadSplice),
    .StoreSplice(StoreSplice),

    // instr memory flags
    .IMemRead(IMemRead),
    .IRWrite(IRWrite),

    .instruction_out(instruction),
    .alu_zero(alu_zero),
    .alu_equal(alu_equal),
    .alu_greater(alu_greater),
    .alu_less(alu_less),

    // clock and reset
    .clk(clk),
    .reset(reset)
);

logic [6:0] funct7;
logic [2:0] funct3;
logic [6:0] opcode;
logic branch_cond;

assign funct7 = instruction[31:25];
assign funct3 = instruction[14:12];
assign opcode = instruction[6:0];

// assign branching condition depending on ALU results
assign branch_cond = funct3 == opcodes::F3_BEQ ?  alu_equal   : 
                     funct3 == opcodes::F3_BNE ? ~alu_equal   :
                     funct3 == opcodes::F3_BGE ?  alu_greater :
                     funct3 == opcodes::F3_BLT ?  alu_less    : 0;

// assign PCWriteState
assign PCWriteState = (PCWrite || (branch_cond && PCWriteCond));

enum {
    START,
    INSTR_FETCH,
    INSTR_DECODE,
    MEM_ADDRESS_COMP,
    IMM_ARITH,
    EXECUTION_TYPE_R,
    EXECUTION_TYPE_U,
    ARITH_COMPL,
    BRANCH_COMPL,
    MEM_ACC_LD,
    WAIT_READ_DATA_MEM,
    WAIT_READ_INSTR_MEM,
    MEM_ACC_SD,
    WRITE_BACK,
    JUMP_COMPL,
    JUMP_EXEC
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
    MemToReg    = '0;
    DMemOp      = 0;
    LoadMDR     = 0;
    IMemRead    = 0;
    IRWrite     = 0;
    LoadSplice  = 0;
    StoreSplice = 0;

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
                opcodes::LD, opcodes::TYPE_S: next_state = MEM_ADDRESS_COMP;
                opcodes::IMM_ARITH: next_state = IMM_ARITH;
                opcodes::TYPE_R: next_state = EXECUTION_TYPE_R;
                opcodes::TYPE_U: next_state = EXECUTION_TYPE_U;
                opcodes::TYPE_SB: next_state = BRANCH_COMPL;
                opcodes::TYPE_UJ: next_state = JUMP_EXEC;
            endcase // todo: add default
        end

        // opcode: « ld » OR « SD »
        MEM_ADDRESS_COMP: begin
            ALUSrcA  = 1;
            ALUSrcB  = operations::_ALB_IMM;
            ALUOp    = operations::SUM;
            LoadAOut = 1;

            case (opcode)
                opcodes::LD: next_state = MEM_ACC_LD;
                opcodes::TYPE_S: next_state = MEM_ACC_SD;
            endcase // todo: add default
        end

        // opcode: « r-type »
        EXECUTION_TYPE_R: begin
            LoadAOut = 1;
            ALUSrcA  = operations::_ALA_REG_A;
            ALUSrcB  = operations::_ALB_REG_B;

            case (funct3)
                opcodes::F3_ADD: ALUOp = funct7[6:4] == 3'b000 ? operations::SUM : operations::SUB;
                opcodes::F3_SLT: ALUOp = operations::SHIFT_LEFT;
                opcodes::F3_AND: ALUOp = operations::AND;
            endcase

            next_state = ARITH_COMPL;
        end

        // opcode: « addi, srai, srli, ... »
        IMM_ARITH: begin
            LoadAOut = 1;
            ALUSrcA  = operations::_ALA_REG_A;
            ALUSrcB  = operations::_ALB_IMM;
            
            case (funct3)
                opcodes::F3_ADDI: ALUOp = operations::SUM;
                opcodes::F3_SRLI: ALUOp = funct7 == opcodes::F7_SRAI ? operations::SHIFT_RIGHT_A : operations::SHIFT_RIGHT;
                opcodes::F3_SLLI: ALUOp = operations::SHIFT_LEFT;
                opcodes::F3_SLTI: ALUOp = operations::LESS;
            endcase

            next_state = ARITH_COMPL;
        end
        
        // opcode: « u-type » 
        EXECUTION_TYPE_U: begin
            LoadAOut = 1;
            ALUSrcA = operations::_ALA_REG_A;
            ALUSrcB = operations::_ALB_IMM;
            ALUOp = operations::LOAD;

            next_state = ARITH_COMPL;
        end

        // opcode: « beq »
        BRANCH_COMPL: begin
            PCWriteCond = 1;
            PCSource = operations::_PC_ALU_REG;
            ALUSrcA  = operations::_ALA_REG_A;
            ALUSrcB  = operations::_ALB_REG_B;
            // ALUOut already has (pc + imm << 2) from previous instr_decode
            // branch condition is assigned above this always block

            next_state = WAIT_READ_INSTR_MEM;
        end

        JUMP_EXEC: begin
            // save pc to rd first
            RegWrite = 1;
            MemToReg = operations::_FW_PC_4;

            next_state = JUMP_COMPL;     
        end

        JUMP_COMPL: begin
            PCWrite = 1;
            PCSource = operations::_PC_ALU_REG;
            // ALUOut already has (pc + imm << 2) from previous instr_decode 

            next_state = WAIT_READ_INSTR_MEM;
        end

        // opcode: « ld »
        MEM_ACC_LD: begin
            DMemOp  = 0;
            next_state = WAIT_READ_DATA_MEM;
        end

        // wait 1 clock cycle for the memory to load an address
        WAIT_READ_DATA_MEM: begin
            LoadMDR = 1;
            next_state = WRITE_BACK;
        end

        // wait 1 clock cycle for the memory to load an address (in case of a branch)
        WAIT_READ_INSTR_MEM: begin
            next_state = INSTR_FETCH;            
        end

        // opcode: « sd »
        MEM_ACC_SD: begin
            DMemOp = 1;

             case (funct3)
                opcodes::F3_SD: StoreSplice = operations::SPL_SD;
                opcodes::F3_SW: StoreSplice = operations::SPL_SW;
                opcodes::F3_SH: StoreSplice = operations::SPL_SH;
                opcodes::F3_SB: StoreSplice = operations::SPL_SB;
            endcase

            next_state = INSTR_FETCH;
        end

        WRITE_BACK: begin
            RegWrite = 1;
            MemToReg = 2'b01;

            case (funct3)
                opcodes::F3_LD : LoadSplice = operations::SPL_LD;
                opcodes::F3_LW : LoadSplice = operations::SPL_LW;
                opcodes::F3_LH : LoadSplice = operations::SPL_LH;
                opcodes::F3_LBU: LoadSplice = operations::SPL_LBU;
            endcase

            next_state = INSTR_FETCH;
        end

        ARITH_COMPL: begin
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
