#!bin/bash

MATRIX_SIZE=64
BLOCK_SIZE=32

source scripts/activate
executePython -s simulation/matrix_utilities.py -m W_Memory   -f testbench/BNN/testMatrix.svh -sp 0 -ms ${MATRIX_SIZE} -bs ${BLOCK_SIZE} 
executePython -s simulation/matrix_utilities.py -m IO0_Memory -f testbench/BNN/testMatrix.svh -sp 1 -ms ${MATRIX_SIZE} -bs ${BLOCK_SIZE} -a
executePython -s simulation/matrix_utilities.py -m IO1_Memory -f testbench/BNN/testMatrix.svh -sp 2 -ms ${MATRIX_SIZE} -bs ${BLOCK_SIZE} -a