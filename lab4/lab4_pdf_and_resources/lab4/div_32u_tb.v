`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/02 20:08:55
// Design Name: 
// Module Name: div_32u_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module div_32u_tb( );
  parameter N = 32;               // 定义位宽
  parameter SEED = 1;              // 定义不同的随机序列
     reg clk, rst;
     reg [N-1:0] x, y;
     reg in_valid;
     wire [N-1:0] q,r;
     wire  out_valid;
     wire  in_error;

  div_32u my_div_32u (.Q(q),.R(r),.out_valid(out_valid),.in_error(in_error),.clk(clk),.rst(rst),.X(x),.Y(y),.in_valid(in_valid)); // 
  
   reg [N-1:0] temp_Q;
   reg [N-1:0] temp_R;
   integer i, errors;
  task checkP;
    begin
      temp_Q = x / y;
      temp_R = x % y;
       if (out_valid &&((temp_Q !=q)||(temp_R !=r))) begin
        errors=errors+1;
        $display($time," Error: x=%d, y=%d, expected Quot= %d, Rem=%d(%h),got Quot= %d,Rem=%d(%h)",
                 x, y, temp_Q,temp_R,temp_R, q,r, r); 
        end
    end
  endtask


  initial begin : TB   // Start testing at time 0
     clk = 0;
	 forever 
	#2 clk = ~clk;	     //模拟时钟信号
  end

  initial 
   begin	
    errors = 0;
           x = $random(SEED);                        // Set pattern based on seed parameter
   for (i=0; i<10000; i=i+1) begin                //计算10000次
        rst = 1'b0;
        #2
        rst = 1'b1;                             //上电后1us复位信号
        x=$random; y=$random;
//	    x=0; y=1;
     	#2
    	rst = 1'b0;	
	    in_valid=1'b1;                        //初始化数据
	    #5
	    in_valid=1'b0;
	    #150;	                          // wait 150 ns, then check result
	     checkP;
      end  
    $display($time, " Divider32U test end. Errors %d .",errors); 
    $stop(1);          // end test
  end



endmodule
