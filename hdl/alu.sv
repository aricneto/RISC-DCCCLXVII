// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==
// -> aricneto                          88,bd88b  88b .d888b, d8888b
//                                     88,P'    88P  ?8b,   d8P' `P
//                                    d88      d88    `?8b 88,b    
//                                   d88'     d88' `?888P' `?888P'
// -> module description:
//        8-function ALU with variable bus width 
// ==--===--===-==---==--==--===--===-==---==--==--===--===-==---==--==--==

module alu #(
    parameter SIZE = 64
)(
    // alu funct
    input wire [2:0] funct,

    // alu operand inputs
    input logic signed [SIZE-1:0] a,
    input logic signed [SIZE-1:0] b,

    // operation result
    output logic signed [SIZE-1:0] result,

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
logic signed [SIZE-1:0] res;

// result of addition and subtraction operations.
logic signed [SIZE-1:0] res_add;
logic signed [SIZE-1:0] res_sub;

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
assign negative = result[SIZE-1]; // output true if result is negative

// output true if overflow occurred 
assign overflow = funct == SUM ? ((a[SIZE-1] == b[SIZE-1]) & res_add[SIZE-1] != a[SIZE-1]) : ((a[SIZE-1] != b[SIZE-1]) & res_sub[SIZE-1] != a[SIZE-1]);

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
	        res = 0;
	endcase
end

endmodule: alu