// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==
// -> aricneto                          88,bd88b  88b .d888b, d8888b
//                                     88,P'    88P  ?8b,   d8P' `P
//                                    d88      d88    `?8b 88,b    
//                                   d88'     d88' `?888P' `?888P'
// -> module description:
//        register that only saves on a flag and clock
// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==

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