`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/09 21:28:19
// Design Name: 
// Module Name: hamming7check_tb
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


module hamming7check_tb(   );
  reg [7:1] DI, DU;
  wire [7:1] DC;
  wire NOERR;
  reg [3:0] DATA;
  integer nib, i, errors;

hamming7check hamming7check_tst (.DU(DU), .DC(DC), .NOERROR(NOERR));

initial begin
  errors = 0;
  for (nib=0; nib<=15; nib=nib+1) begin
    DATA[3:0] = nib;
    DI[7:5] = DATA[3:1]; DI[3] = DATA[0]; // Merge in data value
    DI[4] = DI[7] ^ DI[6] ^ DI[5];        // Merge in check bits
    DI[2] = DI[7] ^ DI[6] ^ DI[3];
    DI[1] = DI[7] ^ DI[5] ^ DI[3];
    DU = DI; #2 ;             // Check no-error case
    if ((DC!==DI) || (NOERR!==1'b1)) begin
      errors = errors + 1;
      $display("Error, DI=%b, DU=%b, DC=%b, NOERR=%b",DI,DU,DC,NOERR);
    end
    for (i=1; i<=7; i=i+1) begin      // Insert error in each bit position
      DU = DI; DU[i] = ~DI[i]; #2 ;  // and check that it's corrected
        if ((DC!==DI) || (NOERR!==1'b0)) begin
          errors = errors + 1;
          $display("Error, DI=%b, DU=%b, DC=%b, NOERR=%b",DI,DU,DC,NOERR);
        end
    end
  end
  $display("Test completed, %0d errors",errors);
  $stop(1); $fflush;
end     
endmodule
