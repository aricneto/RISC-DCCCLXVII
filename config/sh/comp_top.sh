#!/bin/bash

PATH_WORK=$(pwd)
MODELSIM="${PATH_WORK}/modelsim.ini"

mkdir -p ${PATH_WORK}/libs/lib_BENCH

# create new lib
vlib ${PATH_WORK}/libs/lib_BENCH

# delete previous lib
vdel -lib  ${PATH_WORK}/libs/lib_BENCH -all
 
# create new lib
vlib ${PATH_WORK}/libs/lib_BENCH

# map lib to lib_BENCH
vmap lib_BENCH ${PATH_WORK}/libs/lib_BENCH

# compile top
vlog -msgsingleline -work lib_BENCH ${PATH_WORK}/bench/tb_control.sv +incdir+${PATH_WORK}/hdl+${PATH_WORK}/hdl/memory -y ${PATH_WORK}/hdl
