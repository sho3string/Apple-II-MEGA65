// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
// Date        : Wed Jul  8 22:38:03 2026
// Host        : shoestring-virtual-machine running 64-bit Ubuntu 22.04.4 LTS
// Command     : write_verilog -force -mode synth_stub
//               /mnt/hgfs/GitHub/Apple-II-MEGA65/CORE/CORE-R3.srcs/sources_1/ip/i_ila_floppy_track/i_ila_floppy_track_stub.v
// Design      : i_ila_floppy_track
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tfbg484-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2022.2" *)
module i_ila_floppy_track(clk, probe0, probe1, probe2, probe3, probe4, probe5, 
  probe6, probe7, probe8, probe9, probe10, probe11)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[0:0],probe1[0:0],probe2[8:0],probe3[7:0],probe4[3:0],probe5[12:0],probe6[0:0],probe7[0:0],probe8[0:0],probe9[31:0],probe10[5:0],probe11[5:0]" */;
  input clk;
  input [0:0]probe0;
  input [0:0]probe1;
  input [8:0]probe2;
  input [7:0]probe3;
  input [3:0]probe4;
  input [12:0]probe5;
  input [0:0]probe6;
  input [0:0]probe7;
  input [0:0]probe8;
  input [31:0]probe9;
  input [5:0]probe10;
  input [5:0]probe11;
endmodule
