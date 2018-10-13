module assert_type_r (
     // register write switch
    input logic reg_write,

    // register number inputs
    input wire [4:0] r_reg1, // read reg 1
    input wire [4:0] r_reg2, // read reg 2
    input wire [4:0] w_reg,  // write reg

    // write data input
    input wire [63:0]  w_data,

    // register data outputs
    output wire [63:0] r_data1,
    output wire [63:0] r_data2,

    // instruction register
    // enable register data read
    input logic write_ir,

    // instruction data
    input logic [31:0] instruction,

    // instruction outputs
    output logic [31:0] instr_all,
    output logic [4:0]  instr_24_20, // rs2 in most cases
    output logic [4:0]  instr_19_15, // rs1 in most cases
    output logic [4:0]  instr_11_7,  // rd in most cases
    output logic [6:0]  opcode,      // last 7 bits is always opcode 

    // clock and reset
    input logic clk,
    input logic reset
);

assert property (clk |-> opcode == opcodes::TYPE_R);

endmodule