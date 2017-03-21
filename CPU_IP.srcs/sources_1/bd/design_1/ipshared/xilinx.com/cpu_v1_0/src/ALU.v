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
ALU name (
  .op1_i(),
  .op2_i(),
  .ALUcontr(),
  //out
  .result_o(),
  .zero_tag()
  );
 */


module ALU (
    input  wire [31:0]op1_i,
    input  wire [31:0]op2_i,
    input  wire [ 3:0]ALUcontr,
    output reg [31:0]result_o,
    output reg zero_tag,
    output reg jr_tag
    );
    
always @(*) begin
 case(ALUcontr)
    `add : begin result_o <= op1_i + op2_i; jr_tag <= 1'b0; end
    `sub : begin result_o <= op1_i - op2_i;  jr_tag <= 1'b0; end  
    `and : begin result_o <= op1_i & op2_i;jr_tag <= 1'b0; end

    `jr  : begin jr_tag <= 1'h1;result_o<=result_o; end
    
    `or  : begin result_o <= op1_i | op2_i;jr_tag <= 1'b0; end
    `xor : begin result_o <= op1_i ^ op2_i;jr_tag <= 1'b0; end

    `sll : begin result_o <= op2_i << op1_i ;jr_tag <= 1'b0; end
    `srl : begin result_o <= op2_i >> op1_i ;jr_tag <= 1'b0; end
    `sra : begin result_o <= {{31{op2_i[31]}},op2_i} >> op1_i ;jr_tag <= 1'b0; end

    `slt : begin if(op1_i < op2_i) result_o <= 32'd1;
           else  result_o <= 32'd0;
           end
    default : begin
      result_o<=32'hffff_ffff;
      jr_tag <= 1'b0; 
    end
 endcase
end
always @(result_o) begin
  if(result_o == 0) zero_tag <= 1;
  else  zero_tag<=0;
end

endmodule

