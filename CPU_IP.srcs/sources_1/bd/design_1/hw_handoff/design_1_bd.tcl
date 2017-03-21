
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2016.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# counter_timer, fre_div

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg484-1
   set_property BOARD_PART em.avnet.com:zed:part0:1.3 [current_project]
}


# CHANGE DESIGN NAME HERE
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set clk_in [ create_bd_port -dir I clk_in ]
  set full_tag_counter [ create_bd_port -dir O full_tag_counter ]
  set rst [ create_bd_port -dir I -type rst rst ]
  set zero_tag_timer [ create_bd_port -dir O zero_tag_timer ]

  # Create instance: CPU_0, and set properties
  set CPU_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:CPU:1.0 CPU_0 ]

  # Create instance: DM, and set properties
  set DM [ create_bd_cell -type ip -vlnv xilinx.com:ip:dist_mem_gen:8.0 DM ]
  set_property -dict [ list \
CONFIG.coefficient_file {../../../../imports/MIPS_FPGA/DM.coe} \
CONFIG.data_width {32} \
CONFIG.depth {128} \
 ] $DM

  # Create instance: IM, and set properties
  set IM [ create_bd_cell -type ip -vlnv xilinx.com:ip:dist_mem_gen:8.0 IM ]
  set_property -dict [ list \
CONFIG.coefficient_file {../../../../imports/MIPS_FPGA/IM.coe} \
CONFIG.data_width {32} \
CONFIG.depth {128} \
CONFIG.memory_type {rom} \
 ] $IM

  # Create instance: counter_timer_0, and set properties
  set block_name counter_timer
  set block_cell_name counter_timer_0
  if { [catch {set counter_timer_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $counter_timer_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: fre_div_0, and set properties
  set block_name fre_div
  set block_cell_name fre_div_0
  if { [catch {set fre_div_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $fre_div_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create port connections
  connect_bd_net -net CPU_0_addr_DM [get_bd_pins CPU_0/addr_DM] [get_bd_pins DM/a]
  connect_bd_net -net CPU_0_control_reg [get_bd_pins CPU_0/control_reg] [get_bd_pins counter_timer_0/control_reg]
  connect_bd_net -net CPU_0_data_reg_counter [get_bd_pins CPU_0/data_reg_counter] [get_bd_pins counter_timer_0/data_in]
  connect_bd_net -net CPU_0_data_to_DM [get_bd_pins CPU_0/data_to_DM] [get_bd_pins DM/d]
  connect_bd_net -net CPU_0_pc_out [get_bd_pins CPU_0/pc_out] [get_bd_pins IM/a]
  connect_bd_net -net CPU_0_write_en_DM [get_bd_pins CPU_0/write_en_DM] [get_bd_pins DM/we]
  connect_bd_net -net clk_in_1 [get_bd_ports clk_in] [get_bd_pins fre_div_0/clk_in]
  connect_bd_net -net counter_timer_0_full_tag_counter [get_bd_ports full_tag_counter] [get_bd_pins counter_timer_0/full_tag_counter]
  connect_bd_net -net counter_timer_0_zero_tag_timer [get_bd_ports zero_tag_timer] [get_bd_pins counter_timer_0/zero_tag_timer]
  connect_bd_net -net dist_mem_gen_0_spo [get_bd_pins CPU_0/instr] [get_bd_pins IM/spo]
  connect_bd_net -net dist_mem_gen_1_spo [get_bd_pins CPU_0/data_from_DM] [get_bd_pins DM/spo]
  connect_bd_net -net fre_div_0_clk [get_bd_pins CPU_0/clk] [get_bd_pins DM/clk] [get_bd_pins counter_timer_0/clk] [get_bd_pins fre_div_0/clk]
  connect_bd_net -net rst_1 [get_bd_ports rst] [get_bd_pins CPU_0/rst] [get_bd_pins counter_timer_0/rst] [get_bd_pins fre_div_0/rst]

  # Create address segments

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.12  2016-01-29 bk=1.3547 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port zero_tag_timer -pg 1 -y 340 -defaultsOSRD
preplace port clk_in -pg 1 -y 60 -defaultsOSRD
preplace port rst -pg 1 -y 80 -defaultsOSRD
preplace port full_tag_counter -pg 1 -y 320 -defaultsOSRD
preplace inst DM -pg 1 -lvl 2 -y 110 -defaultsOSRD
preplace inst fre_div_0 -pg 1 -lvl 1 -y 70 -defaultsOSRD
preplace inst IM -pg 1 -lvl 2 -y 240 -defaultsOSRD
preplace inst counter_timer_0 -pg 1 -lvl 4 -y 330 -defaultsOSRD
preplace inst CPU_0 -pg 1 -lvl 3 -y 170 -defaultsOSRD
preplace netloc CPU_0_data_reg_counter 1 3 1 770
preplace netloc fre_div_0_clk 1 1 3 180 300 420 300 NJ
preplace netloc CPU_0_write_en_DM 1 1 3 200 190 NJ 60 750
preplace netloc CPU_0_addr_DM 1 1 3 190 10 NJ 10 780
preplace netloc rst_1 1 0 4 20 10 NJ 20 430 40 NJ
preplace netloc clk_in_1 1 0 1 NJ
preplace netloc CPU_0_pc_out 1 1 3 200 290 NJ 290 760
preplace netloc dist_mem_gen_0_spo 1 2 1 NJ
preplace netloc counter_timer_0_zero_tag_timer 1 4 1 NJ
preplace netloc CPU_0_control_reg 1 3 1 780
preplace netloc CPU_0_data_to_DM 1 1 3 200 30 NJ 30 770
preplace netloc counter_timer_0_full_tag_counter 1 4 1 NJ
preplace netloc dist_mem_gen_1_spo 1 2 1 410
levelinfo -pg 1 0 100 300 590 950 1120 -top 0 -bot 410
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


