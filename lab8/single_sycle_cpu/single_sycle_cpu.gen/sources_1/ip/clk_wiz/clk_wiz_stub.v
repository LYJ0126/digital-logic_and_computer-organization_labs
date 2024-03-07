// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Tue Nov 28 00:51:02 2023
// Host        : LAPTOP-D9H6QATN running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Vivadolabs/lab8/single_sycle_cpu/single_sycle_cpu.gen/sources_1/ip/clk_wiz/clk_wiz_stub.v
// Design      : clk_wiz
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz(clk_out1, reset, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_out1,reset,locked,clk_in1" */;
  output clk_out1;
  input reset;
  output locked;
  input clk_in1;
endmodule
