//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
//Date        : Sat Jan 14 17:30:47 2017
//Host        : sunlex-PC running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=5,numReposBlks=5,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=2,numPkgbdBlks=0,bdsource=USER,da_board_cnt=2,da_ps7_cnt=1,synth_mode=Global}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (clk_in,
    full_tag_counter,
    rst,
    zero_tag_timer);
  input clk_in;
  output full_tag_counter;
  input rst;
  output zero_tag_timer;

  wire [31:0]CPU_0_addr_DM;
  wire [31:0]CPU_0_control_reg;
  wire [31:0]CPU_0_data_reg_counter;
  wire [31:0]CPU_0_data_to_DM;
  wire [31:0]CPU_0_pc_out;
  wire CPU_0_write_en_DM;
  wire clk_in_1;
  wire counter_timer_0_full_tag_counter;
  wire counter_timer_0_zero_tag_timer;
  wire [31:0]dist_mem_gen_0_spo;
  wire [31:0]dist_mem_gen_1_spo;
  wire fre_div_0_clk;
  wire rst_1;

  assign clk_in_1 = clk_in;
  assign full_tag_counter = counter_timer_0_full_tag_counter;
  assign rst_1 = rst;
  assign zero_tag_timer = counter_timer_0_zero_tag_timer;
  design_1_CPU_0_0 CPU_0
       (.addr_DM(CPU_0_addr_DM),
        .clk(fre_div_0_clk),
        .control_reg(CPU_0_control_reg),
        .data_from_DM(dist_mem_gen_1_spo),
        .data_reg_counter(CPU_0_data_reg_counter),
        .data_to_DM(CPU_0_data_to_DM),
        .instr(dist_mem_gen_0_spo),
        .pc_out(CPU_0_pc_out),
        .rst(rst_1),
        .write_en_DM(CPU_0_write_en_DM));
  design_1_dist_mem_gen_1_0 DM
       (.a(CPU_0_addr_DM[6:0]),
        .clk(fre_div_0_clk),
        .d(CPU_0_data_to_DM),
        .spo(dist_mem_gen_1_spo),
        .we(CPU_0_write_en_DM));
  design_1_dist_mem_gen_0_1 IM
       (.a(CPU_0_pc_out[6:0]),
        .spo(dist_mem_gen_0_spo));
  design_1_counter_timer_0_1 counter_timer_0
       (.clk(fre_div_0_clk),
        .control_reg(CPU_0_control_reg),
        .data_in(CPU_0_data_reg_counter),
        .full_tag_counter(counter_timer_0_full_tag_counter),
        .rst(rst_1),
        .zero_tag_timer(counter_timer_0_zero_tag_timer));
  design_1_fre_div_0_0 fre_div_0
       (.clk(fre_div_0_clk),
        .clk_in(clk_in_1),
        .rst(rst_1));
endmodule
