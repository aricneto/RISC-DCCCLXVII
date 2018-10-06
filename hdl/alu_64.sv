module alu_64(
    // alu funct
    input wire [2:0] funct,

    // alu operand inputs
    input logic signed [63:0] a,
    input logic signed [63:0] b,

    // operation result
    output logic signed [63:0] result,

    // status outputs
    output logic overflow,
    output logic negative,
    output logic zero,
    output logic equal,
    output logic greater,
    output logic less
);

enum {SUM, SHIFT_LEFT, SUB, LOAD, XOR, SHIFT_RIGHT, NOT, AND} ops;

// result of the operation, assigned in always block
logic signed [63:0] res;

// result of addition and subtraction operations.
logic signed [63:0] res_add;
logic signed [63:0] res_sub;

// assign operation results
assign res_add = a + b;
assign res_sub = a - b;

// output operation result
assign result = res;

// equality test outputs
assign equal   = a == b; // output true if a == b
assign greater = a > b;  // output true if a > b
assign less    = a < b;  // output true if a < b

assign zero = (result == 0);  // output true if result is zero
assign negative = result[63]; // output true if result is negative

// output true if overflow occurred 
assign overflow = funct == SUM ? ((a[63] == b[63]) & res_add[63] != a[63]) : ((a[63] != b[63]) & res_sub[63] != a[63]);

always_comb begin
    case (funct)
        SUM: // sum
            res = res_add;
        SUB: // sub
            res = res_sub;
        SHIFT_LEFT:
            res = a << b;
        SHIFT_RIGHT:
            res = a >> b;
        LOAD: // load
            res = a;
        AND: // and
            res = a & b;
        XOR: // xor
            res = a ^ b;
        NOT: // not a
            res = ~a;
        default: 
	        res = 64'd0;
	endcase
end

endmodule: alu_64