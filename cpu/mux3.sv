module mux3 #(parameter WIDTH = 8)
             (input logic[WIDTH-1:0]d0,d1,d2,
              input logic[1:0] s,
              output logic[WIDTH-1:0]y);
  assign y = (s == 2'b00)? d0:
             (s == 2'b01)? d1: d2;
endmodule
