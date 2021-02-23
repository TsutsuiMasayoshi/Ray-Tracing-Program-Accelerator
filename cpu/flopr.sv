module flopr #(parameter WIDTH = 8)
              (input logic clk,reset,
               input logic [WIDTH-1:0]d,
               input logic stall,
               input logic[WIDTH-1:0] pcbranch,
               input logic branchpredict,
               input logic[WIDTH-1:0] pcbranch2,
               input logic valid,
               output logic[WIDTH-1:0]q);
  always_ff@(posedge clk,posedge reset)
    if (reset) begin
        q <= 0;
    end else if ((stall == 0) & (branchpredict==1)) begin
        q <= pcbranch;
    end else if ((stall == 0) & valid) begin
        q <= pcbranch2;
    end else if(stall == 0) begin
        q <= d;
    end
endmodule
