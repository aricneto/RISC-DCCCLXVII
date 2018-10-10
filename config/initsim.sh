#!/bin/bash

export PATH_WORK=$(pwd)

printf "\nPATH_WORK (caminho da pasta de trabalho) = \n%s\n\n" "$PATH_WORK"

export MODELSIM="${PATH_WORK}/modelsim.ini"

printf "\nMODELSIM = \n%s\n\n" "$MODELSIM"

vsim -L altera_mf_ver -L lpm_ver -L sgate_ver -L altera_ver -novopt lib_BENCH.tb_control -do config/waves.do