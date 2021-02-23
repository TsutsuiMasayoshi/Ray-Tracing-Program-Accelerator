module uart_in #(CLK_PER_HALF_BIT = 434) (
               input wire rxd,
               output reg[31:0] recv_data,
               output reg recv_valid,
               input wire clk,
               input wire rstn);

   reg [1:0] status;
   reg [31:0] data;
   wire [7:0] rdata;
   wire rx_ready;
   wire ferr;
   localparam s_1 = 0;
   localparam s_2 = 1;
   localparam s_3 = 2;
   localparam s_4 = 3;

   uart_rx #(CLK_PER_HALF_BIT) u2(rdata, rx_ready, ferr, rxd, clk, rstn);
   always @(posedge clk) begin
      if (~rstn) begin
        status <= s_1;
        recv_valid <= 0;
      end else begin
        if (status == s_1 && rx_ready) begin
          recv_data[7:0] <= rdata;
          status <= s_2;
        end else if (status == s_2 && rx_ready) begin
          recv_data[15:8] <= rdata;
          status <= s_3;
        end else if (status == s_3 && rx_ready) begin
          recv_data[23:16] <= rdata;
          status <= s_4;
        end else if (status == s_4 && rx_ready) begin
          recv_data[31:24] <= rdata;
          recv_valid <= 1;
          status <= s_1;
        end
        if (recv_valid) begin
          recv_valid <= 0;
        end
      end
   end
endmodule