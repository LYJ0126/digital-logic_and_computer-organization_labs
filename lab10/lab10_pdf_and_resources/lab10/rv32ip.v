module rv32ip(
input [31:0] a0,
    input   clock,
    input   reset,
    output [31:0] imemaddr,
    input  [31:0] imemdataout,
    output  imemclk,
    output [31:0] dmemaddr,
    input  [31:0] dmemdataout,
    output [31:0] dmemdatain,
    output  dmemrdclk,
    output  dmemwrclk,
    output [2:0] dmemop,
    output  dmemwe,
    output [31:0] dbgdata);
//add your code here
wire done;
assign done = (reset == 1'b1 ? 0 : (imemdataout == 32'hdead10cc) ? 1 : 0);
assign imemclk = clock;assign dmemrdclk = clock;assign dmemwrclk = clock;

reg [31:0] PC;
assign imemaddr = PC;
assign dbgdata = PC;

reg [63:0] IF_ID_REG;//[63:32]PC [31:0] imemdataout
reg [158:0] ID_EX_REG;//[127:96] PC [95:64] imm [63:32] rs1data [31:0] rs2data;
reg [74:0]EX_MEM_REG;
reg [70:0]MEM_WB_REG;


//ID

wire [6:0]funct7, opcode;wire [4:0]rs1, rs2, rd; wire[2:0] funct3;
InstrParse cpuparse(.instr(IF_ID_REG[31:0]),.rd(rd),.rs1(rs1),.rs2(rs2),.funct3(funct3),.funct7(funct7),.opcode(opcode));

wire [2:0]ExtOp, Branch, MemOp;wire MemWr,MemtoReg,ALUASrc,RegWr;wire[1:0] ALUBSrc;wire [3:0] ALUctr;
wire ban;
assign ban = done | reset;
Control cpucontrol (.opcode(opcode),.funct3(funct3),.funct7(funct7),.ExtOp(ExtOp),.Branch(Branch),.MemOp(MemOp),.MemWr(MemWr)
,.MemtoReg(MemtoReg),.ALUASrc(ALUASrc),.RegWr(RegWr),.ALUBSrc(ALUBSrc),.ALUctr(ALUctr),.ban(ban));
 
 
 wire [31:0] rs1data, rs2data;
 wire [31:0] busw;
 wire [31:0] wb_memout, wb_result;wire wb_MemtoReg; wire [4:0] wb_rd; wire wb_RegWr;
 assign busw = (wb_MemtoReg == 1) ? wb_memout : wb_result;
regfile32 myregfile(.reset(reset),.busa(rs1data),.busb(rs2data),.clk(clock),.ra(rs1),.rb(rs2),.rw(wb_rd),.busw(busw),.we(wb_RegWr),.a0(a0));

wire [31:0] imm;
InstrToImm cpuimmex(.instr(IF_ID_REG[31:0]),.ExtOp(ExtOp),.imm(imm));


// EX

wire [31:0] EX_PC,EX_imm; reg [31:0] EX_rs1data, EX_rs2data; wire[4:0] EX_rd; wire[3:0] ex_ALUctr; wire ex_RegWr, ex_ALUASrc, ex_MemtoReg, ex_MemWr;
wire[2:0] ex_MemOp, ex_Branch;wire[1:0] ex_ALUBSrc;
assign EX_PC =ID_EX_REG[127:96]; //assign EX_rs2data = ID_EX_REG[31:0];assign EX_rs1data=ID_EX_REG[63:32];
assign EX_imm=ID_EX_REG[95:64];
assign EX_rd = ID_EX_REG[132:128]; assign ex_ALUctr = ID_EX_REG[136:133];assign ex_RegWr = ID_EX_REG[137];
assign ex_ALUBSrc = ID_EX_REG[139:138]; assign ex_ALUASrc = ID_EX_REG[140]; assign ex_MemtoReg = ID_EX_REG[141];
assign ex_MemWr = ID_EX_REG[142]; assign ex_MemOp = ID_EX_REG[145:143];assign ex_Branch = ID_EX_REG[148:146];

// 转发
wire mem_RegWr , mem_MemtoReg;wire [4:0]mem_rd;wire [31:0] mem_result;

 
wire [4:0] ex_rs1, ex_rs2; assign ex_rs1 = ID_EX_REG[153:149]; assign ex_rs2 = ID_EX_REG[158:154];
always@(*)begin
    if(ex_rs1 == mem_rd && mem_RegWr == 1'b1)begin
        if(mem_MemtoReg == 1'b1)begin
            EX_rs1data = dmemdataout;
        end
        else begin
            EX_rs1data = (ex_rs1 == 5'b00000) ? 0 : mem_result;
        end
    end
    else if(ex_rs1 == wb_rd && wb_RegWr == 1'b1)begin
        if(wb_MemtoReg == 1'b1)begin
             EX_rs1data = wb_memout;
        end
        else begin
            EX_rs1data = (ex_rs1 == 5'b00000) ? 0 : wb_result;
        end
    end
    else begin EX_rs1data = ID_EX_REG[63:32]; end
    if(ex_rs2 == mem_rd && mem_RegWr == 1'b1)begin
        if(mem_MemtoReg == 1'b1)begin
            EX_rs2data = dmemdataout;
        end
        else begin
            EX_rs2data = (ex_rs2 == 5'b00000) ? 0 : mem_result;
        end
    end
    else if(ex_rs2 == wb_rd && wb_RegWr == 1'b1)begin
        if(wb_MemtoReg == 1'b1)begin
             EX_rs2data = wb_memout;
        end
        else begin
            EX_rs2data = (ex_rs2 == 5'b00000) ? 0 : wb_result;
        end
    end
    else begin EX_rs2data = ID_EX_REG[31:0]; end
end

wire stallIF, stallID, stallEX, flushEX;
assign stallIF = (ex_rs1 == mem_rd && mem_MemtoReg == 1'b1) | (ex_rs2 == mem_rd && mem_MemtoReg == 1'b1);assign stallID = stallIF; assign stallEX = stallIF;
assign flushEX = stallIF;



wire [31:0] result;wire zero;
    wire [31:0] dataa;wire [31:0]datab;
    assign dataa = (ex_ALUASrc == 1'b1)? EX_PC : EX_rs1data;
    assign datab = (ex_ALUBSrc == 2'b00) ? EX_rs2data : ((ex_ALUBSrc == 2'b01) ? 32'h00000004 : EX_imm);
    ALU32 cpualu(.result(result),.zero(zero),.dataa(dataa),.datab(datab),.aluctr(ex_ALUctr));

wire Branchsel, PCsel, flushIF, flushID;
BranchControl cpubranch(.Branchsel(Branchsel),.PCsel(PCsel),.flushIF(flushIF),.flushID(flushID),.Branch(ex_Branch),.zero(zero),.result0(result[0]));
wire [31:0] Branchtarget;
assign Branchtarget = (EX_imm & 32'hfffffffc) + ((Branchsel == 1) ? (EX_rs1data & 32'hfffffffc): EX_PC);

// MEM

wire mem_MemWr; wire [31:0] mem_rs2;wire[2:0]mem_MemOp;
assign mem_RegWr = EX_MEM_REG[74];assign mem_MemWr = EX_MEM_REG[73];assign mem_MemtoReg = EX_MEM_REG[72];
assign mem_rd = EX_MEM_REG[68:64];assign mem_result = EX_MEM_REG[63:32];assign mem_rs2 = EX_MEM_REG[31:0];
assign mem_MemOp = EX_MEM_REG[71:69];

assign dmemaddr = mem_result;assign dmemdatain = mem_rs2;assign dmemop=mem_MemOp;assign dmemwe = (~reset & mem_MemWr);//(~reset & ~done & mem_MemWr);



assign wb_result = MEM_WB_REG[31:0]; assign wb_memout = MEM_WB_REG[63:32]; assign wb_rd = MEM_WB_REG[68:64];assign wb_RegWr = MEM_WB_REG[69];
assign wb_MemtoReg = MEM_WB_REG[70];


always@(negedge clock or posedge reset)begin
if(reset)begin
    PC <= 32'h0;IF_ID_REG <= 0; ID_EX_REG <= 0; EX_MEM_REG <= 0; MEM_WB_REG <= 0;
end
else begin
if(imemdataout == 32'hdead10cc)begin//终止
    PC <= PC;
end 
   else if(stallIF == 1'b1)begin//阻塞
        PC <= PC;
    end
    else begin
        PC <= (PCsel == 1'b1)? Branchtarget : (PC + 32'h4);//判断是PC+4还是跳转
    end
    if(stallID == 1'b1)begin
        IF_ID_REG <= IF_ID_REG;
    end
    else if(flushIF == 1'b1)begin
        IF_ID_REG <= 0;
        end
    else begin
        IF_ID_REG <= {PC, imemdataout};
        end
    if(stallEX == 1'b1)begin
        ID_EX_REG <= {ID_EX_REG[158:64] ,EX_rs1data, EX_rs2data};
    end
    else if(flushID == 1'b1)begin
        ID_EX_REG <= 0;
    end
    else begin
        ID_EX_REG <= {rs2,rs1,Branch, MemOp, MemWr, MemtoReg, ALUASrc, ALUBSrc, RegWr, ALUctr,rd, IF_ID_REG[63:32], imm, rs1data, rs2data};
    end
    if(flushEX == 1'b1)begin
        EX_MEM_REG <= 0;
    end
    else begin
    EX_MEM_REG <= {ex_RegWr,ex_MemWr,ex_MemtoReg,ex_MemOp,EX_rd, result, EX_rs2data};
    end
    MEM_WB_REG <= {mem_MemtoReg,mem_RegWr,mem_rd,dmemdataout,mem_result};
end
end


endmodule
