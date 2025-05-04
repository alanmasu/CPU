#!/bin/bash

# This script is used to run GHDL simulations for VHDL files.
# It takes as parameter the name of the simulation process to run.

# Usage: ./ghdl_simulation.sh <simulation_process_name>

# Check if the simulation process name is provided
if [ -z "$1" ]; then
    echo "Usage: source simulation/ghdl_simulation.sh  <simulation_process_name>"
    # exit 1
fi

# Case statement to handle different simulation processes
case $1 in
    "bnn_utilities")
        ghdl -c packages/utilities_pkg.vhd packages/BNN_pkg.vhd testbench/BNN/testBNN_utilities.vhd -r testUtilities
        ;;
    "compressor_layer")
        ghdl -c packages/utilities_pkg.vhd packages/BNN_pkg.vhd src/BNN/compressor_6_3.vhd src/BNN/compressor_layer.vhd testbench/BNN/test_compressor_layer.vhd -r test_compressor_layer --stop-time=100ns
        ;;
    "popcounter")
        ghdl -c packages/utilities_pkg.vhd packages/BNN_pkg.vhd src/BNN/compressor_6_3.vhd src/BNN/compressor_layer.vhd src/BNN/popcounter_tree.vhd testbench/BNN/test_popcounter.vhd -r test_popcounter --stop-time=100ns
        ;;
    "all")
        ghdl -c packages/utilities_pkg.vhd packages/BNN_pkg.vhd testbench/BNN/testBNN_utilities.vhd -r testUtilities
        echo ""
        ghdl -c packages/utilities_pkg.vhd packages/BNN_pkg.vhd src/BNN/compressor_6_3.vhd src/BNN/compressor_layer.vhd testbench/BNN/test_compressor_layer.vhd -r test_compressor_layer --stop-time=100ns
        ;;
    *)
        echo "Unknown simulation process: $1"
        echo "Available processes: all, bnn_utilities, compressor_layer, popcounter"
        return 1
        ;;
esac