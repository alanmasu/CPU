# Project configuration. Only plain `set` commands: every script in
# hw/scripts sources this file, nothing else parses it.

set project_name    CPU

# FPGA part and, optionally, board part: set for the ZedBoard, the board of
# the example. The board part needs the Digilent board files; leave it empty
# when no board files are used. List the installed ones with
# `get_board_parts` in the Vivado Tcl console.
set part            xc7z020clg484-1
set board_part      digilentinc.com:zedboard:part0:1.1

set target_language VHDL

# Vendor field of the VLNV of the IPs packaged in hw/ip/.
set ip_vendor       example.com

# Top module. Leave empty to use the wrapper of the first block design.
set top             top_level_wrapper

# Parallel jobs for synthesis and implementation runs.
set jobs            4

# Oldest Vivado this template supports. The version actually used is pinned
# in hw/VIVADO_VERSION when the project is created for the first time.
set vivado_min      2019.2
