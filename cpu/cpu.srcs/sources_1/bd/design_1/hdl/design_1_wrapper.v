//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
//Date        : Tue Feb 23 22:27:20 2021
//Host        : LAPTOP-ALP3JTLN running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (USB_UART_RX,
    USB_UART_TX,
    default_sysclk_300_clk_n,
    default_sysclk_300_clk_p,
    reset);
  output USB_UART_RX;
  input USB_UART_TX;
  input default_sysclk_300_clk_n;
  input default_sysclk_300_clk_p;
  input reset;

  wire USB_UART_RX;
  wire USB_UART_TX;
  wire default_sysclk_300_clk_n;
  wire default_sysclk_300_clk_p;
  wire reset;

  design_1 design_1_i
       (.USB_UART_RX(USB_UART_RX),
        .USB_UART_TX(USB_UART_TX),
        .default_sysclk_300_clk_n(default_sysclk_300_clk_n),
        .default_sysclk_300_clk_p(default_sysclk_300_clk_p),
        .reset(reset));
endmodule
