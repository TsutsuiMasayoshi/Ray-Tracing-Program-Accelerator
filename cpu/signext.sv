module signext(input logic[15:0] a,
               input logic soru,
               output logic[31:0] y);
    assign y = (soru)?{16'b0000000000000000,a}:{{16{a[15]}},a};
endmodule
