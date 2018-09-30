#!/bin/bash

PATH_WORK=$(pwd)
MODELSIM="${PATH_WORK}/config/modelsim.ini"

# delete previous lib
vdel -lib  ${PATH_WORK}/libs/lib_SV -all
 
# create new lib
vlib ${PATH_WORK}/libs/lib_SV

# map lib to lib_SV
vmap lib_SV ${PATH_WORK}/libs/lib_SV

# compile all files in hdl and its subfolders
for filename in ${PATH_WORK}/hdl/*.sv ${PATH_WORK}/hdl/**/*.sv; do
    # if a file exists
    [ -e "$filename" ] || continue

    # get full file name
    fullname=${filename##*/}

    # compile
    printf "\n===-==-===-==-===\n\nCompiling $fullname\n\n"
    vlog -warning error -msgsingleline -work lib_SV $filename

done