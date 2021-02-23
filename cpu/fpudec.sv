module fpudec(input logic[5:0] op,funct,
              input logic[4:0] second,
              output logic[3:0] fpucontrol,
              output logic[1:0] fpustall);

    always_comb
      if (op != 6'b010001) begin
        fpucontrol <= 4'b0000; 
        fpustall <= 2'b00;
      end else begin
          case(funct)
          6'b000000: begin
                         fpucontrol <= 4'b0000; 
                         fpustall <= 2'b01;
                     end //fadd
          6'b000001: begin 
                         fpucontrol <= 4'b0001;
                         fpustall <= 2'b01;
                     end //fsub
          6'b000010: begin
                         fpucontrol <= 4'b0010;
                         fpustall <= 2'b01;
                     end //fmul
          6'b000011: begin
                         fpucontrol <= 4'b0011;
                         fpustall <= 2'b11;
                     end //fdiv
          6'b000100: begin
                         fpucontrol <= 4'b0100;
                         fpustall <= 2'b10;
                     end //fsqrt
          6'b000101: begin 
                         fpucontrol <= 4'b0101;
                         fpustall <= 2'b01;
                     end //floor
          6'b000110: begin
                         fpucontrol <= 4'b0110;
                         fpustall <= 2'b01;
                     end //ftoi
          6'b000111: begin
                         fpucontrol <= 4'b0111;
                         fpustall <= 2'b01;
                     end //itof
          6'b110010: begin
                         fpucontrol <= 4'b1000;
                         fpustall <= 2'b00;
                     end//feq
          6'b111100: begin
                         fpucontrol <= 4'b1001;
                         fpustall <= 2'b00;
                     end//fless
            default: begin
                         fpucontrol <= 4'bxxxx;
                         fpustall <= 2'b00;
                     end
          endcase
      end
endmodule
