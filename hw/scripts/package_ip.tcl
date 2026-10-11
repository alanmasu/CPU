# prj::package_ip: package one local IP (stage B), hw/ip/<name>/, nothing else.
# prj::ip calls it and then updates the project.
#
# First packaging (no component.xml yet): everything is inferred from the RTL
# in hdl/, as the "Create and Package New IP" wizard does.
# Later packagings: component.xml is kept, and only the changes of the RTL
# are merged into it, as "Re-Package IP" does in the IP Packager. Whatever
# was customized with the GUI packager (parameter names, layout, memory map)
# survives.
#
# In both cases the script then sets:
#  - the version (MAJOR.MINOR), only when a new one is given;
#  - core_revision + 1, so that Vivado offers the upgrade of the instances;
#  - the hidden parameters VERSION_* and BUILD_*, if the RTL has them.

# Output of a git command in dir, or "" when it fails (for example outside a
# git repository).
proc ::prj_priv::git_output {dir args} {
    if {[catch {exec git -C $dir {*}$args} out]} {
        return ""
    }
    return [string trim $out]
}

proc ::prj::package_ip {name {new_version ""}} {
    namespace upvar ::prj_priv hw_dir hw_dir
    namespace upvar ::prj_priv edit_dir edit_dir
    variable part
    variable ip_vendor
    namespace upvar ::prj_priv hdl_exts hdl_exts

    check_vivado_version
    set ip_dir [file join $hw_dir ip $name]
    set hdl_dir [file join $ip_dir hdl]
    set xml [file join $ip_dir component.xml]
    set hdl_files [find_files $hdl_dir $hdl_exts]
    if {[llength $hdl_files] == 0} {
        error "No RTL in $hdl_dir"
    }
    if {$new_version ne "" && ![regexp {^[0-9]+\.[0-9]+$} $new_version]} {
        error "The version must be MAJOR.MINOR, got '$new_version'"
    }

    if {[file exists $xml]} {
        # Open the existing core in a temporary project, as the IP Packager
        # does, add the RTL files that are new, and merge the changes.
        # edit_ip_in_project needs a project already open: in a batch Vivado
        # there is none, so an in-memory one is opened first.
        set edit_project [file join $edit_dir $name]
        file delete -force $edit_project
        create_project -in_memory -part $part
        global_eval ipx::edit_ip_in_project -upgrade true -name edit_$name -directory $edit_project $xml
        foreach f $hdl_files {
            if {[llength [get_files -quiet $f]] == 0} {
                add_files -norecurse $f
            }
        }
        update_compile_order -fileset sources_1
        set core [ipx::current_core]
        ipx::merge_project_changes files $core
        ipx::merge_project_changes hdl_parameters $core
        ipx::merge_project_changes ports $core
        set version [get_property version $core]
        set revision [expr {[get_property core_revision $core] + 1}]
        set first_time 0
    } else {
        create_project -in_memory -part $part
        add_files -norecurse $hdl_files
        set_property top $name [current_fileset]
        update_compile_order -fileset sources_1
        global_eval ipx::package_project -root_dir $ip_dir -vendor $ip_vendor -library user -taxonomy /UserIP
        set core [ipx::current_core]
        set_property display_name $name $core
        set version 0.1
        set revision 1
        set first_time 1
    }

    if {$new_version ne ""} {
        set version $new_version
    }
    lassign [split $version .] major minor
    set_property version $version $core
    set_property core_revision $revision $core

    # Build ID: the last commit that touched the RTL, and whether the RTL has
    # uncommitted changes. Outside git, or before the first commit: zero and
    # dirty.
    set build_id [string range [git_output $hdl_dir log -1 --format=%h --abbrev=8 -- .] 0 7]
    set dirty 1
    if {$build_id eq ""} {
        set build_id 00000000
    } elseif {[git_output $hdl_dir status --porcelain -- .] eq ""} {
        set dirty 0
    }

    # VERSION_DEV is always 1 for now: release builds will come with the
    # release script. An IP without these parameters is left alone.
    set hidden [dict create \
        VERSION_MAJOR $major \
        VERSION_MINOR $minor \
        VERSION_DEV   1 \
        BUILD_DIRTY   $dirty \
        BUILD_ID      0x$build_id]
    dict for {param value} $hidden {
        set user_param [ipx::get_user_parameters -quiet $param -of_objects $core]
        if {[llength $user_param] == 0} {
            continue
        }
        set_property value $value $user_param
        set_property enablement_value false $user_param
        # The HDL gets the value of the model parameter, which the procedures
        # in xgui/ are supposed to copy from the user parameter: that does
        # not always happen in a block design instance, so set both.
        set_property value $value [ipx::get_hdl_parameters $param -of_objects $core]
        set gui_param [ipgui::get_guiparamspec -quiet -name $param -component $core]
        if {[llength $gui_param] > 0} {
            ipgui::remove_param -component $core $gui_param
        }
    }

    global_eval ipx::create_xgui_files $core
    ipx::update_checksums $core
    ipx::check_integrity $core
    ipx::save_core $core

    # The xgui file name contains the version: after a version change, delete
    # the file of the old one. Only when the new file is where expected.
    set xgui_file [file join $ip_dir xgui ${name}_v[string map {. _} $version].tcl]
    if {[file exists $xgui_file]} {
        foreach f [glob -nocomplain -directory [file join $ip_dir xgui] *.tcl] {
            if {$f ne $xgui_file} {
                file delete $f
            }
        }
    }

    # Close what was opened: the edit project and the in-memory one below it,
    # or just the in-memory one of the first packaging.
    if {!$first_time} {
        close_project -delete
    }
    if {[project_is_open]} {
        close_project
    }
    puts "Packaged $name $version (core revision $revision, build $build_id, dirty $dirty)"
}
