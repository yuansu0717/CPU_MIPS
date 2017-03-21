
/*
CPU name (
    .rst(),
    .clk(),
    .instr(),   //指令由IM给出
    .data_from_DM(),  //from DM
    //out
    .pc_out(),
    .read_en_DM(),
    .write_en_DM(),
    .addr_DM(),
    .data_to_DM()
    
    .control_reg(),
    .data_reg_counter()
    )
 */

module CPU (
    input rst,     //复位
    input clk,     //时钟
    input [31:0]instr,     //指令由IM�?
    input [31:0]data_from_DM,  //数据输入，由DM�?
    //input clk_RF,         // 寄存器的时钟（需要不同时钟域吗？�?

    output   [31:0] pc_out,       //�?要引出PC的�?�，DM的控制（读写信号），DM的ADDR，DM的data_from_DM
    output   read_en_DM,
    output   write_en_DM,
    output   [31:0]addr_DM,
    output   [31:0]data_to_DM,

    /********************************ports for peripherals****************/
    output  wire [31:0] control_reg, //15号寄存器
    output  wire [31:0] data_reg_counter

    /****************************end of ports for peripherals*********************/
    );

/*
///wires for peripherals//
wire [31:0] control_reg;
wire [31:0] data_reg_counter; //data reg for counter_timer

///ports for counter_timer//
wire work = control_reg[0];   
wire mode_choose = control_reg[1];
wire rst_soft = control_reg[2];
/*


/****************end of wires for peripherals*******************/

reg [1:0] pc_enable;

always @ (posedge clk or posedge rst)begin
    if(rst == 1 || pc_enable==2) pc_enable<=0;
    else pc_enable<=pc_enable+1;
end

//确定PC下一个�??
reg [31:0] pc;
reg [31:0] pc_next;
reg [31:0]pc_jump;
reg [31:0]pc_branch;
reg [31:0]pc_4;


//指令从指令寄存器打出来后要分�?4个部�?
wire [5:0] op;    //31-16
wire [4:0] rs;    //25-21
wire [4:0] rt;    //20-16
wire [4:0] rd;    //15-11 
wire [4:0] shamt; //10-6
wire [5:0] funct; //5-0

wire [15:0] offset;  //15-0
assign offset = {rd,shamt,funct};
wire [25:0] jump_addr; //25-0
assign jump_addr = {rs,rt,rd,shamt,funct};

//ports from control unit///
wire Shamt_op;
wire RegDst;
wire ALUScr;
wire MemtoReg;
wire RegWrite;
wire MemRead;
wire MemWrite;
wire Branch;
wire Branch_bne;
wire [1:0]ALUOp;
wire Jump;
wire Jal;
///end of ports from control unit//

/////ALUpoart/////////////
wire [31:0] rs_o;
wire [31:0] rt_o;
wire [31:0] ALUscr1;                        //ALUscr1 时钟为RF�?1号输�?
wire [31:0] ALUscr2;                    
assign ALUscr1 =( Shamt_op == 1? {31'h0,shamt} :rs_o ) ;          //确定ALUscr1的来�?
assign ALUscr2 =( ALUScr == 1? ( { {16{offset[15]}},offset  }): rt_o ) ;   //确定ALUscr2来源
wire [31:0] ALU_out;
wire zero_tag;
wire [3:0] ALUcontr;
wire jr_tag;     
///////////END of ALU ports/////////////

wire [31:0] data_o_from_DM;

assign   data_o_from_DM = data_from_DM;
assign {op,rs,rt,rd,shamt,funct} = instr;

assign pc_out = pc;
assign read_en_DM =MemRead ;
assign write_en_DM =MemWrite ;
assign addr_DM =ALU_out ;
assign data_to_DM = rt_o ;




always @ (*)begin
    pc_4      <=  pc +1;
    pc_jump   <=  ({ pc_4[31:28],jump_addr,2'b00} >> 2 ); 
    pc_branch <=  pc + 1 +( { {14{offset[15]}},offset,2'b00} >> 2 );
end

always @(*)begin
    case({((Branch&&zero_tag)||(Branch_bne&&(~zero_tag))),(Jump&&Jal)})  //Jump = 0则无条件跳转
    2'b00:pc_next <= pc_jump;
    2'b01:pc_next <= pc_4;
    2'b10:pc_next <= pc_jump;
    2'b11:pc_next <= pc_branch;
  endcase
end

always @(posedge clk or posedge rst)begin
    if(rst) pc<=0;
    else if((pc_enable == 2)&&(jr_tag==0)) pc<=pc_next;
    else if ((jr_tag==1) && (pc_enable == 2)  )pc<=rs_o;
end

/*
//例化指令寄存�?
IM U1_IM (
    //in
    .clk_IM(), //不和CPU共用时钟，理论上比CPU要快
    .write_en(),
    .read_en(1'b1),
    .addr_ins(),
    .instruction(),

    .pc(pc),
    //out
    .instr({op,rs,rt,rd,shamt,funct})
    );
 
//例化控制单元
*//*
counter_timer U1_counter (
    .clk(clk),
    .rst(rst),
    .rst_soft(rst_soft),
    .work(work),
    .mode_choose(mode_choose),
    .data_in(data_reg_counter),

    .full_tag_counter(full_tag_counter),
    .zero_tag_timer(zero_tag_timer)
    );
*/


control_unit U2_CU (
    .op(op),
    .funct(funct),
    .control_o({Shamt_op,RegDst,ALUScr,MemtoReg,RegWrite,MemRead,MemWrite,Branch,Branch_bne,ALUOp,Jump,Jal})
    );


//例化regfile
regfile U3_RF (
    .rst(rst),
    .clk_RF(clk),
    .i_write_enable(RegWrite&&(pc_enable == 1)),
    .i_rs_num(rs),
    .i_rt_num(rt),
    .i_wr_num((RegDst == 1?rd:(Jal == 0?5'b11111:rt))),   //写入的号 RD RT �? JAL时的 $ra�?1
    .i_data_rf( (MemtoReg == 1? data_o_from_DM : (Jal == 0? pc_4:ALU_out))  ),  //DM.ALU_out,Jal的pc+4选一�?
    .rs_o(rs_o),
    .rt_o(rt_o),

    .control_reg(control_reg),
    .data_reg_counter(data_reg_counter)
    );


ALU U4_ALU (
  .op1_i(ALUscr1),
  .op2_i(ALUscr2),
  .ALUcontr(ALUcontr),  //由ALUcontr引出
  //out
  .result_o( ALU_out ),
  .zero_tag( zero_tag ),
  .jr_tag(jr_tag)
  );



ALU_control U5_ALUCT (
    .func(funct),
    .ALUop(ALUOp),
    .ALUcontr_o(ALUcontr)
    );
/*
DM U6_DM(
    .clk_DM(), //与CPU不一�?
    .addr_i(ALU_out), 
    .re_i(MemRead),
    .wr_i(MemWrite),
    .data_i(rt_o),
    .data_o(data_o_from_DM)
    );
    */

endmodule