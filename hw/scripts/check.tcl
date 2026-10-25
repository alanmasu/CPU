# prj::check: checks to run before a commit.
#  - this Vivado matches hw/VIVADO_VERSION
#  - no block design has changes that were not exported
#  - no committed file contains an absolute path of this machine
#  - with -with-export, no change of the project is missing from the
#    snapshot: the project is exported into work/ and compared with the
#    snapshot it matches, which takes the time of an export (see
#    exported_changes in sync.tcl). When they are the same, the files of
#    the project were rewritten by a build only: .baseline/ is updated, so
#    that the pre-commit hook, which compares the files without Vivado,
#    lets the commit through.
# It also warns, without failing:
#  - about local IPs not released, or whose component.xml does not match
#    their committed RTL (see prj::release);
#  - when the namespace prj holds commands that are not of the template:
#    procs of Vivado loaded while a command of prj was running.

proc ::prj::check {{option ""}} {
    namespace upvar ::prj_priv root_dir root_dir
    namespace upvar ::prj_priv project_dir project_dir
    namespace upvar ::prj_priv snapshot_copy snapshot_copy

    set with_export [expr {[check_option $option {-with-export}] eq "-with-export"}]
    check_vivado_version
    set problems 0

    if {[file exists $project_dir]} {
        set stale [unexported_bds]
        if {[llength $stale] > 0} {
            puts "NOT EXPORTED: block designs changed after the last export: $stale (run prj::export)"
            incr problems
        }
        # Normal after a pull: not a problem for a commit, but the project
        # is not the one in git.
        if {[file exists $snapshot_copy] && [snapshot_changed]} {
            puts "SNAPSHOT CHANGED: hw/src/vivado_project.tcl is not the snapshot this project matches; make vivado, synth, bitstream or xsa create the project again from it (see prj::sync)"
        }
        if {$with_export} {
            set changes [exported_changes]
            if {$changes ne ""} {
                puts "NOT EXPORTED: the project has changes that are not in its snapshot (run prj::export to save them):\n$changes"
                incr problems
            } else {
                save_baseline_files
                puts "EXPORT: the project gives back its snapshot, so it has no changes to export; its files are now the reference of the pre-commit hook"
            }
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

    set xsa_state [delivered_xsa_state]
    if {$xsa_state ne ""} {
        puts "XSA: $xsa_state: run 'make xsa', then 'make update-xsa'"
    }

    foreach name [local_ips] {
        set ip_problems [ip_release_state $name]
        if {[llength $ip_problems] > 0} {
            puts "IP $name [component_param [file join $root_dir hw ip $name component.xml] version]: [join $ip_problems {, }]: run make release IP=$name when the RTL is ready"
        }
    }

    set foreign {}
    foreach command [lsort [info commands ::prj::*]] {
        if {[namespace tail $command] ni {build check create export help ip get_commit package_ip regen_pkg release sim sim_all sim_ip sync}} {
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

# The .xsa delivered to the software in sw/hw/ (make update-xsa), against
# the commits: "" when it is fine or there is none, otherwise what is wrong.
# Its commit comes from <project>.usr_access, the USR_ACCESS value of its
# bitstream. Older than hw/ means that a commit after it changed hw/ (the
# scripts of the template left out: they do not change the hardware).
proc ::prj_priv::delivered_xsa_state {} {
    variable root_dir
    set xsas [glob -nocomplain -directory [file join $root_dir sw hw] *.xsa]
    if {[llength $xsas] == 0} {
        return ""
    }
    set value_file "[file rootname [lindex $xsas 0]].usr_access"
    if {![file exists $value_file]} {
        return "sw/hw/[file tail [lindex $xsas 0]] has no commit (delivered with FORCE=1)"
    }
    scan [read_text $value_file] %x value
    set commit [format %07x [expr {($value >> 4) & 0xFFFFFFF}]]
    set problems {}
    if {$value & 1} {
        lappend problems "built from commit $commit with changes in hw/ that were not committed"
    }
    set last [git_output $root_dir log -1 --format=%h -- hw :(exclude)hw/scripts]
    # merge-base exits with 1 when the first commit is not an ancestor of
    # the second, and exec takes that for an error.
    if {$last ne "" && [catch {exec git -C $root_dir merge-base --is-ancestor $last $commit}]} {
        lappend problems "built from commit $commit, older than the last change to hw/ ($last)"
    }
    return [join $problems "; "]
}
