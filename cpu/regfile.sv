module regfile(input logic clk,
               input logic[1:0] we3,
               input logic rawrite,
               input logic[4:0] ra1,ra2,ra3,wa3,
               input logic[31:0] wd3,pc,
               input logic[1:0] regaorf1,regaorf2,
               input logic[31:0] outw,recv_data,
               input logic recv_valid,
               input logic[1:0] readflag,
               input logic[1:0] rf3flag,
               output logic[31:0] rd1,rd2,rd3);

  logic[31:0] rf[31:0] = '{32{0}};
  logic[31:0] rf2[31:0] = '{32{0}};
  logic[31:0] rf3[63:0] = '{64{0}};
  logic[5:0] num;
  logic[31:0] data;
  logic[1:0] valid;
  logic[5:0] ra1rf3,ra2rf3;
  
  assign num = (recv_valid == 1 & (readflag == 2'b01 | readflag == 2'b10))?{1'b0,ra2}:(rf3flag == 2'b10)?{1'b1,wa3}: {1'b0,wa3};
  assign data = (recv_valid == 1 & (readflag == 2'b01 | readflag == 2'b10))?recv_data:wd3;
  assign valid = (rf3flag != 0)? 2'b11:(((we3 == 2'b01))|(recv_valid == 1 & readflag == 2'b01))? 2'b01: (((we3 == 2'b10)) | (recv_valid == 1 & readflag == 2'b10))? 2'b10: 2'b00;
  
  always_ff @(posedge clk) begin
    if (valid == 2'b01) begin
        rf[num[4:0]] <= data;
    end else if (valid == 2'b10) begin
        rf2[num[4:0]] <= data;
    end else if (valid == 2'b11) begin
        rf3[num] <= data;
    end
    
    if (rawrite) begin
        rf[31] <= pc;
    end 
  end
  assign ra1rf3 = (regaorf1==2'b11)? {1'b1,ra1}:{1'b0,ra1};
  assign ra2rf3 = (regaorf2==2'b11)? {1'b1,ra2}:{1'b0,ra2};
  assign rd1 = (ra1 != 0 & (regaorf1 == 2'b00))? rf[ra1]:(ra1 != 31 & (regaorf1 == 2'b01))? rf2[ra1]: (regaorf1==2'b10|regaorf1==2'b11)? rf3[ra1rf3]:0;
  assign rd2 = (ra2 != 0 & (regaorf2 == 2'b00))? rf[ra2]:(ra2 != 31 & (regaorf2 == 2'b01))? rf2[ra2]: (regaorf2==2'b10|regaorf2==2'b11)? rf3[ra2rf3]:0;
  assign rd3 = rf[ra3];
endmodule
