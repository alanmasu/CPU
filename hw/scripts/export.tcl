# prj::export: save the whole project into hw/src/vivado_project.tcl.
#
# The snapshot is written by write_project_tcl, so it holds everything done in
# the GUI: files and their properties, simulation sets, run strategies and the
# block designs. Before writing it:
#  - catalog IPs left inside vivado/ are moved to hw/src/ip/;
#  - the IP repository of .env is left out, because its path depends on the
#    machine (prj::create adds it back).
# After writing it, the script is cleaned so that it has no absolute path.
# It refuses to replace a snapshot that changed after the project was
# created or exported last, unless -force (the snapshot is committed) or
# -discard-local (it has changes that are not committed): see
# check_snapshot_unchanged.
#   prj::export ?-force|-discard-local?

proc ::prj::export {{option ""}} {
    namespace upvar ::prj_priv hw_dir hw_dir
    namespace upvar ::prj_priv project_dir project_dir
    namespace upvar ::prj_priv project_tcl project_tcl

    check_option $option {-force -discard-local}
    check_vivado_version
    check_snapshot_unchanged $option
    open_project_if_needed
    move_local_ips
    warn_local_sources
    check_before_export
    foreach bd [get_files -quiet *.bd] {
        global_eval open_bd_design $bd
        save_bd_design
        warn_automatic_crossbars
    }
    write_snapshot $project_tcl
    puts "Exported the project to hw/src/vivado_project.tcl"
    mark_exported
    save_baseline
}

# write_project_tcl into path, with the script cleaned (clean_project_script):
# the part of prj::export after the checks, used also by prj::sync to compare
# the project with its snapshot. The project must be open, with its block
# designs.
proc ::prj_priv::write_snapshot {path} {
    variable hw_dir
    variable project_dir

    # Left out of the snapshot for the time of write_project_tcl, and put
    # back right after:
    #  - the IP repository of .env, whose path depends on the machine;
    #  - the checkpoint of incremental synthesis, a file that Vivado
    #    generates inside vivado/ and imports into utils_1 after a synthesis:
    #    the recreated project would look for it and fail. Vivado makes it
    #    again at the first synthesis of the recreated project.
    set repo_paths [get_property ip_repo_paths [current_project]]
    set_property ip_repo_paths [committed_ip_repos] [current_project]
    set synth [get_runs synth_1]
    set checkpoint [get_property INCREMENTAL_CHECKPOINT $synth]
    set generated_utils [generated_utils_files]
    if {[llength $generated_utils] > 0} {
        remove_files -fileset utils_1 $generated_utils
    }
    set_property INCREMENTAL_CHECKPOINT {} $synth

    set raw_tcl [file join $project_dir vivado_project.raw.tcl]
    # origin_dir is left as "." in the script: prj::create sets it through
    # origin_dir_loc. The project directory is written literally as
    # "$origin_dir/vivado", so that it is expanded when the script runs.
    set failed [catch {
        global_eval write_project_tcl -force -paths_relative_to $hw_dir -origin_dir_override . \
            -target_proj_dir {$origin_dir/vivado} $raw_tcl
    } message]

    set_property ip_repo_paths $repo_paths [current_project]
    foreach f $generated_utils {
        if {[file exists $f]} {
            add_files -fileset utils_1 -norecurse $f
        }
    }
    set_property INCREMENTAL_CHECKPOINT $checkpoint $synth
    if {$failed} {
        error "write_project_tcl failed: $message"
    }

    write_text $path [clean_project_script [read_text $raw_tcl]]
    file delete $raw_tcl
}

# An axi_interconnect with STRATEGY 0 (Custom, the default) lets Vivado
# choose the mode of its crossbar while it builds the block design: SASD,
# one transaction at a time and no ID on the master side, or SAMD, which
# needs the IDs. write_project_tcl saves only STRATEGY 0, so a project
# created again from the snapshot can get the other mode: in the ported CPU
# project two crossbars went from SASD to SAMD and the validation of the
# block design failed (BD 41-237, ID_WIDTH), and with a slave that accepts
# both the hardware changes without an error. A warning for each one, in
# the open block design, with the mode Vivado chose: fixing it in the GUI,
# with STRATEGY 1 (Minimize Area, SASD) or 2 (Maximize Performance, SAMD),
# puts it into the snapshot.
proc ::prj_priv::warn_automatic_crossbars {} {
    foreach interconnect [get_bd_cells -quiet -hierarchical -filter {VLNV =~ "xilinx.com:ip:axi_interconnect:*"}] {
        if {[get_property -quiet CONFIG.STRATEGY $interconnect] ne "0"} {
            continue
        }
        # With one master and one slave there is no crossbar, and no mode.
        set xbar [get_bd_cells -quiet $interconnect/xbar]
        if {$xbar eq ""} {
            continue
        }
        set mode [get_property -quiet CONFIG.CONNECTIVITY_MODE $xbar]
        if {$mode eq ""} {
            set mode "unknown"
        }
        message 6 WARNING "$interconnect has STRATEGY 0: the mode of its crossbar ($mode now) is chosen by Vivado and not saved in the snapshot, and can change when the project is created again; set STRATEGY to 1 (SASD) or 2 (SAMD) in the GUI to keep it"
    }
}

# Files of the utils_1 fileset inside vivado/: generated by Vivado, like the
# checkpoint of incremental synthesis.
proc ::prj_priv::generated_utils_files {} {
    variable project_dir
    set files {}
    foreach f [get_files -quiet -of_objects [get_filesets -quiet utils_1]] {
        if {[string first $project_dir/ [file normalize $f]] == 0} {
            lappend files $f
        }
    }
    return $files
}

# The IP repositories that live in the repository: hw/ip and hw/ip_ext.
proc ::prj_priv::committed_ip_repos {} {
    variable hw_dir
    set repos {}
    foreach dir [list [file join $hw_dir ip] [file join $hw_dir ip_ext]] {
        if {[file isdirectory $dir]} {
            lappend repos $dir
        }
    }
    return $repos
}

# Catalog IPs outside block designs whose .xci is inside vivado/ (where the
# GUI creates them by default): move them to hw/src/ip/<name>/.
#
# The .xci holds paths relative to itself (output directory, COE files...),
# so copying the file breaks them. copy_ip writes a new .xci with the paths
# rewritten, but it needs a new name, and the name must stay the same
# because the RTL instantiates it: copy to a temporary name, drop the
# original, copy back with the original name into hw/src/ip/.
proc ::prj_priv::move_local_ips {} {
    variable hw_dir
    variable project_dir
    variable edit_dir
    foreach xci [get_files -quiet -norecurse -of_objects [get_filesets sources_1] *.xci] {
        set path [file normalize $xci]
        if {[string first $project_dir/ $path] != 0} {
            continue
        }
        set name [file rootname [file tail $path]]
        set ip_dir [file join $hw_dir src ip]
        set dest [file join $ip_dir $name $name.xci]
        if {[file exists $dest]} {
            error "Cannot move the IP $name: $dest already exists"
        }
        set tmp_name ${name}_moving
        set tmp_dir [file join $edit_dir ip_move]
        file mkdir $tmp_dir
        file mkdir $ip_dir

        # The copy keeps the name, so it would reuse the output directory of
        # the original, whose files were generated from the old .xci: Vivado
        # then locks the IP for stale content. Delete that directory before
        # the copy with the original name is made.
        set old_output_dir [get_property IP_OUTPUT_DIR [get_ips $name]]

        # Settings of the .xci file in the project, like global synthesis
        # instead of out-of-context: copy_ip does not carry them over.
        set old_file [get_files $path]
        set file_props [dict create]
        foreach prop {GENERATE_SYNTH_CHECKPOINT SYNTH_CHECKPOINT_MODE IS_ENABLED USED_IN} {
            if {$prop in [list_property $old_file]} {
                dict set file_props $prop [get_property $prop $old_file]
            }
        }

        global_eval copy_ip -name $tmp_name -dir $tmp_dir [get_ips $name]
        remove_files [get_files $path]
        file delete -force $old_output_dir
        global_eval copy_ip -name $name -dir $ip_dir [get_ips $tmp_name]
        remove_files [get_files [get_property IP_FILE [get_ips $tmp_name]]]
        file delete -force [file join $tmp_dir $tmp_name]

        if {![file exists $dest]} {
            error "The IP $name was copied, but not to $dest: check the IP sources in the GUI"
        }
        set new_file [get_files $dest]
        dict for {prop value} $file_props {
            set_property $prop $value $new_file
        }
        fix_moved_ip_paths $name [file dirname $path]

        # An out-of-context run of the IP, if any, was made from the old
        # output products.
        set ooc_run [get_runs -quiet ${name}_synth_1]
        if {[llength $ooc_run] > 0} {
            reset_run $ooc_run
        }
        puts "Moved the IP $name to hw/src/ip/$name/"
    }
}

# write_project_tcl saves the project as it is, problems included: a file
# that no longer exists, or an IP locked by Vivado, would end up in the
# snapshot and break the next 'make project'. Refuse to export them.
# Exception: a missing file that Vivado generated inside vivado/ in utils_1
# (the checkpoint of incremental synthesis) stays out of the snapshot
# anyway, so it is only removed from the project.
proc ::prj_priv::check_before_export {} {
    foreach f [generated_utils_files] {
        if {![file exists $f]} {
            remove_files -fileset utils_1 $f
            message 4 WARNING "removed from utils_1 a generated file that no longer exists: $f"
        }
    }
    set problems {}
    foreach f [get_files -quiet -norecurse -of_objects [get_filesets]] {
        if {![file exists $f]} {
            lappend problems "file not found, remove it from the project: $f"
        }
    }
    foreach ip [get_ips -quiet] {
        if {[get_property IS_LOCKED $ip]} {
            lappend problems "IP $ip is locked, see Report IP Status"
        }
    }
    if {[llength $problems] > 0} {
        error "The project was not exported:\n[join $problems \n]"
    }
}

# Safety net after a move: a parameter that names a file (for example the
# COE of a memory) and still points to it only from the old location is set
# again as an absolute path. Vivado stores it relative to the new location.
proc ::prj_priv::fix_moved_ip_paths {name old_dir} {
    set ip [get_ips $name]
    foreach prop [list_property $ip CONFIG.*] {
        set value [get_property $prop $ip]
        if {$value eq "" || [file pathtype $value] ne "relative"} {
            continue
        }
        set old_target [file normalize [file join $old_dir $value]]
        if {[file isfile $old_target]} {
            set_property $prop $old_target $ip
            puts "  $prop of $name now points to $old_target"
        }
    }
}

# Other files inside vivado/<name>.srcs/ (for example added with "Copy
# sources into project"): their right place under hw/src/ depends on what
# they are, so only warn. The utils filesets are skipped: Vivado fills them
# with files of its own, like the checkpoint of incremental synthesis.
proc ::prj_priv::warn_local_sources {} {
    variable project_dir
    namespace upvar ::prj project_name project_name
    set srcs_dir [file join $project_dir $project_name.srcs]
    foreach fileset [get_filesets] {
        if {[string match utils_* $fileset]} {
            continue
        }
        foreach f [get_files -quiet -norecurse -of_objects $fileset] {
            set path [file normalize $f]
            if {[string first $srcs_dir $path] == 0 && [file extension $path] ni {.bd .xci}} {
                message 1 WARNING "$path is inside vivado/ and will be lost: move it under hw/src/ and add it again by reference"
            }
        }
    }
}

# Replace the header of write_project_tcl, which holds the date and absolute
# paths of this machine, turn the remaining paths under hw/ into $origin_dir,
# and refuse if an absolute path of this machine is still there.
proc ::prj_priv::clean_project_script {text} {
    variable hw_dir
    variable root_dir

    set lines [split $text "\n"]
    set first_code 0
    while {$first_code < [llength $lines]} {
        set line [string trim [lindex $lines $first_code]]
        if {$line ne "" && [string index $line 0] ne "#"} {
            break
        }
        incr first_code
    }
    set header [list \
        "# Snapshot of the Vivado project, written by prj::export with write_project_tcl." \
        "# Do not edit by hand: change the project in the GUI and export again." \
        "# Recreate the project with 'make project', which sets origin_dir to hw/." \
        ""]
    # Left out, because they are not settings and would change the snapshot
    # without any change to the project:
    #  - needs_refresh, the state of a run, which changes at every build;
    #  - the webtalk.* properties of the project, usage counters of Vivado
    #    (webtalk.xsim_launch_sim grows at every simulation, seen on 2021.2,
    #    24/10/2026), the same as the WTX options of the .xpr. In the
    #    snapshot they would also make the test export of prj::sync differ
    #    after a simulation, as if the project had local changes.
    set kept {}
    foreach line [lrange $lines $first_code end] {
        if {[string first {-name "needs_refresh"} $line] >= 0} {
            continue
        }
        if {[string first {-name "webtalk.} $line] >= 0} {
            continue
        }
        lappend kept $line
    }
    set body [join $kept "\n"]
    set body [string map [list $hw_dir {$origin_dir}] $body]

    # In checkRequiredFiles write_project_tcl writes each IP repository
    # relative to the directory where Vivado runs, around the path itself:
    #   "[file normalize "$origin_dir/../work/[file normalize "$origin_dir/ip"]"]"
    # The same project would give a different snapshot when exported from
    # another directory. Keep only the path of the repository:
    #   "[file normalize "$origin_dir/ip"]"
    regsub -all {\$origin_dir/\.\./[^\[]*\[file normalize "(\$origin_dir/[^"]*)"\]} $body {\1} body

    # Nothing may point inside vivado/: it is generated, and it does not exist
    # when the snapshot recreates the project. The script writes the variable
    # both as $origin_dir and as ${origin_dir}. Allowed mentions:
    #  - the project directory itself, in create_project (no trailing /);
    #  - the import of the HDL wrapper of a block design, which
    #    write_project_tcl writes in the branch taken only when the block
    #    design is locked: otherwise the wrapper is made again by make_wrapper.
    set inside_vivado [list {$origin_dir/vivado/} "\$\{origin_dir\}/vivado/"]
    foreach line [split $body "\n"] {
        if {[string match {*import_files*/bd/*/hdl/*_wrapper.*} $line]} {
            continue
        }
        foreach needle $inside_vivado {
            if {[string first $needle $line] >= 0} {
                error "The exported project refers to a file inside vivado/, which is generated: the file was not written. Line: [string trim $line]"
            }
        }
    }

    set needles [list $root_dir]
    if {[info exists ::env(HOME)]} {
        lappend needles [file normalize $::env(HOME)]
    }
    foreach needle $needles {
        if {[string first $needle $body] >= 0} {
            error "The exported project still contains the absolute path $needle: the file was not written. Look for it in hw/vivado/vivado_project.raw.tcl"
        }
    }
    return "[join $header "\n"]\n$body"
}
