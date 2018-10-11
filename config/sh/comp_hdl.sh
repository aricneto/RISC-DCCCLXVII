#!/bin/bash

PATH_WORK=$(pwd)
MODELSIM="${PATH_WORK}/modelsim.ini"

mkdir -p ${PATH_WORK}/libs/lib_SV

# delete previous lib
vdel -lib  ${PATH_WORK}/libs/lib_SV -all
 
# create new lib
vlib ${PATH_WORK}/libs/lib_SV

# map lib to lib_SV
vmap lib_SV ${PATH_WORK}/libs/lib_SV

# compile all files in hdl and its subfolders
for filename in ${PATH_WORK}/hdl/*.*v ${PATH_WORK}/hdl/**/*.*v; do
    # if a file exists
    [ -e "$filename" ] || continue

    # get full file name
    fullname=${filename##*/}

    # compile
    printf "\n===-==-===-==-===\n\nCompiling $fullname\n\n"
    vlog -msgsingleline -work lib_SV $filename

done