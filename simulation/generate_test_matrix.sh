#!bin/bash

BLOCK_SIZE=32
M=2
N=3
K=4
# check if CPU_ENV is set to 1
if [ -z "$CPU_ENV" ]; then
    echo "Activating CPU environment..."
    source scripts/activate
fi

executePython -s simulation/matrix_utilities.py -m W_Memory   -f testbench/BNN/testMatrix.svh -sp 0 -bs ${BLOCK_SIZE}    -by ${N} -bx ${K}  
executePython -s simulation/matrix_utilities.py -m IO0_Memory -f testbench/BNN/testMatrix.svh -sp 1 -bs ${BLOCK_SIZE} -a -by ${M} -bx ${N}
executePython -s simulation/matrix_utilities.py -m IO1_Memory -f testbench/BNN/testMatrix.svh -sp 2 -bs ${BLOCK_SIZE} -a -by ${M} -bx ${N}