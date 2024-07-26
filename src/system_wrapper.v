//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Fri Jul 26 10:21:15 2024
//Host        : peta21-virtual-machine running 64-bit Ubuntu 20.04.6 LTS
//Command     : generate_target system_wrapper.bd
//Design      : system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module system_wrapper
   (S_AXIS_0_tdata,
    S_AXIS_0_tkeep,
    S_AXIS_0_tlast,
    S_AXIS_0_tready,
    S_AXIS_0_tvalid,
    axis_aclk,
    axis_aresetn,
    data_size_0,
    ddr_address_0,
    finish_0,
    flag_0,
    start_0);
  input [31:0]S_AXIS_0_tdata;
  input [3:0]S_AXIS_0_tkeep;
  input S_AXIS_0_tlast;
  output S_AXIS_0_tready;
  input S_AXIS_0_tvalid;
  input axis_aclk;
  input axis_aresetn;
  input [63:0]data_size_0;
  input [63:0]ddr_address_0;
  output finish_0;
  input [1:0]flag_0;
  input start_0;

  wire [31:0]S_AXIS_0_tdata;
  wire [3:0]S_AXIS_0_tkeep;
  wire S_AXIS_0_tlast;
  wire S_AXIS_0_tready;
  wire S_AXIS_0_tvalid;
  wire axis_aclk;
  wire axis_aresetn;
  wire [63:0]data_size_0;
  wire [63:0]ddr_address_0;
  wire finish_0;
  wire [1:0]flag_0;
  wire start_0;

  system system_i
       (.S_AXIS_0_tdata(S_AXIS_0_tdata),
        .S_AXIS_0_tkeep(S_AXIS_0_tkeep),
        .S_AXIS_0_tlast(S_AXIS_0_tlast),
        .S_AXIS_0_tready(S_AXIS_0_tready),
        .S_AXIS_0_tvalid(S_AXIS_0_tvalid),
        .axis_aclk(axis_aclk),
        .axis_aresetn(axis_aresetn),
        .data_size_0(data_size_0),
        .ddr_address_0(ddr_address_0),
        .finish_0(finish_0),
        .flag_0(flag_0),
        .start_0(start_0));
endmodule
