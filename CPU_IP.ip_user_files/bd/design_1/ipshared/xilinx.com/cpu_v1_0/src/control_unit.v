// 控制单元为租了逻辑，不需要时钟，
// 需要6个输出（指令的[31:26]6位），输出10位
// 10位输出为 RegDst ALUScr MemtoReg RegWrite MemRead 
// MemWrite Branch ALUOp1 ALUOp0 Jump
// 输出的不关心位统一置为0

module control_unit (
    input      [5:0]op,
    input      [5:0]funct,
    output reg [12:0]control_o);
/*
wire RegDst;
wire ALUScr;
wire MemtoReg;
wire RegWrite;
wire MemRead;
wire MemWrite;
wire Branch;
wire [1:0]ALUOp;
wire Jump;

/*
assign Shamt_op   = control_o[12] ; 移位时需要用次位来指示ALUop1的来源， 1位来自于shamt 0 为 rs
assign RegDst     = control_o[11] ;
assign ALUScr     = control_o[10] ;
assign MemtoReg   = control_o[9] ;
assign RegWrite   = control_o[8] ;
assign MemRead    = control_o[7] ;
assign MemWrite   = control_o[6] ;
assign Branch     = control_o[5] ;
assign Branch_bne = control_o[4]
assign [1:0]ALUOp = control_o[3:2];
assign Jump       = control_o[1] ;   //0跳
assign Jal        = control_o[0]    // 0跳
*/

always @ (*)begin
    case(op)
    6'b000000:  begin    // R
             case(funct)
                   6'h0   : control_o <= 13'b110010000_10_11;  //sll
                   6'h3   : control_o <= 13'b110010000_10_11;  //sra
                   6'h2   : control_o <= 13'b110010000_10_11;  //srl
                   default: control_o <= 13'b010010000_10_11; //add sub xor and or
            endcase
            end                                 
    6'b100011: control_o <= 13'b001111000_00_11; //lw
    6'b101011: control_o <= 13'b001000100_00_11; //sw
    6'b000100: control_o <= 13'b000000010_01_11;  //beq
    6'b000010: control_o <= 13'b000000000_00_01;  //jump
    6'b000101: control_o <= 13'b000000001_01_11;   //bne
    6'b000011: control_o <= 13'b000010000_00_10;  //jal
    6'b001000: control_o <= 13'b001010000_00_11; //addi
    default:   control_o <= 13'b000000000_00_11;
  endcase
end

endmodule



