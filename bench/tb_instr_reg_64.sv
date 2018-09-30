`include "../hdl/instr_reg_64.sv"
`timescale 1ns/1ns

module tb_instr_reg_64;

    // clock and reset
    logic clk;
    logic reset;

    // enable register data read
    logic load_ir;

    // register num
    logic [31:0] instruction;

    // instruction outputs
    logic [31:0] instr_all;
    logic [4:0] instr_25_21;
    logic [4:0] instr_20_16;
    logic [15:0] instr_15_0;

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
        $monitor("\ntime  = %d\nload  = %b\nreset = %b\ninstr = %b\nall   = %b\n25-21 = %b\n20-16 = %b\n15-0  = %b\n\n===-==-===-==-===", $time, load_ir, reset, instruction, instr_all, instr_25_21, instr_20_16, instr_15_0);

        clk = 0;
        reset = 0;

        #4
        load_ir = 1;
        instruction = 64'b0101001000010011111111000001010101011111111101111001101010111111;

        #4
        load_ir = 1;
        instruction = 64'b1001001100111100111011011111001001110000100110101101001010101111;

        #4
        load_ir = 1;
        instruction = 64'b0110010000110010010100100100010001100000110111110011110101101000;

        #4
        load_ir = 0;
        instruction = 64'b0101001000010011111111000001010101011111111101111001101010111111;

        #4
        load_ir = 1;
        instruction = 64'b1011111101110111000011100010011111100100111100110011000111001111;
        reset = 1;

        #4;

    end

    always
        #1 clk = !clk;

endmodule: tb_instr_reg_64