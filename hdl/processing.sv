// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==
// -> aricneto                          88,bd88b  88b .d888b, d8888b
//                                     88,P'    88P  ?8b,   d8P' `P
//                                    d88      d88    `?8b 88,b    
//                                   d88'     d88' `?888P' `?888P'
// -> module description:
//        connects all modules and components necessary for the RISC-V
// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==

module processing(
    // ===-==-=== « control flags » ===-==-=== //
    // PC flags
    input logic PCWrite,
    input logic PCWriteCond,
    input logic PCSource,

    // ALU flags
    input logic ALUSrcA,
    input logic [1:0] ALUSrcB,
    input logic [2:0] ALUOp,
    input logic LoadAOut,

    // regfile flags
    input logic RegWrite,
    input logic LoadRegA,
    input logic LoadRegB,
    input logic MemToReg,

    // data memory flags
    input logic DMemOp,
    input logic LoadMDR,

    // instr. memory flags
    input logic IMemRead,
    input logic IRWrite,

    // instruction outputs
    output logic [31:0] instruction_out,

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
wire alu_zero;

// == « ALU MUX » == //
wire [63:0] mux_alu_a;
wire [63:0] mux_alu_b;

// == « ALU REG » == //
wire [63:0] reg_alu_out;

// == « PC » == //
wire [31:0] pc_data;
logic PCWriteState;

// == « PC MUX » == //
wire [63:0] mux_pc_out;

// == « instr. memory » == //
wire [31:0] mem_rd_instr;

// == « data memory » == //
wire [63:0] mem_rd_data;
wire [63:0] reg_mem_rd_data;

// == « signal extender » == //
wire [63:0] instr_extended;

// == « reg file MUX » == //
wire [63:0] mux_reg_file_data;

assign instruction_out = rd_instr_all;
    assign PCWriteState = (PCWrite || (alu_zero && PCWriteCond));

reg_ld #(.SIZE(32)) program_counter (
    .load(PCWriteState),
    .w_data(mux_pc_out[31:0]),
    .r_data(pc_data),
    .clk(clk),
    .reset(reset)
);

memory_32 #(.init_file("mem/instruction.mif")) memory_instr (
    .raddress(pc_data),
    .data_out(mem_rd_instr),
    .clk(clk),
    .write(1'b0)
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
    .reg_write(RegWrite),
    .r_reg1(rd_instr_24_20),
    .r_reg2(rd_instr_19_15),
    .w_reg(rd_instr_11_7),
    .r_data1(rd_regfile_1),
    .r_data2(rd_regfile_2),
    .w_data(mux_reg_file_data),
    .clk(clk),
    .reset(reset)
);

reg_ld reg_ALU_a (
    .load(LoadRegA),
    .w_data(rd_regfile_1),
    .r_data(rd_reg_a),
    .clk(clk),
    .reset(reset)
);

reg_ld reg_ALU_b (
    .load(LoadRegB),
    .w_data(rd_regfile_2),
    .r_data(rd_reg_b),
    .clk(clk),
    .reset(reset)
);

mux_2to1_64 mux_ALU_A (
    .i_select(ALUSrcA),
    .i_0({32'd0, pc_data}),
    .i_1(rd_reg_a),
    .o_select(mux_alu_a)
);

mux_4to1_64 mux_ALU_B (
    .i_select(ALUSrcB),
    .i_0(rd_reg_b),
    .i_1(64'd4),
    .i_2(instr_extended),
    .i_3(instr_extended * 2),
    .o_select(mux_alu_b)
);

alu alu (
    .funct(ALUOp),
    .a(mux_alu_a),
    .b(mux_alu_b),
    .result(alu_res),
    .zero(alu_zero)
);

reg_ld alu_out (
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

// fixme: case switch on sign_extend to extend the right amount for each opcode
sign_extend sign_extend (
    .i_num(rd_instr_all),
    .o_extended(instr_extended)
);

memory_64 #(.init_file("mem/dados.mif")) memory_data (
    .raddress(reg_alu_out),
    .waddress(reg_alu_out),
    .data_out(mem_rd_data),
    .data_in(rd_reg_b),
    .write(DMemOp),
    .clk(clk)
);

reg_ld reg_mem_data (
    .load(LoadMDR),
    .w_data(mem_rd_data),
    .r_data(reg_mem_rd_data),
    .clk(clk),
    .reset(reset)
);

mux_2to1_64 mux_reg_file (
    .i_select(MemToReg),
    .i_0(reg_alu_out),
    .i_1(reg_mem_rd_data),
    .o_select(mux_reg_file_data)
);
    
endmodule: processing
