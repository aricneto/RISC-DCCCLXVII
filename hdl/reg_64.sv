module reg_64(
    // load flag
    input logic load,

    // data in/out
    input  logic [63:0] w_data,
    output logic [63:0] r_data,

    // clock and reset
    input logic clk,
    input logic reset
);

always_ff @(posedge clk, posedge reset) begin
    if (reset) begin
        r_data = 0;
    end
    else if (load) begin
        r_data = w_data;
    end
end
    
endmodule: reg_64