// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==
// -> aricneto                          88,bd88b  88b .d888b, d8888b
//                                     88,P'    88P  ?8b,   d8P' `P
//                                    d88      d88    `?8b 88,b    
//                                   d88'     d88' `?888P' `?888P'
// -> module description:
//        sign-extends the immediate address for some instructions to 64bit
// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==

`include "packages/opcodes.svh"
import opcodes::*;

module sign_extend #(
    parameter IN_WIDTH=32
)(
    input logic [IN_WIDTH-1:0] i_num,
    output logic [63:0] o_extended
);

logic [6:0] opcode;

assign opcode = i_num[6:0];

always_comb begin
    case (opcode)
        opcodes::IMM_ARITH: begin
            if (i_num[14:12] == opcodes::F3_SRAI || i_num[14:12] == opcodes::F3_SLLI)
                o_extended = $signed(i_num[24:20]);
            else
                o_extended = $signed(i_num[31:20]);
        end
        opcodes::JALR, opcodes::LD:
            o_extended = $signed(i_num[31:20]);          
        opcodes::TYPE_S:
            o_extended = $signed({i_num[31:25], i_num[11:7]});
        opcodes::TYPE_SB:
            o_extended = $signed({i_num[31], i_num[7], i_num[30:25], i_num[11:8], 1'b0} << 1);
        opcodes::TYPE_U:
            o_extended = $signed({i_num[31:12], 12'd0});
        opcodes::TYPE_UJ:
            o_extended = $signed({i_num[31], i_num[19:12], i_num[20], i_num[30:21]});
    endcase
end

endmodule: sign_extend