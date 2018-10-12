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

    // uncomment ONE of these lines to test an instruction set
    defparam control_top.processor.memory_instr.init_file = "mem/test_type_r.mif";

    initial begin
        $monitor("instruction: %b\nopcode: %b\nfunct7: %b\nfunct3: %b\n\n===-==-===-==-===", control_top.processor.instr_reg.instr_all, control_top.processor.instr_reg.opcode, control_top.processor.instr_reg.instr_all[31:25], control_top.processor.instr_reg.instr_all[14:12]);
        clk = 0;
        reset = 1;
        #10 reset = 0;
    end

    always
        #50 clk = !clk;

endmodule: tb_control