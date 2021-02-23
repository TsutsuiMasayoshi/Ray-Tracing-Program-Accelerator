module alu(input logic signed [31:0] scra,scrb,
           input logic[4:0] shamt,
           input logic[2:0] alucontrol,
           output logic[31:0] aluout);
 always_comb
   case(alucontrol)
     3'b011: aluout <= scrb << shamt;
     3'b100: aluout <= scrb >>> shamt;
     3'b010: aluout <= scra + scrb;
     3'b110: aluout <= scra - scrb;
     3'b000: aluout <= scra & scrb;
     3'b001: aluout <= scra | scrb;
     3'b101: aluout <= {scrb,16'b0000000000000000};
     3'b111: aluout <= (scra < scrb)?1:0;
     default:   aluout <= 1;
   endcase
endmodule
