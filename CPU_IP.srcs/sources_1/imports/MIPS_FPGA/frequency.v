
/*
input: 100Mhz
output : 25Mhz
with 为分频倍数-1
 */








module fre_div
#(
   parameter width = 3 )

 (
    input clk_in,
    input rst,
    output clk
    );

reg [31:0]clk_counter;

always @ (posedge clk_in or posedge rst) begin
    if(rst)begin
        clk_counter <= 0;
        end
    else if (clk_counter == width) begin
        clk_counter<=0;
    end
    else begin
        clk_counter<=clk_counter+1;
    end

end
assign clk = clk_counter[1];
endmodule