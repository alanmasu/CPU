# prj::check: checks to run before a commit.
#  - this Vivado matches hw/VIVADO_VERSION
#  - no block design has changes that were not exported
#  - no committed file contains an absolute path of this machine
# It also warns when the namespace prj holds commands that are not of the
# template: procs of Vivado loaded while a command of prj was running.

proc ::prj::check {} {
    namespace upvar ::prj_priv root_dir root_dir
    namespace upvar ::prj_priv project_dir project_dir

    check_vivado_version
    set problems 0

    if {[file exists $project_dir]} {
        set stale [unexported_bds]
        if {[llength $stale] > 0} {
            puts "NOT EXPORTED: block designs changed after the last export: $stale (run prj::export)"
            incr problems
        }
    }

    # Absolute paths: only files tracked by git matter, everything else is
    # generated. Both separators are searched, for files written on Windows.
    set needles [list $root_dir [file nativename $root_dir]]
    if {[info exists ::env(HOME)]} {
        lappend needles [file normalize $::env(HOME)]
    }
    set text_exts {.tcl .xdc .xci .xml .bd .v .sv .vh .svh .vhd .vhdl}
    if {[catch {exec git -C $root_dir ls-files} tracked]} {
        puts "SKIPPED: absolute path check, $root_dir is not a git repository"
    } else {
        foreach rel [split $tracked "\n"] {
            if {[file extension $rel] ni $text_exts} {
                continue
            }
            set text [read_text [file join $root_dir $rel]]
            foreach needle $needles {
                if {[string first $needle $text] >= 0} {
                    puts "ABSOLUTE PATH: $rel contains $needle"
                    incr problems
                    break
                }
            }
        }
    }

    set foreign {}
    foreach command [lsort [info commands ::prj::*]] {
        if {[namespace tail $command] ni {build check create export help ip package_ip sim}} {
            lappend foreign [namespace tail $command]
        }
    }
    if {[llength $foreign] > 0} {
        message 2 WARNING "commands that are not of the template in prj:: (procs of Vivado loaded while a prj:: command was running; harmless, but they show up with prj:: plus Tab): $foreign"
    }

    if {$problems > 0} {
        error "$problems problem(s) found"
    }
    puts "All checks passed"
}
