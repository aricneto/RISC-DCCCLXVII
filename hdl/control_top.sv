`include "alu_64.sv"
`include "instr_reg_64.sv"
`include "reg_64.sv"
`include "regfile_64.sv"

module top_control(
    input logic clk,
    input logic reset
);

// ===-==-=== « control flags » ===-==-=== //
// PC flags
logic PCWrite;
logic [1:0] PCSource;
logic PCWriteCond;

// ALU flags
logic ALUSrcA;
logic [1:0] ALUSrcB;
logic [1:0] ALUOp
logic LoadAOut;

// regfile flags
logic RegWrite;
logic LoadRegA;
logic LoadRegB;
logic MemToReg;

// data memory flahs
logic DMemRead;
logic DMemWrite;
logic LoadMDR;

// instr. memory flags
logic IMemRead;
logic IRWrite;

// ===-==-=== « outputs » ===-==-=== //

// == « register file » == //
wire [63:0] rd_regfile_1;
wire [63:0] rd_regfile_2;

// == « reg ALU a, b » == //
wire [63:0] rd_reg_a;
wire [63:0] rd_reg_b;

// == « instruction register » == //
wire [4:0] rd_instr_25_21;
wire [4:0] rd_instr_20_16;
wire [15:0] rd_instr_15_0;
wire [31:0] rd_instr_all;

instr_reg_64 instr_reg (
    .write_ir(IRWrite),
    .instr_all(rd_instr_all),
    .instr_25_21(rd_instr_25_21),
    .instr_20_16(rd_instr_20_16),
    .instr_15_0(rd_instr_15_0),
    .clk(clk),
    .reset(reset)
);

regfile_64 reg_file (
    .r_reg1(rd_instr_25_21),
    .r_reg2(rd_instr_20_16),
    .w_reg()
);

reg_64 reg_ALU_a (
    .load(LoadRegA),
    .w_data(rd_regfile_1),
    .r_data(rd_reg_a)
    .clk(clk),
    .reset(reset)
);

reg_64 reg_ALU_b (
    .load(LoadRegB),
    .w_data(rd_regfile_2),
    .r_data(rd_reg_b)
    .clk(clk),
    .reset(reset)
);

alu_64 ALU (
    opcode,
    a,
    b,

    output logic signed [63:0] result,

    output logic overflow,
    output logic negative,
    output logic zero,
);
    
endmodule: top_control