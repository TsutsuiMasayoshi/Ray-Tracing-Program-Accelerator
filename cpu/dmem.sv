module dmem(input logic clk,we,
            input logic[31:0] a,wd,
            output logic[31:0] rd);
  logic[31:0] RAM[115000:0] = '{115001{0}};
  always_ff @(posedge clk) begin
    if (we) RAM[a] <= wd;
    rd <= RAM[a];
  end
endmodule
