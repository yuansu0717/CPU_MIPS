//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
//Date        : Sat Jan 14 09:30:36 2017
//Host        : sunlex-PC running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (control_reg,
    data_reg_counter,
    reset_rtl,
    sys_clock);
  output [31:0]control_reg;
  output [31:0]data_reg_counter;
  input reset_rtl;
  input sys_clock;

  wire [31:0]control_reg;
  wire [31:0]data_reg_counter;
  wire reset_rtl;
  wire sys_clock;

  design_1 design_1_i
       (.control_reg(control_reg),
        .data_reg_counter(data_reg_counter),
        .reset_rtl(reset_rtl),
        .sys_clock(sys_clock));
endmodule
