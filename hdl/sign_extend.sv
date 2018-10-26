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
logic [2:0] funct3;

assign funct3 = i_num[14:12];
assign opcode = i_num[6:0];

always_comb begin
    case (opcode)
        opcodes::IMM_ARITH: begin
            if (i_num[14:12] == opcodes::F3_SRAI || i_num[14:12] == opcodes::F3_SLLI)
                o_extended = $signed(i_num[25:20]);
            else
                o_extended = $signed(i_num[31:20]);
        end
        opcodes::JALR, opcodes::TYPE_SB: begin
            case (funct3)
                opcodes::F3_JALR: 
                    o_extended = $signed(i_num[31:20]); // shift is done in control unit 
                opcodes::F3_BEQ, opcodes::F3_BNE, opcodes::F3_BGE, opcodes::F3_BLT:
                    o_extended = $signed({i_num[31], i_num[7], i_num[30:25], i_num[11:8]} << 2);
            endcase
        end
        opcodes::LD:
            if (i_num[14:12] == opcodes::F3_LBU)
                o_extended = {52'b0, i_num[31:20]};
            else
                o_extended = $signed(i_num[31:20]);
        opcodes::TYPE_S:
            o_extended = $signed({i_num[31:25], i_num[11:7]});
        opcodes::TYPE_U:
            o_extended = $signed({i_num[31:12], 12'd0});
        opcodes::TYPE_UJ:
            o_extended = $signed({i_num[31], i_num[19:12], i_num[20], i_num[30:21]} << 1); // shift is done in control unit
    endcase
end

endmodule: sign_extend