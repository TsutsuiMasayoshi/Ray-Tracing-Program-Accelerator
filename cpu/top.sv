module top(input logic clk,reset,
           input logic [31:0] recv_data,
           input logic recv_valid,
           output logic[7:0] output_data,
           output logic valid,
           //output logic[7:0] count,
           output logic flag
           );
  logic[13:0] pc;
  logic[31:0] instr,readdata,writedata,dataadr;
  logic memwrite;
  logic[1:0] out;
  logic[1:0] readflag;
  //logic[8:0] count_sub;
  //logic[7:0] count; //for debug
  mips mips(clk,reset,pc,instr,memwrite,out,dataadr,writedata,readflag,readdata,recv_data,recv_valid);
  imem imem(pc,instr);
  dmem dmem(clk,memwrite,dataadr,writedata,readdata);
  //assign count = count_sub[7:0];
  always_ff @(posedge clk) begin
    if (reset) begin
      valid <= 1'b0;
      flag <= 1'b0;
      //count_sub <= 0;
    end else begin
      if (out == 2'b10) begin
        output_data <= writedata[7:0];
        valid <= 1;
      end
      if (valid) begin
        valid <= 0;
      end
      if (readflag != 0) begin
        flag <= 1'b1;
      end
    end
  end
  
endmodule
