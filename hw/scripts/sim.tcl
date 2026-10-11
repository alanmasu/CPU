# prj::sim: run IP testbenches with xsim, directly on the RTL. No packaging
# and no project needed, so it also runs with 'make sim' when the GUI is not
# open. From the GUI, the simulation sets sim_<ip> do the same with waves.
#   prj::sim            every IP with a sim/ directory
#   prj::sim <name>     one IP
# The IP is hw/ip/<name>/ (stage B) or hw/src/hdl/<name>/ (stage A). The top
# testbench is sim/<name>_tb: it stops at the first failed assertion and
# prints "TEST PASSED" at the end.

proc ::prj::sim {{target all}} {
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
