 module serial_tx( 
    input clk,          //输入时钟clk是100MHz，用于产生115200Hz的发送时钟
	input [7:0] data,   //数据输入data通过串行方式由送至tx_out
	input tx_enable,    //握手信号，用于和上层模块通信
	output reg tx_out,  //连接到顶层模块中的UART_RXD_OUT 信号
	output tx_ready     //握手信号，用于和上层模块通信
 );
	wire tx_clk; 								// serial clock
	reg	tx_busy;
	reg [10:0] tx_buf;
	reg [3:0]	tx_count;
	initial
		begin
			tx_count= 4'd0;
			tx_busy = 1'b0;
			tx_out = 1'b1;
		end
	clkgen #(115200) mytxclk(clk,1'b0,1'b1,tx_clk); //always enable tx_clock


	assign tx_ready = ~ tx_busy;
	always@(posedge tx_clk)					//state change only at the tx_clk edge
		begin
 

			if(tx_busy) 					//busy, ignore tx_enable and send
			begin
				tx_out<=tx_buf[0];
				tx_buf[9:0]<=tx_buf[10:1];	//shift tx_buf


				if(tx_count>=4'd10)			//finished
				begin
					tx_busy = 1'b0;
					tx_count<=4'd15;
				end
				else
				begin
					tx_busy = 1'b1;
					tx_count<=tx_count+4'd1;
				end
			end
			else
			begin
				tx_out=1'd1;
				if(tx_enable) 				//load the buffer and start next cycle
				begin
					tx_buf[0]<=1'b0;
					tx_buf[8:1]<=data[7:0];
					tx_buf[9]<=~(^data[7:0]);
					tx_buf[10]<=1'b1;
					tx_busy<=1'd1;
					tx_count<=4'd0;
				end
				else //no data
				begin
					tx_buf<=tx_buf;
					tx_busy<=1'd0;
					tx_count<=4'd0;
				end
			end
		end
 endmodule
