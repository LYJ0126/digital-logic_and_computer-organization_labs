 module uart_test(
    input  clk,
	input  clk100m,             //收发模块的时钟clk100m
	output rxd_out,             //串口的发送数据线
	input  txd_in,              //串口的接收数据线
	output reg [31:0] dbgdata,  //32位调试信息，例如PC、寄存器堆、存储器内容等等
	input  rst,                
	output [31:0] instaddr,     //指令存储器地址
	output reg[31:0] instdata,  //指令存储器数据
	output reg iwe,             //指令存储器写使能
	output [31:0] dataaddr,     //数据存储器地址
	output [31:0] mdata,        //数据存储器数据  
	output reg	dwe,            //数据存储器写使能信号
	output reg	cpuhalt,        //CPU暂停
	output reg	cpureset        //CPU重置
 );			

 
  //main CPU
SingleCycleCPU  mycpu(
                 .clock(clk&~uart_halt), 
                 .reset(BTNC|uart_rst), 
				 .InstrMemaddr(iaddr), .InstrMemdataout(idataout), .InstrMemclk(iclk), 
				 .DataMemaddr(daddr), .DataMemdataout(ddataout), .DataMemdatain(ddatain),
				 .DataMemrdclk(drdclk),.DataMemwrclk(dwrclk), .DataMemop(dop), 
				 .DataMemwe(dwe), .dbgdata(cpudbgdata)
				 );

	
 
InstrMem myinstrmem(
		.addra(uart_halt?uart_iaddr[17:2]:iaddr[17:2]),
		.clka(uart_halt?~uart_clk:iclk),
		.dina(uart_idata),
		.douta(idataout),
		.ena(1'b1),
		.wea(uart_iwe&uart_halt)
		);
 
  // send and receive logic
 always@(posedge clk)
 begin
	if(rst)
	begin
		tx_head<=4'd0;rx_tail<=4'd0;
		tx_send<=1'b0; rx_gotdata<=1'b0;
	end
	else
	begin
		if(rx_ready)
		begin
			if(rx_gotdata==1'b0)
			begin
				rx_buf[rx_tail]<=rx_data;
				rx_tail<=rx_tail+4'd1;
				rx_gotdata<=1'b1;
			end
		end
		else
		begin
			rx_gotdata<=1'b0;
		end
		if(tx_head!=tx_tail)       //has data to send
		begin
			if(~tx_send&tx_ready) //tx free
			begin
				tx_data <= tx_buf[tx_head];
				tx_head<= tx_head+4'd1;
				tx_send<=1'b1;
			end
			else
			begin
				if(~tx_ready) tx_send<=1'b0;
			end
		end
		else
		begin
			if(~tx_ready)
			begin
				tx_send<=1'b0;
			end
		end
	end
 end

endmodule