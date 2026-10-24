# Two ways to simulate:
#  - prj::sim, a simulation set of the project, launched by Vivado as with
#    Run Simulation in the GUI: any simulation set, with its files, top,
#    libraries and settings;
#  - prj::sim_ip, the testbenches of the IPs compiled by hand with the xsim
#    tools, without a project.

# prj::sim: launch the behavioral simulation of a simulation set.
#   prj::sim              the active simulation set
#   prj::sim <simset>     another one
# It runs for the time set in the simulation set (xsim.simulate.runtime;
# "all" for the sets sim_<ip> made by prj::create). In batch (make sim) the
# simulation is then closed and its log read: it fails when Vivado stops or
# the log has a fatal error or an error, and a testbench that prints
# "TEST PASSED" says so in the result. The log is read only after
# close_sim, because Vivado 2021.2 writes it out only then (seen on
# 23/10/2026). In the GUI the simulation stays open with its waves, and the
# result is in the Tcl console; 'make sim GUI=1' opens the GUI and runs it
# there.
# A SystemVerilog testbench that imports a VHDL package can stop when the
# library of the simulation is empty: run prj::regen_pkg, then prj::sim
# again (see regen_pkg.tcl).
# The simulation set is made the active one first: launch_simulation -simset
# takes some settings, the include_dirs at least, from the active set and
# not from the one it is given (found by the porting on 2021.2, 24/10/2026).
# In batch the active set of before is restored at the end, also when the
# simulation fails: the active set is saved in the .xpr, which prj::sync
# compares, so leaving another one would look like a local change, and
# after a pull that changes the snapshot 'make sync' would spend an export
# to find out that it is not. In the GUI the simulated set stays active,
# as when it is chosen by hand, because the simulation stays open.

proc ::prj::sim {{simset ""}} {
    namespace upvar ::prj_priv project_dir project_dir
    namespace upvar ::prj_priv batch batch
    variable project_name

    check_vivado_version
    open_project_if_needed
    if {$simset eq ""} {
        set simset [current_fileset -simset]
    }
    set fileset [get_filesets -quiet $simset]
    if {[llength $fileset] == 0 || [get_property FILESET_TYPE $fileset] ne "SimulationSrcs"} {
        error "$simset is not a simulation set"
    }
    set previous [current_fileset -simset]
    current_fileset -simset $fileset
    if {[catch {global_eval launch_simulation -simset $simset -mode behavioral} message]} {
        if {$batch} {
            current_fileset -simset $previous
        }
        error "The simulation of $simset failed: $message\nIf the log says '<package>' is not declared, a SystemVerilog file imports a VHDL package: run prj::regen_pkg $simset (make regen-pkg SIMSET=$simset), then simulate again"
    }

    if {!$batch} {
        puts "$simset: simulation open in the GUI, the result is in the Tcl console"
        return
    }
    global_eval close_sim -force
    current_fileset -simset $previous
    set log [file join $project_dir $project_name.sim $simset behav xsim simulate.log]
    if {![file exists $log]} {
        error "$simset: no simulate.log in [file dirname $log]"
    }
    set text [read_text $log]
    if {[regexp -nocase -line {^(Fatal|ERROR):.*$} $text line]} {
        error "$simset: TEST FAILED: $line (see $log)"
    }
    if {[string first "TEST PASSED" $text] >= 0} {
        puts "$simset: TEST PASSED"
    } else {
        puts "$simset: finished without errors (the testbench prints no TEST PASSED; see $log)"
    }
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
