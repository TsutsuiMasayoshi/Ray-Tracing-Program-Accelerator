`timescale 1ns / 100ps

module inv_table (clk,we, addr, din, dout);
input clk;
input we;
input [9:0] addr;
input [35:0] din;
output [35:0] dout;
reg [35:0] ram [0:1023];
reg [35:0] dout;
initial begin
$readmemb("cons_grad_table2.mem",ram);
end
always @(posedge clk)
begin
 if (we)
 ram[addr] <= din;
 dout <= ram[addr];
end endmodule

/*
module inv_table
    (input wire clk,
     input wire we,
     input wire [9:0] addr,
     input wire [15:0] din,
     output reg [15:0] dout);
    
    (* RAM_STYLE="BLOCK" *) reg [22:0] ram [0:1023];

    initial begin
        $readmemb("inv_table.data", ram, 0, 1023);
    end

    always @(posedge clk) begin
        if (we)
            ram[addr] <= din;

        dout <= ram[addr];
    end
endmodule
*/