`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/01/14 09:33:18
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CPU_wrapper(
    input clk,
    input rst,
    output wire full_tag_counter,
    output wire zero_tag_timer
    );
    wire work ,mode_choose;
    wire [31:0] control_reg,data_reg_counter;

design_1_wrapper cpu
         (
        .control_reg(control_reg),
        .data_reg_counter(data_reg_counter),
        .reset_rtl(rst),
        .sys_clock(clk)
        );
  counter_timer P1_couter_timer (
            .clk(clk),
            .rst(rst),
           // .rst_soft(),
            .work(control_reg[0]),
            .mode_choose(control_reg[1]),
            .data_in(data_reg_counter),
        
            .full_tag_counter(full_tag_counter),
            .zero_tag_timer(zero_tag_timer)
            );
endmodule
