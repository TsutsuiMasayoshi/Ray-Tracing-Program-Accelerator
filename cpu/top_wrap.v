module top_wrap(input wire clk,reset,
           input wire [31:0] recv_data,
           input wire recv_valid,
           output wire [7:0] output_data,
           output wire valid,
           output wire flag
           );
  top(clk,reset,recv_data,recv_valid,output_data,valid,flag);
endmodule
