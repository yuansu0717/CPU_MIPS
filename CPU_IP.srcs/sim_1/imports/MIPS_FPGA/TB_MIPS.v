

module tb_MIPS();
  
  reg clk,rst;
  wire full_tag_counter,zero_tag_timer;
  initial clk = 0;
  always #5 clk <= ~clk;

  design_1_wrapper tb_CPU(
    .clk_in(clk),
    .rst(rst),
    .full_tag_counter(full_tag_counter),
    .zero_tag_timer(zero_tag_timer)
    );
/*
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
end
*/
  initial begin
    rst = 0;
    #11
    rst = 1;
    #20 rst=0;

    #200000000
    $finish;
  end
  
  
endmodule  