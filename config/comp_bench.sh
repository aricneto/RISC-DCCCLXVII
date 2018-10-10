#!/bin/bash

PATH_WORK=$(pwd)
MODELSIM="${PATH_WORK}/modelsim.ini"

mkdir -p ${PATH_WORK}/libs/lib_BENCH

# delete previous lib
vdel -lib  ${PATH_WORK}/libs/lib_BENCH -all
 
# create new lib
vlib ${PATH_WORK}/libs/lib_BENCH

# map lib to lib_BENCH
vmap lib_BENCH ${PATH_WORK}/libs/lib_BENCH

# compile all files in bench and its subfolders
for filename in ${PATH_WORK}/bench/*.*v ${PATH_WORK}/bench/**/*.*v; do
    # if a file exists
    [ -e "$filename" ] || continue

    # get full file name
    fullname=${filename##*/}

    # compile
    printf "\n===-==-===-==-===\n\nCompiling $fullname\n\n"
    vlog -msgsingleline -work lib_BENCH $filename +incdir+${PATH_WORK}/hdl+${PATH_WORK}/hdl/memory -y ${PATH_WORK}/hdl

done
