module instr_reg_64(
    // enable register data read
    input logic write_ir,

    // register num
    input logic [31:0] instruction,

    // instruction outputs
    output logic [31:0] instr_all,
    output logic [4:0]  instr_25_21,
    output logic [4:0]  instr_20_16,
    output logic [15:0] instr_15_0,

    // clock and reset
    input logic clk,
    input logic reset
);

assign instr_25_21 = instr_all[25:21];
assign instr_20_16 = instr_all[20:16];
assign instr_15_0  = instr_all[15:0];

always_ff @(posedge clk, posedge reset) begin
    if (reset) begin
        instr_all = 0;
    end
    else if (write_ir) begin
        instr_all = instruction;
    end
end
    
endmodule: instr_reg_64