`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 20:40:56
// Design Name: 
// Module Name: Adder32
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


module Adder32(
      output [31:0] f,
      output OF, SF, ZF, CF,
      output cout,
      input [31:0] x, y,
      input sub
    );
    //add your code here
    wire [31:0] yy;
    wire coutt;
    assign yy = (sub == 0) ? y : ~y;
    CLA_16 cla_161(f[15:0] ,coutt, x[15:0], yy[15:0], sub);
    CLA_16 cla_162(f[31:16] ,cout, x[31:16], yy[31:16], coutt);
    assign OF = &{~x[31], ~yy[31], f[31]} | &{x[31], yy[31], ~f[31]};
    assign SF = f[31];
    assign CF = sub ^ cout;
    assign ZF = f == 0;
endmodule

module CLA_16(
       output wire [15:0] f,
       output wire  cout, 
       input [15:0] x, y,
       input cin
  );
 //add your code here
    wire [3:0] Pi,Gi;
    wire [4:0] c;
    assign c[0] = cin;
    CLA_group cla0(f[3:0],Pi[0],Gi[0],x[3:0],y[3:0],c[0]);
    CLA_group cla1(f[7:4],Pi[1],Gi[1],x[7:4],y[7:4],c[1]);
    CLA_group cla2(f[11:8],Pi[2],Gi[2],x[11:8],y[11:8],c[2]);
    CLA_group cla3(f[15:12],Pi[3],Gi[3],x[15:12],y[15:12],c[3]);
    CLU clu(c[4:1],Pi,Gi, c[0]);
    assign cout = c[4];
endmodule

module CLA_group (
     output [3:0] f,
     output pg,gg,
     input [3:0] x, y,
     input cin
);
    wire [4:0] c;
    wire [4:1] p, g;
    assign c[0] = cin;
    FA_PG fa0(f[0], p[1], g[1],x[0], y[0], c[0]);
    FA_PG fa1(f[1], p[2], g[2],x[1], y[1], c[1]);
    FA_PG fa2(f[2], p[3], g[3],x[2], y[2], c[2]);
    FA_PG fa3(f[3], p[4], g[4],x[3], y[3], c[3]);
    CLU clu(c[4:1],p, g, c[0]);
    assign pg=p[1] & p[2] & p[3] & p[4];
    assign gg= g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]);
endmodule

module CLU (
      output [4:1] c,
      input [4:1] p, g,
      input c0
);
    assign c[1] = g[1] | (p[1] & c0);
    assign c[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & c0);
    assign c[3] = g[3] | (p[3] & g[2]) | (&{p[3:2], g[1]}) | (&{p[3:1], c0});
    assign c[4] = g[4] | (p[4] & g[3]) | (&{p[4:3], g[2]}) | (&{p[4:2], g[1]}) | (&{p[4:1], c0});
endmodule

module FA_PG (
     output f, p, g,
     input x, y, cin
	);
    assign f = x ^ y ^ cin;
    assign p = x | y;
    assign g = x & y;
endmodule
