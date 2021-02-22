
`timescale 1ns / 100ps
`default_nettype none


module fpu //for multicycle. not for pipeline
    (input wire         clk,
     input wire  [31:0] input_a,
     input wire  [31:0] input_b,
     input wire  [3:0] fpu_op, // fadd:0000, fsub:0001, fmul:0010, fdiv:0011, fsqrt:0100, floor:0101, ftoi:0110, itof:0111, feq:1000, fless:1001
     output wire [31:0] int_result, //use only in fless and feq. !caution! it is always assigned to feq_result except fless is directed.
     output wire  [31:0] result); //when div and other calculations finish at the same clock, div is selected as the fpu result

    wire [31:0] fadd_src_b;
    assign fadd_src_b = (fpu_op == 4'b0001) ? {~input_b[31],input_b[30:0]} : input_b; //when fsub, toggle the sign bit of input_b and send to fadd.
    
    wire [31:0] add_result;
    wire [31:0] mul_result;
    wire [31:0] div_result;
    wire        fless_result;
    wire        feq_result;
    wire [31:0] itof_result;
    wire [31:0] ftoi_result;
    wire [31:0] sqrt_result;
    wire [31:0] floor_result;
    wire [9:0] table_addr;
    wire [35:0] cons_and_grad;
    wire we;
    wire [35:0] din;

    assign {we,din} = 37'b0; //sqrt_table may not interpreted as block ram so in the case, we have to change this line.


    reg  [3:0] past_op1; //it keeps fpu_op 1clock ago
    reg  [3:0] past_op2; //it keeps fpu_op 2clocks ago
    reg  [3:0] past_op3; //it keeps fpu_op 3clocks ago

    always @(posedge clk) begin
        past_op1 <= fpu_op;
        past_op2 <= past_op1;
        past_op3 <= past_op2;
    end

     
    fadd u1(clk, input_a, fadd_src_b, add_result); //1clock
    fmul_p1 u2(clk, input_a, input_b, mul_result); //1clock
    fdiv u3(clk, input_a, input_b, div_result); //3clock
    fsqrt_p2 u4(clk, input_a, cons_and_grad, table_addr, sqrt_result); //2clock
    sqrt_table u5(clk, we, table_addr, din, cons_and_grad);
    fless u6(input_a, input_b, fless_result); //0clock
    feq u7(input_a, input_b, feq_result); //0clock
    itof u8(clk, input_a, itof_result);//1clock
    ftoi u9(clk, input_a, ftoi_result); //1clock
    floor u10(clk, input_a, floor_result); //1clock

    assign int_result = (past_op1 == 4'b0110) ? ftoi_result :
                       ((fpu_op == 4'b1001) ? fless_result :
                        feq_result); //ftoi has priority and when fpu_op is not 1001, int_result always emits feq_result.

    assign result = (past_op1 == 4'b0111) ? itof_result : 
                    ((past_op1 == 4'b0000 || past_op1 == 4'b0001) ? add_result :
                    ((past_op1 == 4'b0010) ? mul_result :
                    ((past_op1 == 4'b0101) ? floor_result :
                    ((past_op2 == 4'b0100) ? sqrt_result :
                    ((past_op3 == 4'b0011) ? div_result :
                     32'b0)))));
endmodule

`default_nettype wire