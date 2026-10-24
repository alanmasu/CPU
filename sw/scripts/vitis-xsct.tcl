# The Vitis workspace sw/vitis/ with xsct (classic Vitis IDE, tested with
# 2021.2). Run by sw/scripts/vitis.sh, from work/, with one argument:
#   update  repair what is missing, without building:
#           - projects not imported yet (a fresh clone has no .metadata/);
#           - a platform whose copy of the .xsa is missing (it is not
#             committed) or differs from sw/hw/ (after 'make update-xsa'): update
#             its hardware, and delete _ide/ of the applications, which would
#             otherwise keep the old bitstream;
#           - BSP sources missing (they are not committed): regenerate them
#             from system.mss;
#   build   the same, then build platforms, applications and system projects
#           (BOOT.BIN) and check that the expected files exist.
# The GUI must be closed, because it locks the workspace: vitis.sh checks it.
# The output of the Vitis tools is long: the progress lines of this script go
# to stderr and start with "vitis:", so that vitis.sh can send the rest to
# work/vitis.log.

set vitis_root [file dirname [file dirname [file dirname [file normalize [info script]]]]]

proc vitis_step {text} {
    puts stderr "vitis: $text"
}

# The .xsa of the project: exactly one in sw/hw/, delivered by
# 'make update-xsa'.
proc vitis_xsa {root} {
    set found [glob -nocomplain -directory [file join $root sw hw] *.xsa]
    if {[llength $found] != 1} {
        error "expected one .xsa in sw/hw/, found [llength $found]: deliver the hardware with 'make update-xsa', after 'make xsa'"
    }
    return [lindex $found 0]
}

# True when the two files have the same content.
proc vitis_same_file {a b} {
    if {![file exists $a] || ![file exists $b]} {
        return 0
    }
    if {[file size $a] != [file size $b]} {
        return 0
    }
    set fa [open $a rb]
    set fb [open $b rb]
    set same [string equal [read $fa] [read $fb]]
    close $fa
    close $fb
    return $same
}

proc vitis_update {build} {
    global vitis_root
    set root $vitis_root
    set ws [file join $root sw vitis]
    file mkdir $ws

    set platforms {}
    foreach spr [glob -nocomplain -directory $ws */platform.spr] {
        lappend platforms [file tail [file dirname $spr]]
    }
    if {[llength $platforms] == 0} {
        vitis_step "no platform in $ws yet: nothing to do, create one in the Vitis GUI"
        return
    }
    set xsa [vitis_xsa $root]

    # A fresh clone has no .metadata/ yet: the projects in the directory are
    # not known to Vitis and are imported.
    set fresh [expr {![file exists [file join $ws .metadata]]}]
    vitis_step "workspace $ws"
    setws $ws
    if {$fresh} {
        vitis_step "importing the projects of the workspace"
        importprojects $ws
    }

    foreach platform $platforms {
        set dir [file join $ws $platform]
        platform active $platform

        # Hardware: the copy of the .xsa in hw/ of the platform is not
        # committed, so it is missing after a clone; after 'make xsa' it is
        # old. The file is checked here because 'platform config -updatehw'
        # only prints a message when it does not exist.
        set copy [file join $dir hw [file tail $xsa]]
        if {![vitis_same_file $xsa $copy]} {
            vitis_step "$platform: hardware from $xsa"
            platform config -updatehw $xsa
            foreach ide [glob -nocomplain -directory $ws -type d */_ide] {
                vitis_step "deleting [file tail [file dirname $ide]]/_ide/ (old bitstream)"
                file delete -force $ide
            }
        }

        # BSPs: one system.mss per domain; the sources next to it are not
        # committed. The domain is the directory that contains bsp/, or
        # zynq_fsbl for the BSP of the FSBL. Regenerating a BSP makes its
        # domain the active one, which xsct saves into platform.spr: the
        # active domain is restored afterwards, so that the file does not
        # change. domain active without a name returns the active domain.
        set active [domain active]
        set regenerated 0
        foreach mss [glob -nocomplain -directory $dir */*/bsp/system.mss zynq_fsbl/zynq_fsbl_bsp/system.mss] {
            set bsp [file dirname $mss]
            if {[file tail $bsp] eq "zynq_fsbl_bsp"} {
                set domain zynq_fsbl
            } else {
                set domain [file tail [file dirname $bsp]]
            }
            if {[llength [glob -nocomplain -directory $bsp -type d */libsrc]] == 0} {
                vitis_step "$platform: regenerating the BSP sources of $domain"
                domain active $domain
                bsp regenerate
                set regenerated 1
            }
        }
        if {$regenerated && $active ne ""} {
            domain active $active
        }

        if {$build} {
            vitis_step "$platform: building the platform"
            platform generate
        }
    }
    if {!$build} {
        vitis_step "workspace ready, not built: build from the GUI or with make vitis-build"
        return
    }

    # Each application is built in its active configuration, the one chosen
    # in the GUI (Debug or Release). Eclipse keeps it in .metadata/, which is
    # not committed: after a clone it is the default, Debug. xsct returns it
    # in lower case, the output directory has the name of the configuration.
    set apps {}
    set configs {}
    foreach prj [glob -nocomplain -directory $ws */*.prj] {
        set app [file rootname [file tail $prj]]
        set config [app config -name $app build-config]
        lappend apps $app
        lappend configs $config
        vitis_step "$app: building the application ($config)"
        app build -name $app
    }
    set systems {}
    foreach sprj [glob -nocomplain -directory $ws */*.sprj] {
        set system [file rootname [file tail $sprj]]
        lappend systems $system
        vitis_step "$system: building the system project (BOOT.BIN)"
        sysproj build -name $system
    }

    # The Vitis commands do not always fail when something goes wrong: the
    # results are checked here.
    set missing {}
    foreach platform $platforms {
        set export [file join $ws $platform export $platform sw $platform]
        foreach lib [glob -nocomplain -directory $export */bsplib/lib/libxil.a] {
            vitis_step "ok: [string range $lib [string length $ws/] end]"
        }
        if {[llength [glob -nocomplain -directory $export */bsplib/lib/libxil.a]] == 0} {
            lappend missing "$platform: no libxil.a in $export"
        }
        if {![file exists [file join $export boot fsbl.elf]]} {
            lappend missing "$platform: no [file join $export boot fsbl.elf]"
        }
    }
    foreach app $apps config $configs {
        set elf ""
        foreach dir [glob -nocomplain -types d -directory [file join $ws $app] *] {
            if {[string equal -nocase [file tail $dir] $config]} {
                set elf [file join $dir $app.elf]
            }
        }
        if {$elf ne "" && [file exists $elf]} {
            vitis_step "ok: [string range $elf [string length $ws/] end]"
        } else {
            lappend missing "$app: no $app.elf in its $config output directory"
        }
    }
    # xsct cannot tell the active configuration of a system project: its
    # BOOT.BIN is looked for in any of them.
    foreach system $systems {
        set found [glob -nocomplain -directory [file join $ws $system] */sd_card/BOOT.BIN]
        foreach bin $found {
            vitis_step "ok: [string range $bin [string length $ws/] end]"
        }
        if {[llength $found] == 0} {
            lappend missing "$system: no */sd_card/BOOT.BIN"
        }
    }
    if {[llength $missing] > 0} {
        error "the build did not produce:\n  [join $missing "\n  "]"
    }
    vitis_step "done: [llength $platforms] platform(s), [llength $apps] application(s), [llength $systems] system project(s)"
}

switch -- [lindex $argv 0] {
    update {
        set build 0
    }
    build {
        set build 1
    }
    default {
        puts stderr "vitis: ERROR: usage: xsct vitis-xsct.tcl update|build"
        exit 1
    }
}
if {[catch {vitis_update $build} message]} {
    puts stderr "vitis: ERROR: $message"
    exit 1
}
exit 0
