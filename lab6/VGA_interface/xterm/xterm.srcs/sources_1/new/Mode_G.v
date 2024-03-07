`timescale 1ns / 1ps

module Mode_G(
    input   wire           pix_clk  ,
    input   wire    [11:0]   pix_x  ,
    input   wire    [11:0]   pix_y  ,
    input   wire            pix_valid,    
    output  wire     [11:0]  pix_data    
);

//wire    [18:0] ram_addr;
reg [27:0] cntdyn;
reg [7:0] temp_r,temp_g,temp_b,temp_d;

always@(posedge pix_clk) begin
    cntdyn<=cntdyn+1;
    temp_d <=cntdyn>>20;
    temp_r<=-pix_x-pix_y-temp_d;
    temp_g<=pix_x-temp_d;
    temp_b<=pix_y-temp_d;
end

assign  pix_data[11:8]=temp_r[7:4];
assign  pix_data[7:4]=temp_g[7:4];
assign  pix_data[3:0]=temp_b[7:4];

endmodule