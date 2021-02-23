module maindec(input logic[5:0] op,funct,
               input logic[4:0] second,
               input logic recv_valid,
               output logic memtoreg,memwrite,
               output logic[2:0] branch,
               output logic[1:0] alusrc,
               output logic regdst,
               output logic[1:0]regwrite,
               output logic rawrite,
               output logic[1:0] jump,
               output logic soru,
               output logic[1:0] out,
               output logic[2:0] aluop,
               output logic[1:0] regaorf1,regaorf2,rf3flag,
               output logic[1:0] aorf,
               output logic bsltiflag,
               output logic[1:0] readflag);
  logic[29:0] controls;
  assign {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump,rawrite,soru,out,aluop,regaorf1,regaorf2,rf3flag,aorf,bsltiflag,readflag} = controls;
  //branch 001:beq 010:bne 011:bslt 100:bfeq 101:bfless
  always_comb
    case(op)
      6'b000000: case(funct)
                 6'b001000: controls <= 30'b001000000010000000000000000000; //jr
                 default:   controls <= 30'b011000000000000010000000000000; //rtype
                 endcase                    
      6'b100011: controls <= 30'b010010000100000000000000000000; //lw
      6'b101011: controls <= 30'b000010001000000000000000000000; //sw
      6'b110001: controls <= 30'b100010000100000000000010000000; //lwc1
      6'b111001: controls <= 30'b000010001000000000000010000000; //swc1
      6'b101101: controls <= 30'b010100000100000000000000000000; //lw2
      6'b101110: controls <= 30'b000100001000000000000000000000; //sw2
      6'b000100: controls <= 30'b000000010000000000000000000000; //beq
      6'b000101: controls <= 30'b000000100000000000000000000000; //bne
      6'b100000: controls <= 30'b000000010000000000000000000100; //beqi
      6'b100001: controls <= 30'b000000100000000000000000000100; //bnei
      6'b100010: controls <= 30'b000000110000000000000000000000; //bslt
      6'b100100: controls <= 30'b000000110000000000000000000100; //bslti1
      //6'b100101: controls <= 30'b000000110000000000000000000100; //bslti2
      6'b100110: controls <= 30'b000001000000000000001010000000; //bfeq
      6'b100111: controls <= 30'b000001010000000000001010000000; //bfless
      6'b101000: controls <= 30'b000001010000000000010010000000; //bflessi
      6'b101001: controls <= 30'b000001010000000000011010000000; //bflessi2
      6'b101010: controls <= 30'b000001010000000000001100000000; //bflessi3
      6'b101100: controls <= 30'b000001010000000000001110000000; //bflessi4
      6'b001000: controls <= 30'b010010000000000000000000000000; //addi
      6'b001010: controls <= 30'b010010000000000001000000000000; //slti
      //6'b001101: controls <= 30'b010010000000010001100000000000; //ori(soru=1)
      //6'b011101: controls <= 29'b10010000000010001101010000000; //fori
      6'b011100: controls <= 30'b100010000000010001110100100000; //fori1
      6'b011101: controls <= 30'b100010000000010001110101000000; //fori2
      //6'b001111: controls <= 30'b010010000000000010100000000000; //lui
      //6'b011111: controls <= 29'b10010000000000010101010000000; //flui
      6'b011110: controls <= 30'b100010000000000010110100100000; //flui1
      6'b011111: controls <= 30'b100010000000000010110101000000; //flui2
      
      6'b000010: controls <= 30'b000000000001000000000000000000; //j
      6'b000011: controls <= 30'b010000000001100000000000000000; //jal
      6'b010001: case(second)
                 5'b10000:begin
                          case(funct)
                          6'b000110: controls <= 30'b011000000000000000001010010000;//ftoi
                          6'b000111: controls <= 30'b101000000000000000000000001000;//itof
                          6'b111100: controls <= 30'b011000000000000000001010010000;//feq
                          6'b110010: controls <= 30'b011000000000000000001010010000;//fless
                          default:   controls <= 30'b101000000000000000001010001000;
                          endcase
                          end
                 5'b10001:controls <= 30'b101000000000000000010010001000;
                 5'b10010:controls <= 30'b101000000000000000011010001000;
                 5'b10011:controls <= 30'b101000000000000000001100001000;
                 5'b10100:controls <= 30'b101000000000000000001110001000;
                 endcase
      //6'b111111: controls <= 30'b000000000000000100000000000000; //outi
      6'b111110: controls <= 30'b000000000000001000000000000000; //outc
      6'b111101: begin
                    if (recv_valid == 0) begin
                        controls <= 30'b000000000000000000000000000001;
                    end else begin
                        controls <= 30'b000000000000000000000000000000;
                    end
                 end //readi
      6'b111100: begin
                    if (recv_valid == 0) begin
                        controls <= 30'b000000000000000000000000000010;
                    end else begin
                        controls <= 30'b000000000000000000000000000000;
                    end
                 end //readf
      //6'b111011: controls <= 30'b000000000000001100000000000000; //outf
      default:   controls <= 30'b000000000000000000000000000000;
    endcase
endmodule
