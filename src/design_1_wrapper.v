//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Tue Jun 11 14:45:09 2024
//Host        : peta21-virtual-machine running 64-bit Ubuntu 20.04.6 LTS
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (Op2_0,
    S_AXIS_0_tdata,
    S_AXIS_0_tlast,
    S_AXIS_0_tready,
    S_AXIS_0_tstrb,
    S_AXIS_0_tuser,
    S_AXIS_0_tvalid,
    S_AXIS_ACLK_0);
  input [0:0]Op2_0;
  input [31:0]S_AXIS_0_tdata;
  input S_AXIS_0_tlast;
  output S_AXIS_0_tready;
  input [3:0]S_AXIS_0_tstrb;
  input S_AXIS_0_tuser;
  input S_AXIS_0_tvalid;
  input S_AXIS_ACLK_0;

  wire [0:0]Op2_0;
  wire [31:0]S_AXIS_0_tdata;
  wire S_AXIS_0_tlast;
  wire S_AXIS_0_tready;
  wire [3:0]S_AXIS_0_tstrb;
  wire S_AXIS_0_tuser;
  wire S_AXIS_0_tvalid;
  wire S_AXIS_ACLK_0;

  design_1 design_1_i
       (.Op2_0(Op2_0),
        .S_AXIS_0_tdata(S_AXIS_0_tdata),
        .S_AXIS_0_tlast(S_AXIS_0_tlast),
        .S_AXIS_0_tready(S_AXIS_0_tready),
        .S_AXIS_0_tstrb(S_AXIS_0_tstrb),
        .S_AXIS_0_tuser(S_AXIS_0_tuser),
        .S_AXIS_0_tvalid(S_AXIS_0_tvalid),
        .S_AXIS_ACLK_0(S_AXIS_ACLK_0));
endmodule
