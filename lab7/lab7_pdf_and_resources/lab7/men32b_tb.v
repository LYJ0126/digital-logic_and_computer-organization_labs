`timescale 1ns / 1ps


module men32b_tb(    );
 wire  [31:0] ram_rdata;   //时钟下降沿，并且写入使能为低电平时输出
 reg        clk;                //时钟信号
 reg        ram_wen;                //存储器写使能信号，高电平时允许写入数据
 reg [2:0]  memop;      //读写字节数控制
 reg [31:0] ram_wdata;       //下降沿写入数据
 reg [15:0] ram_addr;    //写入地址
 
mem32b u_ram_top(
    .dataout (ram_rdata),
    .clk      (clk       ),
    .we       (ram_wen   ),
    .MemOp    (memop  ),
    .datain   (ram_wdata ),
    .addr     (ram_addr ) 
);
reg[31:0] temp;
integer errors;

  task checkP;
    begin
       if (ram_rdata!=temp) begin
        errors=errors+1;
        $display($time," Data Memory read/writer error. MemOp=%d,we=%1b,addr=%h,DataOut=%h,Temp=%h",
                 memop, ram_wen, ram_addr, ram_rdata, temp); 
        end
    end
  endtask

//clkData Memory
initial 
begin
    clk = 1'b1;
end
always #5 clk = ~clk;
					
initial 
begin
	errors=0;
	ram_addr   = 16'd0;
	ram_wdata  = 32'd0;
	ram_wen    =  1'd0;
	memop =  3'd0;
	#10;
	
	$display("=============================");
	$display("Test Begin");
	
	// Part 0 Begin
	#10;
	memop      = 3'd0;
	ram_wen    = 1'b0;
	ram_addr   = 16'hf0;
	ram_wdata  = 32'hffffffff;
    #10;
	ram_wen    = 1'b1;
	ram_addr   = 16'hf0;
	ram_wdata  = 32'h01234567;
    #10;
	ram_addr   = 16'hf4;
    #10;
	ram_addr   = 16'hf8;
    #10;
	ram_wen    = 1'b0;
	ram_addr   = 16'hf0;
	#10
	temp       =  32'h01234567;
	checkP;
    #10;
    memop      = 3'd1;
	ram_addr   = 16'hf0;
	#10
	temp       =  32'h00000067;
	checkP;
	#10;
    memop      = 3'd2;
	ram_addr   = 16'hf0;
  	#10
	temp       =  32'h00004567;
	checkP;
    #10;
    // Part 1 Begin
    #10;
	memop      = 3'd5;
	ram_wen    = 1'b1;
	ram_addr   = 16'hf4;
	ram_wdata  = 32'h89abcdef;
 	#10;
	ram_wen    = 1'b0;
	ram_addr   = 16'hf4;
	#10
	temp       =  32'hffffffef;
	checkP;
 	#10;
	memop      = 3'd0;
	ram_addr   = 16'hf4;
	#10
	temp       =  32'h012345ef;
	checkP;
 	#10;
	memop      = 3'd1;
	ram_addr   = 16'hf4;
	#10
	temp       =  32'h000000ef;
	checkP;
 	#10;
	memop      = 3'd2;
	ram_addr   = 16'hf4;
	#10
	temp       =  32'h000045ef;
	checkP;

    #10;
	// Part 2 Begin
    #10;
	memop      = 3'd6;
	ram_wen    = 1'b1;
	ram_addr   = 16'hf8;
	ram_wdata  = 32'h89abcdef;
 	#10;
	ram_wen    = 1'b0;
	ram_addr   = 16'hf8;
	#10
	temp       =  32'hffffcdef;
	checkP;
 	#10;
	memop      = 3'd0;
	ram_addr   = 16'hf8;
	#10
	temp       =  32'h0123cdef;
	checkP;
 	#10;
	memop      = 3'd1;
	ram_addr   = 16'hf8;
 	#10
	temp       =  32'h000000ef;
	checkP;
	#10;
	memop      = 3'd2;
	ram_addr   = 16'hf8;
 	#10
	temp       =  32'h0000cdef;
	checkP;
	#20;
	$display("TEST Done. Errors=%d",errors);
	$finish;
end

endmodule
