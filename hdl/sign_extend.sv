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