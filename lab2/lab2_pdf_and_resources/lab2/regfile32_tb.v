`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/16 20:18:12
// Design Name: 
// Module Name: regfile32_tb
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


module regfile32_tb(   );
 wire [31:0] busa;
 wire [31:0] busb;
 reg [31:0] busw;
 reg [4:0] ra, rb,rw; 
 reg clk, we;
 integer i, errors;
  regfile32 d_register_inst(busa, busb, busw, ra, rb, rw,clk, we);
 always
  # 5 clk=~clk;
  initial begin
  clk=1;errors=0;#10
  for (i=0;i<=31;i=i+1)
   begin
       we=1;rw=i; busw=(1<<i);
       #10;
   end
  for (i=0;i<=31;i=i+1)
   begin
       we=0;rw=i;busw=32'hffffffff;
       #10;
   end
     for (i=0;i<=31;i=i+1)
     begin
     ra=i;rb=i;
     #10 if (busa!=(1<<i)) begin
            $display("Error: busa=%8h, 1<<i = %8h,i=%5b",   busa, 1<<i,i); 
            errors=errors+1; 
          end
         if (busb!=(1<<i)) begin 
             $display("Error: busb=%8h, 1<<i = %8h,i=%5b",   busb, 1<<i,i); 
             errors=errors+1; 
          end
     end
     $display("Test done, %d errors\n",errors);   
     $stop(1);
end

endmodule
