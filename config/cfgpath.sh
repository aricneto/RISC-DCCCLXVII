#!/bin/bash

export PATH_WORK=$(cd ..; pwd)

printf "\nPATH_WORK (caminho da pasta de trabalho) = \n%s\n\n" "$PATH_WORK"

export MODELSIM="${PATH_WORK}/modelsim.ini"

printf "\nMODELSIM = \n%s\n\n" "$MODELSIM"
