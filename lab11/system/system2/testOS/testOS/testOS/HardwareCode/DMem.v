`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2023 11:01:17 PM
// Design Name: 
// Module Name: Mem
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


module DMem(
	input  [31:0] addr,
	output [31:0] dataout,
	input  [31:0] datain,
	input  rdclk,
	input  wrclk,
	input [2:0] memop,
	input we);

//add your code here
wire [1:0] low2b;
assign low2b = addr[1:0];
wire [3:0] wea;
wire [31:0] dout;
wire [7:0] partlow2b;
wire [3:0] startlow2b;
reg [31:0] din;
myDMem dd(
    .wrclk(wrclk)  ,
    .we(we) ,
    .wea(wea),
    .addr(addr[17:2]) ,
    .din(din) ,
    .rdclk(rdclk),
    .dout(dout) );

assign partlow2b = (low2b == 0)?dout[7:0]:
                    ((low2b==1)?dout[15:8]:
                    ((low2b==2)?dout[23:16]:
                    ((low2b ==3)?dout[31:24]:0)));
assign startlow2b = (low2b == 0)?4'b0001:
                    ((low2b==1)?4'b0010:
                    ((low2b==2)?4'b0100:
                    ((low2b ==3)?4'b1000:0)));

assign wea = (memop==3'b000)?startlow2b:
             ((memop==3'b001 && low2b[1]==1'b0)?4'b0011:
             ((memop==3'b001 && low2b[1]==1'b1)?4'b1100:
             ((memop==3'b010)?4'b1111:0))); 

assign dataout = (memop==3'b000)?$signed(partlow2b):
                 ((memop==3'b001 && low2b[1]==1'b0)?$signed(dout[15:0]):
                 ((memop==3'b001 && low2b[1]==1'b1)?$signed(dout[31:16]):
                 ((memop==3'b010)?$signed(dout):
                 ((memop==3'b100)?{24'd0,partlow2b}:
                 ((memop ==3'b101 && low2b[1]==1'b0)?{16'd0,dout[15:0]}:
                 ((memop ==3'b101 && low2b[1]==1'b1)?{16'd0,dout[31:16]}:0))))));
                 
always @(*)
begin
    case(memop)
    3'b000:
    begin
        case(low2b)
        2'b00:din <= {24'd0,datain[7:0]};
        2'b01:din <= {16'd0,datain[7:0],8'd0};
        2'b10:din <= {8'd0,datain[7:0],16'd0};
        2'b11:din <= {datain[7:0],24'd0};
        endcase  
    end
    3'b001:
    begin
        case(low2b)
        2'b00:din <= {16'd0,datain[15:0]};
        2'b10:din <= {datain[15:0],16'd0};
        endcase  
    end
    3'b010: din <= datain ;
    endcase 
end

endmodule

module myDMem(
    input wrclk,
    input we,
    input [3:0] wea,
    input [15:0] addr,
    input [31:0] din,
    input rdclk,
    output reg [31:0] dout
);
    (* ram_style="block" *) reg [31:0] ram [65535:0];
    initial begin $readmemh("F:/testOS/testOS/SimpleOS/build/target_d.hex", ram);end
    always @(posedge wrclk)begin
        if(we) begin
            if(wea[0]) ram[addr][7:0]=din[7:0];
            if(wea[1]) ram[addr][15:8]=din[15:8];
            if(wea[2]) ram[addr][23:16]=din[23:16];
            if(wea[3]) ram[addr][31:24]=din[31:24];
        end
    end
    always @(posedge rdclk)begin
        if(~we) begin
            dout<=ram[addr];
        end
    end
endmodule

`timescale 1ns / 1ps

module dmem(
	input  [31:0] addr,
	output reg [31:0] dataout,
	input  [31:0] datain,
	input  rdclk,
	input  wrclk,
	input [2:0] memop,
	input we);
	
	
	reg [3:0] byteen;
	reg [31:0] temp;
	wire [31:0] cur;
	
	data_ram mem(
		.wea(byteen), 
		.ena(we),
		.dina(temp),
		.addra(addr[16:2]),
		.clka(wrclk),
		.addrb(addr[16:2]),
		.clkb(rdclk), 
		.doutb(cur)
	);
	
	always @ (*)
		case (memop)
			3'b000: 
				case (addr[1:0]) 
					2'b00: dataout = {{24{cur[7]}}, cur[7:0]};
					2'b01: dataout = {{24{cur[15]}}, cur[15:8]};
					2'b10: dataout = {{24{cur[23]}}, cur[23:16]};
					2'b11: dataout = {{24{cur[31]}}, cur[31:24]};
				endcase
			3'b001:
				case (addr[1:0]) 
					2'b00, 2'b01: dataout = {{16{cur[15]}}, cur[15:0]};
					2'b10, 2'b11: dataout = {{16{cur[31]}}, cur[31:16]};
				endcase
			3'b010: 
				dataout = cur;
			3'b100:
				case (addr[1:0]) 
					2'b00: dataout = {24'b0, cur[7:0]};
					2'b01: dataout = {24'b0, cur[15:8]};
					2'b10: dataout = {24'b0, cur[23:16]};
					2'b11: dataout = {24'b0, cur[31:24]};
				endcase
			3'b101:
				case (addr[1:0]) 
					2'b00, 2'b01: dataout = {16'b0, cur[15:0]};
					2'b10, 2'b11: dataout = {16'b0, cur[31:16]};
				endcase
		endcase

	always @ (*) 
		if (we)
			case (memop)
				3'b000: 
					case (addr[1:0])
						2'b00: begin byteen = 4'b0001; temp = {24'd0, datain[7:0]}; end
						2'b01: begin byteen = 4'b0010; temp = {16'd0, datain[7:0], 8'd0}; end
						2'b10: begin byteen = 4'b0100; temp = {8'd0, datain[7:0], 16'd0}; end
						2'b11: begin byteen = 4'b1000; temp = {datain[7:0], 24'd0}; end
					endcase
				3'b001:
					case (addr[1:0])
						2'b00, 2'b01: begin byteen = 4'b0011; temp = {16'd0, datain[15:0]}; end
						2'b10, 2'b11: begin byteen = 4'b1100; temp = {datain[15:0], 16'd0}; end
					endcase
				3'b010: begin byteen = 4'b1111; temp = datain; end
			endcase

endmodule