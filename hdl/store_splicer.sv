// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==
// -> aricneto                          88,bd88b  88b .d888b, d8888b
//                                     88,P'    88P  ?8b,   d8P' `P
//                                    d88      d88    `?8b 88,b    
//                                   d88'     d88' `?888P' `?888P'
// -> module description:
//        sign-extends the memory data for store operations
// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==

`include "packages/operations.svh"
import operations::*;

module store_splicer (
    input logic [1:0] control, 
    input logic [63:0] i_num,
    output logic [63:0] o_extended
);

always_comb begin
    case (control)
        operations::SPL_SD:
            o_extended = i_num;
        operations::SPL_SW:
            o_extended = {32'd0, i_num[31:0]};
        operations::SPL_SH:
            o_extended = {48'd0, i_num[15:0]};
        operations::SPL_SB:
            o_extended = i_num[7:0];
    endcase
end

endmodule: store_splicer