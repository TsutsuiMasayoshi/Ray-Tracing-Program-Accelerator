`timescale 1ns / 100ps
`default_nettype none

module itof 
    (input wire clk,
     input wire [31:0] input_a,
     output wire [31:0] output_a);
    
    wire [31:0] input_abs;
    reg [31:0] input_absreg;

    wire round_bit;
    reg round_bitreg;
    wire all_1flag;
    wire exp_carry;
    reg exp_carryreg;

    wire ans_sign;
    reg ans_signreg;
    wire [7:0] ans_exp;
    wire [22:0] ans_mant;



    assign ans_sign = (input_a[31] == 1'b1) ? 1'b1 : 1'b0;
    assign input_abs = (input_a[31] == 1'b1) ? 33'h100000000 - input_a : input_a;

    //this pattern match can rewrite in binary searching ...?
    assign {round_bit, all_1flag} = (input_abs[30] == 1'b1) ? {input_abs[6], &input_abs[29:7]} :
                                   ((input_abs[29] == 1'b1) ? {input_abs[5], &input_abs[28:6]} :
                                   ((input_abs[28] == 1'b1) ? {input_abs[4], &input_abs[27:5]} :
                                   ((input_abs[27] == 1'b1) ? {input_abs[3], &input_abs[26:4]} :
                                   ((input_abs[26] == 1'b1) ? {input_abs[2], &input_abs[25:3]} :
                                   ((input_abs[25] == 1'b1) ? {input_abs[1], &input_abs[24:2]} :
                                   ((input_abs[24] == 1'b1) ? {input_abs[0], &input_abs[23:1]} :
                                   2'b0))))));
    
    assign exp_carry = all_1flag & round_bit;

    always @(posedge clk) begin
       input_absreg <= input_abs; 
       round_bitreg <= round_bit;
       exp_carryreg <= exp_carry;
       ans_signreg <= ans_sign;
    end

    assign {ans_exp, ans_mant} = (input_absreg[30] == 1'b1) ? {8'd157+exp_carryreg, input_absreg[29:7]+round_bitreg} :
                                   ((input_absreg[29] == 1'b1) ? {8'd156+exp_carryreg, input_absreg[28:6]+round_bitreg} :
                                   ((input_absreg[28] == 1'b1) ? {8'd155+exp_carryreg, input_absreg[27:5]+round_bitreg} :
                                   ((input_absreg[27] == 1'b1) ? {8'd154+exp_carryreg, input_absreg[26:4]+round_bitreg} :
                                   ((input_absreg[26] == 1'b1) ? {8'd153+exp_carryreg, input_absreg[25:3]+round_bitreg} :
                                   ((input_absreg[25] == 1'b1) ? {8'd152+exp_carryreg, input_absreg[24:2]+round_bitreg} :
                                   ((input_absreg[24] == 1'b1) ? {8'd151+exp_carryreg, input_absreg[23:1]+round_bitreg} :
                                   ((input_absreg[23] == 1'b1) ? {8'd150, input_absreg[22:0]} :
                                   ((input_absreg[22] == 1'b1) ? {8'd149, {input_absreg[21:0],1'b0}} :
                                   ((input_absreg[21] == 1'b1) ? {8'd148, {input_absreg[20:0],2'b0}} :
                                   ((input_absreg[20] == 1'b1) ? {8'd147, {input_absreg[19:0],3'b0}} :
                                   ((input_absreg[19] == 1'b1) ? {8'd146, {input_absreg[18:0],4'b0}} :
                                   ((input_absreg[18] == 1'b1) ? {8'd145, {input_absreg[17:0],5'b0}} :
                                   ((input_absreg[17] == 1'b1) ? {8'd144, {input_absreg[16:0],6'b0}} :
                                   ((input_absreg[16] == 1'b1) ? {8'd143, {input_absreg[15:0],7'b0}} :
                                   ((input_absreg[15] == 1'b1) ? {8'd142, {input_absreg[14:0],8'b0}} :
                                   ((input_absreg[14] == 1'b1) ? {8'd141, {input_absreg[13:0],9'b0}} :
                                   ((input_absreg[13] == 1'b1) ? {8'd140, {input_absreg[12:0],10'b0}} :
                                   ((input_absreg[12] == 1'b1) ? {8'd139, {input_absreg[11:0],11'b0}} :
                                   ((input_absreg[11] == 1'b1) ? {8'd138, {input_absreg[10:0],12'b0}} :
                                   ((input_absreg[10] == 1'b1) ? {8'd137, {input_absreg[9:0],13'b0}} :
                                   ((input_absreg[9] == 1'b1) ? {8'd136, {input_absreg[8:0],14'b0}} :
                                   ((input_absreg[8] == 1'b1) ? {8'd135, {input_absreg[7:0],15'b0}} :
                                   ((input_absreg[7] == 1'b1) ? {8'd134, {input_absreg[6:0],16'b0}} :
                                   ((input_absreg[6] == 1'b1) ? {8'd133, {input_absreg[5:0],17'b0}} :
                                   ((input_absreg[5] == 1'b1) ? {8'd132, {input_absreg[4:0],18'b0}} :
                                   ((input_absreg[4] == 1'b1) ? {8'd131, {input_absreg[3:0],19'b0}} :
                                   ((input_absreg[3] == 1'b1) ? {8'd130, {input_absreg[2:0],20'b0}} :
                                   ((input_absreg[2] == 1'b1) ? {8'd129, {input_absreg[1:0],21'b0}} :
                                   ((input_absreg[1] == 1'b1) ? {8'd128, {input_absreg[0],22'b0}} :
                                   ((input_absreg[0] == 1'b1) ? {8'd127, {23'b0}} :
                                   ((ans_signreg == 1'b1) ? {8'd158, 23'b0} :
                                   31'b0)))))))))))))))))))))))))))))));

    assign output_a = {ans_signreg, ans_exp, ans_mant};

    //always @(posedge clk) begin
        //output_a <= {ans_sign, ans_exp, ans_mant};
    //end
    
endmodule

`default_nettype wire