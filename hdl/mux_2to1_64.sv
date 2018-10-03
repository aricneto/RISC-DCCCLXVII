module mux_4to1_64(
    input wire i_select,
    input wire [63:0] i_1,
    input wire [63:0] i_2,
    output logic [63:0] o_select
);

enum {A, B} states;

always @(*) begin
    case (i_select)
        A: o_select = i_1;
        B: o_select = i_2;
        default: o_select = 63'd0;
    endcase
end

endmodule