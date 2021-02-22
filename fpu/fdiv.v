`timescale 1ns / 100ps
`default_nettype none


module fdiv //finv:2clock,fmul:1clock  total:3clock
    (input wire         clk,
     input wire  [31:0] input_a,
     input wire  [31:0] input_b,
     output wire  [31:0] result);
     
    wire   [9:0] bram_addr;
    wire  [35:0] bram_emit;
    wire  [31:0] inversed;
    wire         over126flag;
    reg          keep_flag;

    wire         we;
    assign we = 1'b0;
    wire  [35:0] din;
    assign din = 36'b0;
    
    reg [31:0] keep_a2;
    reg [31:0] keep_a3;
    //reg [31:0] keep_a4;

    wire [31:0] assumed_result;

    finv_p2 u1(clk, input_b, bram_emit, bram_addr, inversed, over126flag);
    inv_table u2(clk, we, bram_addr, din, bram_emit);
    fmul_p1 u3(clk, keep_a3, inversed, assumed_result);

    assign result = (keep_flag == 1'b1) ? {assumed_result[31], assumed_result[30:23]-1'b1, assumed_result[22:0]} : assumed_result; //subtract 1 from exp

    always @(posedge clk) begin
        keep_a2 <= input_a;
        keep_a3 <= keep_a2;
        keep_flag <= over126flag;
        //keep_a4 <= keep_a3;
    end

endmodule

`default_nettype wire