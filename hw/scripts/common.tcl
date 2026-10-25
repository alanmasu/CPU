# Shared setup for every script in hw/scripts: paths, configuration, helpers.
# The namespace prj holds only the commands for the user and the
# configuration read from project.tcl, so that prj:: plus Tab in the Tcl
# console shows only those. The helpers and the internal paths are in
# prj_priv. Nothing goes into the global namespace. The helpers reach the
# configuration with namespace upvar, the commands reach the helpers through
# the namespace path and the internal paths with namespace upvar.

namespace eval ::prj_priv {
    variable hw_dir      [file normalize [file join [file dirname [info script]] ..]]
    variable root_dir    [file dirname $hw_dir]
    variable project_dir [file join $hw_dir vivado]
    variable out_dir     [file join $root_dir out hw]
    variable sim_dir     [file join $root_dir out sim]
    variable edit_dir    [file join $root_dir out ip_edit]
    variable pin_file    [file join $hw_dir VIVADO_VERSION]
    variable stamp_file  [file join $project_dir .exported]
    variable snapshot_copy [file join $project_dir .snapshot]
    variable baseline_dir  [file join $project_dir .baseline]
    variable backup_dir    [file join $hw_dir vivado.bak]
    # 1 when the command runs in a batch Vivado (set by run.tcl), 0 in the GUI.
    variable batch 0
    variable project_tcl [file join $hw_dir src vivado_project.tcl]
    variable hdl_exts    {.v .sv .vh .svh .vhd .vhdl}
}

namespace eval ::prj {
    namespace path ::prj_priv

    # Declared before sourcing, so that the plain `set` commands in
    # project.tcl create variables of this namespace and never touch a global
    # variable with the same name. The loop variable is removed afterwards,
    # because in a namespace eval it is a variable of the namespace.
    foreach name {project_name part board_part target_language ip_vendor top jobs vivado_min sim_result_lines} {
        variable $name
    }
    unset name
    source [file join $::prj_priv::hw_dir project.tcl]
}

# Runs a Vivado command in the global namespace. Vivado loads some of its
# Tcl scripts only when they are needed, and a proc defined there without a
# namespace lands in the current one: called from a command of prj, the procs
# of Vivado (block design and IP utilities, transceiver helpers) ended up in
# prj, next to the commands of the template. Used for the commands that work
# on block designs and IPs; prj::check warns if it happens anyway.
proc ::prj_priv::global_eval {args} {
    uplevel #0 $args
}

# A message through the Vivado message system, with an id of this template:
# it shows up as "WARNING: [template-prjutils-<number>] ...", and it can be
# filtered with set_msg_config like the messages of Vivado.
proc ::prj_priv::message {number severity text} {
    common::send_msg_id template-prjutils-$number $severity $text
}

proc ::prj_priv::read_text {path} {
    set f [open $path r]
    set text [string trim [read $f]]
    close $f
    return $text
}

proc ::prj_priv::write_text {path text} {
    set f [open $path w]
    puts $f $text
    close $f
}

# Stop if this Vivado is older than the template supports, or differs from
# the version the project was created with (hw/VIVADO_VERSION).
proc ::prj_priv::check_vivado_version {} {
    namespace upvar ::prj vivado_min vivado_min
    variable pin_file
    set current [version -short]
    if {[package vcompare $current $vivado_min] < 0} {
        error "Vivado $current is older than $vivado_min, the oldest version this template supports"
    }
    if {[file exists $pin_file]} {
        set pinned [read_text $pin_file]
        if {$current ne $pinned} {
            error "The project is pinned to Vivado $pinned (hw/VIVADO_VERSION) but this is Vivado $current. Moving to another version is a deliberate migration, see README.md"
        }
    }
}

# Every file under dir whose extension is in exts. Directories named
# skip_dir are not entered: used to keep testbenches out of design sources.
proc ::prj_priv::find_files {dir exts {skip_dir ""}} {
    set found {}
    foreach path [lsort [glob -nocomplain -directory $dir *]] {
        if {[file isdirectory $path]} {
            if {[file tail $path] ne $skip_dir} {
                lappend found {*}[find_files $path $exts $skip_dir]
            }
        } elseif {[file extension $path] in $exts} {
            lappend found $path
        }
    }
    return $found
}

proc ::prj_priv::add_to_fileset {fileset files} {
    if {[llength $files] > 0} {
        add_files -norecurse -fileset $fileset $files
    }
}

# Names of the local IPs: directories of hw/ip/ with an hdl/ inside.
proc ::prj_priv::local_ips {} {
    variable hw_dir
    set names {}
    foreach dir [lsort [glob -nocomplain -type d -directory [file join $hw_dir ip] *]] {
        if {[file isdirectory [file join $dir hdl]]} {
            lappend names [file tail $dir]
        }
    }
    return $names
}

# Directories of the IPs that have testbenches in sim/: stage B in hw/ip/,
# stage A in hw/src/hdl/.
proc ::prj_priv::ip_sim_dirs {} {
    variable hw_dir
    set dirs {}
    foreach parent [list [file join $hw_dir ip] [file join $hw_dir src hdl]] {
        foreach dir [lsort [glob -nocomplain -type d -directory $parent *]] {
            if {[file isdirectory [file join $dir sim]]} {
                lappend dirs $dir
            }
        }
    }
    return $dirs
}

# Directories scanned for packaged IPs:
#  - hw/ip      local IPs, packaged inside this project (stage B)
#  - hw/ip_ext  released IPs added as git submodules (stage C)
#  - VIVADO_IP_REPO_EXT  licensed IPs that cannot live in the repo; the path
#                        comes from .env, exported by the Makefile
proc ::prj_priv::ip_repo_list {} {
    variable hw_dir
    set repos {}
    foreach dir [list [file join $hw_dir ip] [file join $hw_dir ip_ext]] {
        if {[file isdirectory $dir]} {
            lappend repos $dir
        }
    }
    if {[info exists ::env(VIVADO_IP_REPO_EXT)] && $::env(VIVADO_IP_REPO_EXT) ne ""} {
        if {![file isdirectory $::env(VIVADO_IP_REPO_EXT)]} {
            error "VIVADO_IP_REPO_EXT (from .env) is not a directory: $::env(VIVADO_IP_REPO_EXT)"
        }
        lappend repos [file normalize $::env(VIVADO_IP_REPO_EXT)]
    }
    return $repos
}

proc ::prj_priv::project_is_open {} {
    return [expr {![catch {current_project}]}]
}

# Open the project, unless it is already open (commands run from the GUI).
proc ::prj_priv::open_project_if_needed {} {
    variable project_dir
    namespace upvar ::prj project_name project_name
    if {[project_is_open]} {
        set open_dir [file normalize [get_property DIRECTORY [current_project]]]
        if {$open_dir ne $project_dir} {
            error "The open project is $open_dir, not this one ($project_dir)"
        }
        return
    }
    set xpr [file join $project_dir $project_name.xpr]
    if {![file exists $xpr]} {
        error "$xpr does not exist: run 'make project' first"
    }
    open_project $xpr
}

# Record that hw/src/vivado_project.tcl matches hw/vivado/ right now.
proc ::prj_priv::mark_exported {} {
    variable stamp_file
    write_text $stamp_file [clock format [clock seconds]]
}

# Block designs saved after the last export or project creation: changes
# made in the GUI that would be lost by deleting vivado/.
proc ::prj_priv::unexported_bds {} {
    variable project_dir
    variable stamp_file
    set stamp 0
    if {[file exists $stamp_file]} {
        set stamp [file mtime $stamp_file]
    }
    set stale {}
    foreach bd [find_files $project_dir {.bd}] {
        if {[file mtime $bd] > $stamp} {
            lappend stale [file rootname [file tail $bd]]
        }
    }
    return $stale
}
