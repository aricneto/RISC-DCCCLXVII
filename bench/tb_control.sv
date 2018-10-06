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
`timescale 1ps/1ps

module tb_control;

    logic clk;
    logic reset;

    control_top control_top(
        .clk(clk),
        .reset(reset)
    );

    initial begin
        $monitor("\ntime = %t\nreg x9 = %d\nreg x20 = %d\nreg x21 = %d\nstate = %b\nnext  = %b\ninstr = %b\npc = %d\nmux = %d\n\n===-==-===-==-===", 
        $time, 
        control_top.processor.reg_file.registers[10], 
        control_top.processor.reg_file.registers[21], 
        control_top.processor.reg_file.registers[22],
        control_top.state,
        control_top.next_state,
        control_top.instruction,
        control_top.processor.pc_data,
        control_top.processor.mux_pc_out);

        clk = 0;
        reset = 1;
        #10 reset = 0;

    end // initial begin

    always
        #80 clk = !clk;

endmodule: tb_control