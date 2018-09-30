#!/bin/bash

PATH_WORK=$(pwd)
MODELSIM="${PATH_WORK}/config/modelsim.ini"

# delete previous lib
vdel -lib  ${PATH_WORK}/libs/lib_SV -all
 
# create new lib
vlib ${PATH_WORK}/libs/lib_SV

# map lib to lib_SV
vmap lib_SV ${PATH_WORK}/libs/lib_SV

# compile files
vlog -check_synthesis -work lib_SV ${PATH_WORK}/hdl/alu_64.sv
vlog -check_synthesis -work lib_SV ${PATH_WORK}/hdl/instr_reg_64.sv
vlog -check_synthesis -work lib_SV ${PATH_WORK}/hdl/regfile_64.sv
