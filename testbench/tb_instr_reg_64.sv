`timescale 1ns/1ns

module tb_instr_reg_64;

    // clock and reset
    logic clk;
    logic reset;

    // enable register data read
    logic load_ir;

    // register num
    logic signed [31:0] instruction;

    // instruction outputs
    logic signed [31:0] instr_all;
    logic signed [4:0] instr_25_21;
    logic signed [4:0] instr_20_16;
    logic signed [15:0] instr_15_0;

    instr_reg_64 inreg (
        .clk(clk),
        .reset(reset),
        .load_ir(load_ir),
        .instruction(instruction),
        .instr_all(instr_all),
        .instr_25_21(instr_25_21),
        .instr_20_16(instr_20_16),
        .instr_15_0(instr_15_0)
    );

    initial begin
        $monitor("time = %d\nload = %b\ninstr = %d\nall = %d\n25-21 = %d\n20-16 = %d\n15-0 = %d\n\n===-==-===-==-===", $time, load_ir, instruction, instr_all, instr_25_21, instr_20_16, instr_15_0);

        load_ir = 1;
        instruction = 420;

        #8
        load_ir = 1;
        instruction = 15;

        #8
        load_ir = 1;
        instruction = 32;

        #8
        load_ir = 0;
        instruction = 48;

        #8
        load_ir = 1;
        instruction = 90;
        reset = 1;

    end // initial begin

    always
        #5 clk = !clk;

endmodule: tb_instr_reg_64