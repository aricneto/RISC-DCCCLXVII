`include "../hdl/sign_extend.sv"
`timescale 1ns/1ns

module tb_sign_extend;

    logic [31:0] unextended;
    logic [63:0] extended;

    sign_extend ext(
        .i_num(unextended),
        .o_extended(extended)
    );

    initial begin
        $monitor("\nin (bin) = %b\nin (dec) = %d\nout (bin) = %b\nout (dec) = %d\n\n===-==-===-==-===", unextended, unextended, extended, extended);

        #1 unextended = 31;
        #1 unextended = -15;

    end // initial begin

endmodule: tb_alu_64