#!/bin/bash

# This script is used to run GHDL simulations for VHDL files.
# It takes as parameter the name of the simulation process to run.

# Usage: ./ghdl_simulation.sh <simulation_process_name>

# Check if the simulation process name is provided
if [ -z "$1" ]; then
    echo "Usage: source hw/ghdl/ghdl_simulation.sh  <simulation_process_name>"
    # exit 1
fi

# Case statement to handle different simulation processes
case $1 in
    "bnn_utilities")
        ghdl -c hw/src/hdl/packages/utilities_pkg.vhd hw/src/hdl/packages/BNN_pkg.vhd hw/src/sim/bnn/testBNN_utilities.vhd -r testUtilities
        ;;
    "compressors")
        ghdl -c hw/src/hdl/bnn/compressor_6_3.vhd hw/src/hdl/bnn/compressor_3_2.vhd hw/src/sim/bnn/test_compressor.vhd -r test_compressor
        ;;
    "compressor_layer")
        ghdl -c --std=08 hw/src/hdl/packages/utilities_pkg.vhd hw/src/hdl/packages/BNN_pkg.vhd hw/src/hdl/bnn/compressor_6_3.vhd hw/src/hdl/bnn/compressor_layer.vhd hw/src/sim/bnn/test_compressor_layer.vhd -r test_compressor_layer --stop-time=100ns
        ;;
    "popcounter")
        ghdl -c hw/src/hdl/packages/utilities_pkg.vhd hw/src/hdl/packages/BNN_pkg.vhd \
                hw/src/hdl/bnn/compressor_6_3.vhd \
                hw/src/hdl/bnn/compressor_layer.vhd \
                hw/src/hdl/bnn/ternary_adder.vhd \
                hw/src/hdl/bnn/popcounter_tree.vhd \
                hw/src/hdl/bnn/popcounter.vhd \
                hw/src/sim/bnn/test_popcounter.vhd \
                -r test_popcounter --stop-time=100ns #> hw/ghdl/sim.txt
        ;;
    "btpu")
        ghdl -c \
            hw/src/hdl/packages/utilities_pkg.vhd \
            hw/src/hdl/packages/BNN_pkg.vhd \
            hw/src/hdl/packages/types_pkg.vhd \
            hw/src/hdl/packages/constant_package.vhd \
            hw/src/hdl/packages/memory_pkg.vhd \
            hw/src/hdl/bnn/compressor_6_3.vhd \
            hw/src/hdl/bnn/compressor_layer.vhd \
            hw/src/hdl/bnn/ternary_adder.vhd \
            hw/src/hdl/bnn/popcounter_tree.vhd \
            hw/src/hdl/bnn/popcounter.vhd \
            hw/src/hdl/bnn/binary_mac.vhd \
            hw/src/hdl/bnn/BTPU_MAC.vhd \
            hw/ghdl/src/BTPU_memory.vhd \
            hw/src/hdl/bnn/BTPU.vhd \
            hw/ghdl/src/BTPU_tb.vhd \
            -r BTPU_tb \
            > hw/ghdl/results/sim_btpu.txt
        ;;
    "all")
        ghdl -c hw/src/hdl/packages/utilities_pkg.vhd hw/src/hdl/packages/BNN_pkg.vhd hw/src/sim/bnn/testBNN_utilities.vhd -r testUtilities
        echo ""
        ghdl -c hw/src/hdl/packages/utilities_pkg.vhd hw/src/hdl/packages/BNN_pkg.vhd hw/src/hdl/bnn/compressor_6_3.vhd hw/src/hdl/bnn/compressor_layer.vhd hw/src/sim/bnn/test_compressor_layer.vhd -r test_compressor_layer --stop-time=100ns
        ;;
    *)
        echo "Unknown simulation process: $1"
        echo "Available processes: all, compressors, bnn_utilities, compressor_layer, popcounter"
        return 1
        ;;
esac