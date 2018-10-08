// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==
// -> aricneto                          88,bd88b  88b .d888b, d8888b
//                                     88,P'    88P  ?8b,   d8P' `P
//                                    d88      d88    `?8b 88,b    
//                                   d88'     d88' `?888P' `?888P'
// -> module description:
//        standard 2 to 1 MUX
// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==

module mux_2to1_64 (
    input wire i_select,
    input wire [63:0] i_0,
    input wire [63:0] i_1,
    output logic [63:0] o_select
);

enum {A, B} states;

always_comb begin
    case (i_select)
        A: o_select = i_0;
        B: o_select = i_1;
        default: o_select = 64'd0;
    endcase
end

endmodule: mux_2to1_64