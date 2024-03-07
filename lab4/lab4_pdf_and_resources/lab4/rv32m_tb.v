`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/05 10:13:46
// Design Name: 
// Module Name: rv32m_tb
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


module rv32m_tb(   );
  parameter N = 32;               // 定义位宽
  parameter SEED = 1;              // 定义不同的随机序列
  wire [N-1:0] Rd;               //运算结果
  wire Out_valid,In_error;       //运算结束和错误输入标志
  reg [N-1:0]  Rs1,Rs2;         //32位数据输入
  reg [2:0]   Funct3;             //功能选择信号
  reg Clk,Rst;                        //复位信号
  reg In_valid;                   //输入为1时，表示数据就绪，开始运算
  integer i, errors;
  reg signed [63:0]  TempMul;
  reg signed [64:0]  TempMulsu;
  reg [63:0]  TempMulu;
  reg [31:0] TempRd;
  parameter Mul     = 3'b000,   // 定义不同运算的控制码
             Mulh    = 3'b001, 
             Mulhsu  = 3'b010, 
             Mulhu   = 3'b011, 
             Div     = 3'b100, 
             Divu    = 3'b101, 
             Rem     = 3'b110, 
             Remu    = 3'b111;

  initial begin : TB   // Start testing at time 0
     Clk = 0;
	 forever 
	#1 Clk = ~Clk;	     //模拟时钟信号
  end

   rv32m my_rv32m(.rd(Rd),.out_valid(Out_valid),.in_error(In_error),.clk(Clk),.rst(Rst),.rs1(Rs1),.rs2(Rs2),.funct3(Funct3),.in_valid(In_valid));

  task checkrv32m;
    begin
    case (Funct3)
    Mul: begin 
                 TempMul=Rs1 *  Rs2;   //带符号数乘法运算
                 if (TempMul[31:0]!=Rd) 
                  begin     
                       errors = errors + 1;
                      $display("ERROR: Funct3,Rs1,Rs2 = %3b,%8h,%8h, want= %8h, got=%8h,err=%1b." ,
                      Funct3, Rs1, Rs2, TempMul[31:0], Rd,In_error);                 
                  end
             end
    Mulh: begin 
                 TempMul=$signed(Rs1) * $signed( Rs2);   //带符号数乘法运算
                 if (TempMul[63:32]!=Rd) 
                  begin     
                       errors = errors + 1;
                      $display("ERROR: Funct3,Rs1,Rs2 = %3b,%8h,%8h, want= %8h, got=%8h,err=%1b." ,
                      Funct3, Rs1, Rs2, TempMul[63:32], Rd,In_error);                 
                  end
             end
    Mulhsu: begin                 //带符号数乘以无符号数运算
                 TempMulsu=$signed(Rs1) *$signed({1'b0, Rs2});   //无符号数乘法
                 if (TempMulsu[63:32]!=Rd)
                  begin     
                       errors = errors + 1;
                      $display("ERROR: Funct3,Rs1,Rs2 = %3b,%8h,%8h, want= %8h, got=%8h,err=%1b." ,
                      Funct3, Rs1, Rs2, TempMul[63:32], Rd,In_error);                 
                  end
             end
    Mulhu: begin                 //无符号数小于比较运算
                 TempMulu=Rs1 * Rs2;   
                 if (TempMulu[63:32]!=Rd) 
                  begin     
                       errors = errors + 1;
                      $display("ERROR: Funct3,Rs1,Rs2 = %3b,%8h,%8h, want= %8h, got=%8h,err=%1b." ,
                      Funct3, Rs1, Rs2, TempMul[63:32], Rd,In_error);                 
                  end
             end
      Div: begin 
                 TempRd=$signed(Rs1) / $signed(Rs2);   //带符号数除法运算
                 if (TempRd!=Rd) 
                  begin     
                       errors = errors + 1;
                      $display("ERROR: Funct3,Rs1,Rs2 = %3b,%8h,%8h, want= %8h, got=%8h,err=%1b." ,
                      Funct3, Rs1, Rs2, TempMul[63:32], Rd,In_error);                 
                  end
             end
      Divu: begin 
                 TempRd=Rs1 / Rs2;   //带符号数除法运算
                 if (TempRd!=Rd) 
                  begin     
                       errors = errors + 1;
                      $display("ERROR: Funct3,Rs1,Rs2 = %3b,%8h,%8h, want= %8h, got=%8h,err=%1b." ,
                      Funct3, Rs1, Rs2, TempMul[63:32], Rd,In_error);                 
                  end
             end
      Rem: begin 
                 TempRd=$signed(Rs1) % $signed(Rs2);   //带符号数除法运算
                 if (TempRd!=Rd) 
                  begin     
                       errors = errors + 1;
                      $display("ERROR: Funct3,Rs1,Rs2 = %3b,%8h,%8h, want= %8h, got=%8h,err=%1b." ,
                      Funct3, Rs1, Rs2, TempMul[63:32], Rd,In_error);                 
                  end
             end
      Remu: begin 
                 TempRd=Rs1 % Rs2;   //带符号数除法运算
                 if (TempRd!=Rd) 
                  begin     
                       errors = errors + 1;
                      $display("ERROR: Funct3,Rs1,Rs2 = %3b,%8h,%8h, want= %8h, got=%8h,err=%1b." ,
                      Funct3, Rs1, Rs2, TempMul[63:32], Rd,In_error);                 
                  end
             end
             
    endcase
    end
  endtask
  
  initial begin
    errors = 0;
           Rs1 = $random(SEED);                        // Set pattern based on seed parameter
   for (i=0; i<10000; i=i+1) begin                     //计算10000次
        Rst = 1'b0;    
        #2   Rst = 1'b1;               //复位信号有效
          Rs1 = 4; Rs2=-1;             //初始化数据
     	#2 	Rst = 1'b0;	 In_valid=1'b1;               //数据就绪         
	    #2  In_valid=1'b0;
             
          Funct3 = Mul;  #80 ; checkrv32m;    
          Funct3 = Mulh;  #80 ; checkrv32m;
          Funct3 = Mulhsu;  #80 ; checkrv32m; 
          Funct3 = Mulhu;  #80 ; checkrv32m;  
              
          Funct3 = Div;  #80 ; checkrv32m; 
          Funct3 = Divu;  #80 ; checkrv32m; 
          Funct3 = Rem;  #80 ; checkrv32m;  
          Funct3 = Remu;  #80 ; checkrv32m;   
    end
    $display("RV32M test done. Errors: %0d .", errors);
    $stop(1);
  end

endmodule
