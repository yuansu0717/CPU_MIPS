`define add 4'b0000
`define sub 4'b0001
`define and 4'b0110
`define or  4'b0111
`define xor 4'b1000
`define sll 4'b1001
`define srl 4'b1011
`define sra 4'b1010
`define slt 4'b1100
`define jr  4'b1101
/*
ALU_control name (
    .func(),
    .ALUop(),
    .ALUcontr_o()
    );
 */

module ALU_control(
    input  [5:0]func, //指令的func段 31-25,R型有用
    input  [1:0]ALUop,
    output reg [3:0]ALUcontr_o);

//reg ALUcontr_o;

always @(*) begin
    case(ALUop)
    0:ALUcontr_o<=`add;
    1:ALUcontr_o<=`sub;
    2:begin
        case(func)
         'h20:ALUcontr_o<=`add;
         'h24:ALUcontr_o<=`and;
         'h27:ALUcontr_o<=`xor;
         'h25:ALUcontr_o<=`or;
         'h00:ALUcontr_o<=`sll;
         'h03:ALUcontr_o<=`sra;
         'h22:ALUcontr_o<=`sub;
         'h2a:ALUcontr_o<=`slt;
         'h02:ALUcontr_o<=`srl;
         'h08:ALUcontr_o<=`jr ;
         default:ALUcontr_o<=4'hf;    //f代表没事
        endcase
       end
    default:ALUcontr_o<=4'hf;
    endcase
end

endmodule