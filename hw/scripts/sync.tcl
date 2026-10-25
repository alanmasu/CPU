# prj::sync: bring hw/vivado/ in step with hw/src/vivado_project.tcl.
#   prj::sync ?-discard-local?
#
# hw/vivado/ is a local copy of the project, made from the snapshot. After a
# pull, a checkout or an edit by hand the snapshot changes, while the
# project stays as it was. Two copies inside hw/vivado/, written by
# prj::create and prj::export, tell what happened:
#   .snapshot   the snapshot the project matches: the one it was created
#               from, or the one it wrote last;
#   .baseline/  the files of the project at that moment that hold the
#               choices of the user (see project_state_files).
# The snapshot has changed when it differs from .snapshot. Whether the
# project has local changes takes two steps:
#  1. its files are compared with .baseline/: when they are the same, there
#     is no change, and that is known at once;
#  2. when they differ, it is not yet a change: the first build rewrites the
#     .xpr by itself (fine-grained filesets and runs of every IP, the
#     strategy of each run; seen on 2021.2 and 2025.1, 22/10/2026), and a
#     setting changed in the GUI ends up among those lines. The project is
#     then exported into work/ and compared with .snapshot, which is exact
#     (the export of a project without changes gives back its snapshot,
#     verified 12/10/2026) but takes the time of an export.
#
# The Makefile runs prj::sync before the targets that use the project, only
# when the snapshot has changed:
#  - without local changes the project is created again from the snapshot;
#  - with local changes it stops and lists the three ways out (see
#    local_changes_choices), with the diff of the snapshot in
#    work/local-changes.diff;
#    with -discard-local the project is moved to hw/vivado.bak/, replacing
#    an older one, and created again;
#  - with the project open in a Vivado GUI it stops, whatever the option.
# KEEP_LOCAL=1, the first way out, never reaches prj::sync: the Makefile
# skips it and prints the warning itself.

proc ::prj::sync {{option ""}} {
    namespace upvar ::prj_priv project_dir project_dir
    namespace upvar ::prj_priv backup_dir backup_dir

    set discard [expr {[check_option $option {-discard-local}] eq "-discard-local"}]
    check_vivado_version
    if {![file exists $project_dir]} {
        ::prj::create
        return
    }
    if {![snapshot_changed]} {
        puts "The project matches hw/src/vivado_project.tcl"
        return
    }
    if {[gui_has_project]} {
        error "hw/src/vivado_project.tcl has changed and the project is open in a Vivado GUI: close it and run the command again"
    }

    set changes ""
    if {[project_files_changed]} {
        set changes [exported_changes]
    }
    if {$changes ne ""} {
        if {!$discard} {
            error "\n[local_changes_choices $changes]"
        }
        file delete -force $backup_dir
        file rename $project_dir $backup_dir
        puts "The old project, with its changes, is now in hw/vivado.bak/"
    } else {
        file delete -force $project_dir
    }
    puts "hw/src/vivado_project.tcl has changed: creating the project again from it"
    ::prj::create
}

# The message of a snapshot that changed under a project with local
# changes: what happened, the changes, and the three ways out.
proc ::prj_priv::local_changes_choices {changes} {
    set export_parameter [lindex [snapshot_overwrite_option] 1]
    set export_cost ""
    if {$export_parameter eq "DISCARD_LOCAL=1"} {
        set export_cost "; the snapshot has changes that are not committed, which this loses"
    }
    return [join [list \
        "==== hw/src/vivado_project.tcl has changed, and the project has changes that were not exported ====" \
        "The snapshot is not the one this project was created from or exported last (a pull, a checkout or an edit by hand)." \
        "Creating the project again from it would lose these local changes:" \
        $changes \
        "Choose one of these:" \
        "  1. go on with the local project as it is, without the new snapshot (this warning comes back at every command):" \
        "       make <target> KEEP_LOCAL=1" \
        "  2. write the local project over the snapshot, then merge the two versions with git (README, \"After a pull\")$export_cost:" \
        "       make export $export_parameter" \
        "  3. discard the local changes and create the project from the snapshot; the old project is kept in hw/vivado.bak/:" \
        "       make <target> DISCARD_LOCAL=1"] "\n"]
}

proc ::prj_priv::check_option {option allowed} {
    if {$option ne "" && $option ni $allowed} {
        error "Unknown option '$option': the options are [join $allowed {, }]"
    }
    return $option
}

proc ::prj_priv::snapshot_changed {} {
    variable project_tcl
    variable snapshot_copy
    if {![file exists $project_tcl]} {
        return 0
    }
    if {![file exists $snapshot_copy]} {
        return 1
    }
    return [expr {[read_text $project_tcl] ne [read_text $snapshot_copy]}]
}

# Written by prj::create and prj::export, when the project matches the
# snapshot.
proc ::prj_priv::save_baseline {} {
    variable project_tcl
    variable snapshot_copy
    if {[file exists $project_tcl]} {
        file copy -force $project_tcl $snapshot_copy
    } else {
        file delete $snapshot_copy
    }
    save_baseline_files
}

# Only the files of .baseline/, leaving .snapshot as it is: for
# prj::check -with-export, when the export of the project gives back
# .snapshot, so that the project has no local changes but its files were
# rewritten by a build. .snapshot stays the snapshot the project matches,
# also when hw/src/vivado_project.tcl changed after a pull.
proc ::prj_priv::save_baseline_files {} {
    variable baseline_dir
    file delete -force $baseline_dir
    copy_project_state $baseline_dir
}

# The files of hw/vivado/ that hold the choices of the user, relative to it:
# the .xpr and the files of *.srcs/ (block designs, constraints and sources
# imported into the project, catalog IPs). Left out by state_file_ignored.
# The other directories (.gen, .runs, .cache, .sim, .hw, .ip_user_files)
# are all generated. hw/scripts/project-changes.sh chooses the same files,
# for the pre-commit hook: keep the two in step.
proc ::prj_priv::project_state_files {} {
    variable project_dir
    set files [glob -nocomplain -tails -directory $project_dir *.xpr]
    foreach path [all_files [glob -nocomplain -type d -directory $project_dir *.srcs]] {
        set relative [string range $path [string length $project_dir/] end]
        if {![state_file_ignored $relative]} {
            lappend files $relative
        }
    }
    return [lsort $files]
}

# Files of *.srcs/ that are not choices of the user:
#  - rewritten by Vivado by itself (seen at the first build on 2021.2 and
#    2025.1, 12/10/2026): bd/<name>/ip/, the configuration of each IP of a
#    block design, and bd/<name>/<name>.bda, both derived from the .bd;
#    utils_1/imports/, the checkpoint of incremental synthesis;
#  - bd/<name>/ui/, the layout of the block design: positions of the
#    blocks in the drawing, not hardware (decision of the user,
#    25/10/2026), left out also from the comparison of the exported
#    project (without_layout).
# Also applied when comparing, so that a .baseline/ written before a rule
# was added does not count its files as changes.
proc ::prj_priv::state_file_ignored {relative} {
    foreach pattern {*/utils_1/imports/* */bd/*/ip/* *.bda */bd/*/ui/*} {
        if {[string match $pattern $relative]} {
            return 1
        }
    }
    return 0
}

proc ::prj_priv::all_files {dirs} {
    set found {}
    foreach dir $dirs {
        foreach path [lsort [glob -nocomplain -directory $dir *]] {
            if {[file isdirectory $path]} {
                lappend found {*}[all_files [list $path]]
            } else {
                lappend found $path
            }
        }
    }
    return $found
}

# Copy of the files of project_state_files into dest. The .xpr is copied
# without its <Option Name="WTX..."> lines, usage counters of Vivado
# (WTXSimLaunchSim grows at every simulation), not settings.
proc ::prj_priv::copy_project_state {dest} {
    variable project_dir
    foreach relative [project_state_files] {
        set target [file join $dest $relative]
        file mkdir [file dirname $target]
        if {[file extension $relative] eq ".xpr"} {
            set kept {}
            foreach line [split [read_text [file join $project_dir $relative]] "\n"] {
                if {[string first {<Option Name="WTX} $line] < 0} {
                    lappend kept $line
                }
            }
            write_text $target [join $kept "\n"]
        } else {
            file copy -force [file join $project_dir $relative] $target
        }
    }
}

# Step 1 of the check: whether the files of the project differ from
# .baseline/. No copy (a project created by an older version of the
# template) counts as different.
proc ::prj_priv::project_files_changed {} {
    variable root_dir
    variable baseline_dir
    if {![file isdirectory $baseline_dir]} {
        return 1
    }
    set now_dir [file join $root_dir work local-now]
    file delete -force $now_dir
    copy_project_state $now_dir
    set changed 0
    foreach name [lsort -unique [concat [all_relative $baseline_dir] [all_relative $now_dir]]] {
        if {[state_file_ignored $name]} {
            continue
        }
        set before [file join $baseline_dir $name]
        set after [file join $now_dir $name]
        if {![file exists $before] || ![file exists $after] || [read_text $before] ne [read_text $after]} {
            set changed 1
        }
    }
    file delete -force $now_dir
    return $changed
}

# Step 2: the project exported into work/local-export.tcl and compared with
# .snapshot. "" when they are the same, otherwise the lines of the message
# that show the changes; the diff goes into work/local-changes.diff, with
# enough context to see the block design or the run a line belongs to.
proc ::prj_priv::exported_changes {} {
    variable root_dir
    variable snapshot_copy
    if {![file exists $snapshot_copy]} {
        return "  no copy of the snapshot to compare with: the project was created by an older version of the template"
    }
    puts "The files of the project changed after it was created or exported (a build, or a change in the GUI): exporting it to compare with its snapshot, which takes the time of an export"
    set exported [file join $root_dir work local-export.tcl]
    # In the GUI (prj::check -with-export) the project is already open and
    # stays open; in batch it is opened here and closed at the end.
    set opened_here [expr {![project_is_open]}]
    open_project_if_needed
    # A block design whose file is gone (deleted by hand, or left by a
    # branch that was removed) cannot be opened, and open_bd_design would
    # stop with a Vivado error (BD 41-1296, seen on 2021.2, 24/10/2026):
    # the project cannot be compared, so it is reported as changed.
    set missing {}
    foreach bd [get_files -quiet *.bd] {
        if {![file exists $bd]} {
            lappend missing "    $bd"
        }
    }
    if {[llength $missing] > 0} {
        if {$opened_here} {
            close_project
        }
        return "  the project cannot be exported to compare it, because the files of these block designs do not exist:\n[join $missing \n]"
    }
    # Opened and saved as prj::export does: without save_bd_design, in batch
    # write_project_tcl leaves out the layout of the block design (the
    # regenerate_bd_layout block), and the export would differ from the
    # snapshot of an unchanged project (seen on 2021.2 and 2025.1,
    # 22/10/2026). Saving an unchanged block design changes nothing in it.
    foreach bd [get_files -quiet *.bd] {
        global_eval open_bd_design $bd
        save_bd_design
    }
    set failed [catch {write_snapshot $exported} message]
    if {$opened_here} {
        close_project
    }
    if {$failed} {
        return "  the export to compare the project failed: $message"
    }
    # Compared without the layout of the block designs (without_layout):
    # the two copies are written into work/, and the diff is made of them.
    set snapshot_compared [file join $root_dir work local-snapshot.nolayout.tcl]
    set exported_compared [file join $root_dir work local-export.nolayout.tcl]
    write_text $snapshot_compared [without_layout [read_text $snapshot_copy]]
    write_text $exported_compared [without_layout [read_text $exported]]
    if {[read_text $snapshot_compared] eq [read_text $exported_compared]} {
        puts "The exported project is the same as its snapshot, the layout of the block designs left out: no local changes"
        return ""
    }
    set diff_file [file join $root_dir work local-changes.diff]
    # diff exits with 1 when the files differ, which exec takes for an
    # error: the output goes into the file anyway.
    catch {exec diff -u -U12 $snapshot_compared $exported_compared > $diff_file}
    return "  the project, exported, differs from the snapshot it was created from or exported last (the layout of the block designs left out):\n    code --diff $snapshot_compared $exported_compared\n  the whole diff: $diff_file"
}

# The text of a snapshot without the layout of its block designs: the
# string of each regenerate_bd_layout, from its first line to the line that
# closes it, a lone "}", is replaced by one line. The layout holds the
# positions of the blocks in the drawing, not hardware, and changes without
# any change to the design: the GUI writes the blocks in another order when
# it draws a block design (seen on 2021.2, 25/10/2026), and moving a block
# changes its coordinates. Leaving it out of the comparison was decided by
# the user, 25/10/2026. The snapshot itself keeps it, as Vivado writes it.
proc ::prj_priv::without_layout {text} {
    set kept {}
    set inside 0
    foreach line [split $text "\n"] {
        if {$inside} {
            if {$line eq "\}"} {
                set inside 0
            }
            continue
        }
        if {[string first "regenerate_bd_layout -layout_string \{" $line] >= 0} {
            lappend kept "  regenerate_bd_layout (layout left out of the comparison)"
            set inside 1
            continue
        }
        lappend kept $line
    }
    return [join $kept "\n"]
}

proc ::prj_priv::all_relative {dir} {
    set names {}
    foreach path [all_files [list $dir]] {
        lappend names [string range $path [string length $dir/] end]
    }
    return $names
}

# A Vivado GUI opened by 'make vivado', which passes the .xpr of this
# project on its command line: the full path of the .xpr is searched, as in
# hw/scripts/gui-open.sh, so that the shell of a Makefile recipe (which
# holds hw/vivado/*.xpr, not expanded) is not taken for it. A GUI that
# opened the project otherwise (Vivado started by hand, then Open Project)
# is not seen. Without pgrep (Windows) nothing is seen.
proc ::prj_priv::gui_has_project {} {
    variable project_dir
    set xpr [lindex [glob -nocomplain -directory $project_dir *.xpr] 0]
    if {$xpr eq "" || ![info exists ::env(USER)]} {
        return 0
    }
    # pgrep exits with 1 when no process matches.
    return [expr {![catch {exec pgrep -u $::env(USER) -f $xpr}]}]
}

# What overwriting the snapshot costs: when its version is committed git
# keeps it, and -force (FORCE=1) is enough; when it has changes that are not
# committed (a merge in progress, an edit by hand) they would be lost for
# good, as with the local changes of the project, and it takes
# -discard-local (DISCARD_LOCAL=1). Returns the option and the parameter of
# make. Outside git nothing is committed.
proc ::prj_priv::snapshot_overwrite_option {} {
    variable root_dir
    # git diff --quiet exits with 1 when there are changes, and exec takes
    # that for an error.
    if {[catch {exec git -C $root_dir diff --quiet HEAD -- hw/src/vivado_project.tcl}]} {
        return {-discard-local DISCARD_LOCAL=1}
    }
    return {-force FORCE=1}
}

# Before replacing the snapshot: refused when it has changed since the
# project was created or exported last, unless the option that matches what
# would be lost is given (see snapshot_overwrite_option). A project created
# by an older version of the template has no .snapshot: nothing to compare
# with, so the export goes on and writes it.
proc ::prj_priv::check_snapshot_unchanged {option} {
    variable snapshot_copy
    if {![file exists $snapshot_copy] || ![snapshot_changed]} {
        return
    }
    lassign [snapshot_overwrite_option] needed parameter
    if {$needed eq "-force"} {
        set text "hw/src/vivado_project.tcl has changed since this project was created or exported last (a pull or a checkout), and exporting replaces it with this project; its version is committed, so git keeps it"
    } else {
        set text "hw/src/vivado_project.tcl has changed since this project was created or exported last, and it has changes that are not committed (a merge in progress, an edit by hand): exporting replaces it with this project, and those changes are lost for good"
    }
    if {$option ne $needed} {
        error "$text.\nTo export anyway: make export $parameter (prj::export $needed in the GUI). To get the new snapshot instead, close the GUI and run make vivado, synth, bitstream or xsa."
    }
    message 5 WARNING $text
}
