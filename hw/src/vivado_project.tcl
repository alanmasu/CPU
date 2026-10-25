# Snapshot of the Vivado project, written by prj::export with write_project_tcl.
# Do not edit by hand: change the project in the GUI and export again.
# Recreate the project with 'make project', which sets origin_dir to hw/.

proc checkRequiredFiles { origin_dir} {
  set status true
  set files [list \
 "[file normalize "$origin_dir/src/ip/BTPU_memory/BTPU_memory.xci"]"\
 "[file normalize "$origin_dir/src/ip/axi_btpu_ctrl/axi_btpu_ctrl.xci"]"\
 "[file normalize "$origin_dir/src/ip/data_memory/data_memory.xci"]"\
 "[file normalize "$origin_dir/src/ip/axi_bram_ctrl_0/axi_bram_ctrl_0.xci"]"\
 "[file normalize "$origin_dir/src/ip/instruction_mem/instruction_mem.xci"]"\
 "[file normalize "$origin_dir/src/hdl/axi/AXI_memory_controller.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/packages/utilities_pkg.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/packages/BNN_pkg.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/packages/types_pkg.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/packages/constant_package.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/packages/memory_pkg.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/bnn/compressor_layer.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/bnn/popcounter_tree.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/bnn/ternary_adder.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/bnn/popcounter.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/bnn/binary_mac.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/bnn/BTPU_MAC.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/bnn/BTPU.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/cpu/IF/instruction_fetch.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/cpu/ID/triple_port_ram.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/cpu/ID/sign_extender_ro.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/cpu/ID/istruction_decode.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/cpu/IE/barrel_shifter.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/cpu/IE/alu.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/cpu/IE/comparator.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/cpu/IE/execute.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/cpu/MEM_WB/address_manager.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/cpu/MEM_WB/memory_write_back.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/periph/GPIO.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/packages/i2c_utils_pkg.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/periph/I2C_driver.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/periph/I2C_module.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/periph/oled_driver/oled_driver.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/periph/timer.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/periph/oled_driver/ascii_rom.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/bnn/compressor_6_3.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/periph/oled_driver/delay_module.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/periph/oled_driver/oled_counter.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/periph/oled_driver/spi_controller.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/cpu/CPU.vhd"]"\
 "[file normalize "$origin_dir/src/sim/bnn/BTPU_wrapper.vhd"]"\
 "[file normalize "$origin_dir/src/sim/common/AXISlaveInterface.vhd"]"\
 "[file normalize "$origin_dir/src/constr/CPU_constraint.xdc"]"\
 "[file normalize "$origin_dir/src/sim/cpu/test_ID.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/packages/types_pkg.vhd"]"\
 "[file normalize "$origin_dir/src/sim/cpu/test_TriplePortRam.vhd"]"\
 "[file normalize "$origin_dir/src/sim/wcfg/test_TriplePortRam_behav.wcfg"]"\
 "[file normalize "$origin_dir/src/sim/cpu/test_IF.vhd"]"\
 "[file normalize "$origin_dir/src/sim/wcfg/test_IF_behav.wcfg"]"\
 "[file normalize "$origin_dir/src/sim/common/slave_interface.vhd"]"\
 "[file normalize "$origin_dir/src/sim/bnn/testBlockMatrixMul.svh"]"\
 "[file normalize "$origin_dir/src/sim/cpu/test_CPU_wh_AXI.sv"]"\
 "[file normalize "$origin_dir/src/sim/cpu/test_GPIO_prog_on_CPU.sv"]"\
 "[file normalize "$origin_dir/src/sim/wcfg/test_CPU_behav_AXI.wcfg"]"\
 "[file normalize "$origin_dir/src/sim/cpu/test_addr_manager.vhd"]"\
 "[file normalize "$origin_dir/src/sim/wcfg/test_addr_manager_behav.wcfg"]"\
 "[file normalize "$origin_dir/src/sim/axi/mem_ctrl_test_wrapper.vhd"]"\
 "[file normalize "$origin_dir/src/sim/common/slave_interface.vhd"]"\
 "[file normalize "$origin_dir/src/sim/bnn/testMatrix.svh"]"\
 "[file normalize "$origin_dir/src/sim/axi/test_AXI_ctrl.sv"]"\
 "[file normalize "$origin_dir/src/sim/wcfg/test_AXI_ctrl_behav.wcfg"]"\
 "[file normalize "$origin_dir/src/sim/periph/test_GPIO.vhd"]"\
 "[file normalize "$origin_dir/src/sim/wcfg/test_GPIO_behav.wcfg"]"\
 "[file normalize "$origin_dir/src/hdl/packages/types_pkg.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/packages/constant_package.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/packages/memory_pkg.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/packages/i2c_utils_pkg.vhd"]"\
 "[file normalize "$origin_dir/src/sim/periph/test_I2C_module.vhd"]"\
 "[file normalize "$origin_dir/src/sim/periph/test_I2C_uitilities.vhd"]"\
 "[file normalize "$origin_dir/src/sim/wcfg/test_I2C_module_behav.wcfg"]"\
 "[file normalize "$origin_dir/src/hdl/bnn/compressor_3_2.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/bnn/compressor_6_3.vhd"]"\
 "[file normalize "$origin_dir/src/sim/bnn/test_compressor.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/packages/utilities_pkg.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/packages/BNN_pkg.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/bnn/compressor_6_3.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/bnn/compressor_layer.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/bnn/popcounter_tree.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/bnn/ternary_adder.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/bnn/popcounter.vhd"]"\
 "[file normalize "$origin_dir/src/sim/bnn/test_popcounter.vhd"]"\
 "[file normalize "$origin_dir/src/sim/wcfg/test_popcounter_behav.wcfg"]"\
 "[file normalize "$origin_dir/src/hdl/packages/utilities_pkg.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/packages/BNN_pkg.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/bnn/compressor_6_3.vhd"]"\
 "[file normalize "$origin_dir/src/hdl/bnn/compressor_layer.vhd"]"\
 "[file normalize "$origin_dir/src/sim/bnn/test_compressor_layer.vhd"]"\
 "[file normalize "$origin_dir/src/sim/bnn/testBNN_utilities.vhd"]"\
 "[file normalize "$origin_dir/src/sim/wcfg/test_compressor_layer_behav.wcfg"]"\
 "[file normalize "$origin_dir/scripts/write_bitstream_pre.tcl"]"\
  ]
  foreach ifile $files {
    if { ![file isfile $ifile] } {
      puts " Could not find remote file $ifile "
      set status false
    }
  }

  return $status
}
# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

# Set the project name
set _xil_proj_name_ "CPU"

# Use project name variable, if specified in the tcl shell
if { [info exists ::user_project_name] } {
  set _xil_proj_name_ $::user_project_name
}

variable script_file
set script_file "vivado_project.raw.tcl"

# Help information for this script
proc print_help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-origin_dir_override\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--project_name <name>\] Create project with the specified name. Default"
  puts "                       name is the name of the project from where this"
  puts "                       script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < $::argc} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir"   { incr i; set origin_dir [lindex $::argv $i] }
      "--project_name" { incr i; set _xil_proj_name_ [lindex $::argv $i] }
      "--help"         { print_help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/vivado"]"

# Check for paths and files needed for project creation
set validate_required 0
if { $validate_required } {
  if { [checkRequiredFiles $origin_dir] } {
    puts "Tcl file $script_file is valid. All files required for project creation is accesable. "
  } else {
    puts "Tcl file $script_file is not valid. Not all files required for project creation is accesable. "
    return
  }
}

# Create project
create_project ${_xil_proj_name_} "$origin_dir/vivado" -part xc7z020clg484-1

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [current_project]
set_property -name "board_part" -value "digilentinc.com:zedboard:part0:1.1" -objects $obj
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/${_xil_proj_name_}.cache/ip" -objects $obj
set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
set_property -name "platform.board_id" -value "zedboard" -objects $obj
set_property -name "revised_directory_structure" -value "1" -objects $obj
set_property -name "sim.central_dir" -value "$proj_dir/${_xil_proj_name_}.ip_user_files" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj
set_property -name "target_language" -value "VHDL" -objects $obj
set_property -name "xpm_libraries" -value "XPM_CDC XPM_FIFO XPM_MEMORY" -objects $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 [file normalize "${origin_dir}/src/ip/BTPU_memory/BTPU_memory.xci"] \
 [file normalize "${origin_dir}/src/ip/axi_btpu_ctrl/axi_btpu_ctrl.xci"] \
 [file normalize "${origin_dir}/src/ip/data_memory/data_memory.xci"] \
 [file normalize "${origin_dir}/src/ip/axi_bram_ctrl_0/axi_bram_ctrl_0.xci"] \
 [file normalize "${origin_dir}/src/ip/instruction_mem/instruction_mem.xci"] \
 [file normalize "${origin_dir}/src/hdl/axi/AXI_memory_controller.vhd"] \
 [file normalize "${origin_dir}/src/hdl/packages/utilities_pkg.vhd"] \
 [file normalize "${origin_dir}/src/hdl/packages/BNN_pkg.vhd"] \
 [file normalize "${origin_dir}/src/hdl/packages/types_pkg.vhd"] \
 [file normalize "${origin_dir}/src/hdl/packages/constant_package.vhd"] \
 [file normalize "${origin_dir}/src/hdl/packages/memory_pkg.vhd"] \
 [file normalize "${origin_dir}/src/hdl/bnn/compressor_layer.vhd"] \
 [file normalize "${origin_dir}/src/hdl/bnn/popcounter_tree.vhd"] \
 [file normalize "${origin_dir}/src/hdl/bnn/ternary_adder.vhd"] \
 [file normalize "${origin_dir}/src/hdl/bnn/popcounter.vhd"] \
 [file normalize "${origin_dir}/src/hdl/bnn/binary_mac.vhd"] \
 [file normalize "${origin_dir}/src/hdl/bnn/BTPU_MAC.vhd"] \
 [file normalize "${origin_dir}/src/hdl/bnn/BTPU.vhd"] \
 [file normalize "${origin_dir}/src/hdl/cpu/IF/instruction_fetch.vhd"] \
 [file normalize "${origin_dir}/src/hdl/cpu/ID/triple_port_ram.vhd"] \
 [file normalize "${origin_dir}/src/hdl/cpu/ID/sign_extender_ro.vhd"] \
 [file normalize "${origin_dir}/src/hdl/cpu/ID/istruction_decode.vhd"] \
 [file normalize "${origin_dir}/src/hdl/cpu/IE/barrel_shifter.vhd"] \
 [file normalize "${origin_dir}/src/hdl/cpu/IE/alu.vhd"] \
 [file normalize "${origin_dir}/src/hdl/cpu/IE/comparator.vhd"] \
 [file normalize "${origin_dir}/src/hdl/cpu/IE/execute.vhd"] \
 [file normalize "${origin_dir}/src/hdl/cpu/MEM_WB/address_manager.vhd"] \
 [file normalize "${origin_dir}/src/hdl/cpu/MEM_WB/memory_write_back.vhd"] \
 [file normalize "${origin_dir}/src/hdl/periph/GPIO.vhd"] \
 [file normalize "${origin_dir}/src/hdl/packages/i2c_utils_pkg.vhd"] \
 [file normalize "${origin_dir}/src/hdl/periph/I2C_driver.vhd"] \
 [file normalize "${origin_dir}/src/hdl/periph/I2C_module.vhd"] \
 [file normalize "${origin_dir}/src/hdl/periph/oled_driver/oled_driver.vhd"] \
 [file normalize "${origin_dir}/src/hdl/periph/timer.vhd"] \
 [file normalize "${origin_dir}/src/hdl/periph/oled_driver/ascii_rom.vhd"] \
 [file normalize "${origin_dir}/src/hdl/bnn/compressor_6_3.vhd"] \
 [file normalize "${origin_dir}/src/hdl/periph/oled_driver/delay_module.vhd"] \
 [file normalize "${origin_dir}/src/hdl/periph/oled_driver/oled_counter.vhd"] \
 [file normalize "${origin_dir}/src/hdl/periph/oled_driver/spi_controller.vhd"] \
 [file normalize "${origin_dir}/src/hdl/cpu/CPU.vhd"] \
 [file normalize "${origin_dir}/src/sim/bnn/BTPU_wrapper.vhd"] \
 [file normalize "${origin_dir}/src/sim/common/AXISlaveInterface.vhd"] \
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
set file "$origin_dir/src/ip/BTPU_memory/BTPU_memory.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "generate_files_for_reference" -value "0" -objects $file_obj
set_property -name "registered_with_manager" -value "1" -objects $file_obj

set file "$origin_dir/src/ip/axi_btpu_ctrl/axi_btpu_ctrl.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "generate_files_for_reference" -value "0" -objects $file_obj
set_property -name "registered_with_manager" -value "1" -objects $file_obj

set file "$origin_dir/src/ip/data_memory/data_memory.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "generate_files_for_reference" -value "0" -objects $file_obj
set_property -name "registered_with_manager" -value "1" -objects $file_obj

set file "$origin_dir/src/ip/axi_bram_ctrl_0/axi_bram_ctrl_0.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "generate_files_for_reference" -value "0" -objects $file_obj
set_property -name "registered_with_manager" -value "1" -objects $file_obj

set file "$origin_dir/src/ip/instruction_mem/instruction_mem.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "generate_files_for_reference" -value "0" -objects $file_obj
set_property -name "registered_with_manager" -value "1" -objects $file_obj

set file "$origin_dir/src/hdl/axi/AXI_memory_controller.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/packages/utilities_pkg.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/packages/BNN_pkg.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/packages/types_pkg.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/packages/constant_package.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/packages/memory_pkg.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/bnn/compressor_layer.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/bnn/popcounter_tree.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/bnn/ternary_adder.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/bnn/popcounter.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/bnn/binary_mac.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/bnn/BTPU_MAC.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/bnn/BTPU.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/cpu/IF/instruction_fetch.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/cpu/ID/triple_port_ram.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/cpu/ID/sign_extender_ro.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/cpu/ID/istruction_decode.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/cpu/IE/barrel_shifter.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/cpu/IE/alu.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/cpu/IE/comparator.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/cpu/IE/execute.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/cpu/MEM_WB/address_manager.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/cpu/MEM_WB/memory_write_back.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2008" -objects $file_obj

set file "$origin_dir/src/hdl/periph/GPIO.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/packages/i2c_utils_pkg.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/periph/I2C_driver.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/periph/I2C_module.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/periph/oled_driver/oled_driver.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/periph/timer.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/periph/oled_driver/ascii_rom.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/bnn/compressor_6_3.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/periph/oled_driver/delay_module.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/periph/oled_driver/oled_counter.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/periph/oled_driver/spi_controller.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/cpu/CPU.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/sim/bnn/BTPU_wrapper.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/sim/common/AXISlaveInterface.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj


# Set 'sources_1' fileset file properties for local files
# None

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "top" -value "top_level_wrapper" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/src/constr/CPU_constraint.xdc"]"
set file_added [add_files -norecurse -fileset $obj [list $file]]
set file "$origin_dir/src/constr/CPU_constraint.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
# Empty (no sources present)

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property -name "top" -value "CPU" -objects $obj
set_property -name "top_arch" -value "Behavioral" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj
set_property -name "top_file" -value "src/hdl/cpu/CPU.vhd" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj

# Create 'decode' fileset (if not found)
if {[string equal [get_filesets -quiet decode] ""]} {
  create_fileset -simset decode
}

# Set 'decode' fileset object
set obj [get_filesets decode]
set files [list \
 [file normalize "${origin_dir}/src/sim/cpu/test_ID.vhd"] \
]
add_files -norecurse -fileset $obj $files

# Set 'decode' fileset file properties for remote files
set file "$origin_dir/src/sim/cpu/test_ID.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets decode] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj


# Set 'decode' fileset file properties for local files
# None

# Set 'decode' fileset properties
set obj [get_filesets decode]
set_property -name "top" -value "test_ID" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj

# Create 'test_register_file' fileset (if not found)
if {[string equal [get_filesets -quiet test_register_file] ""]} {
  create_fileset -simset test_register_file
}

# Set 'test_register_file' fileset object
set obj [get_filesets test_register_file]
set files [list \
 [file normalize "${origin_dir}/src/hdl/packages/types_pkg.vhd"] \
 [file normalize "${origin_dir}/src/sim/cpu/test_TriplePortRam.vhd"] \
 [file normalize "${origin_dir}/src/sim/wcfg/test_TriplePortRam_behav.wcfg"] \
]
add_files -norecurse -fileset $obj $files

# Set 'test_register_file' fileset file properties for remote files
set file "$origin_dir/src/hdl/packages/types_pkg.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets test_register_file] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/sim/cpu/test_TriplePortRam.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets test_register_file] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj


# Set 'test_register_file' fileset file properties for local files
# None

# Set 'test_register_file' fileset properties
set obj [get_filesets test_register_file]
set_property -name "top" -value "test_TriplePortRam" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj

# Create 'fetch_sim' fileset (if not found)
if {[string equal [get_filesets -quiet fetch_sim] ""]} {
  create_fileset -simset fetch_sim
}

# Set 'fetch_sim' fileset object
set obj [get_filesets fetch_sim]
set files [list \
 [file normalize "${origin_dir}/src/sim/cpu/test_IF.vhd"] \
 [file normalize "${origin_dir}/src/sim/wcfg/test_IF_behav.wcfg"] \
]
add_files -norecurse -fileset $obj $files

# Set 'fetch_sim' fileset file properties for remote files
set file "$origin_dir/src/sim/cpu/test_IF.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets fetch_sim] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj


# Set 'fetch_sim' fileset file properties for local files
# None

# Set 'fetch_sim' fileset properties
set obj [get_filesets fetch_sim]
set_property -name "top" -value "test_IF" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj

# Create 'CPU_sim' fileset (if not found)
if {[string equal [get_filesets -quiet CPU_sim] ""]} {
  create_fileset -simset CPU_sim
}

# Set 'CPU_sim' fileset object
set obj [get_filesets CPU_sim]
set files [list \
 [file normalize "${origin_dir}/src/sim/common/slave_interface.vhd"] \
 [file normalize "${origin_dir}/src/sim/bnn/testBlockMatrixMul.svh"] \
 [file normalize "${origin_dir}/src/sim/cpu/test_CPU_wh_AXI.sv"] \
 [file normalize "${origin_dir}/src/sim/cpu/test_GPIO_prog_on_CPU.sv"] \
 [file normalize "${origin_dir}/src/sim/wcfg/test_CPU_behav_AXI.wcfg"] \
]
add_files -norecurse -fileset $obj $files

# Set 'CPU_sim' fileset file properties for remote files
set file "$origin_dir/src/sim/common/slave_interface.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets CPU_sim] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2008" -objects $file_obj

set file "$origin_dir/src/sim/bnn/testBlockMatrixMul.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets CPU_sim] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/src/sim/cpu/test_CPU_wh_AXI.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets CPU_sim] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/src/sim/cpu/test_GPIO_prog_on_CPU.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets CPU_sim] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj
set_property -name "is_enabled" -value "0" -objects $file_obj


# Set 'CPU_sim' fileset file properties for local files
# None

# Set 'CPU_sim' fileset properties
set obj [get_filesets CPU_sim]
set_property -name "include_dirs" -value "[file normalize "$origin_dir/../out/riscv/test/sim"]" -objects $obj
set_property -name "nl.mode" -value "funcsim" -objects $obj
set_property -name "top" -value "test_CPU_wh_AXI" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj
set_property -name "xsim.simulate.log_all_signals" -value "1" -objects $obj
set_property -name "xsim.simulate.runtime" -value "5 ms" -objects $obj

# Create 'address_manager' fileset (if not found)
if {[string equal [get_filesets -quiet address_manager] ""]} {
  create_fileset -simset address_manager
}

# Set 'address_manager' fileset object
set obj [get_filesets address_manager]
set files [list \
 [file normalize "${origin_dir}/src/sim/cpu/test_addr_manager.vhd"] \
 [file normalize "${origin_dir}/src/sim/wcfg/test_addr_manager_behav.wcfg"] \
]
add_files -norecurse -fileset $obj $files

# Set 'address_manager' fileset file properties for remote files
set file "$origin_dir/src/sim/cpu/test_addr_manager.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets address_manager] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj


# Set 'address_manager' fileset file properties for local files
# None

# Set 'address_manager' fileset properties
set obj [get_filesets address_manager]
set_property -name "top" -value "test_addr_manager" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj
set_property -name "xsim.simulate.runtime" -value "100ns" -objects $obj

# Create 'AXI_mem_ctrl' fileset (if not found)
if {[string equal [get_filesets -quiet AXI_mem_ctrl] ""]} {
  create_fileset -simset AXI_mem_ctrl
}

# Set 'AXI_mem_ctrl' fileset object
set obj [get_filesets AXI_mem_ctrl]
set files [list \
 [file normalize "${origin_dir}/src/sim/axi/mem_ctrl_test_wrapper.vhd"] \
 [file normalize "${origin_dir}/src/sim/common/slave_interface.vhd"] \
 [file normalize "${origin_dir}/src/sim/bnn/testMatrix.svh"] \
 [file normalize "${origin_dir}/src/sim/axi/test_AXI_ctrl.sv"] \
 [file normalize "${origin_dir}/src/sim/wcfg/test_AXI_ctrl_behav.wcfg"] \
]
add_files -norecurse -fileset $obj $files

# Set 'AXI_mem_ctrl' fileset file properties for remote files
set file "$origin_dir/src/sim/axi/mem_ctrl_test_wrapper.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets AXI_mem_ctrl] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/sim/common/slave_interface.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets AXI_mem_ctrl] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2008" -objects $file_obj

set file "$origin_dir/src/sim/bnn/testMatrix.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets AXI_mem_ctrl] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/src/sim/axi/test_AXI_ctrl.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets AXI_mem_ctrl] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj


# Set 'AXI_mem_ctrl' fileset file properties for local files
# None

# Set 'AXI_mem_ctrl' fileset properties
set obj [get_filesets AXI_mem_ctrl]
set_property -name "top" -value "test_AXI_ctrl" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj
set_property -name "xsim.simulate.log_all_signals" -value "1" -objects $obj
set_property -name "xsim.simulate.runtime" -value "50ms" -objects $obj

# Create 'test_GPIO' fileset (if not found)
if {[string equal [get_filesets -quiet test_GPIO] ""]} {
  create_fileset -simset test_GPIO
}

# Set 'test_GPIO' fileset object
set obj [get_filesets test_GPIO]
set files [list \
 [file normalize "${origin_dir}/src/sim/periph/test_GPIO.vhd"] \
 [file normalize "${origin_dir}/src/sim/wcfg/test_GPIO_behav.wcfg"] \
]
add_files -norecurse -fileset $obj $files

# Set 'test_GPIO' fileset file properties for remote files
set file "$origin_dir/src/sim/periph/test_GPIO.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets test_GPIO] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj


# Set 'test_GPIO' fileset file properties for local files
# None

# Set 'test_GPIO' fileset properties
set obj [get_filesets test_GPIO]
set_property -name "top" -value "test_GPIO" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj
set_property -name "xsim.simulate.runtime" -value "130ns" -objects $obj

# Create 'test_I2C_module' fileset (if not found)
if {[string equal [get_filesets -quiet test_I2C_module] ""]} {
  create_fileset -simset test_I2C_module
}

# Set 'test_I2C_module' fileset object
set obj [get_filesets test_I2C_module]
set files [list \
 [file normalize "${origin_dir}/src/hdl/packages/types_pkg.vhd"] \
 [file normalize "${origin_dir}/src/hdl/packages/constant_package.vhd"] \
 [file normalize "${origin_dir}/src/hdl/packages/memory_pkg.vhd"] \
 [file normalize "${origin_dir}/src/hdl/packages/i2c_utils_pkg.vhd"] \
 [file normalize "${origin_dir}/src/sim/periph/test_I2C_module.vhd"] \
 [file normalize "${origin_dir}/src/sim/periph/test_I2C_uitilities.vhd"] \
 [file normalize "${origin_dir}/src/sim/wcfg/test_I2C_module_behav.wcfg"] \
]
add_files -norecurse -fileset $obj $files

# Set 'test_I2C_module' fileset file properties for remote files
set file "$origin_dir/src/hdl/packages/types_pkg.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets test_I2C_module] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/packages/constant_package.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets test_I2C_module] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/packages/memory_pkg.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets test_I2C_module] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/packages/i2c_utils_pkg.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets test_I2C_module] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/sim/periph/test_I2C_module.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets test_I2C_module] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2008" -objects $file_obj

set file "$origin_dir/src/sim/periph/test_I2C_uitilities.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets test_I2C_module] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj


# Set 'test_I2C_module' fileset file properties for local files
# None

# Set 'test_I2C_module' fileset properties
set obj [get_filesets test_I2C_module]
set_property -name "top" -value "test_I2C_module" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj
set_property -name "xsim.simulate.log_all_signals" -value "1" -objects $obj
set_property -name "xsim.simulate.runtime" -value "50ms" -objects $obj

# Create 'compressor_6_3_sim' fileset (if not found)
if {[string equal [get_filesets -quiet compressor_6_3_sim] ""]} {
  create_fileset -simset compressor_6_3_sim
}

# Set 'compressor_6_3_sim' fileset object
set obj [get_filesets compressor_6_3_sim]
set files [list \
 [file normalize "${origin_dir}/src/hdl/bnn/compressor_3_2.vhd"] \
 [file normalize "${origin_dir}/src/hdl/bnn/compressor_6_3.vhd"] \
 [file normalize "${origin_dir}/src/sim/bnn/test_compressor.vhd"] \
]
add_files -norecurse -fileset $obj $files

# Set 'compressor_6_3_sim' fileset file properties for remote files
set file "$origin_dir/src/hdl/bnn/compressor_3_2.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets compressor_6_3_sim] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/bnn/compressor_6_3.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets compressor_6_3_sim] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/sim/bnn/test_compressor.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets compressor_6_3_sim] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj


# Set 'compressor_6_3_sim' fileset file properties for local files
# None

# Set 'compressor_6_3_sim' fileset properties
set obj [get_filesets compressor_6_3_sim]
set_property -name "source_set" -value "" -objects $obj
set_property -name "top" -value "test_compressor" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj
set_property -name "xsim.simulate.log_all_signals" -value "1" -objects $obj
set_property -name "xsim.simulate.runtime" -value "100 ns" -objects $obj

# Create 'popcount_sim' fileset (if not found)
if {[string equal [get_filesets -quiet popcount_sim] ""]} {
  create_fileset -simset popcount_sim
}

# Set 'popcount_sim' fileset object
set obj [get_filesets popcount_sim]
set files [list \
 [file normalize "${origin_dir}/src/hdl/packages/utilities_pkg.vhd"] \
 [file normalize "${origin_dir}/src/hdl/packages/BNN_pkg.vhd"] \
 [file normalize "${origin_dir}/src/hdl/bnn/compressor_6_3.vhd"] \
 [file normalize "${origin_dir}/src/hdl/bnn/compressor_layer.vhd"] \
 [file normalize "${origin_dir}/src/hdl/bnn/popcounter_tree.vhd"] \
 [file normalize "${origin_dir}/src/hdl/bnn/ternary_adder.vhd"] \
 [file normalize "${origin_dir}/src/hdl/bnn/popcounter.vhd"] \
 [file normalize "${origin_dir}/src/sim/bnn/test_popcounter.vhd"] \
 [file normalize "${origin_dir}/src/sim/wcfg/test_popcounter_behav.wcfg"] \
]
add_files -norecurse -fileset $obj $files

# Set 'popcount_sim' fileset file properties for remote files
set file "$origin_dir/src/hdl/packages/utilities_pkg.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets popcount_sim] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/packages/BNN_pkg.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets popcount_sim] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/bnn/compressor_6_3.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets popcount_sim] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/bnn/compressor_layer.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets popcount_sim] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/bnn/popcounter_tree.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets popcount_sim] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/bnn/ternary_adder.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets popcount_sim] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/bnn/popcounter.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets popcount_sim] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/sim/bnn/test_popcounter.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets popcount_sim] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj


# Set 'popcount_sim' fileset file properties for local files
# None

# Set 'popcount_sim' fileset properties
set obj [get_filesets popcount_sim]
set_property -name "source_set" -value "" -objects $obj
set_property -name "top" -value "test_popcounter" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj
set_property -name "xsim.simulate.log_all_signals" -value "1" -objects $obj
set_property -name "xsim.simulate.runtime" -value "100 ns" -objects $obj

# Create 'compressor_level_sim' fileset (if not found)
if {[string equal [get_filesets -quiet compressor_level_sim] ""]} {
  create_fileset -simset compressor_level_sim
}

# Set 'compressor_level_sim' fileset object
set obj [get_filesets compressor_level_sim]
set files [list \
 [file normalize "${origin_dir}/src/hdl/packages/utilities_pkg.vhd"] \
 [file normalize "${origin_dir}/src/hdl/packages/BNN_pkg.vhd"] \
 [file normalize "${origin_dir}/src/hdl/bnn/compressor_6_3.vhd"] \
 [file normalize "${origin_dir}/src/hdl/bnn/compressor_layer.vhd"] \
 [file normalize "${origin_dir}/src/sim/bnn/test_compressor_layer.vhd"] \
 [file normalize "${origin_dir}/src/sim/bnn/testBNN_utilities.vhd"] \
 [file normalize "${origin_dir}/src/sim/wcfg/test_compressor_layer_behav.wcfg"] \
]
add_files -norecurse -fileset $obj $files

# Set 'compressor_level_sim' fileset file properties for remote files
set file "$origin_dir/src/hdl/packages/utilities_pkg.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets compressor_level_sim] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/packages/BNN_pkg.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets compressor_level_sim] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/bnn/compressor_6_3.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets compressor_level_sim] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/hdl/bnn/compressor_layer.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets compressor_level_sim] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/sim/bnn/test_compressor_layer.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets compressor_level_sim] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/src/sim/bnn/testBNN_utilities.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets compressor_level_sim] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj


# Set 'compressor_level_sim' fileset file properties for local files
# None

# Set 'compressor_level_sim' fileset properties
set obj [get_filesets compressor_level_sim]
set_property -name "source_set" -value "" -objects $obj
set_property -name "top" -value "test_compressor_layer" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj
set_property -name "xsim.simulate.log_all_signals" -value "1" -objects $obj
set_property -name "xsim.simulate.runtime" -value "100 ns" -objects $obj

# Set 'utils_1' fileset object
set obj [get_filesets utils_1]
set files [list \
 [file normalize "${origin_dir}/scripts/write_bitstream_pre.tcl"] \
]
add_files -norecurse -fileset $obj $files

# Set 'utils_1' fileset file properties for remote files
set file "$origin_dir/scripts/write_bitstream_pre.tcl"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets utils_1] [list "*$file"]]
set_property -name "file_type" -value "TCL" -objects $file_obj


# Set 'utils_1' fileset file properties for local files
# None

# Set 'utils_1' fileset properties
set obj [get_filesets utils_1]


# Adding sources referenced in BDs, if not already added
if { [get_files BTPU_memory.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/BTPU_memory/BTPU_memory.xci
}
if { [get_files axi_btpu_ctrl.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/axi_btpu_ctrl/axi_btpu_ctrl.xci
}
if { [get_files data_memory.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/data_memory/data_memory.xci
}
if { [get_files axi_bram_ctrl_0.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/axi_bram_ctrl_0/axi_bram_ctrl_0.xci
}
if { [get_files instruction_mem.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/instruction_mem/instruction_mem.xci
}
if { [get_files AXI_memory_controller.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/axi/AXI_memory_controller.vhd
}
if { [get_files utilities_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/utilities_pkg.vhd
}
if { [get_files BNN_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/BNN_pkg.vhd
}
if { [get_files types_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/types_pkg.vhd
}
if { [get_files constant_package.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/constant_package.vhd
}
if { [get_files memory_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/memory_pkg.vhd
}
if { [get_files compressor_layer.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/compressor_layer.vhd
}
if { [get_files popcounter_tree.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/popcounter_tree.vhd
}
if { [get_files ternary_adder.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/ternary_adder.vhd
}
if { [get_files popcounter.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/popcounter.vhd
}
if { [get_files binary_mac.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/binary_mac.vhd
}
if { [get_files BTPU_MAC.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/BTPU_MAC.vhd
}
if { [get_files BTPU.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/BTPU.vhd
}
if { [get_files instruction_fetch.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/IF/instruction_fetch.vhd
}
if { [get_files triple_port_ram.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/ID/triple_port_ram.vhd
}
if { [get_files sign_extender_ro.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/ID/sign_extender_ro.vhd
}
if { [get_files istruction_decode.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/ID/istruction_decode.vhd
}
if { [get_files barrel_shifter.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/IE/barrel_shifter.vhd
}
if { [get_files alu.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/IE/alu.vhd
}
if { [get_files comparator.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/IE/comparator.vhd
}
if { [get_files execute.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/IE/execute.vhd
}
if { [get_files address_manager.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/MEM_WB/address_manager.vhd
}
if { [get_files memory_write_back.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/MEM_WB/memory_write_back.vhd
}
if { [get_files GPIO.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/GPIO.vhd
}
if { [get_files i2c_utils_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/i2c_utils_pkg.vhd
}
if { [get_files I2C_driver.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/I2C_driver.vhd
}
if { [get_files I2C_module.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/I2C_module.vhd
}
if { [get_files oled_driver.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/oled_driver/oled_driver.vhd
}
if { [get_files timer.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/timer.vhd
}
if { [get_files ascii_rom.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/oled_driver/ascii_rom.vhd
}
if { [get_files compressor_6_3.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/compressor_6_3.vhd
}
if { [get_files delay_module.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/oled_driver/delay_module.vhd
}
if { [get_files oled_counter.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/oled_driver/oled_counter.vhd
}
if { [get_files spi_controller.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/oled_driver/spi_controller.vhd
}
if { [get_files CPU.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/CPU.vhd
}


# Proc to create BD top_level
proc cr_bd_top_level { parentCell } {
# The design that will be created by this Tcl proc contains the following 
# module references:
# CPU



  # CHANGE DESIGN NAME HERE
  set design_name top_level

  common::send_gid_msg -ssname BD::TCL -id 2010 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

  create_bd_design $design_name

  set bCheckIPsPassed 1
  ##################################################################
  # CHECK IPs
  ##################################################################
  set bCheckIPs 1
  if { $bCheckIPs == 1 } {
     set list_check_ips "\ 
  xilinx.com:ip:axi_cdma:4.1\
  xilinx.com:ip:processing_system7:5.5\
  xilinx.com:ip:proc_sys_reset:5.0\
  "

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

  }

  ##################################################################
  # CHECK Modules
  ##################################################################
  set bCheckModules 1
  if { $bCheckModules == 1 } {
     set list_check_mods "\ 
  CPU\
  "

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

  if { $bCheckIPsPassed != 1 } {
    common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
    return 3
  }

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]

  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]


  # Create ports
  set GPIO_0 [ create_bd_port -dir IO -from 15 -to 0 GPIO_0 ]
  set SCL_0 [ create_bd_port -dir IO SCL_0 ]
  set SDA_0 [ create_bd_port -dir IO SDA_0 ]
  set btn_center_0 [ create_bd_port -dir I btn_center_0 ]
  set btn_down_0 [ create_bd_port -dir I btn_down_0 ]
  set btn_left_0 [ create_bd_port -dir I btn_left_0 ]
  set btn_right_0 [ create_bd_port -dir I btn_right_0 ]
  set btn_up_0 [ create_bd_port -dir I btn_up_0 ]
  set leds_0 [ create_bd_port -dir O -from 2 -to 0 leds_0 ]
  set oled_dc_0 [ create_bd_port -dir O oled_dc_0 ]
  set oled_res_0 [ create_bd_port -dir O oled_res_0 ]
  set oled_sclk_0 [ create_bd_port -dir O oled_sclk_0 ]
  set oled_sdin_0 [ create_bd_port -dir O oled_sdin_0 ]
  set oled_select0_0 [ create_bd_port -dir I oled_select0_0 ]
  set oled_vbat_0 [ create_bd_port -dir O oled_vbat_0 ]
  set oled_vdd_0 [ create_bd_port -dir O oled_vdd_0 ]
  set run_in_0 [ create_bd_port -dir I run_in_0 ]
  set run_out_0 [ create_bd_port -dir O run_out_0 ]
  set switches_0 [ create_bd_port -dir I -from 1 -to 0 switches_0 ]

  # Create instance: CPU_0, and set properties
  set block_name CPU
  set block_cell_name CPU_0
  if { [catch {set CPU_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $CPU_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.IS_STANDALONE {true} \
 ] $CPU_0

  # Create instance: axi_cdma_0, and set properties
  set axi_cdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_cdma:4.1 axi_cdma_0 ]

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {3} \
   CONFIG.STRATEGY {1} \
 ] $axi_mem_intercon

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
   CONFIG.PCW_ACT_CAN0_PERIPHERAL_FREQMHZ {23.8095} \
   CONFIG.PCW_ACT_CAN1_PERIPHERAL_FREQMHZ {23.8095} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {40.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {40.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_I2C_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {50.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {50.000000} \
   CONFIG.PCW_ACT_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_ACT_USB1_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
   CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {666.666667} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {40} \
   CONFIG.PCW_CAN0_BASEADDR {0xE0008000} \
   CONFIG.PCW_CAN0_GRP_CLK_ENABLE {0} \
   CONFIG.PCW_CAN0_HIGHADDR {0xE0008FFF} \
   CONFIG.PCW_CAN0_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_CAN0_PERIPHERAL_FREQMHZ {-1} \
   CONFIG.PCW_CAN1_BASEADDR {0xE0009000} \
   CONFIG.PCW_CAN1_GRP_CLK_ENABLE {0} \
   CONFIG.PCW_CAN1_HIGHADDR {0xE0009FFF} \
   CONFIG.PCW_CAN1_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_CAN1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_CAN1_PERIPHERAL_FREQMHZ {-1} \
   CONFIG.PCW_CAN_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_CAN_PERIPHERAL_VALID {0} \
   CONFIG.PCW_CLK0_FREQ {40000000} \
   CONFIG.PCW_CLK1_FREQ {40000000} \
   CONFIG.PCW_CLK2_FREQ {10000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CORE0_FIQ_INTR {0} \
   CONFIG.PCW_CORE0_IRQ_INTR {0} \
   CONFIG.PCW_CORE1_FIQ_INTR {0} \
   CONFIG.PCW_CORE1_IRQ_INTR {0} \
   CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {667} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1333.333} \
   CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
   CONFIG.PCW_DCI_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DCI_PERIPHERAL_FREQMHZ {10.159} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_HPRLPR_QUEUE_PARTITION {HPR(0)/LPR(32)} \
   CONFIG.PCW_DDR_HPR_TO_CRITICAL_PRIORITY_LEVEL {15} \
   CONFIG.PCW_DDR_LPR_TO_CRITICAL_PRIORITY_LEVEL {2} \
   CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_PORT0_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT1_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT2_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT3_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_RAM_BASEADDR {0x00100000} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x1FFFFFFF} \
   CONFIG.PCW_DDR_WRITE_TO_CRITICAL_PRIORITY_LEVEL {2} \
   CONFIG.PCW_DM_WIDTH {4} \
   CONFIG.PCW_DQS_WIDTH {4} \
   CONFIG.PCW_DQ_WIDTH {32} \
   CONFIG.PCW_ENET0_BASEADDR {0xE000B000} \
   CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
   CONFIG.PCW_ENET0_HIGHADDR {0xE000BFFF} \
   CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {0} \
   CONFIG.PCW_ENET1_BASEADDR {0xE000C000} \
   CONFIG.PCW_ENET1_GRP_MDIO_ENABLE {0} \
   CONFIG.PCW_ENET1_HIGHADDR {0xE000CFFF} \
   CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_ENET1_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_ENABLE {1} \
   CONFIG.PCW_ENET_RESET_POLARITY {Active Low} \
   CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_EN_4K_TIMER {0} \
   CONFIG.PCW_EN_CAN0 {0} \
   CONFIG.PCW_EN_CAN1 {0} \
   CONFIG.PCW_EN_CLK0_PORT {1} \
   CONFIG.PCW_EN_CLK1_PORT {1} \
   CONFIG.PCW_EN_CLK2_PORT {0} \
   CONFIG.PCW_EN_CLK3_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG0_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG1_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG2_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG3_PORT {0} \
   CONFIG.PCW_EN_DDR {1} \
   CONFIG.PCW_EN_EMIO_CAN0 {0} \
   CONFIG.PCW_EN_EMIO_CAN1 {0} \
   CONFIG.PCW_EN_EMIO_CD_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_CD_SDIO1 {0} \
   CONFIG.PCW_EN_EMIO_ENET0 {0} \
   CONFIG.PCW_EN_EMIO_ENET1 {0} \
   CONFIG.PCW_EN_EMIO_GPIO {0} \
   CONFIG.PCW_EN_EMIO_I2C0 {0} \
   CONFIG.PCW_EN_EMIO_I2C1 {0} \
   CONFIG.PCW_EN_EMIO_MODEM_UART0 {0} \
   CONFIG.PCW_EN_EMIO_MODEM_UART1 {0} \
   CONFIG.PCW_EN_EMIO_PJTAG {0} \
   CONFIG.PCW_EN_EMIO_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_SDIO1 {0} \
   CONFIG.PCW_EN_EMIO_SPI0 {0} \
   CONFIG.PCW_EN_EMIO_SPI1 {0} \
   CONFIG.PCW_EN_EMIO_SRAM_INT {0} \
   CONFIG.PCW_EN_EMIO_TRACE {0} \
   CONFIG.PCW_EN_EMIO_TTC0 {1} \
   CONFIG.PCW_EN_EMIO_TTC1 {0} \
   CONFIG.PCW_EN_EMIO_UART0 {0} \
   CONFIG.PCW_EN_EMIO_UART1 {0} \
   CONFIG.PCW_EN_EMIO_WDT {0} \
   CONFIG.PCW_EN_EMIO_WP_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_WP_SDIO1 {0} \
   CONFIG.PCW_EN_ENET0 {1} \
   CONFIG.PCW_EN_ENET1 {0} \
   CONFIG.PCW_EN_GPIO {1} \
   CONFIG.PCW_EN_I2C0 {0} \
   CONFIG.PCW_EN_I2C1 {0} \
   CONFIG.PCW_EN_MODEM_UART0 {0} \
   CONFIG.PCW_EN_MODEM_UART1 {0} \
   CONFIG.PCW_EN_PJTAG {0} \
   CONFIG.PCW_EN_PTP_ENET0 {0} \
   CONFIG.PCW_EN_PTP_ENET1 {0} \
   CONFIG.PCW_EN_QSPI {1} \
   CONFIG.PCW_EN_RST0_PORT {1} \
   CONFIG.PCW_EN_RST1_PORT {0} \
   CONFIG.PCW_EN_RST2_PORT {0} \
   CONFIG.PCW_EN_RST3_PORT {0} \
   CONFIG.PCW_EN_SDIO0 {1} \
   CONFIG.PCW_EN_SDIO1 {0} \
   CONFIG.PCW_EN_SMC {0} \
   CONFIG.PCW_EN_SPI0 {0} \
   CONFIG.PCW_EN_SPI1 {0} \
   CONFIG.PCW_EN_TRACE {0} \
   CONFIG.PCW_EN_TTC0 {1} \
   CONFIG.PCW_EN_TTC1 {0} \
   CONFIG.PCW_EN_UART0 {0} \
   CONFIG.PCW_EN_UART1 {1} \
   CONFIG.PCW_EN_USB0 {1} \
   CONFIG.PCW_EN_USB1 {0} \
   CONFIG.PCW_EN_WDT {0} \
   CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {5} \
   CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {5} \
   CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK0_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK1_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK2_BUF {FALSE} \
   CONFIG.PCW_FCLK_CLK3_BUF {FALSE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {40.000000} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {40.000000} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_GP0_EN_MODIFIABLE_TXN {1} \
   CONFIG.PCW_GP0_NUM_READ_THREADS {4} \
   CONFIG.PCW_GP0_NUM_WRITE_THREADS {4} \
   CONFIG.PCW_GP1_EN_MODIFIABLE_TXN {1} \
   CONFIG.PCW_GP1_NUM_READ_THREADS {4} \
   CONFIG.PCW_GP1_NUM_WRITE_THREADS {4} \
   CONFIG.PCW_GPIO_BASEADDR {0xE000A000} \
   CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
   CONFIG.PCW_GPIO_EMIO_GPIO_WIDTH {64} \
   CONFIG.PCW_GPIO_HIGHADDR {0xE000AFFF} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
   CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C0_BASEADDR {0xE0004000} \
   CONFIG.PCW_I2C0_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C0_HIGHADDR {0xE0004FFF} \
   CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_BASEADDR {0xE0005000} \
   CONFIG.PCW_I2C1_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C1_HIGHADDR {0xE0005FFF} \
   CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {25} \
   CONFIG.PCW_I2C_RESET_ENABLE {1} \
   CONFIG.PCW_I2C_RESET_POLARITY {Active Low} \
   CONFIG.PCW_IMPORT_BOARD_PRESET {None} \
   CONFIG.PCW_INCLUDE_ACP_TRANS_CHECK {0} \
   CONFIG.PCW_INCLUDE_TRACE_BUFFER {0} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {30} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
   CONFIG.PCW_IRQ_F2P_INTR {0} \
   CONFIG.PCW_IRQ_F2P_MODE {DIRECT} \
   CONFIG.PCW_MIO_0_DIRECTION {inout} \
   CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_0_PULLUP {disabled} \
   CONFIG.PCW_MIO_0_SLEW {slow} \
   CONFIG.PCW_MIO_10_DIRECTION {inout} \
   CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_10_PULLUP {disabled} \
   CONFIG.PCW_MIO_10_SLEW {slow} \
   CONFIG.PCW_MIO_11_DIRECTION {inout} \
   CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_11_PULLUP {disabled} \
   CONFIG.PCW_MIO_11_SLEW {slow} \
   CONFIG.PCW_MIO_12_DIRECTION {inout} \
   CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_12_PULLUP {disabled} \
   CONFIG.PCW_MIO_12_SLEW {slow} \
   CONFIG.PCW_MIO_13_DIRECTION {inout} \
   CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_13_PULLUP {disabled} \
   CONFIG.PCW_MIO_13_SLEW {slow} \
   CONFIG.PCW_MIO_14_DIRECTION {inout} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_14_PULLUP {disabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {inout} \
   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_15_PULLUP {disabled} \
   CONFIG.PCW_MIO_15_SLEW {slow} \
   CONFIG.PCW_MIO_16_DIRECTION {out} \
   CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_16_PULLUP {disabled} \
   CONFIG.PCW_MIO_16_SLEW {fast} \
   CONFIG.PCW_MIO_17_DIRECTION {out} \
   CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_17_PULLUP {disabled} \
   CONFIG.PCW_MIO_17_SLEW {fast} \
   CONFIG.PCW_MIO_18_DIRECTION {out} \
   CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_18_PULLUP {disabled} \
   CONFIG.PCW_MIO_18_SLEW {fast} \
   CONFIG.PCW_MIO_19_DIRECTION {out} \
   CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_19_PULLUP {disabled} \
   CONFIG.PCW_MIO_19_SLEW {fast} \
   CONFIG.PCW_MIO_1_DIRECTION {out} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_1_PULLUP {disabled} \
   CONFIG.PCW_MIO_1_SLEW {fast} \
   CONFIG.PCW_MIO_20_DIRECTION {out} \
   CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_20_PULLUP {disabled} \
   CONFIG.PCW_MIO_20_SLEW {fast} \
   CONFIG.PCW_MIO_21_DIRECTION {out} \
   CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_21_PULLUP {disabled} \
   CONFIG.PCW_MIO_21_SLEW {fast} \
   CONFIG.PCW_MIO_22_DIRECTION {in} \
   CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_22_PULLUP {disabled} \
   CONFIG.PCW_MIO_22_SLEW {fast} \
   CONFIG.PCW_MIO_23_DIRECTION {in} \
   CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_23_PULLUP {disabled} \
   CONFIG.PCW_MIO_23_SLEW {fast} \
   CONFIG.PCW_MIO_24_DIRECTION {in} \
   CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_24_PULLUP {disabled} \
   CONFIG.PCW_MIO_24_SLEW {fast} \
   CONFIG.PCW_MIO_25_DIRECTION {in} \
   CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_25_PULLUP {disabled} \
   CONFIG.PCW_MIO_25_SLEW {fast} \
   CONFIG.PCW_MIO_26_DIRECTION {in} \
   CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_26_PULLUP {disabled} \
   CONFIG.PCW_MIO_26_SLEW {fast} \
   CONFIG.PCW_MIO_27_DIRECTION {in} \
   CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_27_PULLUP {disabled} \
   CONFIG.PCW_MIO_27_SLEW {fast} \
   CONFIG.PCW_MIO_28_DIRECTION {inout} \
   CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_28_PULLUP {disabled} \
   CONFIG.PCW_MIO_28_SLEW {fast} \
   CONFIG.PCW_MIO_29_DIRECTION {in} \
   CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_29_PULLUP {disabled} \
   CONFIG.PCW_MIO_29_SLEW {fast} \
   CONFIG.PCW_MIO_2_DIRECTION {inout} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {fast} \
   CONFIG.PCW_MIO_30_DIRECTION {out} \
   CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_30_PULLUP {disabled} \
   CONFIG.PCW_MIO_30_SLEW {fast} \
   CONFIG.PCW_MIO_31_DIRECTION {in} \
   CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_31_PULLUP {disabled} \
   CONFIG.PCW_MIO_31_SLEW {fast} \
   CONFIG.PCW_MIO_32_DIRECTION {inout} \
   CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_32_PULLUP {disabled} \
   CONFIG.PCW_MIO_32_SLEW {fast} \
   CONFIG.PCW_MIO_33_DIRECTION {inout} \
   CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_33_PULLUP {disabled} \
   CONFIG.PCW_MIO_33_SLEW {fast} \
   CONFIG.PCW_MIO_34_DIRECTION {inout} \
   CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_34_PULLUP {disabled} \
   CONFIG.PCW_MIO_34_SLEW {fast} \
   CONFIG.PCW_MIO_35_DIRECTION {inout} \
   CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_35_PULLUP {disabled} \
   CONFIG.PCW_MIO_35_SLEW {fast} \
   CONFIG.PCW_MIO_36_DIRECTION {in} \
   CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_36_PULLUP {disabled} \
   CONFIG.PCW_MIO_36_SLEW {fast} \
   CONFIG.PCW_MIO_37_DIRECTION {inout} \
   CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_37_PULLUP {disabled} \
   CONFIG.PCW_MIO_37_SLEW {fast} \
   CONFIG.PCW_MIO_38_DIRECTION {inout} \
   CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_38_PULLUP {disabled} \
   CONFIG.PCW_MIO_38_SLEW {fast} \
   CONFIG.PCW_MIO_39_DIRECTION {inout} \
   CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_39_PULLUP {disabled} \
   CONFIG.PCW_MIO_39_SLEW {fast} \
   CONFIG.PCW_MIO_3_DIRECTION {inout} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {fast} \
   CONFIG.PCW_MIO_40_DIRECTION {inout} \
   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_40_PULLUP {disabled} \
   CONFIG.PCW_MIO_40_SLEW {fast} \
   CONFIG.PCW_MIO_41_DIRECTION {inout} \
   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_41_PULLUP {disabled} \
   CONFIG.PCW_MIO_41_SLEW {fast} \
   CONFIG.PCW_MIO_42_DIRECTION {inout} \
   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_42_PULLUP {disabled} \
   CONFIG.PCW_MIO_42_SLEW {fast} \
   CONFIG.PCW_MIO_43_DIRECTION {inout} \
   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_43_PULLUP {disabled} \
   CONFIG.PCW_MIO_43_SLEW {fast} \
   CONFIG.PCW_MIO_44_DIRECTION {inout} \
   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_44_PULLUP {disabled} \
   CONFIG.PCW_MIO_44_SLEW {fast} \
   CONFIG.PCW_MIO_45_DIRECTION {inout} \
   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_45_PULLUP {disabled} \
   CONFIG.PCW_MIO_45_SLEW {fast} \
   CONFIG.PCW_MIO_46_DIRECTION {in} \
   CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_46_PULLUP {disabled} \
   CONFIG.PCW_MIO_46_SLEW {slow} \
   CONFIG.PCW_MIO_47_DIRECTION {in} \
   CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_47_PULLUP {disabled} \
   CONFIG.PCW_MIO_47_SLEW {slow} \
   CONFIG.PCW_MIO_48_DIRECTION {out} \
   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_48_PULLUP {disabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {in} \
   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_49_PULLUP {disabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {fast} \
   CONFIG.PCW_MIO_50_DIRECTION {inout} \
   CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_50_PULLUP {disabled} \
   CONFIG.PCW_MIO_50_SLEW {slow} \
   CONFIG.PCW_MIO_51_DIRECTION {inout} \
   CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_51_PULLUP {disabled} \
   CONFIG.PCW_MIO_51_SLEW {slow} \
   CONFIG.PCW_MIO_52_DIRECTION {out} \
   CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_52_PULLUP {disabled} \
   CONFIG.PCW_MIO_52_SLEW {slow} \
   CONFIG.PCW_MIO_53_DIRECTION {inout} \
   CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_53_PULLUP {disabled} \
   CONFIG.PCW_MIO_53_SLEW {slow} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {fast} \
   CONFIG.PCW_MIO_6_DIRECTION {out} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {fast} \
   CONFIG.PCW_MIO_7_DIRECTION {out} \
   CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_7_PULLUP {disabled} \
   CONFIG.PCW_MIO_7_SLEW {slow} \
   CONFIG.PCW_MIO_8_DIRECTION {out} \
   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_8_PULLUP {disabled} \
   CONFIG.PCW_MIO_8_SLEW {fast} \
   CONFIG.PCW_MIO_9_DIRECTION {inout} \
   CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_9_PULLUP {disabled} \
   CONFIG.PCW_MIO_9_SLEW {slow} \
   CONFIG.PCW_MIO_PRIMITIVE {54} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {\
GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI\
Flash#Quad SPI Flash#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#Enet 0#Enet\
0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB\
0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD\
0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#UART 1#UART 1#GPIO#GPIO#Enet 0#Enet 0} \
   CONFIG.PCW_MIO_TREE_SIGNALS {\
gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#gpio[7]#gpio[8]#gpio[9]#gpio[10]#gpio[11]#gpio[12]#gpio[13]#gpio[14]#gpio[15]#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#wp#cd#tx#rx#gpio[50]#gpio[51]#mdc#mdio} \
   CONFIG.PCW_M_AXI_GP0_ENABLE_STATIC_REMAP {0} \
   CONFIG.PCW_M_AXI_GP0_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP0_SUPPORT_NARROW_BURST {0} \
   CONFIG.PCW_M_AXI_GP0_THREAD_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP1_ENABLE_STATIC_REMAP {0} \
   CONFIG.PCW_M_AXI_GP1_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP1_SUPPORT_NARROW_BURST {0} \
   CONFIG.PCW_M_AXI_GP1_THREAD_ID_WIDTH {12} \
   CONFIG.PCW_NAND_CYCLES_T_AR {1} \
   CONFIG.PCW_NAND_CYCLES_T_CLR {1} \
   CONFIG.PCW_NAND_CYCLES_T_RC {11} \
   CONFIG.PCW_NAND_CYCLES_T_REA {1} \
   CONFIG.PCW_NAND_CYCLES_T_RR {1} \
   CONFIG.PCW_NAND_CYCLES_T_WC {11} \
   CONFIG.PCW_NAND_CYCLES_T_WP {1} \
   CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
   CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_CS0_T_CEOE {1} \
   CONFIG.PCW_NOR_CS0_T_PC {1} \
   CONFIG.PCW_NOR_CS0_T_RC {11} \
   CONFIG.PCW_NOR_CS0_T_TR {1} \
   CONFIG.PCW_NOR_CS0_T_WC {11} \
   CONFIG.PCW_NOR_CS0_T_WP {1} \
   CONFIG.PCW_NOR_CS0_WE_TIME {0} \
   CONFIG.PCW_NOR_CS1_T_CEOE {1} \
   CONFIG.PCW_NOR_CS1_T_PC {1} \
   CONFIG.PCW_NOR_CS1_T_RC {11} \
   CONFIG.PCW_NOR_CS1_T_TR {1} \
   CONFIG.PCW_NOR_CS1_T_WC {11} \
   CONFIG.PCW_NOR_CS1_T_WP {1} \
   CONFIG.PCW_NOR_CS1_WE_TIME {0} \
   CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
   CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_SRAM_CS0_T_CEOE {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_PC {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_RC {11} \
   CONFIG.PCW_NOR_SRAM_CS0_T_TR {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_WC {11} \
   CONFIG.PCW_NOR_SRAM_CS0_T_WP {1} \
   CONFIG.PCW_NOR_SRAM_CS0_WE_TIME {0} \
   CONFIG.PCW_NOR_SRAM_CS1_T_CEOE {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_PC {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_RC {11} \
   CONFIG.PCW_NOR_SRAM_CS1_T_TR {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_WC {11} \
   CONFIG.PCW_NOR_SRAM_CS1_T_WP {1} \
   CONFIG.PCW_NOR_SRAM_CS1_WE_TIME {0} \
   CONFIG.PCW_OVERRIDE_BASIC_CLOCK {0} \
   CONFIG.PCW_P2F_CAN0_INTR {0} \
   CONFIG.PCW_P2F_CAN1_INTR {0} \
   CONFIG.PCW_P2F_CTI_INTR {0} \
   CONFIG.PCW_P2F_DMAC0_INTR {0} \
   CONFIG.PCW_P2F_DMAC1_INTR {0} \
   CONFIG.PCW_P2F_DMAC2_INTR {0} \
   CONFIG.PCW_P2F_DMAC3_INTR {0} \
   CONFIG.PCW_P2F_DMAC4_INTR {0} \
   CONFIG.PCW_P2F_DMAC5_INTR {0} \
   CONFIG.PCW_P2F_DMAC6_INTR {0} \
   CONFIG.PCW_P2F_DMAC7_INTR {0} \
   CONFIG.PCW_P2F_DMAC_ABORT_INTR {0} \
   CONFIG.PCW_P2F_ENET0_INTR {0} \
   CONFIG.PCW_P2F_ENET1_INTR {0} \
   CONFIG.PCW_P2F_GPIO_INTR {0} \
   CONFIG.PCW_P2F_I2C0_INTR {0} \
   CONFIG.PCW_P2F_I2C1_INTR {0} \
   CONFIG.PCW_P2F_QSPI_INTR {0} \
   CONFIG.PCW_P2F_SDIO0_INTR {0} \
   CONFIG.PCW_P2F_SDIO1_INTR {0} \
   CONFIG.PCW_P2F_SMC_INTR {0} \
   CONFIG.PCW_P2F_SPI0_INTR {0} \
   CONFIG.PCW_P2F_SPI1_INTR {0} \
   CONFIG.PCW_P2F_UART0_INTR {0} \
   CONFIG.PCW_P2F_UART1_INTR {0} \
   CONFIG.PCW_P2F_USB0_INTR {0} \
   CONFIG.PCW_P2F_USB1_INTR {0} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.063} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.062} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.065} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.083} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {-0.007} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {-0.010} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {-0.006} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {-0.048} \
   CONFIG.PCW_PACKAGE_NAME {clg484} \
   CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_PCAP_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_PERIPHERAL_BOARD_PRESET {part0} \
   CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PLL_BYPASSMODE_ENABLE {0} \
   CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
   CONFIG.PCW_PS7_SI_REV {PRODUCTION} \
   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_QSPI_INTERNAL_HIGHADDRESS {0xFCFFFFFF} \
   CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
   CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_CD_IO {MIO 47} \
   CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_WP_IO {MIO 46} \
   CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
   CONFIG.PCW_SD1_GRP_CD_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SDIO0_BASEADDR {0xE0100000} \
   CONFIG.PCW_SDIO0_HIGHADDR {0xE0100FFF} \
   CONFIG.PCW_SDIO1_BASEADDR {0xE0101000} \
   CONFIG.PCW_SDIO1_HIGHADDR {0xE0101FFF} \
   CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {20} \
   CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
   CONFIG.PCW_SMC_CYCLE_T0 {NA} \
   CONFIG.PCW_SMC_CYCLE_T1 {NA} \
   CONFIG.PCW_SMC_CYCLE_T2 {NA} \
   CONFIG.PCW_SMC_CYCLE_T3 {NA} \
   CONFIG.PCW_SMC_CYCLE_T4 {NA} \
   CONFIG.PCW_SMC_CYCLE_T5 {NA} \
   CONFIG.PCW_SMC_CYCLE_T6 {NA} \
   CONFIG.PCW_SMC_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SMC_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_SMC_PERIPHERAL_VALID {0} \
   CONFIG.PCW_SPI0_BASEADDR {0xE0006000} \
   CONFIG.PCW_SPI0_GRP_SS0_ENABLE {0} \
   CONFIG.PCW_SPI0_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_SPI0_GRP_SS2_ENABLE {0} \
   CONFIG.PCW_SPI0_HIGHADDR {0xE0006FFF} \
   CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SPI1_BASEADDR {0xE0007000} \
   CONFIG.PCW_SPI1_GRP_SS0_ENABLE {0} \
   CONFIG.PCW_SPI1_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_SPI1_GRP_SS2_ENABLE {0} \
   CONFIG.PCW_SPI1_HIGHADDR {0xE0007FFF} \
   CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SPI_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ {166.666666} \
   CONFIG.PCW_SPI_PERIPHERAL_VALID {0} \
   CONFIG.PCW_S_AXI_ACP_ARUSER_VAL {31} \
   CONFIG.PCW_S_AXI_ACP_AWUSER_VAL {31} \
   CONFIG.PCW_S_AXI_ACP_ID_WIDTH {3} \
   CONFIG.PCW_S_AXI_GP0_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_GP1_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP0_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP1_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP1_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP2_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP2_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP3_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP3_ID_WIDTH {6} \
   CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_TRACE_BUFFER_CLOCK_DELAY {12} \
   CONFIG.PCW_TRACE_BUFFER_FIFO_SIZE {128} \
   CONFIG.PCW_TRACE_GRP_16BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_2BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_32BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_4BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_8BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_INTERNAL_WIDTH {2} \
   CONFIG.PCW_TRACE_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TRACE_PIPELINE_WIDTH {8} \
   CONFIG.PCW_TTC0_BASEADDR {0xE0104000} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_HIGHADDR {0xE0104fff} \
   CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_TTC0_TTC0_IO {EMIO} \
   CONFIG.PCW_TTC1_BASEADDR {0xE0105000} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_HIGHADDR {0xE0105fff} \
   CONFIG.PCW_TTC1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_UART0_BASEADDR {0xE0000000} \
   CONFIG.PCW_UART0_BAUD_RATE {115200} \
   CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART0_HIGHADDR {0xE0000FFF} \
   CONFIG.PCW_UART0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_UART1_BASEADDR {0xE0001000} \
   CONFIG.PCW_UART1_BAUD_RATE {115200} \
   CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART1_HIGHADDR {0xE0001FFF} \
   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
   CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {20} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
   CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE {0} \
   CONFIG.PCW_UIPARAM_DDR_AL {0} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_BL {8} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.41} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.411} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.341} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.358} \
   CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH {61.0905} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH {61.0905} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH {61.0905} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH {61.0905} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN {0} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {6} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {2048 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH {68.4725} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH {71.086} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH {66.794} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH {108.7385} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.025} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.028} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.001} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.001} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH {64.1705} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH {63.686} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH {68.46} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH {105.4895} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
   CONFIG.PCW_UIPARAM_DDR_ECC {Disabled} \
   CONFIG.PCW_UIPARAM_DDR_ENABLE {1} \
   CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {533.333313} \
   CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP {Normal (0-85)} \
   CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J128M16 HA-15E} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {14} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {45.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {36.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {49.5} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
   CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {1} \
   CONFIG.PCW_UIPARAM_GENERATE_SUMMARY {NA} \
   CONFIG.PCW_USB0_BASEADDR {0xE0102000} \
   CONFIG.PCW_USB0_HIGHADDR {0xE0102fff} \
   CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB0_RESET_ENABLE {0} \
   CONFIG.PCW_USB0_RESET_IO {<Select>} \
   CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
   CONFIG.PCW_USB1_BASEADDR {0xE0103000} \
   CONFIG.PCW_USB1_HIGHADDR {0xE0103fff} \
   CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_USB1_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB1_RESET_ENABLE {0} \
   CONFIG.PCW_USB_RESET_ENABLE {1} \
   CONFIG.PCW_USB_RESET_POLARITY {Active Low} \
   CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_USE_AXI_FABRIC_IDLE {0} \
   CONFIG.PCW_USE_AXI_NONSECURE {0} \
   CONFIG.PCW_USE_CORESIGHT {0} \
   CONFIG.PCW_USE_CROSS_TRIGGER {0} \
   CONFIG.PCW_USE_CR_FABRIC {1} \
   CONFIG.PCW_USE_DDR_BYPASS {0} \
   CONFIG.PCW_USE_DEBUG {0} \
   CONFIG.PCW_USE_DEFAULT_ACP_USER_VAL {0} \
   CONFIG.PCW_USE_DMA0 {0} \
   CONFIG.PCW_USE_DMA1 {0} \
   CONFIG.PCW_USE_DMA2 {0} \
   CONFIG.PCW_USE_DMA3 {0} \
   CONFIG.PCW_USE_EXPANDED_IOP {0} \
   CONFIG.PCW_USE_EXPANDED_PS_SLCR_REGISTERS {0} \
   CONFIG.PCW_USE_FABRIC_INTERRUPT {0} \
   CONFIG.PCW_USE_HIGH_OCM {0} \
   CONFIG.PCW_USE_M_AXI_GP0 {1} \
   CONFIG.PCW_USE_M_AXI_GP1 {0} \
   CONFIG.PCW_USE_PROC_EVENT_BUS {0} \
   CONFIG.PCW_USE_PS_SLCR_REGISTERS {0} \
   CONFIG.PCW_USE_S_AXI_ACP {0} \
   CONFIG.PCW_USE_S_AXI_GP0 {1} \
   CONFIG.PCW_USE_S_AXI_GP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP0 {0} \
   CONFIG.PCW_USE_S_AXI_HP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP2 {0} \
   CONFIG.PCW_USE_S_AXI_HP3 {0} \
   CONFIG.PCW_USE_TRACE {0} \
   CONFIG.PCW_USE_TRACE_DATA_EDGE_DETECTOR {0} \
   CONFIG.PCW_VALUE_SILVERSION {3} \
   CONFIG.PCW_WDT_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_WDT_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_WDT_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_WDT_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.preset {ZedBoard} \
 ] $processing_system7_0

  # Create instance: ps7_0_axi_periph, and set properties
  set ps7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {2} \
   CONFIG.STRATEGY {1} \
 ] $ps7_0_axi_periph

  # Create instance: rst_ps7_0_100M, and set properties
  set rst_ps7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_100M ]

  # Create interface connections
  connect_bd_intf_net -intf_net CPU_0_M_AXI [get_bd_intf_pins CPU_0/M_AXI] [get_bd_intf_pins axi_mem_intercon/S00_AXI]
  connect_bd_intf_net -intf_net axi_cdma_0_M_AXI [get_bd_intf_pins axi_cdma_0/M_AXI] [get_bd_intf_pins axi_mem_intercon/S01_AXI]
  connect_bd_intf_net -intf_net axi_cdma_0_M_AXI_SG [get_bd_intf_pins axi_cdma_0/M_AXI_SG] [get_bd_intf_pins axi_mem_intercon/S02_AXI]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_GP0]
  connect_bd_intf_net -intf_net axi_mem_intercon_M01_AXI [get_bd_intf_pins axi_mem_intercon/M01_AXI] [get_bd_intf_pins ps7_0_axi_periph/S01_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins CPU_0/s_axi_d] [get_bd_intf_pins ps7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M01_AXI [get_bd_intf_pins CPU_0/s_axi_i] [get_bd_intf_pins ps7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M02_AXI [get_bd_intf_pins CPU_0/s_axi_btpu] [get_bd_intf_pins ps7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M03_AXI [get_bd_intf_pins axi_cdma_0/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M03_AXI]

  # Create port connections
  connect_bd_net -net CPU_0_leds [get_bd_ports leds_0] [get_bd_pins CPU_0/leds]
  connect_bd_net -net CPU_0_oled_dc [get_bd_ports oled_dc_0] [get_bd_pins CPU_0/oled_dc]
  connect_bd_net -net CPU_0_oled_res [get_bd_ports oled_res_0] [get_bd_pins CPU_0/oled_res]
  connect_bd_net -net CPU_0_oled_sclk [get_bd_ports oled_sclk_0] [get_bd_pins CPU_0/oled_sclk]
  connect_bd_net -net CPU_0_oled_sdin [get_bd_ports oled_sdin_0] [get_bd_pins CPU_0/oled_sdin]
  connect_bd_net -net CPU_0_oled_vbat [get_bd_ports oled_vbat_0] [get_bd_pins CPU_0/oled_vbat]
  connect_bd_net -net CPU_0_oled_vdd [get_bd_ports oled_vdd_0] [get_bd_pins CPU_0/oled_vdd]
  connect_bd_net -net CPU_0_run_out [get_bd_ports run_out_0] [get_bd_pins CPU_0/run_out]
  connect_bd_net -net Net [get_bd_ports GPIO_0] [get_bd_pins CPU_0/GPIO]
  connect_bd_net -net Net1 [get_bd_ports SDA_0] [get_bd_pins CPU_0/SDA]
  connect_bd_net -net Net2 [get_bd_ports SCL_0] [get_bd_pins CPU_0/SCL]
  connect_bd_net -net axi_cdma_0_cdma_introut [get_bd_pins CPU_0/cdma_interrupt] [get_bd_pins axi_cdma_0/cdma_introut]
  connect_bd_net -net btn_center_0_1 [get_bd_ports btn_center_0] [get_bd_pins CPU_0/btn_center]
  connect_bd_net -net btn_down_0_1 [get_bd_ports btn_down_0] [get_bd_pins CPU_0/btn_down]
  connect_bd_net -net btn_left_0_1 [get_bd_ports btn_left_0] [get_bd_pins CPU_0/btn_left]
  connect_bd_net -net btn_right_0_1 [get_bd_ports btn_right_0] [get_bd_pins CPU_0/btn_right]
  connect_bd_net -net btn_up_0_1 [get_bd_ports btn_up_0] [get_bd_pins CPU_0/btn_up]
  connect_bd_net -net oled_select0_0_1 [get_bd_ports oled_select0_0] [get_bd_pins CPU_0/oled_select0]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins CPU_0/clk] [get_bd_pins axi_cdma_0/m_axi_aclk] [get_bd_pins axi_cdma_0/s_axi_lite_aclk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/M01_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_mem_intercon/S01_ACLK] [get_bd_pins axi_mem_intercon/S02_ACLK] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_GP0_ACLK] [get_bd_pins ps7_0_axi_periph/ACLK] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/M02_ACLK] [get_bd_pins ps7_0_axi_periph/M03_ACLK] [get_bd_pins ps7_0_axi_periph/S00_ACLK] [get_bd_pins ps7_0_axi_periph/S01_ACLK] [get_bd_pins rst_ps7_0_100M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins CPU_0/clk_100MHz] [get_bd_pins processing_system7_0/FCLK_CLK1]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_ps7_0_100M/ext_reset_in]
  connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn [get_bd_pins CPU_0/res_in] [get_bd_pins axi_cdma_0/s_axi_lite_aresetn] [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/M01_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_mem_intercon/S01_ARESETN] [get_bd_pins axi_mem_intercon/S02_ARESETN] [get_bd_pins ps7_0_axi_periph/ARESETN] [get_bd_pins ps7_0_axi_periph/M00_ARESETN] [get_bd_pins ps7_0_axi_periph/M01_ARESETN] [get_bd_pins ps7_0_axi_periph/M02_ARESETN] [get_bd_pins ps7_0_axi_periph/M03_ARESETN] [get_bd_pins ps7_0_axi_periph/S00_ARESETN] [get_bd_pins ps7_0_axi_periph/S01_ARESETN] [get_bd_pins rst_ps7_0_100M/peripheral_aresetn]
  connect_bd_net -net run_in_0_1 [get_bd_ports run_in_0] [get_bd_pins CPU_0/run_in]
  connect_bd_net -net switches_0_1 [get_bd_ports switches_0] [get_bd_pins CPU_0/switches]

  # Create address segments
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs CPU_0/s_axi_i/reg0] -force
  assign_bd_address -offset 0x40030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0xE0000000 -range 0x00400000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_IOP] -force
  assign_bd_address -offset 0xFC000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_QSPI_LINEAR] -force
  assign_bd_address -offset 0x40080000 -range 0x00080000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs CPU_0/s_axi_btpu/reg0] -force
  assign_bd_address -offset 0x40080000 -range 0x00080000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs CPU_0/s_axi_btpu/reg0] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs CPU_0/s_axi_d/reg0] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs CPU_0/s_axi_d/reg0] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs CPU_0/s_axi_i/reg0] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs CPU_0/s_axi_i/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0xE0000000 -range 0x00400000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_IOP] -force
  assign_bd_address -offset 0xE0000000 -range 0x00400000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_IOP] -force
  assign_bd_address -offset 0xFC000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_QSPI_LINEAR] -force
  assign_bd_address -offset 0xFC000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_QSPI_LINEAR] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs CPU_0/s_axi_d/reg0] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs CPU_0/s_axi_i/reg0] -force
  assign_bd_address -offset 0x40080000 -range 0x00080000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs CPU_0/s_axi_btpu/reg0] -force
  assign_bd_address -offset 0x40030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs CPU_0/s_axi_d/reg0]
  exclude_bd_addr_seg -offset 0x43C00000 -range 0x00100000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs CPU_0/s_axi_btpu/reg0]
  exclude_bd_addr_seg -offset 0x40000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP0]
  exclude_bd_addr_seg -offset 0x40030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg]
  exclude_bd_addr_seg -offset 0x40000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP0]
  exclude_bd_addr_seg -offset 0x40030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg]
  exclude_bd_addr_seg -offset 0x40000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP0]

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   "ActiveEmotionalView":"Default View",
   "Default View_ScaleFactor":"0.558972",
   "Default View_TopLeft":"-150,-79",
   "ExpandedHierarchyInLayout":"",
   "guistr":"# # String gsaved with Nlview 7.0r4  2019-12-20 bk=1.5203 VDI=41 GEI=36 GUI=JA:10.0 TLS
#  -string -flagsOSRD
preplace port DDR -pg 1 -lvl 6 -x 1950 -y 130 -defaultsOSRD
preplace port FIXED_IO -pg 1 -lvl 6 -x 1950 -y 160 -defaultsOSRD
preplace port port-id_SCL_0 -pg 1 -lvl 6 -x 1950 -y 570 -defaultsOSRD
preplace port port-id_SDA_0 -pg 1 -lvl 6 -x 1950 -y 540 -defaultsOSRD
preplace port port-id_btn_center_0 -pg 1 -lvl 0 -x 0 -y 740 -defaultsOSRD
preplace port port-id_btn_down_0 -pg 1 -lvl 0 -x 0 -y 650 -defaultsOSRD
preplace port port-id_btn_left_0 -pg 1 -lvl 0 -x 0 -y 680 -defaultsOSRD
preplace port port-id_btn_right_0 -pg 1 -lvl 0 -x 0 -y 710 -defaultsOSRD
preplace port port-id_btn_up_0 -pg 1 -lvl 0 -x 0 -y 620 -defaultsOSRD
preplace port port-id_oled_dc_0 -pg 1 -lvl 6 -x 1950 -y 720 -defaultsOSRD
preplace port port-id_oled_res_0 -pg 1 -lvl 6 -x 1950 -y 750 -defaultsOSRD
preplace port port-id_oled_sclk_0 -pg 1 -lvl 6 -x 1950 -y 690 -defaultsOSRD
preplace port port-id_oled_sdin_0 -pg 1 -lvl 6 -x 1950 -y 660 -defaultsOSRD
preplace port port-id_oled_select0_0 -pg 1 -lvl 0 -x 0 -y 800 -defaultsOSRD
preplace port port-id_oled_vbat_0 -pg 1 -lvl 6 -x 1950 -y 780 -defaultsOSRD
preplace port port-id_oled_vdd_0 -pg 1 -lvl 6 -x 1950 -y 810 -defaultsOSRD
preplace port port-id_run_in_0 -pg 1 -lvl 0 -x 0 -y 590 -defaultsOSRD
preplace port port-id_run_out_0 -pg 1 -lvl 6 -x 1950 -y 600 -defaultsOSRD
preplace portBus GPIO_0 -pg 1 -lvl 6 -x 1950 -y 510 -defaultsOSRD
preplace portBus leds_0 -pg 1 -lvl 6 -x 1950 -y 630 -defaultsOSRD
preplace portBus switches_0 -pg 1 -lvl 0 -x 0 -y 770 -defaultsOSRD
preplace inst CPU_0 -pg 1 -lvl 5 -x 1660 -y 650 -defaultsOSRD
preplace inst axi_cdma_0 -pg 1 -lvl 3 -x 910 -y 400 -defaultsOSRD
preplace inst axi_mem_intercon -pg 1 -lvl 4 -x 1280 -y 220 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 5 -x 1660 -y 230 -defaultsOSRD
preplace inst ps7_0_axi_periph -pg 1 -lvl 2 -x 570 -y 270 -defaultsOSRD
preplace inst rst_ps7_0_100M -pg 1 -lvl 1 -x 210 -y 120 -defaultsOSRD
preplace netloc CPU_0_leds 1 5 1 1890J 630n
preplace netloc CPU_0_oled_dc 1 5 1 1920J 700n
preplace netloc CPU_0_oled_res 1 5 1 1890J 720n
preplace netloc CPU_0_oled_sclk 1 5 1 1900J 680n
preplace netloc CPU_0_oled_sdin 1 5 1 NJ 660
preplace netloc CPU_0_oled_vbat 1 5 1 1870J 740n
preplace netloc CPU_0_oled_vdd 1 5 1 1860J 760n
preplace netloc CPU_0_run_out 1 5 1 1930J 600n
preplace netloc Net 1 5 1 1900J 510n
preplace netloc Net1 1 5 1 1910J 540n
preplace netloc Net2 1 5 1 1920J 570n
preplace netloc axi_cdma_0_cdma_introut 1 3 2 1050 790 NJ
preplace netloc btn_center_0_1 1 0 5 20J 730 NJ 730 NJ 730 NJ 730 NJ
preplace netloc btn_down_0_1 1 0 5 NJ 650 NJ 650 NJ 650 NJ 650 1430J
preplace netloc btn_left_0_1 1 0 5 NJ 680 NJ 680 NJ 680 NJ 680 1450J
preplace netloc btn_right_0_1 1 0 5 NJ 710 NJ 710 NJ 710 NJ 710 NJ
preplace netloc btn_up_0_1 1 0 5 NJ 620 NJ 620 NJ 620 NJ 620 1440J
preplace netloc oled_select0_0_1 1 0 5 30J 770 NJ 770 NJ 770 NJ 770 NJ
preplace netloc processing_system7_0_FCLK_CLK0 1 0 6 20 20 400 40 760 140 1130 430 1450 380 1880
preplace netloc processing_system7_0_FCLK_CLK1 1 4 2 1460 390 1870
preplace netloc processing_system7_0_FCLK_RESET0_N 1 0 6 20 490 NJ 490 NJ 490 1130J 450 NJ 450 1860
preplace netloc rst_ps7_0_100M_peripheral_aresetn 1 1 4 390 50 740 160 1100 610 NJ
preplace netloc run_in_0_1 1 0 5 NJ 590 NJ 590 NJ 590 NJ 590 1450J
preplace netloc switches_0_1 1 0 5 20J 750 NJ 750 NJ 750 NJ 750 NJ
preplace netloc CPU_0_M_AXI 1 3 3 1130 20 NJ 20 1890
preplace netloc axi_cdma_0_M_AXI 1 3 1 1070 100n
preplace netloc axi_cdma_0_M_AXI_SG 1 3 1 1110 120n
preplace netloc axi_mem_intercon_M00_AXI 1 4 1 N 210
preplace netloc axi_mem_intercon_M01_AXI 1 1 4 420 60 NJ 60 1120J 420 1440
preplace netloc processing_system7_0_DDR 1 5 1 1900J 130n
preplace netloc processing_system7_0_FIXED_IO 1 5 1 NJ 160
preplace netloc processing_system7_0_M_AXI_GP0 1 1 5 410 10 NJ 10 NJ 10 NJ 10 1860
preplace netloc ps7_0_axi_periph_M00_AXI 1 2 3 770 290 1090J 530 NJ
preplace netloc ps7_0_axi_periph_M01_AXI 1 2 3 750 300 1060J 550 NJ
preplace netloc ps7_0_axi_periph_M02_AXI 1 2 3 730 310 1080J 510 NJ
preplace netloc ps7_0_axi_periph_M03_AXI 1 2 1 720 300n
levelinfo -pg 1 0 210 570 910 1280 1660 1950
pagesize -pg 1 -db -bbox -sgen -160 0 2090 850
"
}

  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
  close_bd_design $design_name 
}
# End of cr_bd_top_level()
cr_bd_top_level ""
set_property GENERATE_SYNTH_CHECKPOINT "0" [get_files top_level.bd ] 
set_property REGISTERED_WITH_MANAGER "1" [get_files top_level.bd ] 
set_property USED_IN "synthesis implementation" [get_files top_level.bd ] 
set_property USED_IN_SIMULATION "0" [get_files top_level.bd ] 

if { [get_files BTPU_memory.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/BTPU_memory/BTPU_memory.xci
}
if { [get_files axi_btpu_ctrl.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/axi_btpu_ctrl/axi_btpu_ctrl.xci
}
if { [get_files data_memory.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/data_memory/data_memory.xci
}
if { [get_files axi_bram_ctrl_0.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/axi_bram_ctrl_0/axi_bram_ctrl_0.xci
}
if { [get_files instruction_mem.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/instruction_mem/instruction_mem.xci
}
if { [get_files AXI_memory_controller.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/axi/AXI_memory_controller.vhd
}
if { [get_files utilities_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/utilities_pkg.vhd
}
if { [get_files BNN_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/BNN_pkg.vhd
}
if { [get_files types_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/types_pkg.vhd
}
if { [get_files constant_package.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/constant_package.vhd
}
if { [get_files memory_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/memory_pkg.vhd
}
if { [get_files compressor_layer.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/compressor_layer.vhd
}
if { [get_files popcounter_tree.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/popcounter_tree.vhd
}
if { [get_files ternary_adder.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/ternary_adder.vhd
}
if { [get_files popcounter.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/popcounter.vhd
}
if { [get_files binary_mac.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/binary_mac.vhd
}
if { [get_files BTPU_MAC.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/BTPU_MAC.vhd
}
if { [get_files BTPU.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/BTPU.vhd
}
if { [get_files instruction_fetch.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/IF/instruction_fetch.vhd
}
if { [get_files triple_port_ram.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/ID/triple_port_ram.vhd
}
if { [get_files sign_extender_ro.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/ID/sign_extender_ro.vhd
}
if { [get_files istruction_decode.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/ID/istruction_decode.vhd
}
if { [get_files barrel_shifter.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/IE/barrel_shifter.vhd
}
if { [get_files alu.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/IE/alu.vhd
}
if { [get_files comparator.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/IE/comparator.vhd
}
if { [get_files execute.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/IE/execute.vhd
}
if { [get_files address_manager.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/MEM_WB/address_manager.vhd
}
if { [get_files memory_write_back.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/MEM_WB/memory_write_back.vhd
}
if { [get_files GPIO.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/GPIO.vhd
}
if { [get_files i2c_utils_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/i2c_utils_pkg.vhd
}
if { [get_files I2C_driver.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/I2C_driver.vhd
}
if { [get_files I2C_module.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/I2C_module.vhd
}
if { [get_files oled_driver.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/oled_driver/oled_driver.vhd
}
if { [get_files timer.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/timer.vhd
}
if { [get_files ascii_rom.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/oled_driver/ascii_rom.vhd
}
if { [get_files compressor_6_3.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/compressor_6_3.vhd
}
if { [get_files delay_module.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/oled_driver/delay_module.vhd
}
if { [get_files oled_counter.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/oled_driver/oled_counter.vhd
}
if { [get_files spi_controller.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/oled_driver/spi_controller.vhd
}
if { [get_files CPU.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/CPU.vhd
}


# Proc to create BD top_level_dbg
proc cr_bd_top_level_dbg { parentCell } {
# The design that will be created by this Tcl proc contains the following 
# module references:
# CPU



  # CHANGE DESIGN NAME HERE
  set design_name top_level_dbg

  common::send_gid_msg -ssname BD::TCL -id 2010 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

  create_bd_design $design_name

  set bCheckIPsPassed 1
  ##################################################################
  # CHECK IPs
  ##################################################################
  set bCheckIPs 1
  if { $bCheckIPs == 1 } {
     set list_check_ips "\ 
  xilinx.com:ip:axi_cdma:4.1\
  xilinx.com:ip:processing_system7:5.5\
  xilinx.com:ip:proc_sys_reset:5.0\
  xilinx.com:ip:system_ila:1.1\
  "

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

  }

  ##################################################################
  # CHECK Modules
  ##################################################################
  set bCheckModules 1
  if { $bCheckModules == 1 } {
     set list_check_mods "\ 
  CPU\
  "

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

  if { $bCheckIPsPassed != 1 } {
    common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
    return 3
  }

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]

  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]


  # Create ports
  set GPIO_0 [ create_bd_port -dir IO -from 15 -to 0 GPIO_0 ]
  set SCL_0 [ create_bd_port -dir IO SCL_0 ]
  set SDA_0 [ create_bd_port -dir IO SDA_0 ]
  set btn_center_0 [ create_bd_port -dir I btn_center_0 ]
  set btn_down_0 [ create_bd_port -dir I btn_down_0 ]
  set btn_left_0 [ create_bd_port -dir I btn_left_0 ]
  set btn_right_0 [ create_bd_port -dir I btn_right_0 ]
  set btn_up_0 [ create_bd_port -dir I btn_up_0 ]
  set leds_0 [ create_bd_port -dir O -from 2 -to 0 leds_0 ]
  set oled_dc_0 [ create_bd_port -dir O oled_dc_0 ]
  set oled_res_0 [ create_bd_port -dir O oled_res_0 ]
  set oled_sclk_0 [ create_bd_port -dir O oled_sclk_0 ]
  set oled_sdin_0 [ create_bd_port -dir O oled_sdin_0 ]
  set oled_select0_0 [ create_bd_port -dir I oled_select0_0 ]
  set oled_vbat_0 [ create_bd_port -dir O oled_vbat_0 ]
  set oled_vdd_0 [ create_bd_port -dir O oled_vdd_0 ]
  set run_in_0 [ create_bd_port -dir I run_in_0 ]
  set run_out_0 [ create_bd_port -dir O run_out_0 ]
  set switches_0 [ create_bd_port -dir I -from 1 -to 0 switches_0 ]

  # Create instance: CPU_0, and set properties
  set block_name CPU
  set block_cell_name CPU_0
  if { [catch {set CPU_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $CPU_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.IS_STANDALONE {true} \
 ] $CPU_0

  # Create instance: axi_cdma_0, and set properties
  set axi_cdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_cdma:4.1 axi_cdma_0 ]
  set_property -dict [ list \
   CONFIG.C_INCLUDE_DRE {0} \
   CONFIG.C_INCLUDE_SF {0} \
   CONFIG.C_INCLUDE_SG {1} \
   CONFIG.C_USE_DATAMOVER_LITE {0} \
 ] $axi_cdma_0

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {3} \
   CONFIG.STRATEGY {1} \
 ] $axi_mem_intercon

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
   CONFIG.PCW_ACT_CAN0_PERIPHERAL_FREQMHZ {23.8095} \
   CONFIG.PCW_ACT_CAN1_PERIPHERAL_FREQMHZ {23.8095} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {40.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {40.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_I2C_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {50.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {50.000000} \
   CONFIG.PCW_ACT_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_ACT_USB1_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
   CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {666.666667} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {40} \
   CONFIG.PCW_CAN0_BASEADDR {0xE0008000} \
   CONFIG.PCW_CAN0_GRP_CLK_ENABLE {0} \
   CONFIG.PCW_CAN0_HIGHADDR {0xE0008FFF} \
   CONFIG.PCW_CAN0_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_CAN0_PERIPHERAL_FREQMHZ {-1} \
   CONFIG.PCW_CAN1_BASEADDR {0xE0009000} \
   CONFIG.PCW_CAN1_GRP_CLK_ENABLE {0} \
   CONFIG.PCW_CAN1_HIGHADDR {0xE0009FFF} \
   CONFIG.PCW_CAN1_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_CAN1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_CAN1_PERIPHERAL_FREQMHZ {-1} \
   CONFIG.PCW_CAN_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_CAN_PERIPHERAL_VALID {0} \
   CONFIG.PCW_CLK0_FREQ {40000000} \
   CONFIG.PCW_CLK1_FREQ {40000000} \
   CONFIG.PCW_CLK2_FREQ {10000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CORE0_FIQ_INTR {0} \
   CONFIG.PCW_CORE0_IRQ_INTR {0} \
   CONFIG.PCW_CORE1_FIQ_INTR {0} \
   CONFIG.PCW_CORE1_IRQ_INTR {0} \
   CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {667} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1333.333} \
   CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
   CONFIG.PCW_DCI_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DCI_PERIPHERAL_FREQMHZ {10.159} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_HPRLPR_QUEUE_PARTITION {HPR(0)/LPR(32)} \
   CONFIG.PCW_DDR_HPR_TO_CRITICAL_PRIORITY_LEVEL {15} \
   CONFIG.PCW_DDR_LPR_TO_CRITICAL_PRIORITY_LEVEL {2} \
   CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_PORT0_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT1_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT2_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT3_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_RAM_BASEADDR {0x00100000} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x1FFFFFFF} \
   CONFIG.PCW_DDR_WRITE_TO_CRITICAL_PRIORITY_LEVEL {2} \
   CONFIG.PCW_DM_WIDTH {4} \
   CONFIG.PCW_DQS_WIDTH {4} \
   CONFIG.PCW_DQ_WIDTH {32} \
   CONFIG.PCW_ENET0_BASEADDR {0xE000B000} \
   CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
   CONFIG.PCW_ENET0_HIGHADDR {0xE000BFFF} \
   CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {0} \
   CONFIG.PCW_ENET1_BASEADDR {0xE000C000} \
   CONFIG.PCW_ENET1_GRP_MDIO_ENABLE {0} \
   CONFIG.PCW_ENET1_HIGHADDR {0xE000CFFF} \
   CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_ENET1_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_ENABLE {1} \
   CONFIG.PCW_ENET_RESET_POLARITY {Active Low} \
   CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_EN_4K_TIMER {0} \
   CONFIG.PCW_EN_CAN0 {0} \
   CONFIG.PCW_EN_CAN1 {0} \
   CONFIG.PCW_EN_CLK0_PORT {1} \
   CONFIG.PCW_EN_CLK1_PORT {1} \
   CONFIG.PCW_EN_CLK2_PORT {0} \
   CONFIG.PCW_EN_CLK3_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG0_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG1_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG2_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG3_PORT {0} \
   CONFIG.PCW_EN_DDR {1} \
   CONFIG.PCW_EN_EMIO_CAN0 {0} \
   CONFIG.PCW_EN_EMIO_CAN1 {0} \
   CONFIG.PCW_EN_EMIO_CD_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_CD_SDIO1 {0} \
   CONFIG.PCW_EN_EMIO_ENET0 {0} \
   CONFIG.PCW_EN_EMIO_ENET1 {0} \
   CONFIG.PCW_EN_EMIO_GPIO {0} \
   CONFIG.PCW_EN_EMIO_I2C0 {0} \
   CONFIG.PCW_EN_EMIO_I2C1 {0} \
   CONFIG.PCW_EN_EMIO_MODEM_UART0 {0} \
   CONFIG.PCW_EN_EMIO_MODEM_UART1 {0} \
   CONFIG.PCW_EN_EMIO_PJTAG {0} \
   CONFIG.PCW_EN_EMIO_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_SDIO1 {0} \
   CONFIG.PCW_EN_EMIO_SPI0 {0} \
   CONFIG.PCW_EN_EMIO_SPI1 {0} \
   CONFIG.PCW_EN_EMIO_SRAM_INT {0} \
   CONFIG.PCW_EN_EMIO_TRACE {0} \
   CONFIG.PCW_EN_EMIO_TTC0 {1} \
   CONFIG.PCW_EN_EMIO_TTC1 {0} \
   CONFIG.PCW_EN_EMIO_UART0 {0} \
   CONFIG.PCW_EN_EMIO_UART1 {0} \
   CONFIG.PCW_EN_EMIO_WDT {0} \
   CONFIG.PCW_EN_EMIO_WP_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_WP_SDIO1 {0} \
   CONFIG.PCW_EN_ENET0 {1} \
   CONFIG.PCW_EN_ENET1 {0} \
   CONFIG.PCW_EN_GPIO {1} \
   CONFIG.PCW_EN_I2C0 {0} \
   CONFIG.PCW_EN_I2C1 {0} \
   CONFIG.PCW_EN_MODEM_UART0 {0} \
   CONFIG.PCW_EN_MODEM_UART1 {0} \
   CONFIG.PCW_EN_PJTAG {0} \
   CONFIG.PCW_EN_PTP_ENET0 {0} \
   CONFIG.PCW_EN_PTP_ENET1 {0} \
   CONFIG.PCW_EN_QSPI {1} \
   CONFIG.PCW_EN_RST0_PORT {1} \
   CONFIG.PCW_EN_RST1_PORT {0} \
   CONFIG.PCW_EN_RST2_PORT {0} \
   CONFIG.PCW_EN_RST3_PORT {0} \
   CONFIG.PCW_EN_SDIO0 {1} \
   CONFIG.PCW_EN_SDIO1 {0} \
   CONFIG.PCW_EN_SMC {0} \
   CONFIG.PCW_EN_SPI0 {0} \
   CONFIG.PCW_EN_SPI1 {0} \
   CONFIG.PCW_EN_TRACE {0} \
   CONFIG.PCW_EN_TTC0 {1} \
   CONFIG.PCW_EN_TTC1 {0} \
   CONFIG.PCW_EN_UART0 {0} \
   CONFIG.PCW_EN_UART1 {1} \
   CONFIG.PCW_EN_USB0 {1} \
   CONFIG.PCW_EN_USB1 {0} \
   CONFIG.PCW_EN_WDT {0} \
   CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {5} \
   CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {5} \
   CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK0_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK1_BUF {FALSE} \
   CONFIG.PCW_FCLK_CLK2_BUF {FALSE} \
   CONFIG.PCW_FCLK_CLK3_BUF {FALSE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {40.000000} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {40.000000} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_GP0_EN_MODIFIABLE_TXN {1} \
   CONFIG.PCW_GP0_NUM_READ_THREADS {4} \
   CONFIG.PCW_GP0_NUM_WRITE_THREADS {4} \
   CONFIG.PCW_GP1_EN_MODIFIABLE_TXN {1} \
   CONFIG.PCW_GP1_NUM_READ_THREADS {4} \
   CONFIG.PCW_GP1_NUM_WRITE_THREADS {4} \
   CONFIG.PCW_GPIO_BASEADDR {0xE000A000} \
   CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
   CONFIG.PCW_GPIO_EMIO_GPIO_WIDTH {64} \
   CONFIG.PCW_GPIO_HIGHADDR {0xE000AFFF} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
   CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C0_BASEADDR {0xE0004000} \
   CONFIG.PCW_I2C0_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C0_HIGHADDR {0xE0004FFF} \
   CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_BASEADDR {0xE0005000} \
   CONFIG.PCW_I2C1_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C1_HIGHADDR {0xE0005FFF} \
   CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {25} \
   CONFIG.PCW_I2C_RESET_ENABLE {1} \
   CONFIG.PCW_I2C_RESET_POLARITY {Active Low} \
   CONFIG.PCW_IMPORT_BOARD_PRESET {None} \
   CONFIG.PCW_INCLUDE_ACP_TRANS_CHECK {0} \
   CONFIG.PCW_INCLUDE_TRACE_BUFFER {0} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {30} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
   CONFIG.PCW_IRQ_F2P_INTR {0} \
   CONFIG.PCW_IRQ_F2P_MODE {DIRECT} \
   CONFIG.PCW_MIO_0_DIRECTION {inout} \
   CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_0_PULLUP {disabled} \
   CONFIG.PCW_MIO_0_SLEW {slow} \
   CONFIG.PCW_MIO_10_DIRECTION {inout} \
   CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_10_PULLUP {disabled} \
   CONFIG.PCW_MIO_10_SLEW {slow} \
   CONFIG.PCW_MIO_11_DIRECTION {inout} \
   CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_11_PULLUP {disabled} \
   CONFIG.PCW_MIO_11_SLEW {slow} \
   CONFIG.PCW_MIO_12_DIRECTION {inout} \
   CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_12_PULLUP {disabled} \
   CONFIG.PCW_MIO_12_SLEW {slow} \
   CONFIG.PCW_MIO_13_DIRECTION {inout} \
   CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_13_PULLUP {disabled} \
   CONFIG.PCW_MIO_13_SLEW {slow} \
   CONFIG.PCW_MIO_14_DIRECTION {inout} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_14_PULLUP {disabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {inout} \
   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_15_PULLUP {disabled} \
   CONFIG.PCW_MIO_15_SLEW {slow} \
   CONFIG.PCW_MIO_16_DIRECTION {out} \
   CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_16_PULLUP {disabled} \
   CONFIG.PCW_MIO_16_SLEW {fast} \
   CONFIG.PCW_MIO_17_DIRECTION {out} \
   CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_17_PULLUP {disabled} \
   CONFIG.PCW_MIO_17_SLEW {fast} \
   CONFIG.PCW_MIO_18_DIRECTION {out} \
   CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_18_PULLUP {disabled} \
   CONFIG.PCW_MIO_18_SLEW {fast} \
   CONFIG.PCW_MIO_19_DIRECTION {out} \
   CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_19_PULLUP {disabled} \
   CONFIG.PCW_MIO_19_SLEW {fast} \
   CONFIG.PCW_MIO_1_DIRECTION {out} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_1_PULLUP {disabled} \
   CONFIG.PCW_MIO_1_SLEW {fast} \
   CONFIG.PCW_MIO_20_DIRECTION {out} \
   CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_20_PULLUP {disabled} \
   CONFIG.PCW_MIO_20_SLEW {fast} \
   CONFIG.PCW_MIO_21_DIRECTION {out} \
   CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_21_PULLUP {disabled} \
   CONFIG.PCW_MIO_21_SLEW {fast} \
   CONFIG.PCW_MIO_22_DIRECTION {in} \
   CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_22_PULLUP {disabled} \
   CONFIG.PCW_MIO_22_SLEW {fast} \
   CONFIG.PCW_MIO_23_DIRECTION {in} \
   CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_23_PULLUP {disabled} \
   CONFIG.PCW_MIO_23_SLEW {fast} \
   CONFIG.PCW_MIO_24_DIRECTION {in} \
   CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_24_PULLUP {disabled} \
   CONFIG.PCW_MIO_24_SLEW {fast} \
   CONFIG.PCW_MIO_25_DIRECTION {in} \
   CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_25_PULLUP {disabled} \
   CONFIG.PCW_MIO_25_SLEW {fast} \
   CONFIG.PCW_MIO_26_DIRECTION {in} \
   CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_26_PULLUP {disabled} \
   CONFIG.PCW_MIO_26_SLEW {fast} \
   CONFIG.PCW_MIO_27_DIRECTION {in} \
   CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_27_PULLUP {disabled} \
   CONFIG.PCW_MIO_27_SLEW {fast} \
   CONFIG.PCW_MIO_28_DIRECTION {inout} \
   CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_28_PULLUP {disabled} \
   CONFIG.PCW_MIO_28_SLEW {fast} \
   CONFIG.PCW_MIO_29_DIRECTION {in} \
   CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_29_PULLUP {disabled} \
   CONFIG.PCW_MIO_29_SLEW {fast} \
   CONFIG.PCW_MIO_2_DIRECTION {inout} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {fast} \
   CONFIG.PCW_MIO_30_DIRECTION {out} \
   CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_30_PULLUP {disabled} \
   CONFIG.PCW_MIO_30_SLEW {fast} \
   CONFIG.PCW_MIO_31_DIRECTION {in} \
   CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_31_PULLUP {disabled} \
   CONFIG.PCW_MIO_31_SLEW {fast} \
   CONFIG.PCW_MIO_32_DIRECTION {inout} \
   CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_32_PULLUP {disabled} \
   CONFIG.PCW_MIO_32_SLEW {fast} \
   CONFIG.PCW_MIO_33_DIRECTION {inout} \
   CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_33_PULLUP {disabled} \
   CONFIG.PCW_MIO_33_SLEW {fast} \
   CONFIG.PCW_MIO_34_DIRECTION {inout} \
   CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_34_PULLUP {disabled} \
   CONFIG.PCW_MIO_34_SLEW {fast} \
   CONFIG.PCW_MIO_35_DIRECTION {inout} \
   CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_35_PULLUP {disabled} \
   CONFIG.PCW_MIO_35_SLEW {fast} \
   CONFIG.PCW_MIO_36_DIRECTION {in} \
   CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_36_PULLUP {disabled} \
   CONFIG.PCW_MIO_36_SLEW {fast} \
   CONFIG.PCW_MIO_37_DIRECTION {inout} \
   CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_37_PULLUP {disabled} \
   CONFIG.PCW_MIO_37_SLEW {fast} \
   CONFIG.PCW_MIO_38_DIRECTION {inout} \
   CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_38_PULLUP {disabled} \
   CONFIG.PCW_MIO_38_SLEW {fast} \
   CONFIG.PCW_MIO_39_DIRECTION {inout} \
   CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_39_PULLUP {disabled} \
   CONFIG.PCW_MIO_39_SLEW {fast} \
   CONFIG.PCW_MIO_3_DIRECTION {inout} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {fast} \
   CONFIG.PCW_MIO_40_DIRECTION {inout} \
   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_40_PULLUP {disabled} \
   CONFIG.PCW_MIO_40_SLEW {fast} \
   CONFIG.PCW_MIO_41_DIRECTION {inout} \
   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_41_PULLUP {disabled} \
   CONFIG.PCW_MIO_41_SLEW {fast} \
   CONFIG.PCW_MIO_42_DIRECTION {inout} \
   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_42_PULLUP {disabled} \
   CONFIG.PCW_MIO_42_SLEW {fast} \
   CONFIG.PCW_MIO_43_DIRECTION {inout} \
   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_43_PULLUP {disabled} \
   CONFIG.PCW_MIO_43_SLEW {fast} \
   CONFIG.PCW_MIO_44_DIRECTION {inout} \
   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_44_PULLUP {disabled} \
   CONFIG.PCW_MIO_44_SLEW {fast} \
   CONFIG.PCW_MIO_45_DIRECTION {inout} \
   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_45_PULLUP {disabled} \
   CONFIG.PCW_MIO_45_SLEW {fast} \
   CONFIG.PCW_MIO_46_DIRECTION {in} \
   CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_46_PULLUP {disabled} \
   CONFIG.PCW_MIO_46_SLEW {slow} \
   CONFIG.PCW_MIO_47_DIRECTION {in} \
   CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_47_PULLUP {disabled} \
   CONFIG.PCW_MIO_47_SLEW {slow} \
   CONFIG.PCW_MIO_48_DIRECTION {out} \
   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_48_PULLUP {disabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {in} \
   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_49_PULLUP {disabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {fast} \
   CONFIG.PCW_MIO_50_DIRECTION {inout} \
   CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_50_PULLUP {disabled} \
   CONFIG.PCW_MIO_50_SLEW {slow} \
   CONFIG.PCW_MIO_51_DIRECTION {inout} \
   CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_51_PULLUP {disabled} \
   CONFIG.PCW_MIO_51_SLEW {slow} \
   CONFIG.PCW_MIO_52_DIRECTION {out} \
   CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_52_PULLUP {disabled} \
   CONFIG.PCW_MIO_52_SLEW {slow} \
   CONFIG.PCW_MIO_53_DIRECTION {inout} \
   CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_53_PULLUP {disabled} \
   CONFIG.PCW_MIO_53_SLEW {slow} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {fast} \
   CONFIG.PCW_MIO_6_DIRECTION {out} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {fast} \
   CONFIG.PCW_MIO_7_DIRECTION {out} \
   CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_7_PULLUP {disabled} \
   CONFIG.PCW_MIO_7_SLEW {slow} \
   CONFIG.PCW_MIO_8_DIRECTION {out} \
   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_8_PULLUP {disabled} \
   CONFIG.PCW_MIO_8_SLEW {fast} \
   CONFIG.PCW_MIO_9_DIRECTION {inout} \
   CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_9_PULLUP {disabled} \
   CONFIG.PCW_MIO_9_SLEW {slow} \
   CONFIG.PCW_MIO_PRIMITIVE {54} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {\
GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI\
Flash#Quad SPI Flash#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#Enet 0#Enet\
0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB\
0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD\
0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#UART 1#UART 1#GPIO#GPIO#Enet 0#Enet 0} \
   CONFIG.PCW_MIO_TREE_SIGNALS {\
gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#gpio[7]#gpio[8]#gpio[9]#gpio[10]#gpio[11]#gpio[12]#gpio[13]#gpio[14]#gpio[15]#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#wp#cd#tx#rx#gpio[50]#gpio[51]#mdc#mdio} \
   CONFIG.PCW_M_AXI_GP0_ENABLE_STATIC_REMAP {0} \
   CONFIG.PCW_M_AXI_GP0_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP0_SUPPORT_NARROW_BURST {0} \
   CONFIG.PCW_M_AXI_GP0_THREAD_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP1_ENABLE_STATIC_REMAP {0} \
   CONFIG.PCW_M_AXI_GP1_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP1_SUPPORT_NARROW_BURST {0} \
   CONFIG.PCW_M_AXI_GP1_THREAD_ID_WIDTH {12} \
   CONFIG.PCW_NAND_CYCLES_T_AR {1} \
   CONFIG.PCW_NAND_CYCLES_T_CLR {1} \
   CONFIG.PCW_NAND_CYCLES_T_RC {11} \
   CONFIG.PCW_NAND_CYCLES_T_REA {1} \
   CONFIG.PCW_NAND_CYCLES_T_RR {1} \
   CONFIG.PCW_NAND_CYCLES_T_WC {11} \
   CONFIG.PCW_NAND_CYCLES_T_WP {1} \
   CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
   CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_CS0_T_CEOE {1} \
   CONFIG.PCW_NOR_CS0_T_PC {1} \
   CONFIG.PCW_NOR_CS0_T_RC {11} \
   CONFIG.PCW_NOR_CS0_T_TR {1} \
   CONFIG.PCW_NOR_CS0_T_WC {11} \
   CONFIG.PCW_NOR_CS0_T_WP {1} \
   CONFIG.PCW_NOR_CS0_WE_TIME {0} \
   CONFIG.PCW_NOR_CS1_T_CEOE {1} \
   CONFIG.PCW_NOR_CS1_T_PC {1} \
   CONFIG.PCW_NOR_CS1_T_RC {11} \
   CONFIG.PCW_NOR_CS1_T_TR {1} \
   CONFIG.PCW_NOR_CS1_T_WC {11} \
   CONFIG.PCW_NOR_CS1_T_WP {1} \
   CONFIG.PCW_NOR_CS1_WE_TIME {0} \
   CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
   CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_SRAM_CS0_T_CEOE {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_PC {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_RC {11} \
   CONFIG.PCW_NOR_SRAM_CS0_T_TR {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_WC {11} \
   CONFIG.PCW_NOR_SRAM_CS0_T_WP {1} \
   CONFIG.PCW_NOR_SRAM_CS0_WE_TIME {0} \
   CONFIG.PCW_NOR_SRAM_CS1_T_CEOE {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_PC {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_RC {11} \
   CONFIG.PCW_NOR_SRAM_CS1_T_TR {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_WC {11} \
   CONFIG.PCW_NOR_SRAM_CS1_T_WP {1} \
   CONFIG.PCW_NOR_SRAM_CS1_WE_TIME {0} \
   CONFIG.PCW_OVERRIDE_BASIC_CLOCK {0} \
   CONFIG.PCW_P2F_CAN0_INTR {0} \
   CONFIG.PCW_P2F_CAN1_INTR {0} \
   CONFIG.PCW_P2F_CTI_INTR {0} \
   CONFIG.PCW_P2F_DMAC0_INTR {0} \
   CONFIG.PCW_P2F_DMAC1_INTR {0} \
   CONFIG.PCW_P2F_DMAC2_INTR {0} \
   CONFIG.PCW_P2F_DMAC3_INTR {0} \
   CONFIG.PCW_P2F_DMAC4_INTR {0} \
   CONFIG.PCW_P2F_DMAC5_INTR {0} \
   CONFIG.PCW_P2F_DMAC6_INTR {0} \
   CONFIG.PCW_P2F_DMAC7_INTR {0} \
   CONFIG.PCW_P2F_DMAC_ABORT_INTR {0} \
   CONFIG.PCW_P2F_ENET0_INTR {0} \
   CONFIG.PCW_P2F_ENET1_INTR {0} \
   CONFIG.PCW_P2F_GPIO_INTR {0} \
   CONFIG.PCW_P2F_I2C0_INTR {0} \
   CONFIG.PCW_P2F_I2C1_INTR {0} \
   CONFIG.PCW_P2F_QSPI_INTR {0} \
   CONFIG.PCW_P2F_SDIO0_INTR {0} \
   CONFIG.PCW_P2F_SDIO1_INTR {0} \
   CONFIG.PCW_P2F_SMC_INTR {0} \
   CONFIG.PCW_P2F_SPI0_INTR {0} \
   CONFIG.PCW_P2F_SPI1_INTR {0} \
   CONFIG.PCW_P2F_UART0_INTR {0} \
   CONFIG.PCW_P2F_UART1_INTR {0} \
   CONFIG.PCW_P2F_USB0_INTR {0} \
   CONFIG.PCW_P2F_USB1_INTR {0} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.063} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.062} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.065} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.083} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {-0.007} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {-0.010} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {-0.006} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {-0.048} \
   CONFIG.PCW_PACKAGE_NAME {clg484} \
   CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_PCAP_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_PERIPHERAL_BOARD_PRESET {part0} \
   CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PLL_BYPASSMODE_ENABLE {0} \
   CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
   CONFIG.PCW_PS7_SI_REV {PRODUCTION} \
   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_QSPI_INTERNAL_HIGHADDRESS {0xFCFFFFFF} \
   CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
   CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_CD_IO {MIO 47} \
   CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_WP_IO {MIO 46} \
   CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
   CONFIG.PCW_SD1_GRP_CD_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SDIO0_BASEADDR {0xE0100000} \
   CONFIG.PCW_SDIO0_HIGHADDR {0xE0100FFF} \
   CONFIG.PCW_SDIO1_BASEADDR {0xE0101000} \
   CONFIG.PCW_SDIO1_HIGHADDR {0xE0101FFF} \
   CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {20} \
   CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
   CONFIG.PCW_SMC_CYCLE_T0 {NA} \
   CONFIG.PCW_SMC_CYCLE_T1 {NA} \
   CONFIG.PCW_SMC_CYCLE_T2 {NA} \
   CONFIG.PCW_SMC_CYCLE_T3 {NA} \
   CONFIG.PCW_SMC_CYCLE_T4 {NA} \
   CONFIG.PCW_SMC_CYCLE_T5 {NA} \
   CONFIG.PCW_SMC_CYCLE_T6 {NA} \
   CONFIG.PCW_SMC_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SMC_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_SMC_PERIPHERAL_VALID {0} \
   CONFIG.PCW_SPI0_BASEADDR {0xE0006000} \
   CONFIG.PCW_SPI0_GRP_SS0_ENABLE {0} \
   CONFIG.PCW_SPI0_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_SPI0_GRP_SS2_ENABLE {0} \
   CONFIG.PCW_SPI0_HIGHADDR {0xE0006FFF} \
   CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SPI1_BASEADDR {0xE0007000} \
   CONFIG.PCW_SPI1_GRP_SS0_ENABLE {0} \
   CONFIG.PCW_SPI1_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_SPI1_GRP_SS2_ENABLE {0} \
   CONFIG.PCW_SPI1_HIGHADDR {0xE0007FFF} \
   CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SPI_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ {166.666666} \
   CONFIG.PCW_SPI_PERIPHERAL_VALID {0} \
   CONFIG.PCW_S_AXI_ACP_ARUSER_VAL {31} \
   CONFIG.PCW_S_AXI_ACP_AWUSER_VAL {31} \
   CONFIG.PCW_S_AXI_ACP_ID_WIDTH {3} \
   CONFIG.PCW_S_AXI_GP0_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_GP1_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP0_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP1_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP1_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP2_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP2_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP3_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP3_ID_WIDTH {6} \
   CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_TRACE_BUFFER_CLOCK_DELAY {12} \
   CONFIG.PCW_TRACE_BUFFER_FIFO_SIZE {128} \
   CONFIG.PCW_TRACE_GRP_16BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_2BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_32BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_4BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_8BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_INTERNAL_WIDTH {2} \
   CONFIG.PCW_TRACE_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TRACE_PIPELINE_WIDTH {8} \
   CONFIG.PCW_TTC0_BASEADDR {0xE0104000} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_HIGHADDR {0xE0104fff} \
   CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_TTC0_TTC0_IO {EMIO} \
   CONFIG.PCW_TTC1_BASEADDR {0xE0105000} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_HIGHADDR {0xE0105fff} \
   CONFIG.PCW_TTC1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_UART0_BASEADDR {0xE0000000} \
   CONFIG.PCW_UART0_BAUD_RATE {115200} \
   CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART0_HIGHADDR {0xE0000FFF} \
   CONFIG.PCW_UART0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_UART1_BASEADDR {0xE0001000} \
   CONFIG.PCW_UART1_BAUD_RATE {115200} \
   CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART1_HIGHADDR {0xE0001FFF} \
   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
   CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {20} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
   CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE {0} \
   CONFIG.PCW_UIPARAM_DDR_AL {0} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_BL {8} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.41} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.411} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.341} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.358} \
   CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH {61.0905} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH {61.0905} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH {61.0905} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH {61.0905} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN {0} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {6} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {2048 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH {68.4725} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH {71.086} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH {66.794} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH {108.7385} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.025} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.028} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.001} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.001} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH {64.1705} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH {63.686} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH {68.46} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH {105.4895} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
   CONFIG.PCW_UIPARAM_DDR_ECC {Disabled} \
   CONFIG.PCW_UIPARAM_DDR_ENABLE {1} \
   CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {533.333313} \
   CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP {Normal (0-85)} \
   CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J128M16 HA-15E} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {14} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {45.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {36.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {49.5} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
   CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {1} \
   CONFIG.PCW_UIPARAM_GENERATE_SUMMARY {NA} \
   CONFIG.PCW_USB0_BASEADDR {0xE0102000} \
   CONFIG.PCW_USB0_HIGHADDR {0xE0102fff} \
   CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB0_RESET_ENABLE {0} \
   CONFIG.PCW_USB0_RESET_IO {<Select>} \
   CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
   CONFIG.PCW_USB1_BASEADDR {0xE0103000} \
   CONFIG.PCW_USB1_HIGHADDR {0xE0103fff} \
   CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_USB1_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB1_RESET_ENABLE {0} \
   CONFIG.PCW_USB_RESET_ENABLE {1} \
   CONFIG.PCW_USB_RESET_POLARITY {Active Low} \
   CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_USE_AXI_FABRIC_IDLE {0} \
   CONFIG.PCW_USE_AXI_NONSECURE {0} \
   CONFIG.PCW_USE_CORESIGHT {0} \
   CONFIG.PCW_USE_CROSS_TRIGGER {0} \
   CONFIG.PCW_USE_CR_FABRIC {1} \
   CONFIG.PCW_USE_DDR_BYPASS {0} \
   CONFIG.PCW_USE_DEBUG {0} \
   CONFIG.PCW_USE_DEFAULT_ACP_USER_VAL {0} \
   CONFIG.PCW_USE_DMA0 {0} \
   CONFIG.PCW_USE_DMA1 {0} \
   CONFIG.PCW_USE_DMA2 {0} \
   CONFIG.PCW_USE_DMA3 {0} \
   CONFIG.PCW_USE_EXPANDED_IOP {0} \
   CONFIG.PCW_USE_EXPANDED_PS_SLCR_REGISTERS {0} \
   CONFIG.PCW_USE_FABRIC_INTERRUPT {0} \
   CONFIG.PCW_USE_HIGH_OCM {0} \
   CONFIG.PCW_USE_M_AXI_GP0 {1} \
   CONFIG.PCW_USE_M_AXI_GP1 {0} \
   CONFIG.PCW_USE_PROC_EVENT_BUS {0} \
   CONFIG.PCW_USE_PS_SLCR_REGISTERS {0} \
   CONFIG.PCW_USE_S_AXI_ACP {0} \
   CONFIG.PCW_USE_S_AXI_GP0 {1} \
   CONFIG.PCW_USE_S_AXI_GP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP0 {0} \
   CONFIG.PCW_USE_S_AXI_HP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP2 {0} \
   CONFIG.PCW_USE_S_AXI_HP3 {0} \
   CONFIG.PCW_USE_TRACE {0} \
   CONFIG.PCW_USE_TRACE_DATA_EDGE_DETECTOR {0} \
   CONFIG.PCW_VALUE_SILVERSION {3} \
   CONFIG.PCW_WDT_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_WDT_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_WDT_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_WDT_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.preset {ZedBoard} \
 ] $processing_system7_0

  # Create instance: ps7_0_axi_periph, and set properties
  set ps7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {2} \
   CONFIG.STRATEGY {1} \
 ] $ps7_0_axi_periph

  # Create instance: rst_ps7_0_100M, and set properties
  set rst_ps7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_100M ]

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {1024} \
   CONFIG.C_MON_TYPE {MIX} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
   CONFIG.C_NUM_OF_PROBES {17} \
   CONFIG.C_PROBE_WIDTH_PROPAGATION {AUTO} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_TXN_CNTR_EN {0} \
   CONFIG.C_SLOT_1_TXN_CNTR_EN {0} \
   CONFIG.C_SLOT_2_TXN_CNTR_EN {0} \
 ] $system_ila_0

  # Create interface connections
  connect_bd_intf_net -intf_net CPU_0_M_AXI [get_bd_intf_pins CPU_0/M_AXI] [get_bd_intf_pins axi_mem_intercon/S00_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets CPU_0_M_AXI] [get_bd_intf_pins CPU_0/M_AXI] [get_bd_intf_pins system_ila_0/SLOT_0_AXI]
  connect_bd_intf_net -intf_net axi_cdma_0_M_AXI [get_bd_intf_pins axi_cdma_0/M_AXI] [get_bd_intf_pins axi_mem_intercon/S01_AXI]
  connect_bd_intf_net -intf_net axi_cdma_0_M_AXI_SG [get_bd_intf_pins axi_cdma_0/M_AXI_SG] [get_bd_intf_pins axi_mem_intercon/S02_AXI]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_GP0]
  connect_bd_intf_net -intf_net axi_mem_intercon_M01_AXI [get_bd_intf_pins axi_mem_intercon/M01_AXI] [get_bd_intf_pins ps7_0_axi_periph/S01_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins axi_cdma_0/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M01_AXI [get_bd_intf_pins CPU_0/s_axi_btpu] [get_bd_intf_pins ps7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M02_AXI [get_bd_intf_pins CPU_0/s_axi_d] [get_bd_intf_pins ps7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M03_AXI [get_bd_intf_pins CPU_0/s_axi_i] [get_bd_intf_pins ps7_0_axi_periph/M03_AXI]

  # Create port connections
  connect_bd_net -net CPU_0_CREG_CTR_dbg [get_bd_pins system_ila_0/probe13]
  connect_bd_net -net CPU_0_M_WB_en_dbg [get_bd_pins system_ila_0/probe0]
  connect_bd_net -net CPU_0_M_WB_we_dbg [get_bd_pins system_ila_0/probe1]
  connect_bd_net -net CPU_0_axi_en_dbg [get_bd_pins system_ila_0/probe6]
  connect_bd_net -net CPU_0_axi_stall_dbg [get_bd_pins system_ila_0/probe8]
  connect_bd_net -net CPU_0_btpu_readed [get_bd_pins system_ila_0/probe16]
  connect_bd_net -net CPU_0_gpio_en_dbg [get_bd_pins system_ila_0/probe7]
  connect_bd_net -net CPU_0_instruction_dbg [get_bd_pins system_ila_0/probe10]
  connect_bd_net -net CPU_0_leds [get_bd_ports leds_0] [get_bd_pins CPU_0/leds]
  connect_bd_net -net CPU_0_mem_addr_dbg [get_bd_pins system_ila_0/probe2]
  connect_bd_net -net CPU_0_mem_data_dbg [get_bd_pins system_ila_0/probe3]
  connect_bd_net -net CPU_0_mem_rdata_dbg [get_bd_pins system_ila_0/probe4]
  connect_bd_net -net CPU_0_mem_we_dbg [get_bd_pins system_ila_0/probe9]
  connect_bd_net -net CPU_0_oled_dc [get_bd_ports oled_dc_0] [get_bd_pins CPU_0/oled_dc]
  connect_bd_net -net CPU_0_oled_res [get_bd_ports oled_res_0] [get_bd_pins CPU_0/oled_res]
  connect_bd_net -net CPU_0_oled_sclk [get_bd_ports oled_sclk_0] [get_bd_pins CPU_0/oled_sclk]
  connect_bd_net -net CPU_0_oled_sdin [get_bd_ports oled_sdin_0] [get_bd_pins CPU_0/oled_sdin]
  connect_bd_net -net CPU_0_oled_vbat [get_bd_ports oled_vbat_0] [get_bd_pins CPU_0/oled_vbat]
  connect_bd_net -net CPU_0_oled_vdd [get_bd_ports oled_vdd_0] [get_bd_pins CPU_0/oled_vdd]
  connect_bd_net -net CPU_0_pc_dbg [get_bd_pins system_ila_0/probe15]
  connect_bd_net -net CPU_0_ram_en_dbg [get_bd_pins system_ila_0/probe5]
  connect_bd_net -net CPU_0_rd_addr_dbg [get_bd_pins system_ila_0/probe14]
  connect_bd_net -net CPU_0_regFile_we_dbg [get_bd_pins system_ila_0/probe12]
  connect_bd_net -net CPU_0_run_out [get_bd_ports run_out_0] [get_bd_pins CPU_0/run_out]
  connect_bd_net -net CPU_0_state_dbg [get_bd_pins system_ila_0/probe11]
  connect_bd_net -net Net [get_bd_ports GPIO_0] [get_bd_pins CPU_0/GPIO]
  connect_bd_net -net Net1 [get_bd_ports SDA_0] [get_bd_pins CPU_0/SDA]
  connect_bd_net -net Net2 [get_bd_ports SCL_0] [get_bd_pins CPU_0/SCL]
  connect_bd_net -net axi_cdma_0_cdma_introut [get_bd_pins CPU_0/cdma_interrupt] [get_bd_pins axi_cdma_0/cdma_introut]
  connect_bd_net -net btn_center_0_1 [get_bd_ports btn_center_0] [get_bd_pins CPU_0/btn_center]
  connect_bd_net -net btn_down_0_1 [get_bd_ports btn_down_0] [get_bd_pins CPU_0/btn_down]
  connect_bd_net -net btn_left_0_1 [get_bd_ports btn_left_0] [get_bd_pins CPU_0/btn_left]
  connect_bd_net -net btn_right_0_1 [get_bd_ports btn_right_0] [get_bd_pins CPU_0/btn_right]
  connect_bd_net -net btn_up_0_1 [get_bd_ports btn_up_0] [get_bd_pins CPU_0/btn_up]
  connect_bd_net -net oled_select0_0_1 [get_bd_ports oled_select0_0] [get_bd_pins CPU_0/oled_select0]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins CPU_0/clk] [get_bd_pins axi_cdma_0/m_axi_aclk] [get_bd_pins axi_cdma_0/s_axi_lite_aclk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/M01_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_mem_intercon/S01_ACLK] [get_bd_pins axi_mem_intercon/S02_ACLK] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_GP0_ACLK] [get_bd_pins ps7_0_axi_periph/ACLK] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/M02_ACLK] [get_bd_pins ps7_0_axi_periph/M03_ACLK] [get_bd_pins ps7_0_axi_periph/S00_ACLK] [get_bd_pins ps7_0_axi_periph/S01_ACLK] [get_bd_pins rst_ps7_0_100M/slowest_sync_clk] [get_bd_pins system_ila_0/clk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins CPU_0/clk_100MHz] [get_bd_pins processing_system7_0/FCLK_CLK1]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_ps7_0_100M/ext_reset_in]
  connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn [get_bd_pins CPU_0/res_in] [get_bd_pins axi_cdma_0/s_axi_lite_aresetn] [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/M01_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_mem_intercon/S01_ARESETN] [get_bd_pins axi_mem_intercon/S02_ARESETN] [get_bd_pins ps7_0_axi_periph/ARESETN] [get_bd_pins ps7_0_axi_periph/M00_ARESETN] [get_bd_pins ps7_0_axi_periph/M01_ARESETN] [get_bd_pins ps7_0_axi_periph/M02_ARESETN] [get_bd_pins ps7_0_axi_periph/M03_ARESETN] [get_bd_pins ps7_0_axi_periph/S00_ARESETN] [get_bd_pins ps7_0_axi_periph/S01_ARESETN] [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins system_ila_0/resetn]
  connect_bd_net -net run_in_0_1 [get_bd_ports run_in_0] [get_bd_pins CPU_0/run_in]
  connect_bd_net -net switches_0_1 [get_bd_ports switches_0] [get_bd_pins CPU_0/switches]

  # Create address segments
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs CPU_0/s_axi_i/reg0] -force
  assign_bd_address -offset 0x40030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0xE0000000 -range 0x00400000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_IOP] -force
  assign_bd_address -offset 0xFC000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_QSPI_LINEAR] -force
  assign_bd_address -offset 0x40080000 -range 0x00080000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs CPU_0/s_axi_btpu/reg0] -force
  assign_bd_address -offset 0x40080000 -range 0x00080000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs CPU_0/s_axi_btpu/reg0] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs CPU_0/s_axi_d/reg0] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs CPU_0/s_axi_d/reg0] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs CPU_0/s_axi_i/reg0] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs CPU_0/s_axi_i/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0xE0000000 -range 0x00400000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_IOP] -force
  assign_bd_address -offset 0xE0000000 -range 0x00400000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_IOP] -force
  assign_bd_address -offset 0xFC000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_QSPI_LINEAR] -force
  assign_bd_address -offset 0xFC000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_QSPI_LINEAR] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs CPU_0/s_axi_i/reg0] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs CPU_0/s_axi_d/reg0] -force
  assign_bd_address -offset 0x40080000 -range 0x00080000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs CPU_0/s_axi_btpu/reg0] -force
  assign_bd_address -offset 0x40030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -offset 0x40080000 -range 0x00080000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs CPU_0/s_axi_btpu/reg0]
  exclude_bd_addr_seg -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs CPU_0/s_axi_d/reg0]
  exclude_bd_addr_seg -offset 0x40000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP0]
  exclude_bd_addr_seg -offset 0x40030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg]
  exclude_bd_addr_seg -offset 0x40000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP0]
  exclude_bd_addr_seg -offset 0x40030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg]
  exclude_bd_addr_seg -offset 0x40000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs processing_system7_0/S_AXI_GP0/GP0_M_AXI_GP0]

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   "ActiveEmotionalView":"Default View",
   "Default View_ScaleFactor":"1.23594",
   "Default View_TopLeft":"1018,29",
   "ExpandedHierarchyInLayout":"",
   "guistr":"# # String gsaved with Nlview 7.0r4  2019-12-20 bk=1.5203 VDI=41 GEI=36 GUI=JA:10.0 TLS
#  -string -flagsOSRD
preplace port DDR -pg 1 -lvl 6 -x 1930 -y 100 -defaultsOSRD
preplace port FIXED_IO -pg 1 -lvl 6 -x 1930 -y 130 -defaultsOSRD
preplace port port-id_SCL_0 -pg 1 -lvl 6 -x 1930 -y 450 -defaultsOSRD
preplace port port-id_SDA_0 -pg 1 -lvl 6 -x 1930 -y 420 -defaultsOSRD
preplace port port-id_btn_center_0 -pg 1 -lvl 0 -x -50 -y 640 -defaultsOSRD
preplace port port-id_btn_down_0 -pg 1 -lvl 0 -x -50 -y 550 -defaultsOSRD
preplace port port-id_btn_left_0 -pg 1 -lvl 0 -x -50 -y 580 -defaultsOSRD
preplace port port-id_btn_right_0 -pg 1 -lvl 0 -x -50 -y 610 -defaultsOSRD
preplace port port-id_btn_up_0 -pg 1 -lvl 0 -x -50 -y 520 -defaultsOSRD
preplace port port-id_oled_dc_0 -pg 1 -lvl 6 -x 1930 -y 600 -defaultsOSRD
preplace port port-id_oled_res_0 -pg 1 -lvl 6 -x 1930 -y 630 -defaultsOSRD
preplace port port-id_oled_sclk_0 -pg 1 -lvl 6 -x 1930 -y 570 -defaultsOSRD
preplace port port-id_oled_sdin_0 -pg 1 -lvl 6 -x 1930 -y 540 -defaultsOSRD
preplace port port-id_oled_select0_0 -pg 1 -lvl 0 -x -50 -y 700 -defaultsOSRD
preplace port port-id_oled_vbat_0 -pg 1 -lvl 6 -x 1930 -y 660 -defaultsOSRD
preplace port port-id_oled_vdd_0 -pg 1 -lvl 6 -x 1930 -y 690 -defaultsOSRD
preplace port port-id_run_in_0 -pg 1 -lvl 0 -x -50 -y 490 -defaultsOSRD
preplace port port-id_run_out_0 -pg 1 -lvl 6 -x 1930 -y 480 -defaultsOSRD
preplace portBus GPIO_0 -pg 1 -lvl 6 -x 1930 -y 390 -defaultsOSRD
preplace portBus leds_0 -pg 1 -lvl 6 -x 1930 -y 510 -defaultsOSRD
preplace portBus switches_0 -pg 1 -lvl 0 -x -50 -y 670 -defaultsOSRD
preplace inst CPU_0 -pg 1 -lvl 5 -x 1620 -y 580 -defaultsOSRD
preplace inst axi_cdma_0 -pg 1 -lvl 3 -x 880 -y 130 -defaultsOSRD
preplace inst axi_mem_intercon -pg 1 -lvl 4 -x 1210 -y 230 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 5 -x 1620 -y 200 -defaultsOSRD
preplace inst ps7_0_axi_periph -pg 1 -lvl 2 -x 560 -y 330 -defaultsOSRD
preplace inst rst_ps7_0_100M -pg 1 -lvl 1 -x 200 -y 200 -defaultsOSRD
preplace inst system_ila_0 -pg 1 -lvl 4 -x 1210 -y 950 -defaultsOSRD
preplace netloc CPU_0_CREG_CTR_dbg 1 3 1 N 1060
preplace netloc CPU_0_M_WB_en_dbg 1 3 1 N 800
preplace netloc CPU_0_M_WB_we_dbg 1 3 1 N 820
preplace netloc CPU_0_axi_en_dbg 1 3 1 N 920
preplace netloc CPU_0_axi_stall_dbg 1 3 1 N 960
preplace netloc CPU_0_btpu_readed 1 3 1 N 1120
preplace netloc CPU_0_gpio_en_dbg 1 3 1 N 940
preplace netloc CPU_0_instruction_dbg 1 3 1 N 1000
preplace netloc CPU_0_leds 1 5 1 1870J 510n
preplace netloc CPU_0_mem_addr_dbg 1 3 1 N 840
preplace netloc CPU_0_mem_data_dbg 1 3 1 N 860
preplace netloc CPU_0_mem_rdata_dbg 1 3 1 N 880
preplace netloc CPU_0_mem_we_dbg 1 3 1 N 980
preplace netloc CPU_0_oled_dc 1 5 1 1900J 600n
preplace netloc CPU_0_oled_res 1 5 1 1910J 630n
preplace netloc CPU_0_oled_sclk 1 5 1 1890J 570n
preplace netloc CPU_0_oled_sdin 1 5 1 1880J 540n
preplace netloc CPU_0_oled_vbat 1 5 1 1860J 660n
preplace netloc CPU_0_oled_vdd 1 5 1 NJ 690
preplace netloc CPU_0_pc_dbg 1 3 1 N 1100
preplace netloc CPU_0_ram_en_dbg 1 3 1 N 900
preplace netloc CPU_0_rd_addr_dbg 1 3 1 N 1080
preplace netloc CPU_0_regFile_we_dbg 1 3 1 N 1040
preplace netloc CPU_0_run_out 1 5 1 1860J 480n
preplace netloc CPU_0_state_dbg 1 3 1 N 1020
preplace netloc Net 1 5 1 1830J 390n
preplace netloc Net1 1 5 1 1840J 420n
preplace netloc Net2 1 5 1 1850J 450n
preplace netloc axi_cdma_0_cdma_introut 1 3 2 1020 450 1380J
preplace netloc btn_center_0_1 1 0 5 NJ 640 NJ 640 NJ 640 NJ 640 1360J
preplace netloc btn_down_0_1 1 0 5 NJ 550 NJ 550 NJ 550 NJ 550 1420J
preplace netloc btn_left_0_1 1 0 5 NJ 580 NJ 580 NJ 580 NJ 580 1390J
preplace netloc btn_right_0_1 1 0 5 NJ 610 NJ 610 NJ 610 NJ 610 1370J
preplace netloc btn_up_0_1 1 0 5 NJ 520 380J 560 NJ 560 NJ 560 1400J
preplace netloc oled_select0_0_1 1 0 5 NJ 700 NJ 700 NJ 700 NJ 700 NJ
preplace netloc processing_system7_0_FCLK_CLK0 1 0 6 -20 100 380 100 720 40 1030 470 1410 40 1830
preplace netloc processing_system7_0_FCLK_CLK1 1 4 2 1420 50 1820
preplace netloc processing_system7_0_FCLK_RESET0_N 1 0 6 -30 20 NJ 20 NJ 20 NJ 20 NJ 20 1850
preplace netloc rst_ps7_0_100M_peripheral_aresetn 1 1 4 390 120 710 220 1040 540 NJ
preplace netloc run_in_0_1 1 0 5 NJ 490 400J 570 NJ 570 NJ 570 1410J
preplace netloc switches_0_1 1 0 5 NJ 670 NJ 670 NJ 670 NJ 670 1360J
preplace netloc CPU_0_M_AXI 1 3 3 1050 430 1400J 380 1820
preplace netloc axi_cdma_0_M_AXI 1 3 1 N 110
preplace netloc axi_cdma_0_M_AXI_SG 1 3 1 N 130
preplace netloc axi_mem_intercon_M00_AXI 1 4 1 1400 180n
preplace netloc axi_mem_intercon_M01_AXI 1 1 4 400 10 NJ 10 NJ 10 1380
preplace netloc processing_system7_0_DDR 1 5 1 1860J 100n
preplace netloc processing_system7_0_FIXED_IO 1 5 1 NJ 130
preplace netloc processing_system7_0_M_AXI_GP0 1 1 5 410 30 NJ 30 NJ 30 NJ 30 1840
preplace netloc ps7_0_axi_periph_M00_AXI 1 2 1 730 100n
preplace netloc ps7_0_axi_periph_M01_AXI 1 2 3 730 440 NJ 440 NJ
preplace netloc ps7_0_axi_periph_M02_AXI 1 2 3 720 460 NJ 460 NJ
preplace netloc ps7_0_axi_periph_M03_AXI 1 2 3 710 480 NJ 480 NJ
levelinfo -pg 1 -50 200 560 880 1210 1620 1930
pagesize -pg 1 -db -bbox -sgen -210 0 2070 1200
"
}

  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
  close_bd_design $design_name 
}
# End of cr_bd_top_level_dbg()
cr_bd_top_level_dbg ""
set_property GENERATE_SYNTH_CHECKPOINT "0" [get_files top_level_dbg.bd ] 
set_property REGISTERED_WITH_MANAGER "1" [get_files top_level_dbg.bd ] 
set_property USED_IN "synthesis implementation" [get_files top_level_dbg.bd ] 
set_property USED_IN_SIMULATION "0" [get_files top_level_dbg.bd ] 

if { [get_files BTPU_memory.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/BTPU_memory/BTPU_memory.xci
}
if { [get_files axi_btpu_ctrl.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/axi_btpu_ctrl/axi_btpu_ctrl.xci
}
if { [get_files data_memory.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/data_memory/data_memory.xci
}
if { [get_files axi_bram_ctrl_0.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/axi_bram_ctrl_0/axi_bram_ctrl_0.xci
}
if { [get_files instruction_mem.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/instruction_mem/instruction_mem.xci
}
if { [get_files AXI_memory_controller.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/axi/AXI_memory_controller.vhd
}
if { [get_files utilities_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/utilities_pkg.vhd
}
if { [get_files BNN_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/BNN_pkg.vhd
}
if { [get_files types_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/types_pkg.vhd
}
if { [get_files constant_package.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/constant_package.vhd
}
if { [get_files memory_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/memory_pkg.vhd
}
if { [get_files compressor_layer.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/compressor_layer.vhd
}
if { [get_files popcounter_tree.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/popcounter_tree.vhd
}
if { [get_files ternary_adder.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/ternary_adder.vhd
}
if { [get_files popcounter.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/popcounter.vhd
}
if { [get_files binary_mac.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/binary_mac.vhd
}
if { [get_files BTPU_MAC.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/BTPU_MAC.vhd
}
if { [get_files BTPU.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/BTPU.vhd
}
if { [get_files instruction_fetch.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/IF/instruction_fetch.vhd
}
if { [get_files triple_port_ram.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/ID/triple_port_ram.vhd
}
if { [get_files sign_extender_ro.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/ID/sign_extender_ro.vhd
}
if { [get_files istruction_decode.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/ID/istruction_decode.vhd
}
if { [get_files barrel_shifter.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/IE/barrel_shifter.vhd
}
if { [get_files alu.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/IE/alu.vhd
}
if { [get_files comparator.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/IE/comparator.vhd
}
if { [get_files execute.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/IE/execute.vhd
}
if { [get_files address_manager.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/MEM_WB/address_manager.vhd
}
if { [get_files memory_write_back.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/MEM_WB/memory_write_back.vhd
}
if { [get_files GPIO.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/GPIO.vhd
}
if { [get_files i2c_utils_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/i2c_utils_pkg.vhd
}
if { [get_files I2C_driver.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/I2C_driver.vhd
}
if { [get_files I2C_module.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/I2C_module.vhd
}
if { [get_files oled_driver.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/oled_driver/oled_driver.vhd
}
if { [get_files timer.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/timer.vhd
}
if { [get_files ascii_rom.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/oled_driver/ascii_rom.vhd
}
if { [get_files compressor_6_3.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/compressor_6_3.vhd
}
if { [get_files delay_module.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/oled_driver/delay_module.vhd
}
if { [get_files oled_counter.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/oled_driver/oled_counter.vhd
}
if { [get_files spi_controller.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/oled_driver/spi_controller.vhd
}
if { [get_files CPU.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/CPU.vhd
}


# Proc to create BD test_design_axi_recursive
proc cr_bd_test_design_axi_recursive { parentCell } {
# The design that will be created by this Tcl proc contains the following 
# module references:
# CPU



  # CHANGE DESIGN NAME HERE
  set design_name test_design_axi_recursive

  common::send_gid_msg -ssname BD::TCL -id 2010 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

  create_bd_design $design_name

  set bCheckIPsPassed 1
  ##################################################################
  # CHECK IPs
  ##################################################################
  set bCheckIPs 1
  if { $bCheckIPs == 1 } {
     set list_check_ips "\ 
  xilinx.com:ip:axi_vip:1.1\
  xilinx.com:ip:proc_sys_reset:5.0\
  xilinx.com:ip:xlconstant:1.1\
  "

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

  }

  ##################################################################
  # CHECK Modules
  ##################################################################
  set bCheckModules 1
  if { $bCheckModules == 1 } {
     set list_check_mods "\ 
  CPU\
  "

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

  if { $bCheckIPsPassed != 1 } {
    common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
    return 3
  }

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set GPIO_0 [ create_bd_port -dir IO -from 31 -to 0 GPIO_0 ]
  set SCL_0 [ create_bd_port -dir IO SCL_0 ]
  set SDA_0 [ create_bd_port -dir IO SDA_0 ]
  set btn_center_0 [ create_bd_port -dir I btn_center_0 ]
  set btn_down_0 [ create_bd_port -dir I btn_down_0 ]
  set btn_left_0 [ create_bd_port -dir I btn_left_0 ]
  set btn_right_0 [ create_bd_port -dir I btn_right_0 ]
  set btn_up_0 [ create_bd_port -dir I btn_up_0 ]
  set clk_in1_0 [ create_bd_port -dir I -type clk clk_in1_0 ]
  set leds_0 [ create_bd_port -dir O -from 2 -to 0 leds_0 ]
  set oled_dc_0 [ create_bd_port -dir O oled_dc_0 ]
  set oled_res_0 [ create_bd_port -dir O oled_res_0 ]
  set oled_sclk_0 [ create_bd_port -dir O oled_sclk_0 ]
  set oled_sdin_0 [ create_bd_port -dir O oled_sdin_0 ]
  set oled_select0_0 [ create_bd_port -dir I oled_select0_0 ]
  set oled_vbat_0 [ create_bd_port -dir O oled_vbat_0 ]
  set oled_vdd_0 [ create_bd_port -dir O oled_vdd_0 ]
  set reset_0 [ create_bd_port -dir I -type rst reset_0 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $reset_0
  set run_in_0 [ create_bd_port -dir I run_in_0 ]
  set run_out_0 [ create_bd_port -dir O run_out_0 ]
  set switches_0 [ create_bd_port -dir I -from 1 -to 0 switches_0 ]

  # Create instance: CPU_0, and set properties
  set block_name CPU
  set block_cell_name CPU_0
  if { [catch {set CPU_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $CPU_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.RUN_BLINK_COUNTER_SIZE {2} \
 ] $CPU_0

  # Create instance: axi_vip_0, and set properties
  set axi_vip_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_0

  # Create instance: axi_vip_0_axi_periph, and set properties
  set axi_vip_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_vip_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {3} \
   CONFIG.NUM_SI {2} \
 ] $axi_vip_0_axi_periph

  # Create instance: axi_vip_1, and set properties
  set axi_vip_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_1 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {PASS_THROUGH} \
 ] $axi_vip_1

  # Create instance: rst_clk_in1_0_100M, and set properties
  set rst_clk_in1_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_in1_0_100M ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create interface connections
  connect_bd_intf_net -intf_net CPU_0_M_AXI [get_bd_intf_pins CPU_0/M_AXI] [get_bd_intf_pins axi_vip_1/S_AXI]
  connect_bd_intf_net -intf_net axi_vip_0_M_AXI [get_bd_intf_pins axi_vip_0/M_AXI] [get_bd_intf_pins axi_vip_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net axi_vip_0_axi_periph_M00_AXI [get_bd_intf_pins CPU_0/s_axi_d] [get_bd_intf_pins axi_vip_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net axi_vip_0_axi_periph_M01_AXI [get_bd_intf_pins CPU_0/s_axi_i] [get_bd_intf_pins axi_vip_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net axi_vip_0_axi_periph_M02_AXI [get_bd_intf_pins CPU_0/s_axi_btpu] [get_bd_intf_pins axi_vip_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net axi_vip_1_M_AXI [get_bd_intf_pins axi_vip_0_axi_periph/S01_AXI] [get_bd_intf_pins axi_vip_1/M_AXI]

  # Create port connections
  connect_bd_net -net CPU_0_leds [get_bd_ports leds_0] [get_bd_pins CPU_0/leds]
  connect_bd_net -net CPU_0_oled_dc [get_bd_ports oled_dc_0] [get_bd_pins CPU_0/oled_dc]
  connect_bd_net -net CPU_0_oled_res [get_bd_ports oled_res_0] [get_bd_pins CPU_0/oled_res]
  connect_bd_net -net CPU_0_oled_sclk [get_bd_ports oled_sclk_0] [get_bd_pins CPU_0/oled_sclk]
  connect_bd_net -net CPU_0_oled_sdin [get_bd_ports oled_sdin_0] [get_bd_pins CPU_0/oled_sdin]
  connect_bd_net -net CPU_0_oled_vbat [get_bd_ports oled_vbat_0] [get_bd_pins CPU_0/oled_vbat]
  connect_bd_net -net CPU_0_oled_vdd [get_bd_ports oled_vdd_0] [get_bd_pins CPU_0/oled_vdd]
  connect_bd_net -net CPU_0_run_out [get_bd_ports run_out_0] [get_bd_pins CPU_0/run_out]
  connect_bd_net -net Net [get_bd_ports GPIO_0] [get_bd_pins CPU_0/GPIO]
  connect_bd_net -net Net1 [get_bd_ports SDA_0] [get_bd_pins CPU_0/SDA]
  connect_bd_net -net Net2 [get_bd_ports SCL_0] [get_bd_pins CPU_0/SCL]
  connect_bd_net -net btn_center_0_1 [get_bd_ports btn_center_0] [get_bd_pins CPU_0/btn_center]
  connect_bd_net -net btn_down_0_1 [get_bd_ports btn_down_0] [get_bd_pins CPU_0/btn_down]
  connect_bd_net -net btn_left_0_1 [get_bd_ports btn_left_0] [get_bd_pins CPU_0/btn_left]
  connect_bd_net -net btn_right_0_1 [get_bd_ports btn_right_0] [get_bd_pins CPU_0/btn_right]
  connect_bd_net -net btn_up_0_1 [get_bd_ports btn_up_0] [get_bd_pins CPU_0/btn_up]
  connect_bd_net -net clk_in1_0_1 [get_bd_ports clk_in1_0] [get_bd_pins CPU_0/clk] [get_bd_pins CPU_0/clk_100MHz] [get_bd_pins axi_vip_0/aclk] [get_bd_pins axi_vip_0_axi_periph/ACLK] [get_bd_pins axi_vip_0_axi_periph/M00_ACLK] [get_bd_pins axi_vip_0_axi_periph/M01_ACLK] [get_bd_pins axi_vip_0_axi_periph/M02_ACLK] [get_bd_pins axi_vip_0_axi_periph/S00_ACLK] [get_bd_pins axi_vip_0_axi_periph/S01_ACLK] [get_bd_pins axi_vip_1/aclk] [get_bd_pins rst_clk_in1_0_100M/slowest_sync_clk]
  connect_bd_net -net oled_select0_0_1 [get_bd_ports oled_select0_0] [get_bd_pins CPU_0/oled_select0]
  connect_bd_net -net rst_clk_in1_0_100M_peripheral_aresetn [get_bd_pins axi_vip_0_axi_periph/M02_ARESETN] [get_bd_pins rst_clk_in1_0_100M/peripheral_aresetn]
  connect_bd_net -net rst_clk_wiz_100M_peripheral_aresetn [get_bd_ports reset_0] [get_bd_pins CPU_0/res_in] [get_bd_pins axi_vip_0/aresetn] [get_bd_pins axi_vip_0_axi_periph/ARESETN] [get_bd_pins axi_vip_0_axi_periph/M00_ARESETN] [get_bd_pins axi_vip_0_axi_periph/M01_ARESETN] [get_bd_pins axi_vip_0_axi_periph/S00_ARESETN] [get_bd_pins axi_vip_0_axi_periph/S01_ARESETN] [get_bd_pins axi_vip_1/aresetn] [get_bd_pins rst_clk_in1_0_100M/ext_reset_in]
  connect_bd_net -net run_in_0_1 [get_bd_ports run_in_0] [get_bd_pins CPU_0/run_in]
  connect_bd_net -net switches_0_1 [get_bd_ports switches_0] [get_bd_pins CPU_0/switches]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout]

  # Create address segments
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs CPU_0/s_axi_d/reg0] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs CPU_0/s_axi_i/reg0] -force
  assign_bd_address -offset 0x44A00000 -range 0x00100000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs CPU_0/s_axi_btpu/reg0] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs CPU_0/s_axi_d/reg0] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs CPU_0/s_axi_i/reg0] -force
  assign_bd_address -offset 0x44A00000 -range 0x00100000 -target_address_space [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs CPU_0/s_axi_btpu/reg0] -force

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   "ActiveEmotionalView":"Default View",
   "Default View_ScaleFactor":"0.677108",
   "Default View_TopLeft":"-347,-10",
   "ExpandedHierarchyInLayout":"",
   "guistr":"# # String gsaved with Nlview 7.0r4  2019-12-20 bk=1.5203 VDI=41 GEI=36 GUI=JA:10.0 TLS
#  -string -flagsOSRD
preplace port port-id_SCL_0 -pg 1 -lvl 4 -x 1150 -y 450 -defaultsOSRD
preplace port port-id_SDA_0 -pg 1 -lvl 4 -x 1150 -y 420 -defaultsOSRD
preplace port port-id_btn_center_0 -pg 1 -lvl 0 -x -50 -y 650 -defaultsOSRD
preplace port port-id_btn_down_0 -pg 1 -lvl 0 -x -50 -y 560 -defaultsOSRD
preplace port port-id_btn_left_0 -pg 1 -lvl 0 -x -50 -y 590 -defaultsOSRD
preplace port port-id_btn_right_0 -pg 1 -lvl 0 -x -50 -y 620 -defaultsOSRD
preplace port port-id_btn_up_0 -pg 1 -lvl 0 -x -50 -y 530 -defaultsOSRD
preplace port port-id_clk_in1_0 -pg 1 -lvl 0 -x -50 -y 40 -defaultsOSRD
preplace port port-id_oled_dc_0 -pg 1 -lvl 4 -x 1150 -y 600 -defaultsOSRD
preplace port port-id_oled_res_0 -pg 1 -lvl 4 -x 1150 -y 630 -defaultsOSRD
preplace port port-id_oled_sclk_0 -pg 1 -lvl 4 -x 1150 -y 570 -defaultsOSRD
preplace port port-id_oled_sdin_0 -pg 1 -lvl 4 -x 1150 -y 540 -defaultsOSRD
preplace port port-id_oled_select0_0 -pg 1 -lvl 0 -x -50 -y 800 -defaultsOSRD
preplace port port-id_oled_vbat_0 -pg 1 -lvl 4 -x 1150 -y 660 -defaultsOSRD
preplace port port-id_oled_vdd_0 -pg 1 -lvl 4 -x 1150 -y 690 -defaultsOSRD
preplace port port-id_reset_0 -pg 1 -lvl 0 -x -50 -y 70 -defaultsOSRD
preplace port port-id_run_in_0 -pg 1 -lvl 0 -x -50 -y 500 -defaultsOSRD
preplace port port-id_run_out_0 -pg 1 -lvl 4 -x 1150 -y 480 -defaultsOSRD
preplace portBus GPIO_0 -pg 1 -lvl 4 -x 1150 -y 390 -defaultsOSRD
preplace portBus leds_0 -pg 1 -lvl 4 -x 1150 -y 510 -defaultsOSRD
preplace portBus switches_0 -pg 1 -lvl 0 -x -50 -y 680 -defaultsOSRD
preplace inst CPU_0 -pg 1 -lvl 3 -x 900 -y 580 -defaultsOSRD
preplace inst axi_vip_0 -pg 1 -lvl 1 -x 210 -y 60 -defaultsOSRD
preplace inst axi_vip_0_axi_periph -pg 1 -lvl 2 -x 580 -y 190 -defaultsOSRD
preplace inst axi_vip_1 -pg 1 -lvl 1 -x 210 -y 280 -defaultsOSRD
preplace inst rst_clk_in1_0_100M -pg 1 -lvl 1 -x 210 -y 460 -defaultsOSRD
preplace inst xlconstant_0 -pg 1 -lvl 2 -x 580 -y 740 -defaultsOSRD
preplace netloc CPU_0_leds 1 3 1 1090J 510n
preplace netloc CPU_0_oled_dc 1 3 1 1120J 600n
preplace netloc CPU_0_oled_res 1 3 1 1130J 630n
preplace netloc CPU_0_oled_sclk 1 3 1 1110J 570n
preplace netloc CPU_0_oled_sdin 1 3 1 1100J 540n
preplace netloc CPU_0_oled_vbat 1 3 1 1090J 660n
preplace netloc CPU_0_oled_vdd 1 3 1 NJ 690
preplace netloc CPU_0_run_out 1 3 1 1080J 480n
preplace netloc Net 1 3 1 1050J 390n
preplace netloc Net1 1 3 1 1060J 420n
preplace netloc Net2 1 3 1 1070J 450n
preplace netloc btn_center_0_1 1 0 3 -10J 660 NJ 660 NJ
preplace netloc btn_down_0_1 1 0 3 -20J 600 NJ 600 NJ
preplace netloc btn_left_0_1 1 0 3 -30J 610 NJ 610 750J
preplace netloc btn_right_0_1 1 0 3 NJ 620 NJ 620 730J
preplace netloc btn_up_0_1 1 0 3 -10J 580 NJ 580 NJ
preplace netloc clk_in1_0_1 1 0 3 0 590 420 500 740
preplace netloc oled_select0_0_1 1 0 3 0J 670 NJ 670 740J
preplace netloc rst_clk_in1_0_100M_peripheral_aresetn 1 1 1 410 320n
preplace netloc rst_clk_wiz_100M_peripheral_aresetn 1 0 3 20 560 400 540 NJ
preplace netloc run_in_0_1 1 0 3 10J 570 430J 560 NJ
preplace netloc switches_0_1 1 0 3 NJ 680 NJ 680 NJ
preplace netloc xlconstant_0_dout 1 2 1 N 740
preplace netloc CPU_0_M_AXI 1 0 4 30 800 NJ 800 NJ 800 1040
preplace netloc axi_vip_0_M_AXI 1 1 1 N 60
preplace netloc axi_vip_0_axi_periph_M00_AXI 1 2 1 750 170n
preplace netloc axi_vip_0_axi_periph_M01_AXI 1 2 1 730 190n
preplace netloc axi_vip_0_axi_periph_M02_AXI 1 2 1 740 210n
preplace netloc axi_vip_1_M_AXI 1 1 1 390 80n
levelinfo -pg 1 -50 210 580 900 1150
pagesize -pg 1 -db -bbox -sgen -210 -10 1290 820
"
}

  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
  close_bd_design $design_name 
}
# End of cr_bd_test_design_axi_recursive()
cr_bd_test_design_axi_recursive ""
set_property GENERATE_SYNTH_CHECKPOINT "0" [get_files test_design_axi_recursive.bd ] 
set_property REGISTERED_WITH_MANAGER "1" [get_files test_design_axi_recursive.bd ] 
set_property USED_IN "" [get_files test_design_axi_recursive.bd ] 
set_property USED_IN_IMPLEMENTATION "0" [get_files test_design_axi_recursive.bd ] 
set_property USED_IN_SIMULATION "0" [get_files test_design_axi_recursive.bd ] 
set_property USED_IN_SYNTHESIS "0" [get_files test_design_axi_recursive.bd ] 

if { [get_files AXISlaveInterface.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/sim/common/AXISlaveInterface.vhd
}
if { [get_files AXI_memory_controller.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/axi/AXI_memory_controller.vhd
}
if { [get_files AXI_memory_controller.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/axi/AXI_memory_controller.vhd
}
if { [get_files BTPU_memory.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/BTPU_memory/BTPU_memory.xci
}
if { [get_files utilities_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/utilities_pkg.vhd
}
if { [get_files BNN_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/BNN_pkg.vhd
}
if { [get_files types_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/types_pkg.vhd
}
if { [get_files constant_package.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/constant_package.vhd
}
if { [get_files memory_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/memory_pkg.vhd
}
if { [get_files compressor_layer.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/compressor_layer.vhd
}
if { [get_files popcounter_tree.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/popcounter_tree.vhd
}
if { [get_files ternary_adder.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/ternary_adder.vhd
}
if { [get_files popcounter.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/popcounter.vhd
}
if { [get_files binary_mac.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/binary_mac.vhd
}
if { [get_files BTPU_MAC.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/BTPU_MAC.vhd
}
if { [get_files BTPU.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/BTPU.vhd
}
if { [get_files compressor_6_3.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/compressor_6_3.vhd
}
if { [get_files BTPU_wrapper.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/sim/bnn/BTPU_wrapper.vhd
}
if { [get_files types_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/types_pkg.vhd
}
if { [get_files constant_package.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/constant_package.vhd
}
if { [get_files memory_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/memory_pkg.vhd
}
if { [get_files timer.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/timer.vhd
}


# Proc to create BD mem_ctrl_test
proc cr_bd_mem_ctrl_test { parentCell } {
# The design that will be created by this Tcl proc contains the following 
# module references:
# AXISlaveInterface, AXI_memory_controller, AXI_memory_controller, btpu_wrapper, timer



  # CHANGE DESIGN NAME HERE
  set design_name mem_ctrl_test

  common::send_gid_msg -ssname BD::TCL -id 2010 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

  create_bd_design $design_name

  set bCheckIPsPassed 1
  ##################################################################
  # CHECK IPs
  ##################################################################
  set bCheckIPs 1
  if { $bCheckIPs == 1 } {
     set list_check_ips "\ 
  xilinx.com:ip:axi_vip:1.1\
  "

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

  }

  ##################################################################
  # CHECK Modules
  ##################################################################
  set bCheckModules 1
  if { $bCheckModules == 1 } {
     set list_check_mods "\ 
  AXISlaveInterface\
  AXI_memory_controller\
  AXI_memory_controller\
  btpu_wrapper\
  timer\
  "

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

  if { $bCheckIPsPassed != 1 } {
    common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
    return 3
  }

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set addra_0 [ create_bd_port -dir I -from 31 -to 0 addra_0 ]
  set addrb_0 [ create_bd_port -dir I -from 31 -to 0 addrb_0 ]
  set address_0 [ create_bd_port -dir I -from 31 -to 0 address_0 ]
  set address_1 [ create_bd_port -dir I -from 31 -to 0 address_1 ]
  set cc_0 [ create_bd_port -dir I -from 31 -to 0 cc_0 ]
  set clock_100mhz [ create_bd_port -dir I -type clk -freq_hz 100000000 clock_100mhz ]
  set dina_0 [ create_bd_port -dir I -from 31 -to 0 dina_0 ]
  set dinb_0 [ create_bd_port -dir I -from 31 -to 0 dinb_0 ]
  set douta_0 [ create_bd_port -dir O -from 31 -to 0 douta_0 ]
  set doutb_0 [ create_bd_port -dir O -from 31 -to 0 doutb_0 ]
  set en_0 [ create_bd_port -dir I en_0 ]
  set en_1 [ create_bd_port -dir I en_1 ]
  set ena_0 [ create_bd_port -dir I -from 3 -to 0 ena_0 ]
  set enb_0 [ create_bd_port -dir I enb_0 ]
  set pwm_0 [ create_bd_port -dir O pwm_0 ]
  set read_data_0 [ create_bd_port -dir O -from 31 -to 0 read_data_0 ]
  set read_data_1 [ create_bd_port -dir O -from 31 -to 0 read_data_1 ]
  set reset_rtl [ create_bd_port -dir I -type rst reset_rtl ]
  set stall_0 [ create_bd_port -dir O stall_0 ]
  set stall_1 [ create_bd_port -dir O stall_1 ]
  set timer_dout_0 [ create_bd_port -dir O -from 31 -to 0 timer_dout_0 ]
  set timer_en_0 [ create_bd_port -dir I timer_en_0 ]
  set we_0 [ create_bd_port -dir I -from 3 -to 0 we_0 ]
  set we_1 [ create_bd_port -dir I -from 3 -to 0 we_1 ]
  set wea_0 [ create_bd_port -dir I -from 3 -to 0 wea_0 ]
  set web_0 [ create_bd_port -dir I -from 3 -to 0 web_0 ]
  set write_data_0 [ create_bd_port -dir I -from 31 -to 0 write_data_0 ]
  set write_data_1 [ create_bd_port -dir I -from 31 -to 0 write_data_1 ]

  # Create instance: AXISlaveInterface_0, and set properties
  set block_name AXISlaveInterface
  set block_cell_name AXISlaveInterface_0
  if { [catch {set AXISlaveInterface_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $AXISlaveInterface_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: AXI_memory_controller_0, and set properties
  set block_name AXI_memory_controller
  set block_cell_name AXI_memory_controller_0
  if { [catch {set AXI_memory_controller_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $AXI_memory_controller_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: AXI_memory_controller_1, and set properties
  set block_name AXI_memory_controller
  set block_cell_name AXI_memory_controller_1
  if { [catch {set AXI_memory_controller_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $AXI_memory_controller_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axi_vip_0, and set properties
  set axi_vip_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_0 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
   CONFIG.PROTOCOL {AXI4LITE} \
 ] $axi_vip_0

  # Create instance: btpu_wrapper_0, and set properties
  set block_name btpu_wrapper
  set block_cell_name btpu_wrapper_0
  if { [catch {set btpu_wrapper_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $btpu_wrapper_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: timer_0, and set properties
  set block_name timer
  set block_cell_name timer_0
  if { [catch {set timer_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $timer_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create interface connections
  connect_bd_intf_net -intf_net AXI_memory_controller_0_M_AXI [get_bd_intf_pins AXI_memory_controller_0/M_AXI] [get_bd_intf_pins axi_vip_0/S_AXI]
  connect_bd_intf_net -intf_net AXI_memory_controller_1_M_AXI [get_bd_intf_pins AXISlaveInterface_0/S_AXI] [get_bd_intf_pins AXI_memory_controller_1/M_AXI]

  # Create port connections
  connect_bd_net -net AXI_memory_controller_0_read_data [get_bd_ports read_data_0] [get_bd_pins AXI_memory_controller_0/read_data]
  connect_bd_net -net AXI_memory_controller_0_stall [get_bd_ports stall_0] [get_bd_pins AXI_memory_controller_0/stall]
  connect_bd_net -net AXI_memory_controller_1_read_data [get_bd_ports read_data_1] [get_bd_pins AXI_memory_controller_1/read_data]
  connect_bd_net -net AXI_memory_controller_1_stall [get_bd_ports stall_1] [get_bd_pins AXI_memory_controller_1/stall]
  connect_bd_net -net addra_0_1 [get_bd_ports addra_0] [get_bd_pins btpu_wrapper_0/addra] [get_bd_pins timer_0/addr]
  connect_bd_net -net addrb_0_1 [get_bd_ports addrb_0] [get_bd_pins btpu_wrapper_0/addrb]
  connect_bd_net -net address_0_1 [get_bd_ports address_0] [get_bd_pins AXI_memory_controller_0/address]
  connect_bd_net -net address_1_1 [get_bd_ports address_1] [get_bd_pins AXI_memory_controller_1/address]
  connect_bd_net -net btpu_wrapper_0_douta [get_bd_ports douta_0] [get_bd_pins btpu_wrapper_0/douta]
  connect_bd_net -net btpu_wrapper_0_doutb [get_bd_ports doutb_0] [get_bd_pins btpu_wrapper_0/doutb]
  connect_bd_net -net cc_0_1 [get_bd_ports cc_0] [get_bd_pins timer_0/cc]
  connect_bd_net -net clk_wiz_clk_out1 [get_bd_ports clock_100mhz] [get_bd_pins AXISlaveInterface_0/S_AXI_ACLK] [get_bd_pins AXI_memory_controller_0/M_AXI_ACLK] [get_bd_pins AXI_memory_controller_1/M_AXI_ACLK] [get_bd_pins axi_vip_0/aclk] [get_bd_pins btpu_wrapper_0/clk] [get_bd_pins btpu_wrapper_0/hs_clk] [get_bd_pins timer_0/clk]
  connect_bd_net -net dina_0_1 [get_bd_ports dina_0] [get_bd_pins btpu_wrapper_0/dina] [get_bd_pins timer_0/din]
  connect_bd_net -net dinb_0_1 [get_bd_ports dinb_0] [get_bd_pins btpu_wrapper_0/dinb]
  connect_bd_net -net en_0_1 [get_bd_ports en_0] [get_bd_pins AXI_memory_controller_0/en]
  connect_bd_net -net en_1_1 [get_bd_ports en_1] [get_bd_pins AXI_memory_controller_1/en]
  connect_bd_net -net ena_0_1 [get_bd_ports ena_0] [get_bd_pins btpu_wrapper_0/ena]
  connect_bd_net -net enb_0_1 [get_bd_ports enb_0] [get_bd_pins btpu_wrapper_0/enb]
  connect_bd_net -net rst_clk_wiz_100M_peripheral_aresetn [get_bd_ports reset_rtl] [get_bd_pins AXISlaveInterface_0/S_AXI_ARESETN] [get_bd_pins AXI_memory_controller_0/M_AXI_ARESETN] [get_bd_pins AXI_memory_controller_1/M_AXI_ARESETN] [get_bd_pins axi_vip_0/aresetn] [get_bd_pins btpu_wrapper_0/res] [get_bd_pins timer_0/res]
  connect_bd_net -net timer_0_dout [get_bd_ports timer_dout_0] [get_bd_pins timer_0/dout]
  connect_bd_net -net timer_0_pwm [get_bd_ports pwm_0] [get_bd_pins timer_0/pwm]
  connect_bd_net -net timer_en_0_1 [get_bd_ports timer_en_0] [get_bd_pins timer_0/en]
  connect_bd_net -net we_0_1 [get_bd_ports we_0] [get_bd_pins AXI_memory_controller_0/we]
  connect_bd_net -net we_1_1 [get_bd_ports we_1] [get_bd_pins AXI_memory_controller_1/we]
  connect_bd_net -net wea_0_1 [get_bd_ports wea_0] [get_bd_pins btpu_wrapper_0/wea] [get_bd_pins timer_0/wea]
  connect_bd_net -net web_0_1 [get_bd_ports web_0] [get_bd_pins btpu_wrapper_0/web]
  connect_bd_net -net write_data_0_1 [get_bd_ports write_data_0] [get_bd_pins AXI_memory_controller_0/write_data]
  connect_bd_net -net write_data_1_1 [get_bd_ports write_data_1] [get_bd_pins AXI_memory_controller_1/write_data]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces AXI_memory_controller_0/M_AXI] [get_bd_addr_segs axi_vip_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces AXI_memory_controller_1/M_AXI] [get_bd_addr_segs AXISlaveInterface_0/S_AXI/reg0] -force

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   "ActiveEmotionalView":"Default View",
   "Default View_ScaleFactor":"0.597872",
   "Default View_TopLeft":"-667,-10",
   "ExpandedHierarchyInLayout":"",
   "guistr":"# # String gsaved with Nlview 7.0r4  2019-12-20 bk=1.5203 VDI=41 GEI=36 GUI=JA:10.0 TLS
#  -string -flagsOSRD
preplace port port-id_clock_100mhz -pg 1 -lvl 0 -x -40 -y 610 -defaultsOSRD
preplace port port-id_en_0 -pg 1 -lvl 0 -x -40 -y 490 -defaultsOSRD
preplace port port-id_en_1 -pg 1 -lvl 0 -x -40 -y 740 -defaultsOSRD
preplace port port-id_enb_0 -pg 1 -lvl 0 -x -40 -y 160 -defaultsOSRD
preplace port port-id_pwm_0 -pg 1 -lvl 3 -x 740 -y 420 -defaultsOSRD
preplace port port-id_reset_rtl -pg 1 -lvl 0 -x -40 -y 640 -defaultsOSRD
preplace port port-id_stall_0 -pg 1 -lvl 3 -x 740 -y 690 -defaultsOSRD
preplace port port-id_stall_1 -pg 1 -lvl 3 -x 740 -y 880 -defaultsOSRD
preplace port port-id_timer_en_0 -pg 1 -lvl 0 -x -40 -y 390 -defaultsOSRD
preplace portBus addra_0 -pg 1 -lvl 0 -x -40 -y 100 -defaultsOSRD
preplace portBus addrb_0 -pg 1 -lvl 0 -x -40 -y 220 -defaultsOSRD
preplace portBus address_0 -pg 1 -lvl 0 -x -40 -y 550 -defaultsOSRD
preplace portBus address_1 -pg 1 -lvl 0 -x -40 -y 800 -defaultsOSRD
preplace portBus cc_0 -pg 1 -lvl 0 -x -40 -y 460 -defaultsOSRD
preplace portBus dina_0 -pg 1 -lvl 0 -x -40 -y 130 -defaultsOSRD
preplace portBus dinb_0 -pg 1 -lvl 0 -x -40 -y 250 -defaultsOSRD
preplace portBus douta_0 -pg 1 -lvl 3 -x 740 -y 130 -defaultsOSRD
preplace portBus doutb_0 -pg 1 -lvl 3 -x 740 -y 160 -defaultsOSRD
preplace portBus ena_0 -pg 1 -lvl 0 -x -40 -y 40 -defaultsOSRD
preplace portBus read_data_0 -pg 1 -lvl 3 -x 740 -y 660 -defaultsOSRD
preplace portBus read_data_1 -pg 1 -lvl 3 -x 740 -y 910 -defaultsOSRD
preplace portBus timer_dout_0 -pg 1 -lvl 3 -x 740 -y 390 -defaultsOSRD
preplace portBus we_0 -pg 1 -lvl 0 -x -40 -y 520 -defaultsOSRD
preplace portBus we_1 -pg 1 -lvl 0 -x -40 -y 770 -defaultsOSRD
preplace portBus wea_0 -pg 1 -lvl 0 -x -40 -y 70 -defaultsOSRD
preplace portBus web_0 -pg 1 -lvl 0 -x -40 -y 190 -defaultsOSRD
preplace portBus write_data_0 -pg 1 -lvl 0 -x -40 -y 580 -defaultsOSRD
preplace portBus write_data_1 -pg 1 -lvl 0 -x -40 -y 830 -defaultsOSRD
preplace inst AXISlaveInterface_0 -pg 1 -lvl 2 -x 560 -y 820 -defaultsOSRD
preplace inst AXI_memory_controller_0 -pg 1 -lvl 1 -x 190 -y 590 -defaultsOSRD
preplace inst AXI_memory_controller_1 -pg 1 -lvl 1 -x 190 -y 820 -defaultsOSRD
preplace inst axi_vip_0 -pg 1 -lvl 2 -x 560 -y 590 -defaultsOSRD
preplace inst btpu_wrapper_0 -pg 1 -lvl 2 -x 560 -y 150 -defaultsOSRD
preplace inst timer_0 -pg 1 -lvl 2 -x 560 -y 410 -defaultsOSRD
preplace netloc AXI_memory_controller_0_read_data 1 1 2 360J 670 720J
preplace netloc AXI_memory_controller_0_stall 1 1 2 350J 690 NJ
preplace netloc AXI_memory_controller_1_read_data 1 1 2 360J 910 NJ
preplace netloc AXI_memory_controller_1_stall 1 1 2 350J 920 720J
preplace netloc addra_0_1 1 0 2 10J 150 390
preplace netloc addrb_0_1 1 0 2 10J 230 NJ
preplace netloc address_0_1 1 0 1 -10J 550n
preplace netloc address_1_1 1 0 1 -20J 800n
preplace netloc btpu_wrapper_0_douta 1 2 1 720J 130n
preplace netloc btpu_wrapper_0_doutb 1 2 1 NJ 160
preplace netloc cc_0_1 1 0 2 0J 470 NJ
preplace netloc clk_wiz_clk_out1 1 0 2 0 700 370
preplace netloc dina_0_1 1 0 2 0J 170 360
preplace netloc dinb_0_1 1 0 2 NJ 250 NJ
preplace netloc en_0_1 1 0 1 30J 490n
preplace netloc en_1_1 1 0 1 20J 740n
preplace netloc ena_0_1 1 0 2 30J 110 NJ
preplace netloc enb_0_1 1 0 2 -10J 190 NJ
preplace netloc rst_clk_wiz_100M_peripheral_aresetn 1 0 2 30 710 380
preplace netloc timer_0_dout 1 2 1 720J 390n
preplace netloc timer_0_pwm 1 2 1 NJ 420
preplace netloc timer_en_0_1 1 0 2 NJ 390 NJ
preplace netloc we_0_1 1 0 1 10J 520n
preplace netloc we_1_1 1 0 1 -20J 770n
preplace netloc wea_0_1 1 0 2 20J 130 400
preplace netloc web_0_1 1 0 2 -20J 210 NJ
preplace netloc write_data_0_1 1 0 1 -20J 580n
preplace netloc write_data_1_1 1 0 1 NJ 830
preplace netloc AXI_memory_controller_0_M_AXI 1 1 1 N 570
preplace netloc AXI_memory_controller_1_M_AXI 1 1 1 N 800
levelinfo -pg 1 -40 190 560 740
pagesize -pg 1 -db -bbox -sgen -220 -10 920 930
"
}

  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
  close_bd_design $design_name 
}
# End of cr_bd_mem_ctrl_test()
cr_bd_mem_ctrl_test ""
set_property GENERATE_SYNTH_CHECKPOINT "0" [get_files mem_ctrl_test.bd ] 
set_property REGISTERED_WITH_MANAGER "1" [get_files mem_ctrl_test.bd ] 
set_property USED_IN "simulation" [get_files mem_ctrl_test.bd ] 
set_property USED_IN_IMPLEMENTATION "0" [get_files mem_ctrl_test.bd ] 
set_property USED_IN_SYNTHESIS "0" [get_files mem_ctrl_test.bd ] 

if { [get_files BTPU_memory.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/BTPU_memory/BTPU_memory.xci
}
if { [get_files axi_btpu_ctrl.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/axi_btpu_ctrl/axi_btpu_ctrl.xci
}
if { [get_files data_memory.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/data_memory/data_memory.xci
}
if { [get_files axi_bram_ctrl_0.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/axi_bram_ctrl_0/axi_bram_ctrl_0.xci
}
if { [get_files instruction_mem.xci] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/ip/instruction_mem/instruction_mem.xci
}
if { [get_files AXI_memory_controller.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/axi/AXI_memory_controller.vhd
}
if { [get_files utilities_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/utilities_pkg.vhd
}
if { [get_files BNN_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/BNN_pkg.vhd
}
if { [get_files types_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/types_pkg.vhd
}
if { [get_files constant_package.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/constant_package.vhd
}
if { [get_files memory_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/memory_pkg.vhd
}
if { [get_files compressor_layer.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/compressor_layer.vhd
}
if { [get_files popcounter_tree.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/popcounter_tree.vhd
}
if { [get_files ternary_adder.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/ternary_adder.vhd
}
if { [get_files popcounter.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/popcounter.vhd
}
if { [get_files binary_mac.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/binary_mac.vhd
}
if { [get_files BTPU_MAC.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/BTPU_MAC.vhd
}
if { [get_files BTPU.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/BTPU.vhd
}
if { [get_files instruction_fetch.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/IF/instruction_fetch.vhd
}
if { [get_files triple_port_ram.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/ID/triple_port_ram.vhd
}
if { [get_files sign_extender_ro.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/ID/sign_extender_ro.vhd
}
if { [get_files istruction_decode.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/ID/istruction_decode.vhd
}
if { [get_files barrel_shifter.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/IE/barrel_shifter.vhd
}
if { [get_files alu.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/IE/alu.vhd
}
if { [get_files comparator.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/IE/comparator.vhd
}
if { [get_files execute.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/IE/execute.vhd
}
if { [get_files address_manager.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/MEM_WB/address_manager.vhd
}
if { [get_files memory_write_back.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/MEM_WB/memory_write_back.vhd
}
if { [get_files GPIO.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/GPIO.vhd
}
if { [get_files i2c_utils_pkg.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/packages/i2c_utils_pkg.vhd
}
if { [get_files I2C_driver.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/I2C_driver.vhd
}
if { [get_files I2C_module.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/I2C_module.vhd
}
if { [get_files oled_driver.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/oled_driver/oled_driver.vhd
}
if { [get_files timer.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/timer.vhd
}
if { [get_files ascii_rom.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/oled_driver/ascii_rom.vhd
}
if { [get_files compressor_6_3.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/bnn/compressor_6_3.vhd
}
if { [get_files delay_module.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/oled_driver/delay_module.vhd
}
if { [get_files oled_counter.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/oled_driver/oled_counter.vhd
}
if { [get_files spi_controller.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/periph/oled_driver/spi_controller.vhd
}
if { [get_files CPU.vhd] == "" } {
  import_files -quiet -fileset sources_1 $origin_dir/src/hdl/cpu/CPU.vhd
}


# Proc to create BD test_design
proc cr_bd_test_design { parentCell } {
# The design that will be created by this Tcl proc contains the following 
# module references:
# CPU



  # CHANGE DESIGN NAME HERE
  set design_name test_design

  common::send_gid_msg -ssname BD::TCL -id 2010 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

  create_bd_design $design_name

  set bCheckIPsPassed 1
  ##################################################################
  # CHECK IPs
  ##################################################################
  set bCheckIPs 1
  if { $bCheckIPs == 1 } {
     set list_check_ips "\ 
  xilinx.com:ip:axi_cdma:4.1\
  xilinx.com:ip:axi_vip:1.1\
  "

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

  }

  ##################################################################
  # CHECK Modules
  ##################################################################
  set bCheckModules 1
  if { $bCheckModules == 1 } {
     set list_check_mods "\ 
  CPU\
  "

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

  if { $bCheckIPsPassed != 1 } {
    common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
    return 3
  }

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set GPIO_0 [ create_bd_port -dir IO -from 31 -to 0 GPIO_0 ]
  set SCL_0 [ create_bd_port -dir IO SCL_0 ]
  set SDA_0 [ create_bd_port -dir IO SDA_0 ]
  set btn_center_0 [ create_bd_port -dir I btn_center_0 ]
  set btn_down_0 [ create_bd_port -dir I btn_down_0 ]
  set btn_left_0 [ create_bd_port -dir I btn_left_0 ]
  set btn_right_0 [ create_bd_port -dir I btn_right_0 ]
  set btn_up_0 [ create_bd_port -dir I btn_up_0 ]
  set clk_100MHz_0 [ create_bd_port -dir I clk_100MHz_0 ]
  set leds_0 [ create_bd_port -dir O -from 2 -to 0 leds_0 ]
  set oled_dc_0 [ create_bd_port -dir O oled_dc_0 ]
  set oled_res_0 [ create_bd_port -dir O oled_res_0 ]
  set oled_sclk_0 [ create_bd_port -dir O oled_sclk_0 ]
  set oled_sdin_0 [ create_bd_port -dir O oled_sdin_0 ]
  set oled_select0_0 [ create_bd_port -dir I oled_select0_0 ]
  set oled_vbat_0 [ create_bd_port -dir O oled_vbat_0 ]
  set oled_vdd_0 [ create_bd_port -dir O oled_vdd_0 ]
  set reset_rtl [ create_bd_port -dir I -type rst reset_rtl ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $reset_rtl
  set run_in_0 [ create_bd_port -dir I run_in_0 ]
  set run_out_0 [ create_bd_port -dir O run_out_0 ]
  set switches_0 [ create_bd_port -dir I -from 1 -to 0 switches_0 ]
  set sys_clock [ create_bd_port -dir I -type clk -freq_hz 100000000 sys_clock ]
  set_property -dict [ list \
   CONFIG.PHASE {0.0} \
 ] $sys_clock

  # Create instance: CPU_0, and set properties
  set block_name CPU
  set block_cell_name CPU_0
  if { [catch {set CPU_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $CPU_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.BTPU_SIMULATION {true} \
   CONFIG.IS_STANDALONE {false} \
   CONFIG.RUN_BLINK_COUNTER_SIZE {2} \
 ] $CPU_0

  # Create instance: CPU_0_axi_periph, and set properties
  set CPU_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 CPU_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {5} \
   CONFIG.NUM_SI {4} \
   CONFIG.STRATEGY {1} \
 ] $CPU_0_axi_periph

  # Create instance: axi_cdma_0, and set properties
  set axi_cdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_cdma:4.1 axi_cdma_0 ]

  # Create instance: axi_vip_0, and set properties
  set axi_vip_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_0

  # Create instance: axi_vip_1, and set properties
  set axi_vip_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_1 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
   CONFIG.PROTOCOL {AXI4LITE} \
 ] $axi_vip_1

  # Create interface connections
  connect_bd_intf_net -intf_net CPU_0_M_AXI [get_bd_intf_pins CPU_0/M_AXI] [get_bd_intf_pins CPU_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net CPU_0_axi_periph_M00_AXI [get_bd_intf_pins CPU_0_axi_periph/M00_AXI] [get_bd_intf_pins axi_cdma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net CPU_0_axi_periph_M01_AXI [get_bd_intf_pins CPU_0_axi_periph/M01_AXI] [get_bd_intf_pins axi_vip_1/S_AXI]
  connect_bd_intf_net -intf_net CPU_0_axi_periph_M02_AXI [get_bd_intf_pins CPU_0/s_axi_btpu] [get_bd_intf_pins CPU_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net CPU_0_axi_periph_M03_AXI [get_bd_intf_pins CPU_0/s_axi_d] [get_bd_intf_pins CPU_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net CPU_0_axi_periph_M04_AXI [get_bd_intf_pins CPU_0/s_axi_i] [get_bd_intf_pins CPU_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net axi_cdma_0_M_AXI [get_bd_intf_pins CPU_0_axi_periph/S01_AXI] [get_bd_intf_pins axi_cdma_0/M_AXI]
  connect_bd_intf_net -intf_net axi_cdma_0_M_AXI_SG [get_bd_intf_pins CPU_0_axi_periph/S02_AXI] [get_bd_intf_pins axi_cdma_0/M_AXI_SG]
  connect_bd_intf_net -intf_net axi_vip_0_M_AXI [get_bd_intf_pins CPU_0_axi_periph/S03_AXI] [get_bd_intf_pins axi_vip_0/M_AXI]

  # Create port connections
  connect_bd_net -net CPU_0_leds [get_bd_ports leds_0] [get_bd_pins CPU_0/leds]
  connect_bd_net -net CPU_0_oled_dc [get_bd_ports oled_dc_0] [get_bd_pins CPU_0/oled_dc]
  connect_bd_net -net CPU_0_oled_res [get_bd_ports oled_res_0] [get_bd_pins CPU_0/oled_res]
  connect_bd_net -net CPU_0_oled_sclk [get_bd_ports oled_sclk_0] [get_bd_pins CPU_0/oled_sclk]
  connect_bd_net -net CPU_0_oled_sdin [get_bd_ports oled_sdin_0] [get_bd_pins CPU_0/oled_sdin]
  connect_bd_net -net CPU_0_oled_vbat [get_bd_ports oled_vbat_0] [get_bd_pins CPU_0/oled_vbat]
  connect_bd_net -net CPU_0_oled_vdd [get_bd_ports oled_vdd_0] [get_bd_pins CPU_0/oled_vdd]
  connect_bd_net -net CPU_0_run_out [get_bd_ports run_out_0] [get_bd_pins CPU_0/run_out]
  connect_bd_net -net Net [get_bd_ports GPIO_0] [get_bd_pins CPU_0/GPIO]
  connect_bd_net -net Net1 [get_bd_ports SDA_0] [get_bd_pins CPU_0/SDA]
  connect_bd_net -net Net2 [get_bd_ports SCL_0] [get_bd_pins CPU_0/SCL]
  connect_bd_net -net axi_cdma_0_cdma_introut [get_bd_pins CPU_0/cdma_interrupt] [get_bd_pins axi_cdma_0/cdma_introut]
  connect_bd_net -net btn_center_0_1 [get_bd_ports btn_center_0] [get_bd_pins CPU_0/btn_center]
  connect_bd_net -net btn_down_0_1 [get_bd_ports btn_down_0] [get_bd_pins CPU_0/btn_down]
  connect_bd_net -net btn_left_0_1 [get_bd_ports btn_left_0] [get_bd_pins CPU_0/btn_left]
  connect_bd_net -net btn_right_0_1 [get_bd_ports btn_right_0] [get_bd_pins CPU_0/btn_right]
  connect_bd_net -net btn_up_0_1 [get_bd_ports btn_up_0] [get_bd_pins CPU_0/btn_up]
  connect_bd_net -net clk_100MHz_0_1 [get_bd_ports clk_100MHz_0] [get_bd_pins CPU_0/clk_100MHz]
  connect_bd_net -net clk_wiz_clk_out1 [get_bd_ports sys_clock] [get_bd_pins CPU_0/clk] [get_bd_pins CPU_0_axi_periph/ACLK] [get_bd_pins CPU_0_axi_periph/M00_ACLK] [get_bd_pins CPU_0_axi_periph/M01_ACLK] [get_bd_pins CPU_0_axi_periph/M02_ACLK] [get_bd_pins CPU_0_axi_periph/M03_ACLK] [get_bd_pins CPU_0_axi_periph/M04_ACLK] [get_bd_pins CPU_0_axi_periph/S00_ACLK] [get_bd_pins CPU_0_axi_periph/S01_ACLK] [get_bd_pins CPU_0_axi_periph/S02_ACLK] [get_bd_pins CPU_0_axi_periph/S03_ACLK] [get_bd_pins axi_cdma_0/m_axi_aclk] [get_bd_pins axi_cdma_0/s_axi_lite_aclk] [get_bd_pins axi_vip_0/aclk] [get_bd_pins axi_vip_1/aclk]
  connect_bd_net -net oled_select0_0_1 [get_bd_ports oled_select0_0] [get_bd_pins CPU_0/oled_select0]
  connect_bd_net -net rst_clk_wiz_100M_peripheral_aresetn [get_bd_ports reset_rtl] [get_bd_pins CPU_0/res_in] [get_bd_pins CPU_0_axi_periph/ARESETN] [get_bd_pins CPU_0_axi_periph/M00_ARESETN] [get_bd_pins CPU_0_axi_periph/M01_ARESETN] [get_bd_pins CPU_0_axi_periph/M02_ARESETN] [get_bd_pins CPU_0_axi_periph/M03_ARESETN] [get_bd_pins CPU_0_axi_periph/M04_ARESETN] [get_bd_pins CPU_0_axi_periph/S00_ARESETN] [get_bd_pins CPU_0_axi_periph/S01_ARESETN] [get_bd_pins CPU_0_axi_periph/S02_ARESETN] [get_bd_pins CPU_0_axi_periph/S03_ARESETN] [get_bd_pins axi_cdma_0/s_axi_lite_aresetn] [get_bd_pins axi_vip_0/aresetn] [get_bd_pins axi_vip_1/aresetn]
  connect_bd_net -net run_in_0_1 [get_bd_ports run_in_0] [get_bd_pins CPU_0/run_in]
  connect_bd_net -net switches_0_1 [get_bd_ports switches_0] [get_bd_pins CPU_0/switches]

  # Create address segments
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs CPU_0/s_axi_i/reg0] -force
  assign_bd_address -offset 0x40030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xE0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs axi_vip_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs CPU_0/s_axi_i/reg0] -force
  assign_bd_address -offset 0x40080000 -range 0x00080000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs CPU_0/s_axi_btpu/reg0] -force
  assign_bd_address -offset 0x40080000 -range 0x00080000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs CPU_0/s_axi_btpu/reg0] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs CPU_0/s_axi_d/reg0] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs CPU_0/s_axi_d/reg0] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs CPU_0/s_axi_i/reg0] -force
  assign_bd_address -offset 0xE0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs axi_vip_1/S_AXI/Reg] -force
  assign_bd_address -offset 0xE0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs axi_vip_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs CPU_0/s_axi_d/reg0] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs CPU_0/s_axi_i/reg0] -force
  assign_bd_address -offset 0x40080000 -range 0x00080000 -target_address_space [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs CPU_0/s_axi_btpu/reg0] -force
  assign_bd_address -offset 0x40030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xE0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs axi_vip_1/S_AXI/Reg] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs CPU_0/s_axi_d/reg0]
  exclude_bd_addr_seg -offset 0x40080000 -range 0x00080000 -target_address_space [get_bd_addr_spaces CPU_0/M_AXI] [get_bd_addr_segs CPU_0/s_axi_btpu/reg0]
  exclude_bd_addr_seg -offset 0x40030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg]
  exclude_bd_addr_seg -offset 0x40030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg]

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   "ActiveEmotionalView":"Default View",
   "Default View_ScaleFactor":"0.638636",
   "Default View_TopLeft":"-376,0",
   "ExpandedHierarchyInLayout":"",
   "guistr":"# # String gsaved with Nlview 7.0r4  2019-12-20 bk=1.5203 VDI=41 GEI=36 GUI=JA:10.0 TLS
#  -string -flagsOSRD
preplace port port-id_SCL_0 -pg 1 -lvl 4 -x 1210 -y 80 -defaultsOSRD
preplace port port-id_SDA_0 -pg 1 -lvl 4 -x 1210 -y 50 -defaultsOSRD
preplace port port-id_btn_center_0 -pg 1 -lvl 0 -x -40 -y 250 -defaultsOSRD
preplace port port-id_btn_down_0 -pg 1 -lvl 0 -x -40 -y 160 -defaultsOSRD
preplace port port-id_btn_left_0 -pg 1 -lvl 0 -x -40 -y 190 -defaultsOSRD
preplace port port-id_btn_right_0 -pg 1 -lvl 0 -x -40 -y 220 -defaultsOSRD
preplace port port-id_btn_up_0 -pg 1 -lvl 0 -x -40 -y 130 -defaultsOSRD
preplace port port-id_clk_100MHz_0 -pg 1 -lvl 0 -x -40 -y 70 -defaultsOSRD
preplace port port-id_oled_dc_0 -pg 1 -lvl 4 -x 1210 -y 230 -defaultsOSRD
preplace port port-id_oled_res_0 -pg 1 -lvl 4 -x 1210 -y 260 -defaultsOSRD
preplace port port-id_oled_sclk_0 -pg 1 -lvl 4 -x 1210 -y 200 -defaultsOSRD
preplace port port-id_oled_sdin_0 -pg 1 -lvl 4 -x 1210 -y 170 -defaultsOSRD
preplace port port-id_oled_select0_0 -pg 1 -lvl 0 -x -40 -y 310 -defaultsOSRD
preplace port port-id_oled_vbat_0 -pg 1 -lvl 4 -x 1210 -y 290 -defaultsOSRD
preplace port port-id_oled_vdd_0 -pg 1 -lvl 4 -x 1210 -y 320 -defaultsOSRD
preplace port port-id_reset_rtl -pg 1 -lvl 0 -x -40 -y 430 -defaultsOSRD
preplace port port-id_run_in_0 -pg 1 -lvl 0 -x -40 -y 100 -defaultsOSRD
preplace port port-id_run_out_0 -pg 1 -lvl 4 -x 1210 -y 110 -defaultsOSRD
preplace port port-id_sys_clock -pg 1 -lvl 0 -x -40 -y 390 -defaultsOSRD
preplace portBus GPIO_0 -pg 1 -lvl 4 -x 1210 -y 20 -defaultsOSRD
preplace portBus leds_0 -pg 1 -lvl 4 -x 1210 -y 140 -defaultsOSRD
preplace portBus switches_0 -pg 1 -lvl 0 -x -40 -y 280 -defaultsOSRD
preplace inst CPU_0 -pg 1 -lvl 3 -x 960 -y 210 -defaultsOSRD
preplace inst CPU_0_axi_periph -pg 1 -lvl 2 -x 530 -y 590 -defaultsOSRD
preplace inst axi_cdma_0 -pg 1 -lvl 1 -x 180 -y 400 -defaultsOSRD
preplace inst axi_vip_0 -pg 1 -lvl 1 -x 180 -y 570 -defaultsOSRD
preplace inst axi_vip_1 -pg 1 -lvl 3 -x 960 -y 590 -defaultsOSRD
preplace netloc CPU_0_leds 1 3 1 1150J 140n
preplace netloc CPU_0_oled_dc 1 3 1 1180J 230n
preplace netloc CPU_0_oled_res 1 3 1 1190J 260n
preplace netloc CPU_0_oled_sclk 1 3 1 1170J 200n
preplace netloc CPU_0_oled_sdin 1 3 1 1160J 170n
preplace netloc CPU_0_oled_vbat 1 3 1 1140J 290n
preplace netloc CPU_0_oled_vdd 1 3 1 NJ 320
preplace netloc CPU_0_run_out 1 3 1 1140J 110n
preplace netloc Net 1 3 1 1110J 20n
preplace netloc Net1 1 3 1 1120J 50n
preplace netloc Net2 1 3 1 1130J 80n
preplace netloc axi_cdma_0_cdma_introut 1 1 2 330 300 690J
preplace netloc btn_center_0_1 1 0 3 -20J 260 NJ 260 750J
preplace netloc btn_down_0_1 1 0 3 NJ 160 NJ 160 810J
preplace netloc btn_left_0_1 1 0 3 NJ 190 NJ 190 800J
preplace netloc btn_right_0_1 1 0 3 -20J 240 NJ 240 760J
preplace netloc btn_up_0_1 1 0 3 NJ 130 NJ 130 780J
preplace netloc clk_100MHz_0_1 1 0 3 NJ 70 NJ 70 680J
preplace netloc clk_wiz_clk_out1 1 0 3 -10 300 320 250 790
preplace netloc oled_select0_0_1 1 0 3 -20J 270 NJ 270 710J
preplace netloc rst_clk_wiz_100M_peripheral_aresetn 1 0 3 0 310 340 290 740
preplace netloc run_in_0_1 1 0 3 NJ 100 NJ 100 820J
preplace netloc switches_0_1 1 0 3 NJ 280 NJ 280 700J
preplace netloc CPU_0_M_AXI 1 1 3 350 10 NJ 10 1100
preplace netloc CPU_0_axi_periph_M00_AXI 1 0 3 10 230 NJ 230 680
preplace netloc CPU_0_axi_periph_M01_AXI 1 2 1 N 570
preplace netloc CPU_0_axi_periph_M02_AXI 1 2 1 720 70n
preplace netloc CPU_0_axi_periph_M03_AXI 1 2 1 730 90n
preplace netloc CPU_0_axi_periph_M04_AXI 1 2 1 770 110n
preplace netloc axi_cdma_0_M_AXI 1 1 1 N 380
preplace netloc axi_cdma_0_M_AXI_SG 1 1 1 N 400
preplace netloc axi_vip_0_M_AXI 1 1 1 350 420n
levelinfo -pg 1 -40 180 530 960 1210
pagesize -pg 1 -db -bbox -sgen -200 0 1350 880
"
}

  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
  close_bd_design $design_name 
}
# End of cr_bd_test_design()
cr_bd_test_design ""
set_property GENERATE_SYNTH_CHECKPOINT "0" [get_files test_design.bd ] 
set_property REGISTERED_WITH_MANAGER "1" [get_files test_design.bd ] 
set_property USED_IN "simulation" [get_files test_design.bd ] 
set_property USED_IN_IMPLEMENTATION "0" [get_files test_design.bd ] 
set_property USED_IN_SYNTHESIS "0" [get_files test_design.bd ] 

#call make_wrapper to create wrapper files
if { [get_property IS_LOCKED [ get_files -norecurse top_level.bd] ] == 1  } {
  import_files -fileset sources_1 [file normalize "${origin_dir}/vivado/CPU.gen/sources_1/bd/top_level/hdl/top_level_wrapper.vhd" ]
} else {
  set wrapper_path [make_wrapper -fileset sources_1 -files [ get_files -norecurse top_level.bd] -top]
  add_files -norecurse -fileset sources_1 $wrapper_path
}

if { [get_property IS_LOCKED [ get_files -norecurse top_level_dbg.bd] ] == 1  } {
  import_files -fileset sources_1 [file normalize "${origin_dir}/vivado/CPU.gen/sources_1/bd/top_level_dbg/hdl/top_level_dbg_wrapper.vhd" ]
} else {
  set wrapper_path [make_wrapper -fileset sources_1 -files [ get_files -norecurse top_level_dbg.bd] -top]
  add_files -norecurse -fileset sources_1 $wrapper_path
}

if { [get_property IS_LOCKED [ get_files -norecurse test_design_axi_recursive.bd] ] == 1  } {
  import_files -fileset sources_1 [file normalize "${origin_dir}/vivado/CPU.gen/sources_1/bd/test_design_axi_recursive/hdl/test_design_axi_recursive_wrapper.vhd" ]
} else {
  set wrapper_path [make_wrapper -fileset sources_1 -files [ get_files -norecurse test_design_axi_recursive.bd] -top]
  add_files -norecurse -fileset sources_1 $wrapper_path
}

if { [get_property IS_LOCKED [ get_files -norecurse test_design.bd] ] == 1  } {
  import_files -fileset sources_1 [file normalize "${origin_dir}/vivado/CPU.gen/sources_1/bd/test_design/hdl/test_design_wrapper.vhd" ]
} else {
  set wrapper_path [make_wrapper -fileset sources_1 -files [ get_files -norecurse test_design.bd] -top]
  add_files -norecurse -fileset sources_1 $wrapper_path
}


set idrFlowPropertiesConstraints ""
catch {
 set idrFlowPropertiesConstraints [get_param runs.disableIDRFlowPropertyConstraints]
 set_param runs.disableIDRFlowPropertyConstraints 1
}

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -part xc7z020clg484-1 -flow {Vivado Synthesis 2021} -strategy "Vivado Synthesis Defaults" -report_strategy {No Reports} -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2021" [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Synthesis Default Reports} $obj
set_property set_report_strategy_name 0 $obj
# Create 'synth_1_synth_report_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs synth_1] synth_1_synth_report_utilization_0] "" ] } {
  create_report_config -report_name synth_1_synth_report_utilization_0 -report_type report_utilization:1.0 -steps synth_design -runs synth_1
}
set obj [get_report_configs -of_objects [get_runs synth_1] synth_1_synth_report_utilization_0]
if { $obj != "" } {

}
set obj [get_runs synth_1]
set_property -name "auto_incremental_checkpoint" -value "1" -objects $obj
set_property -name "strategy" -value "Vivado Synthesis Defaults" -objects $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 -part xc7z020clg484-1 -flow {Vivado Implementation 2021} -strategy "Vivado Implementation Defaults" -report_strategy {No Reports} -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
  set_property flow "Vivado Implementation 2021" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Implementation Default Reports} $obj
set_property set_report_strategy_name 0 $obj
# Create 'impl_1_init_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_init_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_init_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps init_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_init_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj

}
# Create 'impl_1_opt_report_drc_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_drc_0] "" ] } {
  create_report_config -report_name impl_1_opt_report_drc_0 -report_type report_drc:1.0 -steps opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_drc_0]
if { $obj != "" } {

}
# Create 'impl_1_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj

}
# Create 'impl_1_power_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_power_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_power_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps power_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_power_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj

}
# Create 'impl_1_place_report_io_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_io_0] "" ] } {
  create_report_config -report_name impl_1_place_report_io_0 -report_type report_io:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_io_0]
if { $obj != "" } {

}
# Create 'impl_1_place_report_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_utilization_0] "" ] } {
  create_report_config -report_name impl_1_place_report_utilization_0 -report_type report_utilization:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_utilization_0]
if { $obj != "" } {

}
# Create 'impl_1_place_report_control_sets_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_control_sets_0] "" ] } {
  create_report_config -report_name impl_1_place_report_control_sets_0 -report_type report_control_sets:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_control_sets_0]
if { $obj != "" } {
set_property -name "options.verbose" -value "1" -objects $obj

}
# Create 'impl_1_place_report_incremental_reuse_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_0] "" ] } {
  create_report_config -report_name impl_1_place_report_incremental_reuse_0 -report_type report_incremental_reuse:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_place_report_incremental_reuse_1' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_1] "" ] } {
  create_report_config -report_name impl_1_place_report_incremental_reuse_1 -report_type report_incremental_reuse:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_1]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_place_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_place_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj

}
# Create 'impl_1_post_place_power_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_post_place_power_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_post_place_power_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps post_place_power_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_post_place_power_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj

}
# Create 'impl_1_phys_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_phys_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_phys_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps phys_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_phys_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj

}
# Create 'impl_1_route_report_drc_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_drc_0] "" ] } {
  create_report_config -report_name impl_1_route_report_drc_0 -report_type report_drc:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_drc_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_methodology_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_methodology_0] "" ] } {
  create_report_config -report_name impl_1_route_report_methodology_0 -report_type report_methodology:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_methodology_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_power_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_power_0] "" ] } {
  create_report_config -report_name impl_1_route_report_power_0 -report_type report_power:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_power_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_route_status_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_route_status_0] "" ] } {
  create_report_config -report_name impl_1_route_report_route_status_0 -report_type report_route_status:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_route_status_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_route_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_timing_summary_0]
if { $obj != "" } {
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj

}
# Create 'impl_1_route_report_incremental_reuse_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_incremental_reuse_0] "" ] } {
  create_report_config -report_name impl_1_route_report_incremental_reuse_0 -report_type report_incremental_reuse:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_incremental_reuse_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_clock_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_clock_utilization_0] "" ] } {
  create_report_config -report_name impl_1_route_report_clock_utilization_0 -report_type report_clock_utilization:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_clock_utilization_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_bus_skew_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_bus_skew_0] "" ] } {
  create_report_config -report_name impl_1_route_report_bus_skew_0 -report_type report_bus_skew:1.1 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_bus_skew_0]
if { $obj != "" } {
set_property -name "options.warn_on_violation" -value "1" -objects $obj

}
# Create 'impl_1_post_route_phys_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_post_route_phys_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps post_route_phys_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj
set_property -name "options.warn_on_violation" -value "1" -objects $obj

}
# Create 'impl_1_post_route_phys_opt_report_bus_skew_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_bus_skew_0] "" ] } {
  create_report_config -report_name impl_1_post_route_phys_opt_report_bus_skew_0 -report_type report_bus_skew:1.1 -steps post_route_phys_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_bus_skew_0]
if { $obj != "" } {
set_property -name "options.warn_on_violation" -value "1" -objects $obj

}
set obj [get_runs impl_1]
set_property -name "strategy" -value "Vivado Implementation Defaults" -objects $obj
set_property -name "steps.write_bitstream.tcl.pre" -value "[file normalize "$origin_dir/scripts/write_bitstream_pre.tcl"]" -objects $obj
set_property -name "steps.write_bitstream.args.readback_file" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.verbose" -value "0" -objects $obj

# set the current impl run
current_run -implementation [get_runs impl_1]
catch {
 if { $idrFlowPropertiesConstraints != {} } {
   set_param runs.disableIDRFlowPropertyConstraints $idrFlowPropertiesConstraints
 }
}

puts "INFO: Project created:${_xil_proj_name_}"
# Create 'drc_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "drc_1" ] ] ""]} {
create_dashboard_gadget -name {drc_1} -type drc
}
set obj [get_dashboard_gadgets [ list "drc_1" ] ]
set_property -name "reports" -value "impl_1#impl_1_route_report_drc_0" -objects $obj

# Create 'methodology_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "methodology_1" ] ] ""]} {
create_dashboard_gadget -name {methodology_1} -type methodology
}
set obj [get_dashboard_gadgets [ list "methodology_1" ] ]
set_property -name "reports" -value "impl_1#impl_1_route_report_methodology_0" -objects $obj

# Create 'power_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "power_1" ] ] ""]} {
create_dashboard_gadget -name {power_1} -type power
}
set obj [get_dashboard_gadgets [ list "power_1" ] ]
set_property -name "reports" -value "impl_1#impl_1_route_report_power_0" -objects $obj

# Create 'timing_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "timing_1" ] ] ""]} {
create_dashboard_gadget -name {timing_1} -type timing
}
set obj [get_dashboard_gadgets [ list "timing_1" ] ]
set_property -name "reports" -value "impl_1#impl_1_route_report_timing_summary_0" -objects $obj

# Create 'utilization_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "utilization_1" ] ] ""]} {
create_dashboard_gadget -name {utilization_1} -type utilization
}
set obj [get_dashboard_gadgets [ list "utilization_1" ] ]
set_property -name "reports" -value "synth_1#synth_1_synth_report_utilization_0" -objects $obj
set_property -name "run.step" -value "synth_design" -objects $obj
set_property -name "run.type" -value "synthesis" -objects $obj

# Create 'utilization_2' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "utilization_2" ] ] ""]} {
create_dashboard_gadget -name {utilization_2} -type utilization
}
set obj [get_dashboard_gadgets [ list "utilization_2" ] ]
set_property -name "reports" -value "impl_1#impl_1_place_report_utilization_0" -objects $obj

move_dashboard_gadget -name {utilization_1} -row 0 -col 0
move_dashboard_gadget -name {power_1} -row 1 -col 0
move_dashboard_gadget -name {drc_1} -row 2 -col 0
move_dashboard_gadget -name {timing_1} -row 0 -col 1
move_dashboard_gadget -name {utilization_2} -row 1 -col 1
move_dashboard_gadget -name {methodology_1} -row 2 -col 1
