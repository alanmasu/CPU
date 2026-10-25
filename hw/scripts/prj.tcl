# Loads the prj:: commands. 'make vivado' sources it when the GUI starts; in a
# GUI opened otherwise, type in the Tcl console:
#   source <product>/hw/scripts/prj.tcl
# The Makefile runs the same commands in batch mode through run.tcl.

namespace eval ::prj {
    foreach script {common usr_access package_ip create export sync ip release sim regen_pkg build check} {
        source [file join [file dirname [file normalize [info script]]] $script.tcl]
    }
    # In a namespace eval the loop variable is a variable of the namespace.
    unset script
}

proc ::prj::help {} {
    puts {prj:: commands (the Makefile target in brackets):
  prj::create                  create hw/vivado/                     [project]
  prj::export ?-force|-discard-local?   project -> hw/src/vivado_project.tcl  [export]
  prj::sync ?-discard-local?   create hw/vivado/ again if the snapshot changed  [sync]
  prj::ip ?name? ?M.m?         repackage IPs, upgrade, export        [ip]
  prj::package_ip name ?M.m?   package one IP, nothing else
  prj::release name ?M.m?      release an IP whose RTL is committed  [release]
  prj::sim ?simset?            simulate a simulation set (default the active one)  [sim]
  prj::sim_all ?dir?           every simulation set, results in out/sim_all/  [sim_all]
  prj::sim_ip ?name?           IP testbenches with xsim, without the project       [sim_ip]
  prj::regen_pkg ?simset?      compile the VHDL packages of a simulation set  [regen_pkg]
  prj::build synth|bitstream|xsa                                     [synth, bitstream, xsa]
  prj::check ?-with-export?    checks to run before a commit; -with-export also
                               exports into work/ to find changes not exported  [check]
  prj::get_commit              the commit on the board, through JTAG}
}

puts "prj:: commands loaded, type prj::help"
