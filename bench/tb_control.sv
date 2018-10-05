`include "control_top.sv"
`include "alu_64.sv"       
`include "mux_2to1_64.sv"  
`include "reg_64.sv"
`include "mux_4to1_64.sv"  
`include "regfile_64.sv"
`include "instr_reg.sv"    
`include "processing.sv"   
`include "sign_extend.sv"
`include "memory_64.sv"  
`include "memory_32.sv"     
`include "ramOnChip.v"
`include "reg_32.sv" 
`timescale 1ns/1ns

module tb_control;

    logic clk;

    control_top control_top();

    initial begin
        $monitor("\ntime = %t\nreg x9 = %d\nreg x20 = %d\nreg x21 = %d\n\n===-==-===-==-===", $time, control_top.processor.reg_file.registers[10], control_top.processor.reg_file.registers[21], control_top.processor.reg_file.registers[22]);

        clk = 0;

    end // initial begin

    always
        #100 clk = !clk;

endmodule: tb_control