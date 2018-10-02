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
logic RegWrite
logic LoadRegA
logic LoadRegB
logic MemToReg

// data memory flahs
logic DMemRead
logic DMemWrite
logic LoadMDR

// instr. memory flags
logic IMemRead
logic IRWrite

// ===-==-=== « outputs » ===-==-=== //

// == « register file » == //
wire [63:0] rd_regfile_1;
wire [63:0] rd_regfile_2;

// == « reg ALU a, b » == //
wire [63:0] rd_reg_a;
wire [63:0] rd_reg_b;



reg_64 reg_ALU_a(
    .clk(clk),
    .load(LoadRegA)
    .w_data(rd_regfile_1);
    .r_data(rd_reg_a)
);

reg_64 reg_ALU_b(
    .clk(clk),
    .load(LoadRegB)
    .w_data(rd_regfile_2);
    .r_data(rd_reg_b)
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