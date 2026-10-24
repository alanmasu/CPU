# prj::release: release a local IP (stage B), hw/ip/<name>/.
#   prj::release <name> [M.m]   with the current version, or a new one
#
# The everyday loop packages the IP while its RTL has uncommitted changes, so
# component.xml records the previous commit of the RTL and dirty, and is
# committed together with the RTL (the pre-commit hook asks for that). A
# release packages it again once the RTL is committed:
#  1. hw/ip/<name>/ must have no uncommitted changes, and a new version must
#     be greater than the current one;
#  2. packaging with VERSION_DEV 0: BUILD_ID is the commit of the RTL,
#     BUILD_DIRTY 0;
#  3. commit of component.xml and xgui/ of that IP only, with the message
#     "feat(<name>): release <M.m>", whatever else is changed or staged;
#  4. when the project exists, upgrade of the instances and export, as
#     prj::ip does: the snapshot is left to commit.
# No tag: in the repository of a product the tags are the versions of the
# product. Nothing is pushed.

proc ::prj::release {name {new_version ""}} {
    namespace upvar ::prj_priv hw_dir hw_dir
    namespace upvar ::prj_priv root_dir root_dir

    check_vivado_version
    # It ends with an export: stop now rather than after the commit.
    check_snapshot_unchanged ""
    set ip_dir [file join $hw_dir ip $name]
    set xml [file join $ip_dir component.xml]
    set rel_dir hw/ip/$name
    if {![file exists $xml]} {
        error "$name has never been packaged: run prj::ip $name first"
    }
    if {[git_output $root_dir rev-parse --git-dir] eq ""} {
        error "$root_dir is not a git repository: a release needs the RTL committed"
    }
    set changes [git_output $root_dir status --porcelain -- $rel_dir]
    if {$changes ne ""} {
        error "$rel_dir has uncommitted changes: commit them first\n$changes"
    }

    set version [component_param $xml version]
    if {$new_version ne ""} {
        if {![regexp {^[0-9]+\.[0-9]+$} $new_version]} {
            error "The version must be MAJOR.MINOR, got '$new_version'"
        }
        if {[package vcompare $new_version $version] <= 0} {
            error "The new version $new_version is not greater than the current one, $version"
        }
        set version $new_version
    }

    if {[project_is_open]} {
        # Packaging opens projects of its own: run it in a separate Vivado,
        # so that the project open in the GUI is not touched.
        run_batch package_ip $name $version 1
    } else {
        package_ip $name $version 1
    }

    # Commit only the files of the package; git add -A also records the
    # xgui file of an old version, deleted by the packaging. git prints on
    # stderr, which exec would take for an error: 2>@1 merges it.
    set paths [list $rel_dir/component.xml $rel_dir/xgui]
    set message "feat($name): release $version"
    exec git -C $root_dir add -A -- {*}$paths 2>@1
    puts [exec git -C $root_dir commit -m $message -- {*}$paths 2>@1]
    set commit [git_output $root_dir rev-parse --short HEAD]
    puts "Released $name $version in commit $commit"

    update_ip_instances [list $name]
    if {[file exists [file join $hw_dir vivado]]} {
        puts "The instances of $name were upgraded and the project exported: commit hw/src/vivado_project.tcl"
    }
}

# A value of component.xml: the version of the core (the first
# <spirit:version> of the file, part of the VLNV at its top), or a hidden
# parameter of the template (BUILD_ID, BUILD_DIRTY, VERSION_DEV), the value
# with id PARAM_VALUE.<name>. "" when it is missing.
proc ::prj_priv::component_param {xml name} {
    set text [read_text $xml]
    if {$name eq "version"} {
        set pattern {<spirit:version>([^<]*)</spirit:version>}
    } else {
        set pattern "spirit:id=\"PARAM_VALUE.$name\"\[^>\]*>(\[^<\]*)<"
    }
    if {![regexp $pattern $text -> value]} {
        return ""
    }
    return $value
}

# The state of a local IP against its RTL in git, as a list of problems
# ("" when it is clean and released): used by prj::check.
proc ::prj_priv::ip_release_state {name} {
    variable hw_dir
    set ip_dir [file join $hw_dir ip $name]
    set xml [file join $ip_dir component.xml]
    set build_id [component_param $xml BUILD_ID]
    if {$build_id eq ""} {
        return {}
    }
    set problems {}
    if {[component_param $xml VERSION_DEV] eq "1"} {
        lappend problems "development build (not released)"
    }
    if {[component_param $xml BUILD_DIRTY] eq "1"} {
        lappend problems "packaged from uncommitted RTL"
    }
    set last [string range [git_output [file join $ip_dir hdl] log -1 --format=%h --abbrev=8 -- .] 0 7]
    if {$last ne "" && [string tolower $build_id] ne "0x$last"} {
        lappend problems "RTL committed after the packaging (component.xml has $build_id, the RTL is at $last)"
    }
    return $problems
}
