// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==
// -> aricneto                          88,bd88b  88b .d888b, d8888b
//                                     88,P'    88P  ?8b,   d8P' `P
//                                    d88      d88    `?8b 88,b    
//                                   d88'     d88' `?888P' `?888P'
// -> module description:
//        sign-extends the immediate address for some instructions to 64bit
// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==

module sign_extend #(
    parameter IN_WIDTH=32
)(
    input logic [IN_WIDTH-1:0] i_num,
    output logic [63:0] o_extended
);

always_comb begin
    o_extended = $signed(i_num);
end

endmodule: sign_extend