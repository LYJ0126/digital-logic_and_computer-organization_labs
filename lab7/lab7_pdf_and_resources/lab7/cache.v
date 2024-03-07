module cache(
    input clk,
    input rst,
    input  [31:0] addr,
    input  rd_req,
    input  wr_req,
    input  [31:0] wr_data,
    output reg [31:0] rd_data,
    output [2:0] info
);
    parameter LINE_ADDR_LEN = 2;
    parameter SET_ADDR_LEN = 3;
    parameter TAG_ADDR_LEN = 12 - LINE_ADDR_LEN - SET_ADDR_LEN;
    parameter MEM_ADDR_LEN = 12;
    parameter UNUSED_ADDR_LEN = 32 - TAG_ADDR_LEN - SET_ADDR_LEN - LINE_ADDR_LEN - 2 ;//未用位表示的部分
    parameter LINE_SIZE = 1 << LINE_ADDR_LEN;
    parameter SET_SIZE = 1 << SET_ADDR_LEN;

    reg [31:0] cache_mem [SET_SIZE-1:0][LINE_SIZE-1:0];
    reg [TAG_ADDR_LEN-1:0] cache_tags [SET_SIZE-1:0];
    reg valid [SET_SIZE-1:0];//valid位
    reg dirty [SET_SIZE-1:0];//脏位

    wire [1:0]   word_addr;
    wire [LINE_ADDR_LEN-1:0]   line_addr;//行
    wire [SET_ADDR_LEN-1:0]    set_addr;
    wire [TAG_ADDR_LEN-1:0]    tag_addr;//tag
    wire [UNUSED_ADDR_LEN-1:0] unused_addr;//未用位
    
    reg [1:0] word_addr_reg;
    reg [LINE_ADDR_LEN-1:0] line_addr_reg;
    reg [SET_ADDR_LEN-1:0] set_addr_reg;
    reg [TAG_ADDR_LEN-1:0] tag_addr_reg;
    reg [UNUSED_ADDR_LEN-1:0] unused_addr_reg;

    reg [1:0] cache_stat;
    parameter IDLE = 2'b00;
    parameter COMPARE = 2'b01;
    parameter WRITEBACK = 2'b10;
    parameter LOADMEM = 2'b11;

    reg [SET_ADDR_LEN-1 :0] mem_rd_set_addr;
    reg [TAG_ADDR_LEN-1 :0] mem_rd_tag_addr;
    wire[MEM_ADDR_LEN-1 :0] mem_rd_addr = {mem_rd_tag_addr,mem_rd_set_addr,2'b00};
    reg [MEM_ADDR_LEN-1 :0] mem_wr_addr;
    reg  [32*LINE_SIZE-1:0] mem_wr_line;
    wire [32*LINE_SIZE-1:0] mem_rd_line;
    assign {unused_addr, tag_addr, set_addr, line_addr, word_addr} = addr;
    reg cache_hit;
    reg rd_or_wr_proc;
    reg state_renewed;
    reg mem_rd_ready;
    reg mem_wr_ready;
    assign info = {valid[set_addr],dirty[set_addr],cache_hit};

    integer i;
    integer j;
    integer k;
    integer l;
    always @ (posedge clk) begin
        if(rst) begin
            for(i=0; i<SET_SIZE; i = i + 1) begin
                dirty[i] <= 1'b0;
                valid[i] <= 1'b0;
                cache_tags[i] <= 0;
            end
            cache_hit <= 1'b0;
            cache_stat <= IDLE;
            mem_wr_line <= 0;            
            mem_wr_addr <= 0;
            state_renewed <= 1'b0;
            mem_rd_ready <= 1'b0;
            mem_wr_ready <= 1'b0;
            {mem_rd_tag_addr,mem_rd_set_addr} <= 0;
            rd_data <= 0;
        end else begin
            case(cache_stat)
                IDLE:begin
                    if(rd_req | wr_req) begin
                        cache_stat <= COMPARE;
                        {unused_addr_reg, tag_addr_reg, set_addr_reg, line_addr_reg, word_addr_reg} <= addr;
                        if (rd_req) begin
                            rd_or_wr_proc <= 1'b1;
                        end
                        else begin
                            rd_or_wr_proc <= 1'b0;
                        end    
                    end
                end
                COMPARE:begin
                    if(state_renewed) begin
                        state_renewed <= 1'b0;
                        if(cache_hit) begin
                            if(rd_or_wr_proc) begin
                                rd_data <= cache_mem[set_addr_reg][line_addr_reg];
                            end
                            else begin 
                                cache_mem[set_addr_reg][line_addr_reg] <= wr_data;
                                dirty[set_addr_reg] <= 1'b1;
                            end 
                            cache_stat <= IDLE;
                        end
                        else begin
                            {mem_rd_tag_addr,mem_rd_set_addr} <= {tag_addr_reg, set_addr_reg};
                            if(dirty[set_addr_reg]) begin
                                cache_stat  <= WRITEBACK;
                            end
                            else begin
                                cache_stat  <= LOADMEM;
                            end
                        end 
                    end
                    else begin
                        state_renewed <= 1'b1;
                        if(valid[set_addr_reg] && cache_tags[set_addr_reg] == tag_addr_reg) begin
                            cache_hit = 1'b1;            
                        end
                        else begin
                            cache_hit = 1'b0;            
                        end
                    end
                end
                WRITEBACK: begin
                    if(mem_wr_ready) begin
                        mem_wr_ready <= 1'b0;
                        cache_stat <= LOADMEM;
                    end
                    else begin
                        mem_wr_ready <= 1'b1;
                        mem_wr_addr <= {cache_tags[set_addr_reg],set_addr_reg};
                        mem_wr_line[31:0] <= cache_mem[set_addr_reg][0];
                        mem_wr_line[63:32] <= cache_mem[set_addr_reg][1];
                        mem_wr_line[95:64] <= cache_mem[set_addr_reg][2];
                        mem_wr_line[127:96] <= cache_mem[set_addr_reg][3];
                    end
                end
                LOADMEM: begin
                    if(mem_rd_ready) begin
                        mem_rd_ready <= 1'b0;
                        cache_stat <= COMPARE;
                        cache_mem[mem_rd_set_addr][0] <= mem_rd_line[31:0];
                        cache_mem[mem_rd_set_addr][1] <= mem_rd_line[63:32];
                        cache_mem[mem_rd_set_addr][2] <= mem_rd_line[95:64];
                        cache_mem[mem_rd_set_addr][3] <= mem_rd_line[127:96];
                        cache_tags[mem_rd_set_addr] <= mem_rd_tag_addr;
                        valid [mem_rd_set_addr] <= 1'b1;
                        dirty [mem_rd_set_addr] <= 1'b0;
                    end
                    else begin
                        mem_rd_ready <= 1'b1;
                    end
                end
            endcase
        end
    end

    wire [MEM_ADDR_LEN-1:0] mem_addr = (cache_stat == WRITEBACK) ? mem_wr_addr : mem_rd_addr;

    main_mem main_mem_0(
        .clk(clk),
        .rst(rst),
        .rd_en(cache_stat == LOADMEM && !mem_rd_ready),
        .rd_line(mem_rd_line),
        .wr_en(cache_stat == WRITEBACK && mem_wr_ready),
        .wr_line(mem_wr_line),
        .addr(mem_addr)
    );
endmodule

module main_mem(
    input clk,
    input rst,
    input rd_en,
    output reg [127:0] rd_line,
    input wr_en,
    input [127:0] wr_line,
    input [11:0] addr
);
    reg [31:0] ram [2**12-1:0];
    integer i;
    always @(posedge clk) begin
        if(rst) begin
            for(i = 0; i < 2**12; i = i + 1) begin
                ram[i] <= 0;
            end
        end
        else begin
            if(wr_en) begin
                ram[addr] <= wr_line[31:0];
                ram[addr+1] <= wr_line[63:32];
                ram[addr+2] <= wr_line[95:64];
                ram[addr+3] <= wr_line[127:96];
            end
            if(rd_en) begin
                rd_line[31:0] <= ram[addr];
                rd_line[63:32] <= ram[addr+1];
                rd_line[95:64] <= ram[addr+2];
                rd_line[127:96] <= ram[addr+3];
            end
        end
    end
endmodule