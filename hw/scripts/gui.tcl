# Entry point of the Vivado GUI opened by the Makefile, with a command to
# run once the project is open:
#   vivado -source hw/scripts/gui.tcl <project>.xpr -tclargs <command> ?args?
# Vivado opens the project given on its command line before it runs this
# script, so the command finds it open. Unlike run.tcl, an error does not
# close Vivado: it is printed, and the GUI stays open. prj.tcl alone cannot
# do this, because run.tcl sources it too, with the arguments of the batch
# command.

source [file join [file dirname [file normalize [info script]]] prj.tcl]

if {[llength $argv] > 0} {
    set command [lindex $argv 0]
    if {[info commands ::prj::$command] eq ""} {
        puts "ERROR: unknown command '$command': see prj::help"
    } elseif {[catch {::prj::$command {*}[lrange $argv 1 end]} message]} {
        puts "ERROR: prj::$command: $message"
    }
    unset command
}
