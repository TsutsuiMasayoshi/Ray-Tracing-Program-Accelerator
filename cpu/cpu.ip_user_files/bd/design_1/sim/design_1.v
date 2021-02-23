//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
//Date        : Tue Feb 23 21:09:38 2021
//Host        : LAPTOP-ALP3JTLN running 64-bit major release  (build 9200)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=5,numReposBlks=5,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=3,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (USB_UART_RX,
    USB_UART_TX,
    default_sysclk_300_clk_n,
    default_sysclk_300_clk_p,
    reset);
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.USB_UART_RX DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.USB_UART_RX, LAYERED_METADATA undef" *) output USB_UART_RX;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.USB_UART_TX DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.USB_UART_TX, LAYERED_METADATA undef" *) input USB_UART_TX;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 default_sysclk_300 CLK_N" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME default_sysclk_300, CAN_DEBUG false, FREQ_HZ 300000000" *) input default_sysclk_300_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 default_sysclk_300 CLK_P" *) input default_sysclk_300_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET, INSERT_VIP 0, POLARITY ACTIVE_HIGH" *) input reset;

  wire USB_UART_TX_1;
  wire clk_wiz_0_clk_out1;
  wire clk_wiz_0_locked;
  wire default_sysclk_300_1_CLK_N;
  wire default_sysclk_300_1_CLK_P;
  wire proc_sys_reset_0_mb_reset;
  wire [0:0]proc_sys_reset_0_peripheral_aresetn;
  wire reset_1;
  wire top_wrap_0_flag;
  wire [7:0]top_wrap_0_output_data;
  wire top_wrap_0_valid;
  wire uart_back_wrap_0_txd;
  wire [31:0]uart_in_0_recv_data;
  wire uart_in_0_recv_valid;

  assign USB_UART_RX = uart_back_wrap_0_txd;
  assign USB_UART_TX_1 = USB_UART_TX;
  assign default_sysclk_300_1_CLK_N = default_sysclk_300_clk_n;
  assign default_sysclk_300_1_CLK_P = default_sysclk_300_clk_p;
  assign reset_1 = reset;
  design_1_clk_wiz_0_0 clk_wiz_0
       (.clk_in1_n(default_sysclk_300_1_CLK_N),
        .clk_in1_p(default_sysclk_300_1_CLK_P),
        .clk_out1(clk_wiz_0_clk_out1),
        .locked(clk_wiz_0_locked),
        .reset(reset_1));
  design_1_proc_sys_reset_0_0 proc_sys_reset_0
       (.aux_reset_in(1'b1),
        .dcm_locked(clk_wiz_0_locked),
        .ext_reset_in(reset_1),
        .mb_debug_sys_rst(1'b0),
        .mb_reset(proc_sys_reset_0_mb_reset),
        .peripheral_aresetn(proc_sys_reset_0_peripheral_aresetn),
        .slowest_sync_clk(clk_wiz_0_clk_out1));
  design_1_top_wrap_0_0 top_wrap_0
       (.clk(clk_wiz_0_clk_out1),
        .flag(top_wrap_0_flag),
        .output_data(top_wrap_0_output_data),
        .recv_data(uart_in_0_recv_data),
        .recv_valid(uart_in_0_recv_valid),
        .reset(proc_sys_reset_0_mb_reset),
        .valid(top_wrap_0_valid));
  design_1_uart_back_wrap_0_0 uart_back_wrap_0
       (.clk(clk_wiz_0_clk_out1),
        .data_valid(top_wrap_0_valid),
        .flag(top_wrap_0_flag),
        .input_data(top_wrap_0_output_data),
        .rstn(proc_sys_reset_0_peripheral_aresetn),
        .txd(uart_back_wrap_0_txd));
  design_1_uart_in_0_0 uart_in_0
       (.clk(clk_wiz_0_clk_out1),
        .recv_data(uart_in_0_recv_data),
        .recv_valid(uart_in_0_recv_valid),
        .rstn(proc_sys_reset_0_peripheral_aresetn),
        .rxd(USB_UART_TX_1));
endmodule
