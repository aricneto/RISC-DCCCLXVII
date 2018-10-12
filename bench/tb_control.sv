`include "packages/opcodes.svh"
`include "packages/operations.svh"
`include "control_top.sv"
`include "alu.sv"       
`include "mux_2to1_64.sv"  
`include "reg_ld.sv"
`include "mux_4to1_64.sv"  
`include "regfile_64.sv"
`include "instr_reg.sv"    
`include "processing.sv"   
`include "sign_extend.sv"
`include "memory_64.sv"  
`include "memory_32.sv"     
`include "ramOnChip.v"
`timescale 1ps/1ps

import opcodes::*;
import operations::*;

module tb_control;

    logic clk;
    logic reset;

    control_top control_top(
        .clk(clk),
        .reset(reset)
    );

    initial begin
        clk = 0;
        reset = 1;
        #10 reset = 0;
    end

    always
        #20 clk = !clk;

endmodule: tb_control