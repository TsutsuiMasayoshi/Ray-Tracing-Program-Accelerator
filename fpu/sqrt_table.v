`timescale 1ns / 100ps

module sqrt_table (clk,we, addr, din, dout);
input clk;
input we;
input [9:0] addr;
input [35:0] din;
output [35:0] dout;
reg [35:0] ram [0:1023];
reg [35:0] dout;
initial begin
$readmemb("sqrt_table.mem",ram);
end
always @(posedge clk)
begin
 if (we)
 ram[addr] <= din;
 dout <= ram[addr];
end endmodule