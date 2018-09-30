module alu_64(
    // alu opcode
    input wire [2:0] opcode,

    // alu operand inputs
    input wire [63:0] a,
    input wire [63:0] b,

    // operation result
    output wire [63:0] result,

    // status outputs
    output logic overflow,
    output logic negative,
    output logic zero,
    output logic equal,
    output logic greater,
    output logic less
);

enum {LOAD, SUM, SUB, AND, XOR, NOT, INC} ops;

// result of the operation, assigned in always block
wire [63:0] res;

// result of addition and subtraction operations.
wire [63:0] res_add;
wire [63:0] res_sub;

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
assign overflow = a[63] != b[63] ? 0 : (operation == SUM ? res_add[63] != a[63] : res_sub[63] != a[63]);

always @(*) begin
    case (opcode) begin
        LOAD: // load
            res = a;
        SUM: // sum
            res = res_add;
        SUB: // sub
            res = res_sub;
        AND: // and
            res = a & b;
        XOR: // xor
            res = a ^ b;
        NOT: // not a
            res = ~a;
        INC: // increment a
            res = a + 1;
        default: 64'd0
    end
end

endmodule: alu_64