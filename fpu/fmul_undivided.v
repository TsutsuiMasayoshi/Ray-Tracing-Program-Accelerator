`timescale 1ns / 100ps
`default_nettype none

module fmul_p1  //overflow時�??��挙動は未定義。underflow時�??��0にされる�??��正規化数の掛け算には対応�??
    (input wire clk,
     input wire [31:0] x1,
     input wire [31:0] x2,
     output wire [31:0] y); //caution! not "reg" but "wire"!

    reg [31:0] x1reg;
    reg [31:0] x2reg;
    
    wire sign1; //x1の符号bit
    wire sign2; //x2の符号bit
    wire [7:0] exp1; //x1の?��?数部
    wire [7:0] exp2; //x2の?��?数部
    reg [7:0] exp1reg; //x1の?��?数部
    reg [7:0] exp2reg; //x2の?��?数部
    //reg [7:0] exp1reg_2; //x1の?��?数部
    //reg [7:0] exp2reg_2; //x2の?��?数部
    wire [22:0] mant1; //x1の仮数部
    wire [22:0] mant2; //x2の仮数部
    
    wire [12:0] mant1_hi;
    wire [10:0] mant1_lo;
    wire [12:0] mant2_hi;
    wire [10:0] mant2_lo;

    reg [12:0] mant1_hireg;
    reg [10:0] mant1_loreg;
    reg [12:0] mant2_hireg;
    reg [10:0] mant2_loreg;

    wire [25:0] hh;
    wire [23:0] hl;
    wire [23:0] lh;

    //reg [25:0] hhreg;
    //reg [23:0] hlreg;
    //reg [23:0] lhreg;

    wire [8:0] exp_assumed; //underflowに備えて1bit拡張
    reg [8:0] exp_assumedreg; //underflowに備えて1bit拡張
    //reg [8:0] exp_assumedreg_2; //underflowに備えて1bit拡張
    wire [8:0] exp_assumed_carried;
    //reg [8:0] exp_assumed_carriedreg;
    wire [25:0] mant_assumed;
    //reg [25:0] mant_assumedreg;

    wire ans_sign; //答えの符号
    reg ans_signreg;
    //reg ans_signreg_2;
    wire [7:0] ans_exp;
    wire [22:0] ans_mant;

    
    assign {sign1, exp1, mant1} = x1;
    assign {sign2, exp2, mant2} = x2;

    wire [8:0] exp_sum; //入力�??��の?��?数部の?��?.桁上がりも?��?慮して9?��?
    reg [8:0] exp_sumreg;

    assign {mant1_hi, mant1_lo} = {1'b1, mant1};
    assign {mant2_hi, mant2_lo} = {1'b1, mant2};

    assign exp_sum = {1'b0,exp1} + {1'b0,exp2};
    assign exp_assumed = exp_sum - 9'd127;
    assign ans_sign = sign1 ^ sign2;

    always @(posedge clk) begin
        //hhreg <= hh;
        //hlreg <= hl;
        //lhreg <= lh;
        mant1_hireg <= mant1_hi;
        mant2_hireg <= mant2_hi;
        mant1_loreg <= mant1_lo;
        mant2_loreg <= mant2_lo;
        exp_assumedreg <= exp_assumed;
        ans_signreg <= ans_sign;
        exp_sumreg <= exp_sum;
        exp1reg <= exp1;
        exp2reg <= exp2;
    end 


    assign hh = {13'b0,mant1_hireg} * mant2_hireg;
    assign hl = {11'b0,mant1_hireg} * mant2_loreg;
    assign lh = {11'b0,mant2_hireg} * mant1_loreg;


    assign mant_assumed = hh + (hl >> 4'd11) + (lh >> 4'd11) + 2'd2;
    assign exp_assumed_carried = exp_assumedreg + 1'd1;


    wire [1:0] underflow; //?��?数部の和が128以上であれば0(underflowして?��?な?��?), 127であれば1(仮数部からのcarryがあれ�??��underflowせずに済�?), 127未?��?であれば2(確実にunderflowする)
    //reg [1:0] underflowreg;

    assign underflow = (exp_sumreg == 9'd127) ? 2'b01 : //?��?数部の和が127の?��?
                       ((exp_sumreg[8] == 1'b1 || exp_sumreg[7] == 1'b1) ? 2'b00 : 2'b10); //?��?数部の和が桁上がりして?��?るとき�??��,-127してもunderflowしえな?��?ので0.

    //always @(posedge clk) begin
        //mant_assumedreg <= mant_assumed;
        //exp_assumed_carriedreg <= exp_assumed_carried;
        //underflowreg <= underflow;
        //exp1reg_2 <= exp1reg;
        //exp2reg_2 <= exp2reg;
        //exp_assumedreg_2 <= exp_assumedreg;
        //ans_signreg_2 <= ans_signreg;
    //end
    
    
    assign {ans_exp, ans_mant} = (exp1reg == 8'b0 || exp2reg == 8'b0) ? 31'b0 : //x1,x2のどちらかがそもそ?��?0な?��?0
                     ((underflow == 2'b01 && mant_assumed[25] == 1'b1) ? {exp_assumed_carried[7:0], mant_assumed[24:2]} : //?��?数部の和が127ぴったりで、仮数部からのcarryがある�??��合�??��、ぎりぎりunderflowを�??��れ�?
                     ((underflow == 2'b10 || underflow == 2'b01) ? {8'b0, 23'b0} : //underflow確実な時�??��0で埋め?��?
                     ((mant_assumed[25] == 1'b1) ? {exp_assumed_carried[7:0], mant_assumed[24:2]} : //underflowなしで、carryがある時
                     {exp_assumedreg[7:0], mant_assumed[23:1]}))); //underflowなし�??��carryもな?��?
    
    assign y = {ans_signreg, ans_exp, ans_mant};
    //always @(posedge clk) begin
        //y <= {ans_signreg, ans_exp, ans_mant};
    //end 


endmodule


`default_nettype wire