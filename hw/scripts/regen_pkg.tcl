# prj::regen_pkg: compile the VHDL packages of a simulation set with xvhdl.
#   prj::regen_pkg              the active simulation set
#   prj::regen_pkg <simset>     another one
#
# The compile.sh that Vivado writes for xsim runs xvlog on every Verilog and
# SystemVerilog file first, and xvhdl on the VHDL files after: the compile
# order only sorts the files of each language. A SystemVerilog testbench that
# imports a VHDL package (import types_pkg::*;) therefore stops with
# "'types_pkg' is not declared" whenever the library of the simulation is
# empty: first run of a simulation set, after Reset Simulation, after
# 'make project'. It works again only once xvhdl has put the package into
# xsim.dir/, because the compilation is incremental.
# This command compiles only the VHDL packages, in the directory and the
# library that the simulation uses. Run it by hand when a simulation stops
# with that error, then launch the simulation again. Written and tested in
# the ported CPU project (Vivado 2021.2, 12/10/2026).

proc ::prj::regen_pkg {{simset ""}} {
    namespace upvar ::prj_priv project_dir project_dir
    variable project_name

    check_vivado_version
    open_project_if_needed
    if {$simset eq ""} {
        set simset [current_fileset -simset]
    }
    set fileset [get_filesets -quiet $simset]
    if {[llength $fileset] == 0 || [get_property FILESET_TYPE $fileset] ne "SimulationSrcs"} {
        error "$simset is not a simulation set"
    }
    if {[get_property TARGET_SIMULATOR [current_project]] ne "XSim"} {
        error "The project does not simulate with xsim"
    }

    # Same format as the .prj files that Vivado writes for xvhdl, one line
    # per package, in the compile order of Vivado: a package that uses
    # another one comes after it. Only the sources of the product: the files
    # that Vivado generates for the IPs are inside vivado/, and their packages
    # belong to IP libraries that xsim has already compiled in the Vivado
    # installation, where xvhdl cannot write.
    set lines {}
    foreach file [get_files -compile_order sources -used_in simulation -of_objects $fileset] {
        if {[string first $project_dir/ [file normalize $file]] == 0} {
            continue
        }
        if {![string match VHDL* [get_property FILE_TYPE $file]]} {
            continue
        }
        if {![declares_vhdl_package $file]} {
            continue
        }
        if {[get_property FILE_TYPE $file] eq "VHDL 2008"} {
            set language vhdl2008
        } else {
            set language vhdl
        }
        lappend lines "$language [get_property LIBRARY $file] \"$file\""
    }
    if {[llength $lines] == 0} {
        error "No VHDL packages in the simulation set $simset"
    }

    # xvhdl writes into the current directory: move to the directory of the
    # simulation, and always come back (it is the GUI directory too).
    set work_dir [file join $project_dir $project_name.sim $simset behav xsim]
    file mkdir $work_dir
    write_text [file join $work_dir regen_pkg.prj] "[join $lines \n]\n"
    set old_dir [pwd]
    cd $work_dir
    set failed [catch {run_tool xvhdl --incr --relax -prj regen_pkg.prj} message]
    cd $old_dir
    if {$failed} {
        error "Compiling the VHDL packages of $simset failed: $message"
    }
    puts "VHDL packages of $simset compiled into [file join $work_dir xsim.dir]: launch the simulation again"
}

# True if the VHDL file declares a package (not only a package body).
proc ::prj_priv::declares_vhdl_package {file} {
    return [regexp -nocase -line {^\s*package\s+\w+\s+is\M} [read_text $file]]
}
