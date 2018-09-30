module regfile_64(
    // clock and reset
    input logic clk,
    input logic reset,

    // register write switch
    input logic regWrite,

    // register number inputs
    input wire [4:0] rReg1, // read reg 1
    input wire [4:0] rReg2, // read reg 2
    input wire [4:0] wReg,  // write reg

    // write data input
    input wire [63:0]  wData,

    // register data outputs
    output wire [63:0] rData1,
    output wire [63:0] rData2
);

reg [63:0] registers [31:0];

assign rData1 = registers[rReg1];
assign rData2 = registers[rReg2];

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        for (int i = 0; i < 31; i = i + 1)
            registers[i] <= 64'd0;
    end 
    else if (regWrite) 
        registers[wReg] <= wData;
end

endmodule: regfile_64