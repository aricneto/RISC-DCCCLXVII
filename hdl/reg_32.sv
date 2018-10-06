module reg_32(
    // load flag
    input logic load,

    // data in/out
    input  logic [31:0] w_data,
    output logic [31:0] r_data,

    // clock and reset
    input logic clk,
    input logic reset
);

always_ff @(posedge clk, posedge reset) begin
    if (reset) begin
        r_data <= 0;
    end
    else if (load) begin
        r_data <= w_data;
    end
end
    
endmodule: reg_32