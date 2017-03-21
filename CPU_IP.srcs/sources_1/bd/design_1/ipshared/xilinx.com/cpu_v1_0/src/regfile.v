
/*
regfile name (
    .clk_RF(),
    .i_write_enable(),
    .i_rs_num(),
    .i_rt_num(),
    .i_wr_num(),
    .i_data_rf()
    .rs_o(),
    .rt_o(),

    .control_reg(),
    .data_reg_counter()
    );
 */




module regfile (
    input rst,
    input clk_RF,
    input i_write_enable,
    input [4:0]i_rs_num,
    input [4:0]i_rt_num,
    input [4:0]i_wr_num,  //待写入的寄存器号
    input [31:0]i_data_rf,
    output wire [31:0]rs_o,
    output wire [31:0]rt_o,

    output wire [31:0] control_reg,
    output wire [31:0] data_reg_counter
    );


 (* ASYNC_REG = "TRUE" *)  reg [31:0]regs[0:31];   //寄存器堆

/******************************************ports for peripherals***************/

assign control_reg = regs[15] ;
assign data_reg_counter = regs[16];

/**************************end of ports for peripheral*******************/

integer i,j;
/*
initial begin  //寄存器初始化       
    for(i=0;i<32;i=i+1)
    regs[i]<=i;
end
initial begin
    #10
    regs[20]<=32'haa5a5a5c;
    regs[15]<=32'h0;
end
/*
always @ (posedge clk_RF or posedge rst)begin  //初始化，可综�?
    if(rst)begin
        for(i=0;i<15;i=i+1)
            regs[i]<=i;
        for(j=15;j<32;j=j+1)
            regs[j]<=j;
    end
end
*/


///////modelsim ONLY/////////////

initial begin  //寄存器初始化       
    for(i=0;i<32;i=i+1)
    regs[i]<=i;
end
initial begin
    #10
    regs[20]<=32'haa5a5a5c;
    regs[15]<=32'h0;
end
/*
always @(posedge clk_RF) begin
    if(i_write_enable)
        $display("regs[%0d] = %h",i_wr_num,regs[i_wr_num]);    //显示写入的�??
end

always @ (i_rs_num,i_rt_num,regs[i_rs_num],regs[i_rt_num]) begin
    $display("RS:regs[%0d] = %h",i_rs_num,regs[i_rs_num]);
    $display("RT:regs[%0d] = %h",i_rt_num,regs[i_rt_num]);
end
///End of Modelsim ONLY//////////////////////
*/

  //�?
assign  rs_o = regs[i_rs_num];
assign  rt_o = regs[i_rt_num];


always @(posedge clk_RF) begin    //�?
     if (i_write_enable == 1) begin   
        regs[i_wr_num]<=i_data_rf;
    end
end

endmodule