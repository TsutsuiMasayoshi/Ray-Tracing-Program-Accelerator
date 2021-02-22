`timescale 1ns / 100ps
`default_nettype none

module floor
    (input wire clk,
     input wire [31:0] input_a,
     output wire [31:0] output_a);
    
    wire sign;
    reg signreg;
    wire [7:0] exp;
    reg [7:0] expreg;
    wire [7:0] carried_exp;
    reg [7:0] carried_expreg;
    wire [22:0] mant;
    reg [22:0] mantreg;

    wire [7:0] shift_len;
    wire [22:0] overfp_mask; //like 1111100000000000000000
    wire [22:0] underfp_mask; //like 0000011111111111111111
    reg [22:0] overfp_maskreg;
    reg [22:0] underfp_maskreg;

    wire [22:0] carry; //use in minus case.
    reg [22:0] carryreg;
    wire [22:0] mant_overfp;
    wire [22:0] mant_underfp;
    wire [22:0] underrounded_mant;

    assign {sign,exp,mant} = input_a;

    assign carried_exp = exp + 8'b1;

    assign shift_len = 8'd150 - exp;
    assign carry = 23'b1 << shift_len;
    assign overfp_mask = 23'h7fffff << shift_len;
    assign underfp_mask = 23'h7fffff >> (23'd23-shift_len);

    always @(posedge clk) begin
        overfp_maskreg <= overfp_mask;
        underfp_maskreg <= underfp_mask;
        carryreg <= carry;
        signreg <= sign;
        expreg <= exp;
        mantreg <= mant;
        carried_expreg <= carried_exp;
    end


    assign mant_overfp = mantreg & overfp_maskreg;
    assign mant_underfp = mantreg & underfp_maskreg;
    assign underrounded_mant = (mantreg & overfp_maskreg) + carryreg;


    assign output_a = (expreg <= 8'd126) ? ((signreg == 1'b0 || expreg == 0) ? {signreg,31'b0} : {signreg,8'd127,23'b0}) :
                     ((expreg < 8'd150) ? ((signreg == 1'b0 || mant_underfp == 23'b0) ? {signreg,expreg,mant_overfp} :
                                          ((mant_overfp == overfp_maskreg) ? {signreg,carried_expreg,23'b0} :
                                          {signreg,expreg,underrounded_mant})) :
                     {signreg,expreg,mantreg});


    /*always @(posedge clk) begin
        if (exp <= 8'd126) begin
            if (sign == 1'b0 || exp == 0) begin
                output_a <= {sign,31'b0};
            end
            else begin
                output_a <= {sign,8'd127,23'b0};
            end
        end
        else if (exp < 8'd150) begin
            if (sign == 1'b0 || mant_underfp == 23'b0) begin //case in which minus ans underfp are all 0
                output_a <= {sign,exp,mant_overfp};
            end
            else if (mant_overfp == overfp_mask) begin //case in which minus and overfp are all 1
                output_a <= {sign,carried_exp,23'b0};
            end
            else begin
                output_a <= {sign,exp,underrounded_mant};
            end
        end
        else begin
            output_a <= input_a;
        end
    end*/ 
endmodule

`default_nettype wire