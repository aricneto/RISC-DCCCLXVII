module control_top();

// ===-==-=== « control flags » ===-==-=== //
// PC flags
logic PCWrite;
logic [1:0] PCSource;
// final result between PCWrite and PCSource
logic PCStateOut;

// ALU flags
logic ALUSrcA;
logic [1:0] ALUSrcB;
logic [1:0] ALUOp;
logic LoadAOut;

// regfile flags
logic RegWrite;
logic LoadRegA;
logic LoadRegB;
logic MemToReg;

// data memory flags
logic DMemRead;
logic DMemWrite;
logic LoadMDR;

// instr. memory flags
logic IMemRead;
logic IRWrite;

logic [31:0] instruction;

// clock and reset
logic clk;
logic reset;

processing processor (
    // PC flags
    .PCWrite(PCWrite),
    .PCSource(PCSource),
    // final result between PCWrite and PCSource
    .PCStateOut(PCStateOut),

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
    .DMemRead(DMemRead),
    .DMemWrite(DMemWrite),
    .LoadMDR(LoadMDR),

    // instr memory flags
    .IMemRead(IMemRead),
    .IRWrite(IRWrite),

    .instruction_out(instruction),

    // clock and reset
    .clk(clk),
    .reset(reset)
)

// r-type
parameter OP_ADD = 7'b0110011;
parameter OP_SUB = 7'b0110011;

// i-type
parameter OP_ADDI = 7'b0010011;
parameter OP_LD   = 7'b0000011;

// s-type
parameter OP_SD   = 7'b0100011;

// sb-type
parameter OP_BEQ  = 7'b1100111;

logic [6:0] opcode;

assign opcode = instruction[6:0];

enum {
    INSTR_FETCH,
    INSTR_DECODE,
    MEM_ADDRESS_COMP,
    EXECUTION,
    R_TYPE_COMPL
    BRANCH_COMPL,
    MEM_ACC_LD,
    MEM_ACC_SD,
    WRITE_BACK
} state, next_state;

always_ff @(posedge clk) begin
    state <= next_state
end

// todo: add reset
always_comb begin //
    case (state)
        INSTR_FETCH: begin
            IMemRead = 1;
            IRWrite  = 1;
            PCWrite  = 1;
            PCSource = 2'b00;
            ALUSrcA  = 0;
            ALUSrcB  = 2'b01;
            ALUOp    = 2'b00;

            next_state = INSTR_DECODE; 
        end
        INSTR_DECODE: begin
            LoadRegA = 1;
            LoadRegB = 1;
            LoadAOut = 1;
            ALUSrcA  = 0;
            ALUSrcB  = 2'b11;
            ALUOp    = 2'b00;

            case (opcode)
                OP_LD:
                OP_SD:
            endcase
        end
        // opcode: « ld » OR « SD »
        MEM_ADDRESS_COMP: begin
            LoadAOut = 1;
            ALUSrcA  = 1;
            ALUSrcB  = 2'b10;
            ALUOp    = 2'b00;

            //todo: next state logic
        end
        // opcode: « r-type »
        EXECUTION: begin
            LoadAOut = 1;
            ALUSrcA  = 1
            ALUSrcB  = 2'b00;
            ALUOp    = 2'b10;

            next_state = R_TYPE_COMPL;
        end
        // opcode: « beq »
        BRANCH_COMPL: begin
            //PCWriteCond = 1;
            PCSource = 2'b01;
            ALUSrcA  = 1;
            ALUSrcB  = 2'b00;
            ALUOp    = 2'b01;

            next_state = INSTR_FETCH;
        end
        // opcode: « ld »
        MEM_ACC_LD: begin
            DMemRead = 1;
            LoadMDR  = 1;

            next_state = WRITE_BACK;
        end
        // opcode: « sd »
        MEM_ACC_SD: begin
            DMemWrite = 1;

            //todo: next state logic
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
            MemToReg = 0;

            next_state = INSTR_FETCH;
        end
        default: begin
            pass
        end
    endcase
end

endmodule: control_top