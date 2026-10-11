# Device tree sources from the .xsa, with xsct, hsi and device-tree-xlnx
# (Vitis up to 2024.1).
# Run by build.sh, which passes the paths through the environment:
#   XSA  OUT_DIR  DT_REPO  PROCESSOR  DT_BOARD (may be empty)
# Produces the .dts/.dtsi files in OUT_DIR; build.sh then runs cpp and dtc.

set xsa       $::env(XSA)
set out_dir   $::env(OUT_DIR)
set dt_repo   $::env(DT_REPO)
set processor $::env(PROCESSOR)
set board     $::env(DT_BOARD)

puts "DT: xsa  = $xsa"
puts "DT: repo = $dt_repo"
puts "DT: out  = $out_dir"

hsi open_hw_design $xsa
hsi set_repo_path $dt_repo
hsi create_sw_design device-tree -os device_tree -proc $processor
# The board file of device-tree-xlnx (data/kernel_dtsi/<version>/BOARD/),
# included at the end of system-top.dts: it sets the root compatible and the
# devices of the board. hsi stops with an error if the board has no file.
if {$board ne ""} {
    hsi set_property CONFIG.periph_type_overrides "{BOARD $board}" [hsi get_os]
}
hsi generate_target -dir $out_dir

hsi close_hw_design [hsi current_hw_design]

exit
