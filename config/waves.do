config wave -signalnamewidth 1
config list -signalnamewidth 1
config wave -vectorcolor yellow

# clock/reset
add wave -divider "Clock/Reset"

add wave -position sim:/tb_control/control_top/clk
add wave -position sim:/tb_control/control_top/reset

# control signals
add wave -divider "Control"

add wave -group "Control signals" \
    sim:/tb_control/control_top/processor/PCWrite \
    sim:/tb_control/control_top/processor/PCWrite \
    sim:/tb_control/control_top/processor/PCWriteCond \
    sim:/tb_control/control_top/processor/PCSource \
    sim:/tb_control/control_top/processor/ALUSrcA \
    sim:/tb_control/control_top/processor/ALUSrcB \
    sim:/tb_control/control_top/processor/ALUOp \
    sim:/tb_control/control_top/processor/LoadAOut \
    sim:/tb_control/control_top/processor/RegWrite \
    sim:/tb_control/control_top/processor/LoadRegA \
    sim:/tb_control/control_top/processor/LoadRegB \
    sim:/tb_control/control_top/processor/MemToReg \
    sim:/tb_control/control_top/processor/DMemOp \
    sim:/tb_control/control_top/processor/LoadMDR \
    sim:/tb_control/control_top/processor/IMemRead \
    sim:/tb_control/control_top/processor/IRWrite

# processing signals
add wave -divider "Processing"

add wave sim:/tb_control/control_top/processor/reg_file/registers
add wave sim:/tb_control/control_top/processor/program_counter/r_data

# watch signals
::add watch sim:/tb_control/control_top/processor/program_counter/r_data -radix decimal -radixenum default
::add watch sim:/tb_control/control_top/processor/alu/b -radix decimal -radixenum default
::add watch sim:/tb_control/control_top/processor/alu/result -radix decimal -radixenum default
::add watch sim:/tb_control/control_top/state -radix default -radixenum default
::add watch sim:/tb_control/control_top/processor/reg_file/registers -radix decimal -radixenum default
::add watch sim:/tb_control/control_top/processor/alu/ops -radix default -radixenum default
::add watch sim:/tb_control/control_top/processor/alu/a -radix decimal -radixenum default

# state machine list
add list  clk -notrigger -width 30 \
    sim:/tb_control/control_top/state \
    sim:/tb_control/control_top/next_state 
# pc
#add list  clk -notrigger sim:/tb_control/control_top/processor/pc_data
## alu
#add list sim:/tb_control/control_top/processor/alu/a 
#add list sim:/tb_control/control_top/processor/alu/b 
#add list -width 10 sim:/tb_control/control_top/processor/alu/ops 
#add list sim:/tb_control/control_top/processor/alu/result 


