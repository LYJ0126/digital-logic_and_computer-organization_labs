`timescale 1ns / 1ps


module testdmem(
    addra,
    clka,
    dina,
    ena,
    wea,
    addrb,
    clkb,
    doutb,
    enb);
	
    input	[14:0]  addra;
    input	clka;
    input	[31:0]  dina;
    input   ena;
	input   [3:0]  wea;
	input   [14:0] addrb;
	input   clkb;
	input	enb;
	output reg	[31:0]  doutb;
	
	reg  [31:0] tempout;
	wire [31:0] tempin;

	
	reg [31:0] ram [32767:0];
	always@(posedge clkb)
	begin
	   if(ena)
			tempout<=ram[addra];
	   else
			if(enb) doutb <= ram[addrb];
	end
	
   assign tempin[7:0]   = (wea[0])? dina[7:0]  : tempout[7:0];
   assign tempin[15:8]  = (wea[1])? dina[15:8] : tempout[15:8];
   assign tempin[23:16] = (wea[2])? dina[23:16]: tempout[23:16];
   assign tempin[31:24] = (wea[3])? dina[31:24]: tempout[31:24];
	
	always@(posedge clka)
	begin
		if(ena) 
		begin
			ram[addra]<=tempin;
		end
	end
		
endmodule
