`timescale 1ns/1ns

module tb_alu_64;

    enum {LOAD, SUM, SUB, AND, XOR, NOT, INC} ops;
    
    logic [2:0] opcode;

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
        .opcode(opcode),
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
        $monitor(" time = %t\n opcode = %b\n a      = %d\n b      = %d\n result = %d\n overf = %b\n neg   = %b\n zero  = %b\n eq    = %b\n grt   = %b\n les   = %b\n\n===-==-===-==-===", $time, opcode, num_a, num_b, result, overflow, negative, zero, equal, greater, less);

        $display("sum test:\n");
        opcode = SUM;
        num_a = 64'd12;
        num_b = 64'd25;

        #10
        $display("sub test:\n");
        opcode = SUB;
        num_a = 64'd12;
        num_b = 64'd25;

        #10
        $display("and test:\n");
        opcode = AND;
        num_a = 64'd12;
        num_b = 64'd25;

        #10
        $display("xor test:\n");
        opcode = XOR;
        num_a = 64'd12;
        num_b = 64'd25;

        #10
        $display("not test:\n");
        opcode = NOT;
        num_a = 64'd0;

        #10
        $display("inc test:\n");
        opcode = INC;
        num_a = 64'd2;

        #10 // testing overflow
        $display("sum overflow test:\n");
        opcode = SUM;
        num_a = 64'b0111111111111111111111111111111111111111111111111111111111111111;
        num_b = 64'd3;

        #10 // testing overflow
        $display("sub overflow test:\n");
        opcode = SUB;
        num_a = 64'b1000000000000000000000000000000000000000000000000000000000000000;
        num_b = 64'd3;

        #10 // testing zero
        $display("zero test:\n");
        opcode = SUB;
        num_a = 64'd54;
        num_b = 64'd54;

    end // initial begin

endmodule: tb_alu_64