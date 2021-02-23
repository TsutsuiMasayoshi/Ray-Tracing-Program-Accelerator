`timescale 1ns / 100ps
`default_nettype none

module ftoi 
    (input wire clk,
     input wire [31:0] input_a,
     output wire [31:0] output_a);
    
    wire sign;
    reg signreg;
    wire [7:0] exp;
    reg [7:0] expreg;
    wire [22:0] mant;
    wire [23:0] mant24;
    wire round_bit;
    wire [31:0] p_ans_assumed_s; //answer when 127 <= exp <= 149
    wire [31:0] p_ans_assumed_l; //150 <= exp <= 158
    reg [31:0] p_ans_assumed_sreg;
    reg [31:0] p_ans_assumed_lreg;
    wire [31:0] n_ans_assumed_s; //answer when 127 <= exp <= 149 (minus case)
    wire [31:0] n_ans_assumed_l; //150 <= exp <= 158 (minus case)

    assign {sign,exp,mant} = input_a;
    assign mant24 = {1'b1,mant};


    assign round_bit = (mant >> (8'd149 - exp)) & 1'b1;
    assign p_ans_assumed_s = (mant24 >> (8'd150 - exp)) + round_bit;
    assign p_ans_assumed_l = mant24 << (exp - 8'd150);

    always @(posedge clk) begin
        signreg <= sign;
        expreg <= exp;
        p_ans_assumed_sreg <= p_ans_assumed_s;
        p_ans_assumed_lreg <= p_ans_assumed_l;
    end
    
    assign n_ans_assumed_s = 33'h100000000 - p_ans_assumed_sreg;
    assign n_ans_assumed_l = 33'h100000000 - p_ans_assumed_lreg;

    assign output_a = (expreg < 8'd126) ? 32'b0 :
                     ((expreg == 8'd126) ? ((signreg == 1'b0) ? 32'b1 : 32'hffffffff) :
                     ((expreg < 8'd150) ? ((signreg == 1'b0) ? p_ans_assumed_sreg : n_ans_assumed_s) :
                     ((expreg < 8'd158) ? ((signreg == 1'b0) ? p_ans_assumed_lreg : n_ans_assumed_l) :
                     32'b0)));



    /*always @(posedge clk) begin
        if (exp < 8'd126) begin
            output_a <= 32'b0;
        end
        else if (exp == 8'd126) begin
            if (sign == 1'b0) begin
                output_a <= 32'b1;
            end
            else begin
                output_a <= 32'hffffffff;
            end
        end
        else if (exp < 8'd150) begin
            if (sign == 1'b0) begin
                output_a <= p_ans_assumed_s;
            end
            else begin
                output_a <= n_ans_assumed_s;
            end
        end
        else if (exp < 8'd158) begin
            if (sign == 1'b0) begin
                output_a <= p_ans_assumed_l;
            end
            else begin
                output_a <= n_ans_assumed_l;
            end
        end
        else begin
            output_a <= 32'b0;
        end
    end */
endmodule

`default_nettype wire