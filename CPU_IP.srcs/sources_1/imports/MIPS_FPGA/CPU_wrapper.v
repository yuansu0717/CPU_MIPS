module CPU_warpper (
    input clk,
    input rst,
    output wire full_tag_counter,
    output wire zero_tag_timer
    );

wire [31:0] instr;
wire [31:0] data_from_DM;
wire [31:0] pc_out;
wire read_en_DM,write_en_DM;
wire [31:0]addr_DM;
wire [31:0]data_to_DM;

counter_timer P_1_counter_timer (
    .clk(clk),
    .rst(rst),
   // .rst_soft(),
    .work(control_reg[0]),
    .mode_choose(control_reg[1]),
    .data_in(data_reg_counter),

    .full_tag_counter(full_tag_counter),
    .zero_tag_timer(zero_tag_timer)
    );

CPU U1_CPU (
    .rst(rst),
    .clk(clk),
    .instr(instr),   //指令由IM给出
    .data_from_DM(data_from_DM),  //from DM
    //out
    .pc_out(pc_out),
    .read_en_DM(read_en_DM),
    .write_en_DM(write_en_DM),
    .addr_DM(addr_DM),
    .data_to_DM(data_to_DM),
    .control_reg(control_reg),
    .data_reg_counter(data_reg_counter)
   // .zero_tag_timer(zero_tag_timer),
   // .full_tag_counter(full_tag_counter)
    );

IM U2_IM (
    //in
    //.clk_IM(),
    //.write_en(),
    .read_en(1'b1),
    //.addr_ins(),
    //.instruction(),
    .pc(pc_out),
    //out
    .instr(instr));

DM U3_DM(
    .clk_DM(clk),
    .addr_i(addr_DM),
    .re_i(read_en_DM),
    .wr_i(write_en_DM),
    .data_i(data_to_DM),
    .data_o(data_from_DM)
    );


endmodule


/*
module tb_MIPS();
  
  reg clk,rst;
  initial clk = 0;
  always #5 clk <= ~clk;
  CPU_top tb_CPU(
    .clk(clk),
    .rst(rst)
    );

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
end

  initial begin
    rst = 0;
    #11
    rst = 1;
    #10 rst=0;

    #650
    $finish;
  end

  
  
endmodule  
*/