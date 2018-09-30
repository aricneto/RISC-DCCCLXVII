module regfile_64(
    // clock and reset
    input logic clk,
    input logic reset,

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
    output wire [63:0] r_data2
);

reg [63:0] registers [31:0];

assign r_data1 = registers[r_reg1];
assign r_data2 = registers[r_reg2];

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        for (int i = 0; i < 31; i = i + 1)
            registers[i] <= 64'd0;
    end 
    else if (reg_write) 
        registers[w_reg] <= w_data;
end

endmodule: regfile_64