`timescale 1ns / 100ps
`default_nettype none


module fsqrt_p2 //2clock
    (input wire         clk,
     input wire  [31:0] input_a,
     input wire  [35:0] cons_and_grad, //blockramから出てくる値。上�?23ビットが定数�?、下�?13ビットが勾�?
     output wire  [9:0] addr, //blockramにアドレスとして渡す仮数部の上�?10ビッ�?(暗黙�?�1は入って�?な�?)
     output reg [31:0] result);
    
    /* 入力を�?フィールドに�?割 */
    wire         sign1;
    wire  [7:0]  exp1;
    wire  [8:0]  mant_head1;
    wire [13:0]  mant_tail1;

    /* blockramから来た�?�を定数�?と勾配に�?割 */
    wire  [22:0] cons23;
    wire  [23:0] cons24; //cons23の�?下位ビ�?トに0を�?�結したもの。計算に使って�?く�?�はこっち
    wire  [12:0] grad13;

    /* 第二ス�?ージ移行時の�?フィールド�?�保存�??*/
    reg         sign2;
    reg  [7:0]  exp2;
    reg [13:0]  mant_tail2;

    /* 第二ス�?ージで勾配とa1をかけたも�?�と、定数�?のLSB1bit拡張を第三ス�?ージへと値を保�? */
    wire [13:0] a1_grad14_even;
    wire [13:0] a1_grad14_odd;
    wire [13:0] a1_grad14;

    assign {sign1, exp1, mant_head1, mant_tail1} = input_a;

    /* 第三ス�?ージで計算する�??数の�?フィール�? */
    wire        result_sign;
    wire  [7:0] result_exp;
    wire [23:0] result_man; //暗黙�?�1が計算結果に含まれて�?る�?�で、�?�とまずそれも受け取る


/* -----------1st stage----------------*/

    assign addr = {exp1[0], mant_head1}; //アドレス渡�?

    always @(posedge clk) begin
        sign2      <= sign1;
        exp2       <= exp1;
        mant_tail2 <= mant_tail1;
    end

/* -----------1st stage----------------*/

/* -----------2nd stage----------------*/

    assign {cons23, grad13} = cons_and_grad; //blockramから定数�?と勾配を受け取る
    assign cons24 = {cons23, 1'b0}; //24bitに拡張
    assign a1_grad14_even = ({13'b0,mant_tail2} * grad13) >> 13; //指数部が偶数の時は、指数部から仮数部に2が降りてくるので（下駄ばきの127が奇数であることに注意）勾配とa1をかけて14ビットに丸める
    assign a1_grad14_odd = ({13'b0,mant_tail2} * grad13) >> 14; //指数部が奇数の時は、勾配とa1をかけて14ビットに丸める

    assign a1_grad14 = (exp2[0] == 1'b0) ? a1_grad14_even : a1_grad14_odd;


    assign result_man = cons24 + a1_grad14; //暗黙�?�1含めた24bit
    assign result_sign = sign2;
    assign result_exp = (exp2 == 8'b0) ? 8'b0 : ({1'b0,exp2} + 9'd127) >> 1; //maybe we can calculate this in earlier stage.

    always @(posedge clk) begin
        result <= {result_sign, result_exp, result_man[22:0]};
    end
/* -----------2nd stage----------------*/

endmodule

`default_nettype wire