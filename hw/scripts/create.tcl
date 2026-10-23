# prj::create: create hw/vivado/.
#
# Normally the project is recreated from hw/src/vivado_project.tcl, the
# snapshot written by prj::export: files, settings and block designs exactly
# as they were in the GUI. The first time, when there is no snapshot yet, it
# is built from hw/project.tcl and the files under hw/src/.
# In both cases, what the snapshot cannot know is added afterwards: the IP
# repository of .env, new files under hw/src/, simulation sets of new IPs.

proc ::prj::create {} {
    namespace upvar ::prj_priv hw_dir hw_dir
    namespace upvar ::prj_priv project_dir project_dir
    variable project_name
    namespace upvar ::prj_priv project_tcl project_tcl
    namespace upvar ::prj_priv pin_file pin_file

    check_vivado_version
    if {[file exists $project_dir]} {
        error "$project_dir already exists: run 'make clean' first"
    }

    # Local IPs never packaged yet (for example in a fresh copy of the
    # template): package them now, with this Vivado.
    foreach name [local_ips] {
        if {![file exists [file join $hw_dir ip $name component.xml]]} {
            package_ip $name
        }
    }

    if {[file exists $project_tcl]} {
        create_from_snapshot
    } else {
        create_from_config
    }

    set_property ip_repo_paths [ip_repo_list] [current_project]
    global_eval update_ip_catalog
    add_new_sources
    foreach dir [ip_sim_dirs] {
        if {[llength [get_filesets -quiet sim_[file tail $dir]]] == 0} {
            create_ip_simset [file tail $dir] $dir
        }
    }
    update_compile_order -fileset sources_1
    set_usr_access_hook

    if {![file exists $pin_file]} {
        write_text $pin_file [version -short]
        puts "Pinned the project to Vivado [version -short] in hw/VIVADO_VERSION: commit this file"
    }
    mark_exported
}

# The snapshot is a script written by write_project_tcl. It reads the
# variables origin_dir_loc and user_project_name if they exist, and parses
# argv, which here holds the arguments of run.tcl: hide them while it runs.
proc ::prj_priv::create_from_snapshot {} {
    variable hw_dir
    namespace upvar ::prj project_name project_name
    variable project_tcl

    set saved_argv $::argv
    set saved_argc $::argc
    set ::argv {}
    set ::argc 0
    set ::origin_dir_loc $hw_dir
    set ::user_project_name $project_name
    set failed [catch {uplevel #0 [list source $project_tcl]} message]
    set ::argv $saved_argv
    set ::argc $saved_argc
    unset ::origin_dir_loc ::user_project_name
    if {$failed} {
        error "hw/src/vivado_project.tcl failed: $message"
    }
}

# First creation: part, board and top from hw/project.tcl.
proc ::prj_priv::create_from_config {} {
    variable project_dir
    namespace upvar ::prj project_name project_name
    namespace upvar ::prj part part
    namespace upvar ::prj board_part board_part
    namespace upvar ::prj target_language target_language
    namespace upvar ::prj top top

    create_project $project_name $project_dir -part $part
    if {$board_part ne ""} {
        if {[llength [get_board_parts -quiet $board_part]] == 0} {
            error "Board part $board_part is not installed in this Vivado"
        }
        set_property board_part $board_part [current_project]
    }
    set_property target_language $target_language [current_project]
    if {$top ne ""} {
        set_property top $top [current_fileset]
    }
}

# Files under hw/src/ that are not in the project yet. A stage-A IP lives in
# src/hdl/<ip>/, with testbenches in src/hdl/<ip>/sim/ that must not end up
# among the design sources. Catalog IPs outside a block design live in
# src/ip/<ip>/<ip>.xci.
proc ::prj_priv::add_new_sources {} {
    variable hw_dir
    variable hdl_exts
    set sets [dict create \
        sources_1 [find_files [file join $hw_dir src hdl] $hdl_exts sim] \
        sim_1     [find_files [file join $hw_dir src sim] $hdl_exts] \
        constrs_1 [find_files [file join $hw_dir src constr] {.xdc}]]
    dict lappend sets sources_1 {*}[glob -nocomplain -directory [file join $hw_dir src ip] */*.xci]
    dict for {fileset files} $sets {
        set new_files {}
        foreach f $files {
            if {[llength [get_files -quiet $f]] == 0} {
                lappend new_files $f
            }
        }
        add_to_fileset $fileset $new_files
    }
}

# Simulation set sim_<name>: the RTL of the IP and its testbenches only, not
# the whole design, with <name>_tb as top and run until $finish.
proc ::prj_priv::create_ip_simset {name dir} {
    variable hdl_exts
    set fileset sim_$name
    create_fileset -simset $fileset
    set_property SOURCE_SET {} [get_filesets $fileset]
    add_to_fileset $fileset [find_files $dir $hdl_exts sim]
    add_to_fileset $fileset [find_files [file join $dir sim] $hdl_exts]
    set_property top ${name}_tb [get_filesets $fileset]
    set_property -name xsim.simulate.runtime -value all -objects [get_filesets $fileset]
}
