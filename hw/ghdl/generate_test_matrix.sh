#!/bin/bash

BLOCK_SIZE=32
M=2
N=3
K=4
# Python with the packages of tools/activate
PYTHON=pyEnv/bin/python3

"$PYTHON" hw/ghdl/matrix_utilities.py -m W_Memory   -f hw/src/sim/bnn/testMatrix.svh -sp 0 -bs ${BLOCK_SIZE}    -by ${N} -bx ${K}
"$PYTHON" hw/ghdl/matrix_utilities.py -m IO0_Memory -f hw/src/sim/bnn/testMatrix.svh -sp 1 -bs ${BLOCK_SIZE} -a -by ${M} -bx ${N}
"$PYTHON" hw/ghdl/matrix_utilities.py -m IO1_Memory -f hw/src/sim/bnn/testMatrix.svh -sp 2 -bs ${BLOCK_SIZE} -a -by ${M} -bx ${N}