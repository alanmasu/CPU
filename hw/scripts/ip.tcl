# prj::ip: the stage-B loop in one command. Repackage local IPs, then bring
# the project up to date: upgrade the instances and export the project.
#   prj::ip                   every IP in hw/ip/
#   prj::ip <name> [M.m]      one IP, optionally with a new version

proc ::prj::ip {{target all} {new_version ""}} {
    check_vivado_version
    # It ends with an export: stop now rather than after the packaging.
    check_snapshot_unchanged ""
    if {$target eq "all"} {
        if {$new_version ne ""} {
            error "A new version needs a single IP: prj::ip <name> M.m"
        }
        set names [local_ips]
    } else {
        set names [list $target]
    }

    foreach name $names {
        if {[project_is_open]} {
            # Packaging opens projects of its own: run it in a separate
            # Vivado, so that the project open in the GUI is not touched.
            run_batch package_ip $name $new_version
        } else {
            package_ip $name $new_version
        }
    }

    update_ip_instances $names
}

# After a packaging: refresh the IP catalog of the project, upgrade the
# instances of the IPs in names, and export the project. Nothing to do
# without a project.
proc ::prj_priv::update_ip_instances {names} {
    variable project_dir
    if {![file exists $project_dir]} {
        puts "No project yet: 'make project' will use the new packages"
        return
    }
    open_project_if_needed
    global_eval update_ip_catalog -rebuild -scan_changes
    foreach bd [get_files -quiet *.bd] {
        global_eval open_bd_design $bd
    }
    foreach name $names {
        set instances [get_ips -quiet -filter "IPDEF =~ *:$name:*"]
        if {[llength $instances] > 0} {
            global_eval upgrade_ip $instances
        }
    }
    # upgrade_ip leaves the block designs not validated, and write_project_tcl
    # would then drop validate_bd_design from the snapshot.
    foreach bd [get_files -quiet *.bd] {
        global_eval current_bd_design [file rootname [file tail $bd]]
        global_eval validate_bd_design
    }
    ::prj::export
}

# Run one prj:: command in a separate Vivado in batch mode.
proc ::prj_priv::run_batch {args} {
    variable hw_dir
    set vivado [file join $::env(XILINX_VIVADO) bin vivado]
    if {$::tcl_platform(platform) eq "windows"} {
        append vivado .bat
    }
    set run_tcl [file join $hw_dir scripts run.tcl]
    # 2>@1: the errors of Vivado go to stderr, and must end up in the
    # console together with the rest of the output.
    set failed [catch {exec $vivado -mode batch -nojournal -nolog -notrace -source $run_tcl -tclargs {*}$args 2>@1} output]
    puts $output
    if {$failed} {
        error "prj::[lindex $args 0] failed in the batch Vivado, see the output above"
    }
}
