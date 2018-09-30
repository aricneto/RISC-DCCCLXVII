#!/bin/bash

PATH_WORK=$(pwd)
MODELSIM="${PATH_WORK}/config/modelsim.ini"

# delete previous lib
vdel -lib  ${PATH_WORK}/libs/lib_BENCH -all
 
# create new lib
vlib ${PATH_WORK}/libs/lib_BENCH

# map lib to lib_BENCH
vmap lib_BENCH ${PATH_WORK}/libs/lib_BENCH

# compile files
vlog -warning error -msgsingleline -work lib_BENCH ${PATH_WORK}/bench/tb_alu_64.sv
vlog -warning error -msgsingleline -work lib_BENCH ${PATH_WORK}/bench/tb_instr_reg_64.sv
