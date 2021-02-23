`timescale 1ns / 100ps
`default_nettype none

module fmul_p1  //overflow?????‹““®‚Í–¢’è‹`Bunderflow?????0‚É‚³‚ê‚é?????³‹K‰»”‚ÌŠ|‚¯Z‚É‚Í‘Î‰???
    (input wire clk,
     input wire [31:0] x1,
     input wire [31:0] x2,
     output wire [31:0] y); //caution! not "reg" but "wire"!
    
    wire sign1; //x1‚Ì•„†bit
    wire sign2; //x2‚Ì•„†bit
    wire [7:0] exp1; //x1‚Ì????”•”
    wire [7:0] exp2; //x2‚Ì????”•”
    reg [7:0] exp1reg; //x1‚Ì????”•”
    reg [7:0] exp2reg; //x2‚Ì????”•”
    wire [22:0] mant1; //x1‚Ì‰¼”•”
    wire [22:0] mant2; //x2‚Ì‰¼”•”
    
    wire [12:0] mant1_hi;
    wire [10:0] mant1_lo;
    wire [12:0] mant2_hi;
    wire [10:0] mant2_lo;

    wire [25:0] hh;
    wire [23:0] hl;
    wire [23:0] lh;

    reg [25:0] hhreg;
    reg [23:0] hlreg;
    reg [23:0] lhreg;

    wire [8:0] exp_assumed; //underflow‚É”õ‚¦‚Ä1bitŠg’£
    reg [8:0] exp_assumedreg; //underflow‚É”õ‚¦‚Ä1bitŠg’£
    wire [8:0] exp_assumed_carried;
    wire [25:0] mant_assumed;

    wire ans_sign; //“š‚¦‚Ì•„†
    reg ans_signreg;
    wire [7:0] ans_exp;
    wire [22:0] ans_mant;
    
    assign {sign1, exp1, mant1} = x1;
    assign {sign2, exp2, mant2} = x2;

    wire [8:0] exp_sum; //“ü—Í?????‚Ì????”•”‚Ì????.Œ…ã‚ª‚è‚à????—¶‚µ‚Ä9????
    reg [8:0] exp_sumreg;

    assign {mant1_hi, mant1_lo} = {1'b1, mant1};
    assign {mant2_hi, mant2_lo} = {1'b1, mant2};

    assign exp_sum = {1'b0,exp1} + {1'b0,exp2};


    assign hh = {13'b0,mant1_hi} * mant2_hi;
    assign hl = {11'b0,mant1_hi} * mant2_lo;
    assign lh = {11'b0,mant2_hi} * mant1_lo;
    assign exp_assumed = exp_sum - 9'd127;
    assign ans_sign = sign1 ^ sign2;

    always @(posedge clk) begin
        hhreg <= hh;
        hlreg <= hl;
        lhreg <= lh;
        exp_assumedreg <= exp_assumed;
        ans_signreg <= ans_sign;
        exp_sumreg <= exp_sum;
        exp1reg <= exp1;
        exp2reg <= exp2;
    end 


    assign mant_assumed = hhreg + (hlreg >> 4'd11) + (lhreg >> 4'd11) + 2'd2;
    assign exp_assumed_carried = exp_assumedreg + 1'd1;


    wire [1:0] underflow; //????”•”‚Ì˜a‚ª128ˆÈã‚Å‚ ‚ê‚Î0(underflow‚µ‚Ä????‚È????), 127‚Å‚ ‚ê‚Î1(‰¼”•”‚©‚ç‚Ìcarry‚ª‚ ‚ê?????underflow‚¹‚¸‚ÉÏ??), 127–¢????‚Å‚ ‚ê‚Î2(ŠmÀ‚Éunderflow‚·‚é)

    assign underflow = (exp_sumreg == 9'd127) ? 2'b01 : //????”•”‚Ì˜a‚ª127‚Ì????
                       ((exp_sumreg[8] == 1'b1 || exp_sumreg[7] == 1'b1) ? 2'b00 : 2'b10); //????”•”‚Ì˜a‚ªŒ…ã‚ª‚è‚µ‚Ä????‚é‚Æ‚«?????,-127‚µ‚Ä‚àunderflow‚µ‚¦‚È????‚Ì‚Å0.
    
    
    assign {ans_exp, ans_mant} = (exp1reg == 8'b0 || exp2reg == 8'b0) ? 31'b0 : //x1,x2‚Ì‚Ç‚¿‚ç‚©‚ª‚»‚à‚»????0‚È????0
                     ((underflow == 2'b01 && mant_assumed[25] == 1'b1) ? {exp_assumed_carried[7:0], mant_assumed[24:2]} : //????”•”‚Ì˜a‚ª127‚Ò‚Á‚½‚è‚ÅA‰¼”•”‚©‚ç‚Ìcarry‚ª‚ ‚é?????‡?????A‚¬‚è‚¬‚èunderflow‚ğ?????‚ê??
                     ((underflow == 2'b10 || underflow == 2'b01) ? {8'b0, 23'b0} : //underflowŠmÀ‚È?????0‚Å–„‚ß????
                     ((mant_assumed[25] == 1'b1) ? {exp_assumed_carried[7:0], mant_assumed[24:2]} : //underflow‚È‚µ‚ÅAcarry‚ª‚ ‚é
                     {exp_assumedreg[7:0], mant_assumed[23:1]}))); //underflow‚È‚µ?????carry‚à‚È????
    
    assign y = {ans_signreg, ans_exp, ans_mant};
    //always @(posedge clk) begin
        //y <= {ans_signreg, ans_exp, ans_mant};
    //end 


endmodule


`default_nettype wire