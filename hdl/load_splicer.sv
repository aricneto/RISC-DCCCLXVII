// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==
// -> aricneto                          88,bd88b  88b .d888b, d8888b
//                                     88,P'    88P  ?8b,   d8P' `P
//                                    d88      d88    `?8b 88,b    
//                                   d88'     d88' `?888P' `?888P'
// -> module description:
//        sign-extends the memory data for load operations
// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==


 // BREAKING: check how LW and LH are supposed to be extended 

`include "packages/operations.svh"
import operations::*;

module load_splicer (
    input logic [1:0] control, 
    input logic [63:0] i_num,
    output logic [63:0] o_extended
);

always_comb begin
    case (control)
        operations::SPL_LD:
            o_extended = i_num;
        operations::SPL_LW:
            o_extended = {32'b0, $signed(i_num[31:0])};
        operations::SPL_LH:
            o_extended = {48'b0, $signed(i_num[15:0])};
        operations::SPL_LBU:
            o_extended = {56'b0, i_num[7:0]};
    endcase
end

endmodule: load_splicer