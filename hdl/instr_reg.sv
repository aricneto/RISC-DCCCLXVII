module instr_reg(
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

assign instr_24_20 = instr_all[24:20];
assign instr_19_15 = instr_all[19:15];
assign instr_11_7  = instr_all[11:7];
assign opcode      = instr_all[6:0];

always_ff @(posedge clk, posedge reset) begin
    if (reset) begin
        instr_all = 0;
    end
    else if (write_ir) begin
        instr_all = instruction;
    end
end
    
endmodule: instr_reg_64