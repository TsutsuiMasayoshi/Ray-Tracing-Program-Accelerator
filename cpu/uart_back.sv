module uart_back #(CLK_PER_HALF_BIT = 434) (
               input logic [7:0] input_data,
               input logic       data_valid,
               output logic     txd,
               input logic       clk,
               input logic       rstn,
               input logic flag
               );

    logic[3:0] status;
    logic[7:0] sdata,data;
    logic [7:0] buffer [50000:0];
    logic tx_start;
    logic[17:0] count,count_send;
    logic tx_busy;
    localparam s_wait = 0;
    localparam s_data = 1;
    localparam s_wait_data = 2;
    
    uart_tx #(CLK_PER_HALF_BIT) u1(sdata, tx_start, tx_busy, txd, clk, rstn);
    
    initial
      buffer[0] <= 8'b10101010;
      
    always_ff @(posedge clk) begin
      if (~rstn) begin
        sdata <= 8'b0;
        tx_start <= 0;
        count <= 1;
        count_send <= 0;
        status <= s_wait;
      end else begin
        if (data_valid) begin
            buffer[count] <= input_data;
            count <= count + 1;
        end
        if (status == s_wait) begin
            if (count_send < count & flag) begin
                status <= s_data;
            end
        end else if (status == s_data & data_valid == 0) begin
          sdata <= buffer[count_send];
          status <= s_wait_data;
        end else if (~tx_busy && status == s_wait_data) begin
          tx_start <= 1;
          count_send <= count_send + 1;
          status <= s_wait;
        end
        if (tx_start) begin
          tx_start <= 0;
        end
      end
    end
    
endmodule
