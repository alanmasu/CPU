# Ways to simulate:
#  - prj::sim, a simulation set of the project, launched by Vivado as with
#    Run Simulation in the GUI: any simulation set, with its files, top,
#    libraries and settings;
#  - prj::sim_all, every simulation set of the project in one session, with
#    the log and the result of each one in a directory;
#  - prj::sim_ip, the testbenches of the IPs compiled by hand with the xsim
#    tools, without a project.

# prj::sim: launch the behavioral simulation of a simulation set.
#   prj::sim              the active simulation set
#   prj::sim <simset>     another one
# It runs for the time set in the simulation set (xsim.simulate.runtime;
# "all" for the sets sim_<ip> made by prj::create). In batch (make sim) the
# simulation is then closed and its log read (simulation_result): it fails
# when Vivado stops or the log has a fatal error or an error, and a
# testbench that prints "TEST PASSED" says so in the result. In the GUI the
# simulation stays open with its waves, and the result is in the Tcl
# console; 'make sim GUI=1' opens the GUI and runs it there.
# The simulation set is made the active one first: launch_simulation -simset
# takes some settings, the include_dirs and the run time at least, from the
# active set and not from the one it is given (found by the porting on
# 2021.2, 24/10/2026): a set could run for the default 1000 ns and end
# without errors before its tests.
# In batch the active set of before is restored at the end, also when the
# simulation fails: the active set is saved in the .xpr, which prj::sync
# compares, so leaving another one would look like a local change, and
# after a pull that changes the snapshot 'make sync' would spend an export
# to find out that it is not. In the GUI the simulated set stays active,
# as when it is chosen by hand, because the simulation stays open.

proc ::prj::sim {{simset ""}} {
    namespace upvar ::prj_priv batch batch

    check_vivado_version
    open_project_if_needed
    if {$simset eq ""} {
        set simset [current_fileset -simset]
    }
    set fileset [simulation_set $simset]
    generate_ip_simulation_targets
    set previous [current_fileset -simset]
    current_fileset -simset $fileset
    set failure [launch_simulation_set $simset]
    if {$failure ne ""} {
        if {$batch} {
            current_fileset -simset $previous
        }
        error "The simulation of $simset failed: $failure"
    }

    if {!$batch} {
        puts "$simset: simulation open in the GUI, the result is in the Tcl console"
        return
    }
    global_eval close_sim -force
    current_fileset -simset $previous
    lassign [simulation_result $simset] status detail log
    if {$status eq "FAILED"} {
        error "$simset: TEST FAILED: $detail (see $log)"
    }
    if {$status eq "PASSED"} {
        puts "$simset: TEST PASSED"
    } else {
        puts "$simset: finished without errors (the testbench prints no TEST PASSED; see $log)"
    }
}

# prj::sim_all: simulate every simulation set of the project, in one session
# of Vivado, and write the result of each one into a directory.
#   prj::sim_all          into out/sim_all/
#   prj::sim_all <dir>    into another directory
# The directory is emptied first. For each simulation set, in alphabetical
# order and each made the active one as prj::sim does:
#   <dir>/<set>.log   its simulate.log, as xsim wrote it
#   <dir>/<set>.txt   only the lines of the log that match sim_result_lines
#                     of hw/project.tcl, when it is set: the lines that the
#                     testbenches of the product print for each test
# and <dir>/summary.txt, one line per set: PASSED (the testbench printed
# TEST PASSED), FAILED (with the first fatal error or error of the log),
# FINISHED (no error, and no TEST PASSED), DID NOT RUN (with the first
# line of the error of Vivado) or SKIPPED. A set without files of its own,
# such as the sim_1 that create_project makes, is skipped: it has no
# testbench, so it would only run the top of the design without stimulus,
# and simulating it fixes its top on the top_file of the snapshot (found by
# the porting in the CPU project, 25/10/2026). prj::sim still simulates it
# when it is asked to. Nothing in these files depends on the date
# or the machine, so two runs, for example before and after a change, are
# compared with 'diff -r'. It goes on after a set that fails, and fails at
# the end if any set failed or did not run. The active simulation set of
# before is restored at the end.
proc ::prj::sim_all {{dir ""}} {
    namespace upvar ::prj_priv root_dir root_dir
    variable sim_result_lines

    check_vivado_version
    open_project_if_needed
    if {$dir eq ""} {
        set dir [file join $root_dir out sim_all]
    }
    set dir [file normalize $dir]
    file delete -force $dir
    file mkdir $dir
    set pattern ""
    if {[info exists sim_result_lines]} {
        set pattern $sim_result_lines
    }

    generate_ip_simulation_targets
    set previous [current_fileset -simset]
    set summary {}
    set bad 0
    set sets [lsort [get_filesets -quiet -filter {FILESET_TYPE == SimulationSrcs}]]
    foreach simset $sets {
        puts "== $simset"
        if {[llength [get_files -quiet -of_objects [get_filesets $simset]]] == 0} {
            set line "$simset: SKIPPED: no files of its own"
            puts $line
            lappend summary $line
            continue
        }
        current_fileset -simset [get_filesets $simset]
        set failure [launch_simulation_set $simset]
        if {$failure ne ""} {
            set status "DID NOT RUN"
            set detail [lindex [split $failure "\n"] 0]
        } else {
            global_eval close_sim -force
            lassign [simulation_result $simset] status detail log
            if {$log ne ""} {
                file copy -force $log [file join $dir $simset.log]
                if {$pattern ne ""} {
                    write_text [file join $dir $simset.txt] [matching_lines [read_text $log] $pattern]
                }
            }
        }
        if {$status eq "FAILED" || $status eq "DID NOT RUN"} {
            incr bad
        }
        set line "$simset: $status"
        if {$detail ne ""} {
            append line ": $detail"
        }
        puts $line
        lappend summary $line
    }
    current_fileset -simset $previous

    write_text [file join $dir summary.txt] [join $summary "\n"]
    puts "Results of [llength $sets] simulation set(s) in $dir"
    if {$bad > 0} {
        error "$bad of [llength $sets] simulation set(s) failed or did not run: see [file join $dir summary.txt]"
    }
}

# The fileset of a simulation set, or an error if there is none.
proc ::prj_priv::simulation_set {simset} {
    set fileset [get_filesets -quiet $simset]
    if {[llength $fileset] == 0 || [get_property FILESET_TYPE $fileset] ne "SimulationSrcs"} {
        error "$simset is not a simulation set"
    }
    return $fileset
}

# Launch the behavioral simulation of a simulation set that is already the
# active one: "" when it runs, otherwise the error of Vivado. A
# SystemVerilog testbench that imports a VHDL package stops when the
# library of the simulation is empty (see regen_pkg.tcl): when the logs of
# the compilation say that something "is not declared", the VHDL packages
# are compiled with prj::regen_pkg and the simulation is launched once more,
# as one would do by hand (decision of the user, 25/10/2026).
proc ::prj_priv::launch_simulation_set {simset} {
    if {![catch {global_eval launch_simulation -simset $simset -mode behavioral} message]} {
        return ""
    }
    if {![something_not_declared $simset]} {
        return $message
    }
    puts "$simset: something is not declared, as when a SystemVerilog file imports a VHDL package not compiled yet: compiling the VHDL packages with prj::regen_pkg and launching the simulation again"
    if {[catch {::prj::regen_pkg $simset} regen_message]} {
        return "$message\n(prj::regen_pkg failed too: $regen_message)"
    }
    if {[catch {global_eval launch_simulation -simset $simset -mode behavioral} message]} {
        return $message
    }
    return ""
}

# Whether the logs of the compilation of a simulation set (xvlog.log,
# compile.log and the others, not simulate.log) say that something is not
# declared.
proc ::prj_priv::something_not_declared {simset} {
    foreach log [glob -nocomplain -directory [simulation_dir $simset] *.log] {
        if {[file tail $log] eq "simulate.log"} {
            continue
        }
        if {[string first "is not declared" [read_text $log]] >= 0} {
            return 1
        }
    }
    return 0
}

proc ::prj_priv::simulation_dir {simset} {
    variable project_dir
    namespace upvar ::prj project_name project_name
    return [file join $project_dir $project_name.sim $simset behav xsim]
}

# The result of a simulation already closed, from its simulate.log, which
# Vivado 2021.2 writes out only at close_sim (seen on 23/10/2026): a list
# of status (PASSED, FAILED, FINISHED), detail (the first fatal error or
# error, for FAILED) and the path of the log ("" when there is none).
proc ::prj_priv::simulation_result {simset} {
    set log [file join [simulation_dir $simset] simulate.log]
    if {![file exists $log]} {
        return [list FAILED "no simulate.log in [file dirname $log]" ""]
    }
    set text [read_text $log]
    if {[regexp -nocase -line {^(Fatal|ERROR):.*$} $text line]} {
        return [list FAILED $line $log]
    }
    if {[string first "TEST PASSED" $text] >= 0} {
        return [list PASSED "" $log]
    }
    return [list FINISHED "" $log]
}

# The lines of text that match the regular expression pattern.
proc ::prj_priv::matching_lines {text pattern} {
    set kept {}
    foreach line [split $text "\n"] {
        if {[regexp -- $pattern $line]} {
            lappend kept $line
        }
    }
    return [join $kept "\n"]
}

# The simulation products of the catalog IPs that are not inside a block
# design (their .xci in hw/src/ip/, used by the RTL or by a module
# reference). A project created from the snapshot does not have them, and
# launch_simulation does not make them: the simulation runs without the
# model of the IP, with only a warning (SIM-utils-52, "IP component XML file
# does not exist"; found by the porting in the CPU project, 2021.2,
# 25/10/2026). The IPs inside a block design are left out, because only
# their block design can generate them (generate_target on one of them
# stops with Vivado 12-3563), and launch_simulation generates the block
# designs by itself. generate_target does nothing for an IP whose products
# are up to date.
proc ::prj_priv::generate_ip_simulation_targets {} {
    set ips {}
    foreach ip [get_ips -quiet] {
        if {[string match */bd/* [get_property IP_FILE $ip]]} {
            continue
        }
        lappend ips $ip
    }
    if {[llength $ips] == 0} {
        return
    }
    puts "Simulation products of the catalog IPs outside block designs: [join $ips {, }]"
    generate_target simulation $ips
}

# prj::sim_ip: run IP testbenches with xsim, directly on the RTL. No
# packaging and no project needed, so it also runs right after a clone, in
# batch. The simulation sets sim_<ip> made by prj::create hold the same
# files, for prj::sim and the GUI.
#   prj::sim_ip            every IP with a sim/ directory
#   prj::sim_ip <name>     one IP
# The IP is hw/ip/<name>/ (stage B) or hw/src/hdl/<name>/ (stage A). The top
# testbench is sim/<name>_tb: it stops at the first failed assertion and
# prints "TEST PASSED" at the end.

proc ::prj::sim_ip {{target all}} {
    set dirs {}
    foreach dir [ip_sim_dirs] {
        if {$target eq "all" || [file tail $dir] eq $target} {
            lappend dirs $dir
        }
    }
    if {[llength $dirs] == 0} {
        error "No testbenches found for '$target' in hw/ip/*/sim or hw/src/hdl/*/sim"
    }
    foreach dir $dirs {
        run_testbench [file tail $dir] $dir
    }
}

proc ::prj_priv::run_testbench {name dir} {
    variable sim_dir
    variable hdl_exts

    set verilog {}
    set systemverilog {}
    set vhdl {}
    set files [concat [find_files $dir $hdl_exts sim] [find_files [file join $dir sim] $hdl_exts]]
    foreach f $files {
        switch [file extension $f] {
            .sv {
                lappend systemverilog $f
            }
            .vhd -
            .vhdl {
                lappend vhdl $f
            }
            .v {
                lappend verilog $f
            }
        }
    }

    # The xsim tools write into the current directory: move to a scratch
    # directory, and always come back (it is the GUI directory too).
    set work_dir [file join $sim_dir $name]
    file mkdir $work_dir
    set old_dir [pwd]
    cd $work_dir
    set failed [catch {
        if {[llength $verilog] > 0} {
            run_tool xvlog {*}$verilog
        }
        if {[llength $systemverilog] > 0} {
            run_tool xvlog -sv {*}$systemverilog
        }
        if {[llength $vhdl] > 0} {
            run_tool xvhdl {*}$vhdl
        }
        # Default time unit for the modules that do not declare one: xelab
        # refuses a design where only some modules have a `timescale.
        run_tool xelab ${name}_tb -s ${name}_tb -timescale 1ns/1ps
        run_tool xsim ${name}_tb -runall
    } output]
    cd $old_dir

    if {$failed || [string first "TEST PASSED" $output] < 0} {
        error "$name: TEST FAILED, see the output above"
    }
    puts "$name: TEST PASSED"
}

# Run an xsim tool, print its output and return it. The tools write progress
# on stderr, so only the exit status tells a failure.
proc ::prj_priv::run_tool {args} {
    set failed [catch {exec -ignorestderr {*}$args} output]
    puts $output
    if {$failed} {
        error "[lindex $args 0] failed"
    }
    return $output
}
