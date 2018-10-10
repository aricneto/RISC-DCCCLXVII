do config/compile.do
vsim -L altera_mf_ver -L lpm_ver -L sgate_ver -L altera_ver -novopt lib_BENCH.tb_control -do config/waves.do
