/*
counter_timer name (
    .clk(),
    .rst(),
   // .rst_soft(),
    .work(),
    .mode_choose(),
    .data_in(),

    .full_tag_counter(),
    .zero_tag_timer()
    );
*/
 module counter_timer (
    input clk,
    input rst,     //硬件复位
  //  input rst_soft,   //软件复位，由15号寄存器控制
  input[31:0] control_reg,
   // input work,
   // input mode_choose,     //0:timer 1:counter
    input [31:0] data_in,
    output wire full_tag_counter,
    output wire zero_tag_timer
    );

  (* dont_touch = "yes" *)    reg [31:0] counter;
  (* dont_touch = "yes" *)    reg state;
(* dont_touch = "yes" *)       wire work ;
 (* dont_touch = "yes" *)    wire mode_choose = control_reg[1];
                            reg [11:0] num;
                    always @ (posedge clk or posedge rst)begin
                            if(rst)
                            num<=0;
                            else if(counter == 1)
                            num<=num+1;
                            end
               assign zero_tag_timer = num[11] ;            
                            
     assign work = control_reg[0] ;
   //  assign zero_tag_timer = counter[8];
     always @ (posedge clk or posedge rst)begin
        if(rst)
            counter<=0;
        else if(work & counter==0)
            counter<=data_in;
        else if(counter != 0)
            counter<=counter-1;
        end
        
         
     
     
     
     
   /*
always @(posedge clk or posedge rst) begin    //复位
    if (rst) begin
        counter <=0;
        full_tag_counter<=0;
        zero_tag_timer<=0;
        state<=0;
    end
    else if(work & (~state))begin
        counter <= data_in;
        state<=1;
    end
     else if (counter == 0 & work==1)begin
        state<=0;
        counter<=data_in;
        end
      else if (work==1)counter<=counter-1;
end



/**********************timer*****************/
/*
always @(posedge clk ) begin
  case(mode_choose)
  1'b0:begin
     if (work == 1 & (state==0) ) begin
        counter<=data_in;
        state<=1;
      end
      else if(counter==1 & (work==1) ) begin
        zero_tag_timer<=1;
        state<=0;
     end
     else if (work==1)begin
        counter<=counter-1;
     end
    end
  1'b1:begin
   if ( counter == (data_in-1) & work) begin
         counter<=0;
     end
     else if(work ) begin
         counter<=counter+1;
     end
     end
     endcase
    
end
/****************end of timer***************/

/**********************counter******************/
/*
always @(posedge (clk)) begin
     if ( counter == (data_in-1) && work && mode_choose) begin
        counter<=0;
    end
    else if(work && mode_choose) begin
        counter<=counter+1;
    end
end
/***************end of counter**********/

endmodule





/************tb for counter************/
/*
module tb_counter();

reg clk,rst,rst_soft,mode_choose,work;
reg [31:0] data_in;

wire full_tag_counter,zero_tag_timer;

counter_timer tb_counter (
    .clk(clk),
    .rst(rst),
    .rst_soft(rst_soft),
    .work(work),
    .mode_choose(mode_choose),
    .data_in(data_in),

    .full_tag_counter(full_tag_counter),
    .zero_tag_timer(zero_tag_timer)
    );

initial begin
    clk=0;
    rst_soft=0;
    rst=0;
end

always # 5 clk<=~clk;

initial begin
    #11
    mode_choose=1;
    rst=1;
    work=1;
    data_in=32'd10;
    #5
    rst=0;
end
endmodule
*/
/************end of tb for counter********************/