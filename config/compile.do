# create lib if it wasn't created before
vlib libs/lib_BENCH

# delete previous lib
vdel -lib libs/lib_BENCH -all
 
# recreate lib
vlib libs/lib_BENCH

# map lib to lib_BENCH
vmap lib_BENCH libs/lib_BENCH

# compile all files in bench and its subfolders
vlog -msgsingleline -work lib_BENCH bench/tb_control.sv +incdir+hdl+hdl/memory -y hdl
