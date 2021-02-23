`default_nettype none

module uart_rx #(CLK_PER_HALF_BIT = 434) (
               output logic [7:0] rdata,
               output logic       rdata_ready,
               output logic       ferr,
               input wire         rxd,
               input wire         clk,
               input wire         rstn);

   localparam e_clk_bit = CLK_PER_HALF_BIT * 2 - 1;

   localparam e_clk_start_bit = CLK_PER_HALF_BIT-1;

   localparam e_clk_stop_bit = (CLK_PER_HALF_BIT*19)/20 - 1;

   logic [7:0]                  rxbuf;
   logic [3:0]                  status;
   logic [31:0]                 counter;
   logic                        next;
   logic                        start;
   logic                        fin_stop_bit;
   logic                        rst_ctr;
   (* ASYNC_REG = "true" *) reg [2:0] reg1;

   localparam s_wait = 0;
   localparam s_start_bit = 1;
   localparam s_bit_0 = 2;
   localparam s_bit_1 = 3;
   localparam s_bit_2 = 4;
   localparam s_bit_3 = 5;
   localparam s_bit_4 = 6;
   localparam s_bit_5 = 7;
   localparam s_bit_6 = 8;
   localparam s_bit_7 = 9;
   localparam s_stop_bit = 10;
   localparam s_send_bit = 11;

   always @(posedge clk) begin
      if (~rstn) begin
         counter <= 0;
         next <= 0;
         start <=0;
      end else begin
         if (counter == e_clk_bit || rst_ctr) begin
            counter <= 0;
         end else if (status != s_wait) begin
            counter <= counter + 1;
         end
         if (~rst_ctr && counter == e_clk_bit) begin
            next <= 1;
         end else begin
            next <= 0;
         end
         if (~rst_ctr && counter == e_clk_start_bit) begin
            start <= 1;
         end else begin
            start <= 0;
         end
         if (~rst_ctr && counter == e_clk_stop_bit) begin
            fin_stop_bit <= 1;
         end else begin
            fin_stop_bit <= 0;
         end
      end
   end

   always @(posedge clk) begin
       if (~rstn) begin
          rxbuf <= 8'b0;
          rdata <= 8'b0;
          status <= s_wait;
          rst_ctr <= 0;
          ferr <= 0;
          rdata_ready <= 0;
          reg1[0] <= 1;
       end else begin
          rst_ctr <= 0;
          ferr <= 0;
          rdata_ready <= 0;
          reg1 <= {rxd,reg1[2:1]};
          if (status == s_wait) begin
             if (reg1[0] == 0 && reg1[1] == 0 && reg1[2] == 0) begin
               status <= s_start_bit;
               rst_ctr <= 1;
             end
          end else if (status == s_start_bit) begin
             if (start) begin
               status <= s_bit_0;
               rst_ctr <= 1;
             end
          end else if (status == s_stop_bit) begin
             if (next) begin
               if (reg1[0] == 1'b0) begin
                 ferr <= 1;
               end
               status <= s_send_bit;
             end
          end else if (status == s_send_bit) begin
             if (fin_stop_bit) begin
               rdata <= rxbuf;
               rdata_ready <= 1;
               status <= s_wait;
               rst_ctr <= 1;
             end
          end else if (next) begin
               rxbuf <= {reg1[0],rxbuf[7:1]};
               status <= status +1;
           end
       end
    end
endmodule
`default_nettype wire
