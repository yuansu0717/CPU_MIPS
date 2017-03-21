//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
//Date        : Sat Jan 14 17:30:47 2017
//Host        : sunlex-PC running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (clk_in,
    full_tag_counter,
    rst,
    zero_tag_timer);
  input clk_in;
  output full_tag_counter;
  input rst;
  output zero_tag_timer;

  wire clk_in;
  wire full_tag_counter;
  wire rst;
  wire zero_tag_timer;

  design_1 design_1_i
       (.clk_in(clk_in),
        .full_tag_counter(full_tag_counter),
        .rst(rst),
        .zero_tag_timer(zero_tag_timer));
endmodule
