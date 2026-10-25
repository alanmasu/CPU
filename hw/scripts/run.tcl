# Batch entry point, used by the Makefile:
#   vivado -mode batch -source hw/scripts/run.tcl -tclargs <command> ?args?
# Runs prj::<command>, one of the commands of prj::help, and closes the
# project it opened.

source [file join [file dirname [file normalize [info script]]] prj.tcl]

set command [lindex $argv 0]
set ::prj_priv::batch 1
if {[info commands ::prj::$command] eq ""} {
    error "Unknown command '$command': see prj::help"
}
# An error is printed as "ERROR: prj::<command>: <message>", so that it can
# be found in the long output of Vivado, followed by the Tcl stack.
if {[catch {::prj::$command {*}[lrange $argv 1 end]} message]} {
    puts "ERROR: prj::$command: $message"
    # errorInfo starts with the message itself: only the stack after it.
    puts [string range $::errorInfo [string length $message] end]
    exit 1
}

if {[::prj_priv::project_is_open]} {
    close_project
}
