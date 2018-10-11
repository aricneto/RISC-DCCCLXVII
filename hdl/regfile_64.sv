// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==
// -> aricneto                          88,bd88b  88b .d888b, d8888b
//                                     88,P'    88P  ?8b,   d8P' `P
//                                    d88      d88    `?8b 88,b    
//                                   d88'     d88' `?888P' `?888P'
// -> module description:
//        64bit, 32 register, register file
// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==

module regfile_64(
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

    // clock and reset
    input logic clk,
    input logic reset
);

reg [63:0] registers [31:0];

assign r_data1 = registers[r_reg1];
assign r_data2 = registers[r_reg2];

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        for (int i = 0; i < 32; i = i + 1)
            registers[i] = 64'd0;
    end 
    else if (reg_write && w_reg != 0) 
        registers[w_reg] = w_data;
end

endmodule: regfile_64