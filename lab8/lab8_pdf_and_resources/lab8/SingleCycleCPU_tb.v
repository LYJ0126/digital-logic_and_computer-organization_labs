`timescale 1ns / 1ps

module SingleCycleCPU_tb(    );
integer numcycles;  //number of cycles in test

reg clk,reset;  //clk and reset signals

reg[8*30:1] testcase; //name of testcase

// CPU declaration

// signals
wire [31:0] iaddr,idataout;
wire iclk;
wire [31:0] daddr,ddataout,ddatain;
wire drdclk, dwrclk, dwe;
wire [2:0]  dop;
wire [15:0] cpudbgdata;



//main CPU
SingleCycleCPU  mycpu(.clock(clk), 
                 .reset(reset), 
				 .InstrMemaddr(iaddr), .InstrMemdataout(idataout), .InstrMemclk(iclk), 
				 .DataMemaddr(daddr), .DataMemdataout(ddataout), .DataMemdatain(ddatain), .DataMemrdclk(drdclk),
				  .DataMemwrclk(dwrclk), .DataMemop(dop), .DataMemwe(dwe),  .dbgdata(cpudbgdata));

			  

 InstrMem myinstrmem(.instr(idataout),.addr(iaddr),.InstrMemEn(1'b1),.clk(iclk)	);
	

//data memory	

DataMem mydatamem(.dataout(ddataout), .clk(dwrclk),  .we(dwe),  .MemOp(dop), .datain(ddatain),.addr(daddr));

//useful tasks
task step;  //step for one cycle ends 1ns AFTER the posedge of the next cycle
	begin
		#9  clk=1'b0; 
		#10 clk=1'b1;
		numcycles = numcycles + 1;	
		#1 ;
	end
endtask
				  
task stepn; //step n cycles
   input integer n; 
	integer i;
	begin
		for (i =0; i<n ; i=i+1)
			step();
	end
endtask

task resetcpu;  //reset the CPU and the test
	begin
		reset = 1'b1; 
		step();
		#5 reset = 1'b0;
		numcycles = 0;
	end
endtask

task loadtestcase;  //load intstructions to instruction mem
	begin
		$readmemh({testcase, ".hex"},myinstrmem.ram);
		$display("---Begin test case %s-----", testcase);
	end
endtask
	
task checkreg;//check registers
   input [4:0] regid;
	input [31:0] results; 
	reg [31:0] debugdata;
	begin
	    debugdata=mycpu.myregfile.regfiles[regid]; //wait for signal to settle
		 if(debugdata==results)
		 	begin
				$display("OK: end of cycle %d reg %h need to be %h, get %h", numcycles-1, regid, results, debugdata);
			end
		else	
			begin
				$display("!!!Error: end of cycle %d reg %h need to be %h, get %h", numcycles-1, regid, results, debugdata);
			 end
	end
endtask

task checkmem;//check registers
   input [31:0] inputaddr;
   input [31:0] results;	
	reg [31:0] debugdata;
	reg [14:0] dmemaddr;
	begin
	    dmemaddr=inputaddr[16:2];
	    debugdata=mydatamem.ram[dmemaddr]; 
		 if(debugdata==results)
		 	begin
				$display("OK: end of cycle %d mem addr= %h need to be %h, get %h", numcycles-1, inputaddr, results, debugdata);
			end
		else	
			begin
				$display("!!!Error: end of cycle %d mem addr= %h need to be %h, get %h", numcycles-1, inputaddr, results, debugdata);
			 end
	end
endtask

task checkpc;//check PC
	input [31:0] results; 
	begin
		 if(mycpu.pc==results)
		 	begin
				$display("OK: end of cycle %d PC need to be %h, get %h", numcycles-1,  results, mycpu.pc);
			end
		else	
			begin
				$display("!!!Error: end of cycle %d PC need to be %h, get %h", numcycles-1, results, mycpu.pc);
			 end
	end
endtask

integer maxcycles =10000;

task run;
   integer i;
	begin
	   i = 0;
	   while( (mycpu.instr!=32'hdead10cc) && (i<maxcycles))
		begin
		   step();
			i=i+1;
		end
	end
endtask

task checkmagnum;
    begin
	    if(numcycles>maxcycles)
		 begin
		   $display("!!!Error:test case %s does not terminate!", testcase);
		 end
		 else if(mycpu.myregfile.regfiles[10]==32'hc0ffee)
		    begin
		       $display("OK:test case %s finshed OK at cycle %d.", testcase, numcycles-1);
		    end
		 else if(mycpu.myregfile.regfiles[10]==32'hdeaddead)
		 begin
		   $display("!!!ERROR:test case %s finshed with error in cycle %d.", testcase, numcycles-1);
		 end
		 else
		 begin
		    $display("!!!ERROR:test case %s unknown error in cycle %d.", testcase, numcycles-1);
		 end
	 end
endtask

task loaddatamem;
    begin
	     $readmemh({testcase, "_d.hex"},mydatamem.ram);
	 end
endtask

task run_riscv_test;
    begin
	   loadtestcase();
	   loaddatamem();
	   resetcpu();
	   run();
	   checkmagnum();
	 end
endtask
	
initial begin:TestBench
      #80
      // output the state of every instruction
	//	$monitor("cycle=%d, pc=%h, instruct= %h op=%h, rs1=%h,rs2=%h, rd=%h, imm=%h,test=%h,test2=%h", 
	//	       numcycles,  mycpu.pc, mycpu.instr, mycpu.op, mycpu.rs1,mycpu.rs2,mycpu.rd,mycpu.imm,mycpu.alua,mycpu.zero);
/*
     testcase = "addtest";
     loadtestcase();
     resetcpu();
     step();
     checkreg(6,100); //t1==100
     step();
     checkreg(7,20); //t2=20
     step();
     checkreg(28,120); //t3=120
     $stop;
*/
		
		testcase = "rv32ui-p-simple";
		run_riscv_test();
		testcase = "rv32ui-p-add";
		run_riscv_test();
		testcase = "rv32ui-p-addi";
		run_riscv_test();
		testcase = "rv32ui-p-and";
		run_riscv_test();
		testcase = "rv32ui-p-andi";
		run_riscv_test();
	    testcase = "rv32ui-p-auipc";
		run_riscv_test();
		testcase = "rv32ui-p-beq";
		run_riscv_test();
		testcase = "rv32ui-p-bge";
		run_riscv_test();
		testcase = "rv32ui-p-bgeu";
		run_riscv_test();
		testcase = "rv32ui-p-blt";
		run_riscv_test();
		testcase = "rv32ui-p-bltu";
		run_riscv_test();
		testcase = "rv32ui-p-bne";
		run_riscv_test();
		testcase = "rv32ui-p-jal";
		run_riscv_test();
		testcase = "rv32ui-p-jalr";
		run_riscv_test();
		testcase = "rv32ui-p-lb";
		run_riscv_test();
		testcase = "rv32ui-p-lbu";
		run_riscv_test();
		testcase = "rv32ui-p-lh";
		run_riscv_test();
		testcase = "rv32ui-p-lhu";
		run_riscv_test();
		testcase = "rv32ui-p-lui";
		run_riscv_test();
		testcase = "rv32ui-p-lw";
		run_riscv_test();
		testcase = "rv32ui-p-or";
		run_riscv_test();
		testcase = "rv32ui-p-ori";
		run_riscv_test();
		testcase = "rv32ui-p-sb";
		run_riscv_test();
		testcase = "rv32ui-p-sh";
		run_riscv_test();
		testcase = "rv32ui-p-sll";
		run_riscv_test();
		testcase = "rv32ui-p-slli";
		run_riscv_test();
		testcase = "rv32ui-p-slt";
		run_riscv_test();
		testcase = "rv32ui-p-slti";
		run_riscv_test();
		testcase = "rv32ui-p-sltiu";
		run_riscv_test();
		testcase = "rv32ui-p-sltu";
		run_riscv_test();
		testcase = "rv32ui-p-sra";
		run_riscv_test();
		testcase = "rv32ui-p-srai";
		run_riscv_test();
		testcase = "rv32ui-p-srl";
		run_riscv_test();
		testcase = "rv32ui-p-srli";
		run_riscv_test();
		testcase = "rv32ui-p-sub";
		run_riscv_test();
		testcase = "rv32ui-p-sw";
		run_riscv_test();
		testcase = "rv32ui-p-xor";
		run_riscv_test();
		testcase = "rv32ui-p-xori";
		run_riscv_test();
		
		
		$stop;
		
end

endmodule
