`timescale 1ns / 1ps


module cache_tb();
    reg resetn;
    reg clk;
    reg [31:0] addr;
    reg rd_req;
    reg wr_req;
    reg [31:0] wr_data;
    wire [31:0] rd_data;
    wire [2:0] info;

    cache myCache(
        .clk(clk),
        .rst(resetn),
        .addr(addr),
        .rd_req(rd_req),
        .wr_req(wr_req),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .info(info)
    );

    reg [1:0] line_shift;
    reg [2:0] set_index;
    reg [6:0] tag;

    integer i;
    integer j;
    initial begin
        clk = 1'b0;
        forever #5 clk=~clk;
    end

    initial begin
        #10
        resetn = 1'b1;
        #5;
        #5;
        resetn = 1'b0;
        #5;
        #5;
        $display("=========================================================");
        $display("Test begin!");
        for (i = 0;i < 8 ;i = i + 1) begin
            set_index = i;
            $display("=========================================================");
            $display("Test index %d",i);
            for (j = 0;j < 4;j = j + 1) begin
                tag = $random();
                line_shift = $random();
                addr = {tag,set_index,line_shift,2'b00};
                wr_req = 1'b1;
                wr_data = $random();
                #100;
                wr_req = 1'b0;
                rd_req = 1'b1;
                #100;
                rd_req = 1'b0;
                $display("The data written is %d and the data read is %d",wr_data,rd_data);
                if (rd_data != wr_data) begin
                    $display("=========================================================");
                    $display("Test end!");
                    $display("----FAIL!!!");
                    $display("=========================================================");
                    $finish;
                end    
            end
        end
        $display("=========================================================");
        $display("Test end!");
        $display("----PASS!!!");
        $display("=========================================================");
        $finish;
    end

    
    
    
endmodule
