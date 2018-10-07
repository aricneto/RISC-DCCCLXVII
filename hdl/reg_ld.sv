module reg_ld #(
    parameter SIZE = 64
)(
    // load flag
    input logic load,

    // data in/out
    input  logic [SIZE-1:0] w_data,
    output logic [SIZE-1:0] r_data,

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
    
endmodule: reg_ld