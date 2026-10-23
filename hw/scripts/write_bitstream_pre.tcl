# Hook of the implementation run, executed by Vivado before write_bitstream
# (property STEPS.WRITE_BITSTREAM.TCL.PRE of impl_1, set by prj::create and
# prj::build): writes the git commit of the product into USR_ACCESS, see
# usr_access.tcl. It runs in the process of the run, from the directory of
# the run, also when the bitstream is generated from the GUI.
#
# The value written is also saved in usr_access.txt in that directory, so
# that prj::build can tell whether the bitstream still matches the commit.

set root [file dirname [file dirname [file dirname [file normalize [info script]]]]]
source [file join $root hw scripts usr_access.tcl]

set hex [::prj_priv::usr_access_hex [::prj_priv::usr_access_value $root]]
set_property BITSTREAM.CONFIG.USR_ACCESS $hex [current_design]
set f [open usr_access.txt w]
puts $f $hex
close $f
puts "USR_ACCESS = $hex"
