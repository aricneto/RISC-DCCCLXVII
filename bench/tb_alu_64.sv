`include "alu_64.sv"
`timescale 1ps/1ps

module tb_alu_64;

    enum {SUM, SHIFT_LEFT, SUB, LOAD, XOR, SHIFT_RIGHT, NOT, AND} ops;
    
    logic [2:0] funct;

    // alu operand inputs
    logic signed [63:0] num_a;
    logic signed [63:0] num_b;

    // operation result
    logic signed [63:0] result;

    // status outputs
    logic overflow;
    logic negative;
    logic zero;
    logic equal;
    logic greater;
    logic less;

    alu_64 alu (
        .funct(funct),
        .a(num_a),
        .b(num_b),
        .result(result),
        .overflow(overflow),
        .negative(negative),
        .zero(zero),
        .equal(equal),
        .greater(greater),
        .less(less)
    );

    initial begin
        $monitor("\ntime = %t\n funct = %b\n a      = %d\n b      = %d\n result = %d\n overf = %b\n neg   = %b\n zero  = %b\n eq    = %b\n grt   = %b\n les   = %b\n\n===-==-===-==-===", $time, funct, num_a, num_b, result, overflow, negative, zero, equal, greater, less);

        $display("sum test:\n");
        funct = SUM;
        num_a = 64'd12;
        num_b = 64'd25;

        #1
        $display("sub test:\n");
        funct = SUB;
        num_a = 64'd12;
        num_b = 64'd25;

        #1
        $display("and test:\n");
        funct = AND;
        num_a = 64'd12;
        num_b = 64'd25;

        #1
        $display("xor test:\n");
        funct = XOR;
        num_a = 64'd12;
        num_b = 64'd25;

        #1
        $display("not test:\n");
        funct = NOT;
        num_a = 64'd0;

        #1 // testing overflow
        $display("sum overflow test:\n");
        funct = SUM;
        num_a = 64'b0111111111111111111111111111111111111111111111111111111111111111;
        num_b = 64'd3;

        #1 // testing overflow
        $display("sub overflow test:\n");
        funct = SUB;
        num_a = 64'b1000000000000000000000000000000000000000000000000000000000000000;
        num_b = 64'd3;

        #1 // testing zero
        $display("zero test:\n");
        funct = SUB;
        num_a = 64'd54;
        num_b = 64'd54;

    end // initial begin

endmodule: tb_alu_64