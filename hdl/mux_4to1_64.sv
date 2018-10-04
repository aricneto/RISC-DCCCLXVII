module mux_4to1_64(
    input wire [1:0] i_select,
    input wire [63:0] i_0,
    input wire [63:0] i_1,
    input wire [63:0] i_2,
    input wire [63:0] i_3,
    output logic [63:0] o_select
);

enum {A, B, C, D} states;

always_comb begin
    case (i_select)
        A: o_select = i_0;
        B: o_select = i_1;
        C: o_select = i_2;
        D: o_select = i_3;
        default: o_select = 63'd0;
    endcase
end

endmodule