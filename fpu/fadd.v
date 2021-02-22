`timescale 1ns / 100ps
`default_nettype none

module fadd
    (input wire clk,
     input wire [31:0] x1,
     input wire [31:0] x2,
     output wire [31:0] y);

    reg [31:0] x1reg;
    reg [31:0] x2reg;
    
    wire            sign1;
    //reg             sign1reg;
    wire            sign2;
    //reg             sign2reg;
    wire [7:0]      exp1;
    //reg [7:0]       exp1reg;
    wire [7:0]      exp2;
    //reg [7:0]       exp2reg;
    wire [22:0]     mant1;
    //reg [22:0]     mant1reg;
    wire [23:0]     mant1_24;
    reg [23:0]     mant1_24reg;
    wire [22:0]     mant2;
    //reg [22:0]     mant2reg;
    wire [23:0]     mant2_24;
    reg [23:0]     mant2_24reg;

    wire            addflag; //if sign1 == sign2 then 1 else 0
    reg            addflagreg;
    //reg            addflagreg_2;

    wire [7:0]      exp_dif;
    reg [7:0]      exp_difreg;

    wire [7:0]      exp_larger;
    reg [7:0]      exp_largerreg;
    //reg [7:0]      exp_largerreg_2;

    wire [23:0]     larger_m;
    //reg [23:0]     larger_mreg;
    wire [24:0]     larger_m_with0; //0bit is jointed to larger_m at tail. so 25 bit num.
    wire [23:0]     smaller_m;
    //reg [23:0]     smaller_mreg;
    wire [24:0]     smaller_m_withgb; // guard bit is jointed to smaller_mantissa at tail. so 25 bit num.
    wire [24:0]     mant_ans_raw;
    //reg [24:0]     mant_ans_rawreg;
    wire [25:0]     mant_ans_raw_withgb; //same as above
    //reg [25:0]     mant_ans_raw_withgbreg; //same as above


    wire            ans_sign;
    reg            ans_signreg;
    //reg            ans_signreg_2;
    wire [7:0]      ans_exp;
    wire [24:0]     ans_mant25; //[24]keeps always 0

    wire guardbit;


    assign {sign1,exp1,mant1} = (x1[30:23] == 8'b0) ? 32'b0 : x1;
    assign {sign2,exp2,mant2} = (x2[30:23] == 8'b0) ? 32'b0 : x2;
    

    assign mant1_24 = (x1[30:23] == 8'b0) ? 24'b0 : {1'b1,mant1};
    assign mant2_24 = (x2[30:23] == 8'b0) ? 24'b0 : {1'b1,mant2};

    assign addflag = sign1 == sign2; //when 1, add the mant. when 0, sub the mant

    assign {ans_sign,exp_larger,exp_dif} = (x1[30:0] > x2[30:0]) ? {sign1,exp1,exp1-exp2} : {sign2,exp2,exp2-exp1}; //IEEE754 fnum's small-large relation == the numbers interpreted them as integers' relation. //use for shiftlen
    
    always @(posedge clk) begin
        //larger_mreg <= larger_m;
        //smaller_mreg <= smaller_m;
        exp_difreg <= exp_dif;
        x1reg <= x1;
        x2reg <= x2;
        mant1_24reg <= mant1_24;
        mant2_24reg <= mant2_24;
        addflagreg <= addflag;
        exp_largerreg <= exp_larger;
        ans_signreg <= ans_sign;
    end

    assign {larger_m, smaller_m} = (x1reg[30:0] > x2reg[30:0]) ? ((exp_difreg > 8'd24) ? {mant1_24reg, 24'b0} : {mant1_24reg, mant2_24reg >> exp_difreg}) :
                                                           ((exp_difreg > 8'd24) ? {mant2_24reg, 24'b0} : {mant2_24reg, mant1_24reg >> exp_difreg});
    



    wire [4:0] gb_idx; //index of guardbit in mant
    assign gb_idx = exp_difreg - 1'b1;

    assign guardbit = (x1reg[30:0] > x2reg[30:0]) ? ((exp_difreg == 8'b0 || exp_difreg > 8'd24) ? 1'b0 : mant2_24reg[gb_idx]) :
                                              ((exp_difreg == 8'b0 || exp_difreg > 8'd24) ? 1'b0 : mant1_24reg[gb_idx]);

    assign larger_m_with0 = {larger_m,1'b0};
    assign smaller_m_withgb = {smaller_m,guardbit};

    assign mant_ans_raw_withgb = larger_m_with0 - smaller_m_withgb;

    assign mant_ans_raw = (addflagreg) ? {1'b0,larger_m} + smaller_m : mant_ans_raw_withgb[25:1]; //the latter is sub case
    
    //always @(posedge clk) begin
        //mant_ans_rawreg <= mant_ans_raw;
        //mant_ans_raw_withgbreg <= mant_ans_raw_withgb;
        //exp_largerreg_2 <= exp_largerreg;
        //addflagreg_2 <= addflagreg;
        //ans_signreg_2 <= ans_signreg;
    //end
    

    assign {ans_exp,ans_mant25} = (mant_ans_raw[24] == 1'b1) ? {exp_largerreg+8'd1,(mant_ans_raw>>1)} : //used only in add case
                               ((mant_ans_raw[23] == 1'b1 && addflagreg == 1) ? {exp_largerreg,mant_ans_raw} :
                               ((mant_ans_raw[23] == 1'b1) ? {exp_largerreg,mant_ans_raw_withgb[25:1]} :
                               ((mant_ans_raw[22] == 1'b1) ? {exp_largerreg-8'd1,mant_ans_raw_withgb[24:0]} :
                               ((mant_ans_raw[21] == 1'b1) ? {exp_largerreg-8'd2,{mant_ans_raw_withgb[23:0],1'b0}} :
                               ((mant_ans_raw[20] == 1'b1) ? {exp_largerreg-8'd3,{mant_ans_raw_withgb[22:0],2'b0}} :
                               ((mant_ans_raw[19] == 1'b1) ? {exp_largerreg-8'd4,{mant_ans_raw_withgb[21:0],3'b0}} :
                               ((mant_ans_raw[18] == 1'b1) ? {exp_largerreg-8'd5,{mant_ans_raw_withgb[20:0],4'b0}} :
                               ((mant_ans_raw[17] == 1'b1) ? {exp_largerreg-8'd6,{mant_ans_raw_withgb[19:0],5'b0}} :
                               ((mant_ans_raw[16] == 1'b1) ? {exp_largerreg-8'd7,{mant_ans_raw_withgb[18:0],6'b0}} :
                               ((mant_ans_raw[15] == 1'b1) ? {exp_largerreg-8'd8,{mant_ans_raw_withgb[17:0],7'b0}} :
                               ((mant_ans_raw[14] == 1'b1) ? {exp_largerreg-8'd9,{mant_ans_raw_withgb[16:0],8'b0}} :
                               ((mant_ans_raw[13] == 1'b1) ? {exp_largerreg-8'd10,{mant_ans_raw_withgb[15:0],9'b0}} :
                               ((mant_ans_raw[12] == 1'b1) ? {exp_largerreg-8'd11,{mant_ans_raw_withgb[14:0],10'b0}} :
                               ((mant_ans_raw[11] == 1'b1) ? {exp_largerreg-8'd12,{mant_ans_raw_withgb[13:0],11'b0}} :
                               ((mant_ans_raw[10] == 1'b1) ? {exp_largerreg-8'd13,{mant_ans_raw_withgb[12:0],12'b0}} :
                               ((mant_ans_raw[9] == 1'b1) ? {exp_largerreg-8'd14,{mant_ans_raw_withgb[11:0],13'b0}} :
                               ((mant_ans_raw[8] == 1'b1) ? {exp_largerreg-8'd15,{mant_ans_raw_withgb[10:0],14'b0}} :
                               ((mant_ans_raw[7] == 1'b1) ? {exp_largerreg-8'd16,{mant_ans_raw_withgb[9:0],15'b0}} :
                               ((mant_ans_raw[6] == 1'b1) ? {exp_largerreg-8'd17,{mant_ans_raw_withgb[8:0],16'b0}} :
                               ((mant_ans_raw[5] == 1'b1) ? {exp_largerreg-8'd18,{mant_ans_raw_withgb[7:0],17'b0}} :
                               ((mant_ans_raw[4] == 1'b1) ? {exp_largerreg-8'd19,{mant_ans_raw_withgb[6:0],18'b0}} :
                               ((mant_ans_raw[3] == 1'b1) ? {exp_largerreg-8'd20,{mant_ans_raw_withgb[5:0],19'b0}} :
                               ((mant_ans_raw[2] == 1'b1) ? {exp_largerreg-8'd21,{mant_ans_raw_withgb[4:0],20'b0}} :
                               ((mant_ans_raw[1] == 1'b1) ? {exp_largerreg-8'd22,{mant_ans_raw_withgb[3:0],21'b0}} :
                               ((mant_ans_raw[0] == 1'b1) ? {exp_largerreg-8'd23,{mant_ans_raw_withgb[2:0],22'b0}} :
                               33'b0)))))))))))))))))))))))));

    assign y = {ans_signreg,ans_exp,ans_mant25[22:0]};
    
    //always @(posedge clk) begin
        //y <= {ans_sign,ans_exp,ans_mant25[22:0]};
    //end
endmodule
`default_nettype wire
