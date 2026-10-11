# Loads the prj:: commands. 'make vivado' sources it when the GUI starts; in a
# GUI opened otherwise, type in the Tcl console:
#   source <product>/hw/scripts/prj.tcl
# The Makefile runs the same commands in batch mode through run.tcl.

namespace eval ::prj {
    foreach script {common usr_access package_ip create export ip sim build check} {
        source [file join [file dirname [file normalize [info script]]] $script.tcl]
    }
    # In a namespace eval the loop variable is a variable of the namespace.
    unset script
}

proc ::prj::help {} {
    puts {prj:: commands (the Makefile target in brackets):
  prj::create                  create hw/vivado/                     [project]
  prj::export                  project -> hw/src/vivado_project.tcl  [export]
  prj::ip ?name? ?M.m?         repackage IPs, upgrade, export        [ip]
  prj::package_ip name ?M.m?   package one IP, nothing else
  prj::sim ?name?              run IP testbenches with xsim          [sim]
  prj::build synth|bitstream|xsa                                     [synth, bitstream, xsa]
  prj::check                   checks to run before a commit         [check]}
}

puts "prj:: commands loaded, type prj::help"
