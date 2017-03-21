module tb_cpu_nomem ();
reg clk,rst;
reg [31:0]instr,data_from_DM;
wire [31:0] pc_out,addr_DM,data_to_DM,control_reg,data_reg_counter;
wire read_en_DM,write_en_DM;
integer i;

task delayx;
input   [31:0]  num;
begin
    repeat(num) begin
        @(posedge clk);
    end
    #1;
end
endtask


CPU cpu_nomem (
    .rst(rst),
    .clk(clk),
    .instr(instr),   //æŒ‡ä»¤ç”±IMç»™å‡º
    .data_from_DM(data_from_DM),  //from DM
    //out
    .pc_out(pc_out),
    .read_en_DM(read_en_DM),
    .write_en_DM(write_en_DM),
    .addr_DM(addr_DM),
    .data_to_DM(data_to_DM),
    
    .control_reg(control_reg),
    .data_reg_counter(data_reg_counter)
    );

initial begin
    clk = 0;
    rst = 0;
    $dumpfile("dump.vcd");
    $dumpvars();
end

always #5 clk<=~clk;



initial begin
    #11
    rst = 1;
    delayx(1);
    rst=0;
    delayx(2);

    data_from_DM=32'h88884444;

    instr=32'b001000_00000_10000_00000_00000_100000;   //addi $0+32 -> $16
    delayx(3);
    instr=32'b001000_00000_01111_00000_00000_000100;     //addi $0+4 -> $15  
    delayx(3);
    instr=32'b001000_00000_01111_00000_00000_000001;    //addi $0+1 -> $15
    delayx(3);
    instr=32'b000000_01001_01001_00001_00000_100010;   // sub $9-$9 -> $1
    delayx(3);
    instr=32'b000000_01001_01001_00001_00000_100010;  //3   // sub $9-$9 -> $1
    delayx(3);
    instr=32'b100011_01000_00011_00000_00000_000101;  //lw $3 <= Mem[5+$s8(8)]
    delayx(3);
    instr=32'b101011_01000_00100_00000_00000_000110;  //8    //sw $4 => Mem[6+$s8(8)]  
    delayx(6);
    instr=32'b000100_00000_00001_00000_00000_000001;  //9    // beq $1 $0 1
    $finish;

end
endmodule