# prj::build: build the project.
#   prj::build synth      run synthesis
#   prj::build bitstream  run up to write_bitstream, copy the .bit to out/hw/
#   prj::build xsa        as bitstream, then write the hardware platform
# Runs that are complete and up to date are not launched again. From the GUI
# the console waits until the runs are done.
#
# The bitstream carries the git commit of the product in USR_ACCESS (see
# usr_access.tcl), written by the hook write_bitstream_pre.tcl. Vivado does
# not know that a commit changes the bitstream: when the implementation is
# up to date but the value written last differs from the current one, only
# the write_bitstream step runs again.

proc ::prj::build {target} {
    namespace upvar ::prj_priv out_dir out_dir
    variable project_name
    variable jobs

    if {$target ni {synth bitstream xsa}} {
        error "usage: prj::build synth|bitstream|xsa"
    }
    check_vivado_version
    open_project_if_needed

    set synth [get_runs synth_1]
    set impl [get_runs impl_1]
    set_usr_access_hook

    if {$target eq "synth"} {
        if {![run_is_done $synth]} {
            reset_run $synth
            launch_runs $synth -jobs $jobs
            wait_on_run $synth
        }
        check_run $synth
        return
    }

    if {![run_is_done $impl] || [find_bitstream] eq ""} {
        if {![run_is_done $synth]} {
            reset_run $synth
        }
        reset_run $impl
        launch_runs $impl -to_step write_bitstream -jobs $jobs
        wait_on_run $impl
    } elseif {[usr_access_stale $impl]} {
        puts "USR_ACCESS out of date: writing the bitstream again"
        reset_run $impl -from_step write_bitstream
        launch_runs $impl -to_step write_bitstream -jobs $jobs
        wait_on_run $impl
    }
    check_run $impl
    file mkdir $out_dir
    file copy -force [find_bitstream] [file join $out_dir $project_name.bit]
    puts "Bitstream: out/hw/$project_name.bit"

    if {$target eq "xsa"} {
        write_hw_platform -fixed -include_bit -force -file [file join $out_dir $project_name.xsa]
        puts "Hardware platform: out/hw/$project_name.xsa"
    }
}

proc ::prj_priv::run_is_done {run} {
    return [expr {[get_property PROGRESS $run] eq "100%" && ![get_property NEEDS_REFRESH $run]}]
}

proc ::prj_priv::check_run {run} {
    if {[get_property PROGRESS $run] ne "100%"} {
        error "$run failed: see [get_property DIRECTORY $run]/runme.log"
    }
}

proc ::prj_priv::find_bitstream {} {
    return [lindex [glob -nocomplain -directory [get_property DIRECTORY [get_runs impl_1]] *.bit] 0]
}

# The hook that writes USR_ACCESS, on impl_1. A hook set by the user is left
# alone, with a warning: then the bitstream does not carry the commit.
proc ::prj_priv::set_usr_access_hook {} {
    variable hw_dir
    set hook [file normalize [file join $hw_dir scripts write_bitstream_pre.tcl]]
    set impl [get_runs impl_1]
    set current [get_property STEPS.WRITE_BITSTREAM.TCL.PRE $impl]
    if {$current eq ""} {
        set_property STEPS.WRITE_BITSTREAM.TCL.PRE $hook $impl
        set current $hook
    }
    # Vivado wants the hook scripts of the runs in the fileset utils_1
    # (warning Runs 36-537 otherwise).
    if {[file normalize $current] eq $hook} {
        if {[llength [get_files -quiet -of_objects [get_filesets utils_1] $hook]] == 0} {
            add_files -fileset utils_1 -norecurse $hook
        }
    } else {
        message 3 WARNING "impl_1 already runs $current before write_bitstream: USR_ACCESS is not set by the template (call hw/scripts/write_bitstream_pre.tcl from that script to keep it)"
    }
}

# True when the bitstream of impl_1 does not carry the current value of
# USR_ACCESS: the hook saves the value it writes in usr_access.txt, in the
# directory of the run.
proc ::prj_priv::usr_access_stale {impl} {
    variable root_dir
    variable hw_dir
    set hook [file normalize [file join $hw_dir scripts write_bitstream_pre.tcl]]
    if {[file normalize [get_property STEPS.WRITE_BITSTREAM.TCL.PRE $impl]] ne $hook} {
        return 0
    }
    set saved [file join [get_property DIRECTORY $impl] usr_access.txt]
    if {![file exists $saved]} {
        return 1
    }
    return [expr {[read_text $saved] ne [usr_access_hex [usr_access_value $root_dir]]}]
}
