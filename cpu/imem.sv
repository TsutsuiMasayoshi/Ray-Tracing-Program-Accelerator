module imem(input logic [13:0] a,
            output logic [31:0] rd);
  logic [31:0] RAM[9000:0];
  initial
    $readmemb("memfile.dat",RAM);
  assign rd = RAM[a];
endmodule
