module processing(
    // ===-==-=== « control flags » ===-==-=== //
    // PC flags
    input logic PCWrite,
    input logic [1:0] PCSource,

    // ALU flags
    input logic ALUSrcA,
    input logic [1:0] ALUSrcB,
    input logic [1:0] ALUOp,
    input logic LoadAOut,

    // regfile flags
    input logic RegWrite,
    input logic LoadRegA,
    input logic LoadRegB,
    input logic MemToReg,

    // data memory flags
    input logic DMemRead,
    input logic DMemWrite,
    input logic LoadMDR,

    // instr. memory flags
    input logic IMemRead,
    input logic IRWrite,

    // clock and reset
    input logic clk,
    input logic reset
);

// ===-==-=== « outputs » ===-==-=== //

// == « register file » == //
wire [63:0] rd_regfile_1;
wire [63:0] rd_regfile_2;

// == « reg ALU a, b » == //
wire [63:0] rd_reg_a;
wire [63:0] rd_reg_b;

// == « instruction register » == //
wire [31:0] rd_instr_all;
wire [4:0] rd_instr_24_20;
wire [4:0] rd_instr_19_15;
wire [4:0] rd_instr_11_7;
wire [6:0] opcode;

// == « ALU » == //
wire [63:0] alu_res;
wire [63:0] alu_zero;

// == « ALU MUX » == //
wire [63:0] mux_alu_a;
wire [63:0] mux_alu_b;

// == « ALU REG » == //
wire [63:0] reg_alu_out;

// == « PC » == //
wire [63:0] pc_data;

// == « PC MUX » == //
wire [63:0] mux_pc_out;

// == « instr. memory » == //
wire [63:0] mem_rd_instr;

// == « data memory » == //
wire [63:0] mem_rd_data;

// == « signal extender » == //
wire [63:0] instr_extended;

reg_64 program_counter (
    .load(PCWrite),
    .w_data(mux_pc_out),
    .r_data(pc_data),
    .clk(clk),
    .reset(reset)
);

memory_32 memory_instr (
    .raddress(pc_data),
    .data_out(mem_rd_instr),
    .clk(clk),
    .write(0)
);

instr_reg instr_reg (
    .write_ir(IRWrite),
    .instruction(mem_rd_instr),
    .instr_all(rd_instr_all),
    .instr_24_20(rd_instr_24_20),
    .instr_19_15(rd_instr_19_15),
    .instr_11_7(rd_instr_11_7),
    .opcode(opcode),
    .clk(clk),
    .reset(reset)
);

regfile_64 reg_file (
    .r_reg1(rd_instr_24_20),
    .r_reg2(rd_instr_19_15),
    .w_reg(rd_instr_11_7),
    .r_data1(rd_regfile_1),
    .r_data2(rd_regfile_2),
    .w_data(), // todo: file mux 
    .clk(clk),
    .reset(reset)
);

reg_64 reg_ALU_a (
    .load(LoadRegA),
    .w_data(rd_regfile_1),
    .r_data(rd_reg_a),
    .clk(clk),
    .reset(reset)
);

reg_64 reg_ALU_b (
    .load(LoadRegB),
    .w_data(rd_regfile_2),
    .r_data(rd_reg_b),
    .clk(clk),
    .reset(reset)
);

mux_2to1_64 mux_ALU_A (
    .i_select(ALUSrcA),
    .i_0(pc_data),
    .i_1(rd_reg_a),
    .o_select(mux_alu_a)
);

mux_4to1_64 mux_ALU_B (
    .i_select(ALUSrcB),
    .i_0(rd_reg_b),
    .i_1(64'd4),
    .i_2(), // todo: imm
    .i_3(), // todo: imm * 2
    .o_select(mux_alu_b)
);

alu_64 alu (
    .funct(ALUOp),
    .a(mux_alu_a),
    .b(mux_alu_a),
    .result(alu_res),
    .zero(alu_zero)
);

reg_64 alu_out (
    .load(LoadAOut),
    .w_data(alu_res),
    .r_data(reg_alu_out),
    .clk(clk),
    .reset(reset)
);

mux_2to1_64 mux_PC (
    .i_select(PCSource),
    .i_0(alu_res),
    .i_1(reg_alu_out),
    .o_select(mux_pc_out)
);

sign_extend sign_extend (
    .i_num(mem_rd_instr),
    .o_extended(instr_extended)
);

memory_64 memory_data (
    .raddress(alu_res),
    .data_out(mem_rd_data),
    .
    .clk(clk),
    .write() // todo: DMemRead or DMemWrite?
);

reg_64 reg_mem_data (
    .
);
    
endmodule: processing