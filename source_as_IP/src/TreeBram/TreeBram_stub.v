// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2014.3 (win64) Build 1034051 Fri Oct  3 17:14:12 MDT 2014
// Date        : Thu Mar 12 18:24:43 2015
// Host        : ee-caswk04 running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub
//               c:/users/zx510/vivado_projects/allocator_project/allocatorrb/ip_repo/allocator_1.0/src/TreeBram/TreeBram_stub.v
// Design      : TreeBram
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_2,Vivado 2014.3" *)
module TreeBram(clka, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[14:0],dina[31:0],douta[31:0]" */;
  input clka;
  input [0:0]wea;
  input [14:0]addra;
  input [31:0]dina;
  output [31:0]douta;
endmodule
