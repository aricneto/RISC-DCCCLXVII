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
logic [2:0] ALUOp;
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

// r-type
parameter TYPE_OP_R = 7'b0110011;
parameter TYPE_OP_I = 7'b0010011;
parameter OP_ADD    = 7'b0110011;
parameter OP_SUB    = 7'b0110011;

// i-type
parameter OP_ADDI = 7'b0010011;
parameter OP_LD   = 7'b0000011;

// s-type
parameter OP_SD   = 7'b0100011;

// sb-type
parameter OP_BEQ  = 7'b1100111;

logic [6:0] funct7;
logic [2:0] funct3;
logic [6:0] opcode;

assign funct7 = instruction[31:25];
assign funct3 = instruction[14:12];
assign opcode = instruction[6:0];

// ALU ops
enum {SUM, SHIFT_LEFT, SUB, LOAD, XOR, SHIFT_RIGHT, NOT, AND} ops;

// ALUSrcB MUX
enum {REG_B, CONST4, IMM, IMM2} ops_ALUSrcB;

// ALUSrcA MUX
enum {PC, REG_A} ops_ALUSrcA;

// PC MUX
enum {ALU_OUT, ALU_REG} ops_PCSource;

// File Write MUX: alu_out, mem_out
parameter MEM_OUT = 1'b1;

enum {
    START,
    INSTR_FETCH,
    INSTR_DECODE,
    MEM_ADDRESS_COMP,
    EXECUTION_TYPE_I,
    EXECUTION_TYPE_R,
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
    ALUSrcB     = 2'd0;
    ALUOp       = 3'd0;
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
            PCSource = 0;
            ALUSrcA  = ALU_OUT;
            ALUSrcB  = CONST4;
            ALUOp    = SUM;

            next_state = INSTR_DECODE; 
        end

        INSTR_DECODE: begin
            LoadRegA = 1;
            LoadRegB = 1;
            LoadAOut = 1;
            ALUSrcA  = PC;
            ALUSrcB  = IMM2;
            ALUOp    = SUM;

            case (opcode)
                OP_LD: next_state = MEM_ADDRESS_COMP;
                OP_SD: next_state = MEM_ADDRESS_COMP;
                TYPE_OP_I: next_state = EXECUTION_TYPE_I;
                TYPE_OP_R: next_state = EXECUTION_TYPE_R;
                OP_BEQ: next_state = BRANCH_COMPL;
            endcase // todo: add default
        end

        // opcode: « ld » OR « SD »
        MEM_ADDRESS_COMP: begin
            LoadAOut = 1;
            ALUSrcA  = 1;
            ALUSrcB  = IMM;
            ALUOp    = SUM;

            case (opcode)
                OP_LD: next_state = MEM_ACC_LD;
                OP_SD: next_state = MEM_ACC_SD;
            endcase // todo: add default
        end

        // opcode: « r-type »
        EXECUTION_TYPE_R: begin
            LoadAOut = 1;
            ALUSrcA  = REG_A;
            ALUSrcB  = REG_B;
            ALUOp    = funct7[6:4]; // todo: if funct3 != 0

            next_state = R_TYPE_COMPL;
        end

        // opcode: « i-type »
        EXECUTION_TYPE_I: begin
            LoadAOut = 1;
            ALUSrcA  = REG_A;
            ALUSrcB  = IMM;
            ALUOp    = funct3; // fixme: srai uses funct7

            next_state = R_TYPE_COMPL;
        end

        // opcode: « beq »
        BRANCH_COMPL: begin
            //PCWriteCond = 1;
            PCSource = 1;
            ALUSrcA  = REG_A;
            ALUSrcB  = REG_B;
            ALUOp    = 2'b01; // fixme: fix operation

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
            //RegDst = 0;
            RegWrite = 1;
            MemToReg = 1;

            next_state = INSTR_FETCH;
        end

        R_TYPE_COMPL: begin
            // RegDst = 1;
            RegWrite = 1;
            MemToReg = MEM_OUT;

            next_state = INSTR_FETCH;
        end

        default: begin
            next_state = INSTR_FETCH;
        end
    endcase
end

endmodule: control_top