module aludec(input logic[5:0] funct,
              input logic[2:0] aluop,
              output logic[2:0] alucontrol);

    always_comb
      case(aluop)
        3'b000: alucontrol <= 3'b010; //add(lw,sw,addi)
        3'b001: alucontrol <= 3'b110; //sub(beq)
        3'b010: alucontrol <= 3'b111; //slt(slti)
        3'b011: alucontrol <= 3'b001; //or(ori)
        3'b101: alucontrol <= 3'b101; //lui
        default:case(funct)
          6'b000000: alucontrol <= 3'b011;//sll
          6'b000010: alucontrol <= 3'b100;//srl
          6'b100000: alucontrol <= 3'b010; //add
          6'b100010: alucontrol <= 3'b110; //sub
          6'b100100: alucontrol <= 3'b000; //and
          6'b100101: alucontrol <= 3'b001; //or
          6'b101010: alucontrol <= 3'b111; //slt
          default:   alucontrol <= 3'bxxx;
        endcase
      endcase
endmodule
