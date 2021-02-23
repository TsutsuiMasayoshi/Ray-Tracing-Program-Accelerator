module uart_back_wrap #(CLK_PER_HALF_BIT = 434) (
               input wire [7:0] input_data,
               input wire       data_valid,
               output wire     txd,
               //output wire[7:0] test_data,
               input wire       clk,
               input wire       rstn,
               input wire       flag
               );

    uart_back #(CLK_PER_HALF_BIT) uart_back(input_data,data_valid,txd,clk,rstn,flag);
endmodule
