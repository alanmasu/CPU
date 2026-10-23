# FSBL from the .xsa, with xsct and hsi (Vitis up to 2024.1).
# Run by build.sh, which passes the paths through the environment:
#   XSA  OUT_DIR  PROCESSOR
# Produces OUT_DIR/executable.elf: hsi always gives it that name.

set xsa       $::env(XSA)
set out_dir   $::env(OUT_DIR)
set processor $::env(PROCESSOR)

puts "FSBL: xsa = $xsa"
puts "FSBL: out = $out_dir"

hsi open_hw_design $xsa
hsi generate_app -proc $processor -app zynq_fsbl -compile -dir $out_dir

# current_hw_design instead of a hard-coded name, so that it does not depend
# on how the design was named in Vivado.
hsi close_hw_design [hsi current_hw_design]

exit
