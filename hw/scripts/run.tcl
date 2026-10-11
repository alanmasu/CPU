# Batch entry point, used by the Makefile:
#   vivado -mode batch -source hw/scripts/run.tcl -tclargs <command> ?args?
# Runs prj::<command>, one of the commands of prj::help, and closes the
# project it opened.

source [file join [file dirname [file normalize [info script]]] prj.tcl]

set command [lindex $argv 0]
if {[info commands ::prj::$command] eq ""} {
    error "Unknown command '$command': see prj::help"
}
::prj::$command {*}[lrange $argv 1 end]

if {[::prj_priv::project_is_open]} {
    close_project
}
