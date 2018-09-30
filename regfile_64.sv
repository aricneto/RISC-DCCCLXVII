module regfile_64(
    input logic clock, reset, regWrite,
    input wire [4:0] rReg1, rReg2, wReg,
    input wire [63:0] wData,
    output wire [63:0] rData1, rData2
);

reg [63:0] registers [31:0];

assign rData1 = registers[rReg1];
assign rData2 = registers[rReg2];

always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        for (int i = 0; i < 31; i = i + 1)
            registers[i] <= 64'd0;
    end 
    else if (regWrite) 
        registers[wReg] <= wData;
end

endmodule: regfile_64