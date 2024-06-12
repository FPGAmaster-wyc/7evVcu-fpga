// if system is in WIN_MODE, only a small rectangular region is active.
// and the frame rate is 200K+ frames/s
//
//`define WIN_MODE
//
// the frequency of clock line connected to port clk_20m in capture_top module 
// determines the sensor frame rate,
//
// clk20m - 40Khz
// clk16p667m - 33.333Khz
// clk15m - 30Khz
// clk10m - 20Khz


module spikep_top (

  input clk, //50m
  input sys_clkp, // 125M
  input sys_clkn,
  input [20:0]  lvds_p1,
  input [20:0]  lvds_n1,
  input clk_p11,
  input clk_n11,
  input [20:0]  lvds_p2,
  input [20:0]  lvds_n2,
  input clk_p21,
  input clk_n21,
  input [20:0]  lvds_p3,
  input [20:0]  lvds_n3,
  input clk_p31,
  input clk_n31,
  input [20:0]  lvds_p4,
  input [20:0]  lvds_n4,
  input clk_p41,
  input clk_n41,
  output PDLU_EN,
  output PDLU_pixel_RSTN,
  output PDLU_RSTN,
  output PDRU_Mclk_20M,
  output clk_spi,
  output mosi,
  input miso1,
  input miso2,
  input miso3,
  input miso4,
  output cs1,
  output cs2,
  output cs3,
  output cs4,

  output led,
  output locked,
  input MGT117_P,
  input MGT117_N,
  output QSFP_SCL,
  inout QSFP_SDA,
  output [0:0] QSFP1_TX_P,
  output [0:0] QSFP1_TX_N,
  input  [0:0] QSFP1_RX_P,
  input  [0:0] QSFP1_RX_N,

  input F_QSFP1_RESETL,
  input F_QSFP1_INTL,
  input F_QSFP1_MODPRSL, 
  input F_QSFP1_MODSELL

);

`ifndef WIN_MODE
    parameter VA = 500;
    parameter FRAME_HALF_CYCLE = 1245;
`else
    parameter VA = 96;
    parameter FRAME_HALF_CYCLE = 235;
`endif

//wire sys_main_clk; // 100Mhz
wire gt_125M_clk; // norminal 125Mhz, actually 135Mhz
wire sys_clk;
wire user_clk_i;
wire user_clk_resetn;
reg [1:0] user_clk_resetn_sync;
(* KEEP = "true" *)wire peripheral_aresetn;

(* mark_debug= "TRUE" *)   wire                channel_up_aurora       ;
(* mark_debug= "TRUE" *)   wire                lane_up_aurora          ;
    
wire aurora_tx_ready;
wire aurora_tx_valid;
wire [63:0] aurora_tx_data;
wire [63:0] aurora_rx_data;
wire aurora_rx_valid;
wire aurora_rx_ready;

wire clk8m;
//wire clk10m;
wire clk12p5m;
wire clk15m;
wire clk16p667m;
(* KEEP = "true" *)wire clk20m;
wire clk100m;
wire clk200m;
wire pll_locked;

reg [27:0] led_cnt;
wire delay_tap_update0;
wire delay_tap_update1;
wire delay_tap_update2;
wire delay_tap_update3;

wire [20:0] in_delay_data_ce0;
wire [20:0] in_delay_data_inc0;
wire [104:0] in_delay_tap_in0;
wire [104:0] in_delay_tap_out0;
wire [20:0] in_delay_data_ce1;
wire [20:0] in_delay_data_inc1;
wire [104:0] in_delay_tap_in1;
wire [104:0] in_delay_tap_out1;
wire [20:0] in_delay_data_ce2;
wire [20:0] in_delay_data_inc2;
wire [104:0] in_delay_tap_in2;
wire [104:0] in_delay_tap_out2;
wire [20:0] in_delay_data_ce3;
wire [20:0] in_delay_data_inc3;
wire [104:0] in_delay_tap_in3;
wire [104:0] in_delay_tap_out3;

(*KEEP = "true" *)wire cmosInitEn;
(*KEEP = "true" *)wire cmosStop;
(*KEEP = "true" *)wire cmosInitDone;
(*KEEP = "true" *)wire soft_resetn;
wire spiAck;
wire [3:0] spiChipSel; // one-hot slave miso sel
wire spiXferDone;
wire [13:0] spiDataRecv;
wire [13:0] spiDataSend;
wire spiEn;

(*KEEP = "true" *)wire capture_en;
(*KEEP = "true" *)wire pb_reset;

wire tvalid_capture_1024;
wire tready_capture_1024;
wire [1023:0] tdata_capture_1024;
wire tvalid_capture_user_clk;
wire tready_capture_user_clk;
wire [1023:0] tdata_capture_user_clk;


// actually 135 Mhz
//IBUFDS_GTE2 IBUFGDS_GTclk_gt (
//  .CEB (1'b0),
//  .I (MGT117_P),
//  .IB (MGT117_N),
//  .ODIV2 (),
//  .O (gt_125M_clk)
//);
IBUFDS RXD_FPGA_diff 
(
 .I(MGT117_P),
 .IB(MGT117_N),
 .O(gt_125M_clk)
   );
//// in: 50 out 125
//clk_wiz_0 clk_wiz_0 (
//  .clk_out2 (clk8m       ),
//  .clk_out1 (sys_main_clk),
//  .clk_in1 (F1_EMCCLK)
//);

//BUFG clkbuf0 (
//    .I (clk),
//    .O (clk_buf)
//);
IBUFDS sysclk_buf (
    .I (sys_clkp),
    .IB (sys_clkn),
    .O (sys_clk)
);

clk_wiz_0 clk_wiz_0_inst
 (
  // Clock out ports
  .clk_out1(clk8m    ),     // output clk_out1
  .clk_out2(clk20m    ),     // output clk_out2
  .clk_out3(clk100m   ),     // output clk_out3
  .clk_out4(clk200m   ),     // output clk_out4
  .clk_out5(clk12p5m  ),     // output clk_out5
  .clk_out6(clk15m    ),     // output clk_out6
  .clk_out7(clk16p667m),     // output clk_out7
  // Status and control signals
  .locked(pll_locked),       // output locked
 // Clock in ports
  .clk_in1(sys_clk));      // input clk_in1

capture_top #(.VA(VA), .FRAME_HALF_CYCLE(FRAME_HALF_CYCLE)) u_capture_top0 (

  .aclk (clk100m/*sys_main_clk*/),
  .aresetn (peripheral_aresetn),
  .soft_resetn (soft_resetn),
  .ref_clock (clk200m),
  .clk_20m(clk20m), // clk16p667m
  .clk_8m (clk8m),

  .delay_tap_update0 (delay_tap_update0),
  .in_delay_data_ce0 (in_delay_data_ce0),
  .in_delay_data_inc0 (in_delay_data_inc0),
  .in_delay_tap_in0 (in_delay_tap_in0),
  .in_delay_tap_out0 (in_delay_tap_out0),

  .delay_tap_update1 (delay_tap_update1),
  .in_delay_data_ce1 (in_delay_data_ce1),
  .in_delay_data_inc1 (in_delay_data_inc1),
  .in_delay_tap_in1 (in_delay_tap_in1),
  .in_delay_tap_out1 (in_delay_tap_out1),

  .delay_tap_update2 (delay_tap_update2),
  .in_delay_data_ce2 (in_delay_data_ce2),
  .in_delay_data_inc2 (in_delay_data_inc2),
  .in_delay_tap_in2 (in_delay_tap_in2),
  .in_delay_tap_out2 (in_delay_tap_out2),

  .delay_tap_update3 (delay_tap_update3),
  .in_delay_data_ce3 (in_delay_data_ce3),
  .in_delay_data_inc3 (in_delay_data_inc3),
  .in_delay_tap_in3 (in_delay_tap_in3),
  .in_delay_tap_out3 (in_delay_tap_out3),

  // host controllable cmos signals
  .cmosInitEn (cmosInitEn),
  .cmosStop (cmosStop),
  .cmosInitDone (cmosInitDone),

  // host controllable capture enable signals
  .capture_en (capture_en),

  // cmos control interface signals
  .PDLU_EN (PDLU_EN),
  .PDLU_pixel_RSTN (PDLU_pixel_RSTN),
  .PDLU_RSTN (PDLU_RSTN),
  .PDRU_Mclk_20M (PDRU_Mclk_20M),

  // host controllable spi signals
  .spiEn (spiEn),
  .spiDataSend (spiDataSend),
  .spiAck (spiAck),
  .spiChipSel (spiChipSel),
  .spiXferDone (spiXferDone),
  .spiDataRecv (spiDataRecv),

  .clk_spi (clk_spi),
  .mosi (mosi),
  .cs1 (cs1),
  .cs2 (cs2),
  .cs3 (cs3),
  .cs4 (cs4),
  .miso1 (miso1),
  .miso2 (miso2),
  .miso3 (miso3),
  .miso4 (miso4),

  .lvds_p1 (lvds_p1),
  .lvds_n1 (lvds_n1),
  .clk_p11 (clk_p11),
  .clk_n11 (clk_n11),
  .lvds_p2 (lvds_p2),
  .lvds_n2 (lvds_n2),
  .clk_p21 (clk_p21),
  .clk_n21 (clk_n21),
  .lvds_p3 (lvds_p3),
  .lvds_n3 (lvds_n3),
  .clk_p31 (clk_p31),
  .clk_n31 (clk_n31),
  .lvds_p4 (lvds_p4),
  .lvds_n4 (lvds_n4),
  .clk_p41 (clk_p41),
  .clk_n41 (clk_n41),

  .AXIS_TDATA (tdata_capture_1024),
  .AXIS_TVALID (tvalid_capture_1024),
  .AXIS_TREADY (tready_capture_1024)

);

core_wrapper u_core_wrapper0 (
  .Clk (clk100m/*sys_main_clk*/),
  .bufr_ce_o (),
  .capture_en_o (capture_en),
  .cmosInitDone_i (cmosInitDone),
  .cmosInitEn_o (cmosInitEn),
  .cmosStop_o (cmosStop),
  .delay_tap_update0_o (delay_tap_update0),
  .delay_tap_update1_o (delay_tap_update1),
  .delay_tap_update2_o (delay_tap_update2),
  .delay_tap_update3_o (delay_tap_update3),
  .in_delay_data_ce0_o (in_delay_data_ce0),
  .in_delay_data_ce1_o (in_delay_data_ce1),
  .in_delay_data_ce2_o (in_delay_data_ce2),
  .in_delay_data_ce3_o (in_delay_data_ce3),
  .in_delay_data_inc0_o (in_delay_data_inc0),
  .in_delay_data_inc1_o (in_delay_data_inc1),
  .in_delay_data_inc2_o (in_delay_data_inc2),
  .in_delay_data_inc3_o (in_delay_data_inc3),
  .in_delay_tap_in0_o (in_delay_tap_in0),
  .in_delay_tap_in1_o (in_delay_tap_in1),
  .in_delay_tap_in2_o (in_delay_tap_in2),
  .in_delay_tap_in3_o (in_delay_tap_in3),
  .in_delay_tap_out0_i (in_delay_tap_out0),
  .in_delay_tap_out1_i (in_delay_tap_out1),
  .in_delay_tap_out2_i (in_delay_tap_out2),
  .in_delay_tap_out3_i (in_delay_tap_out3),
  .megaFrame_o (),
  .megaLine_o (),
  .pb_reset_o (pb_reset),
  .peripheral_aresetn (peripheral_aresetn),
  .reset_rtl_0 (1'b1),
  .dcm_locked_0 (pll_locked),
  .soft_resetn_o (soft_resetn),
  .spiAck_o (spiAck),
  .spiChipSel_o (spiChipSel),
  .spiDataRecv_i (spiDataRecv),
  .spiDataSend_o (spiDataSend),
  .spiEn_o (spiEn),
  .spiXferDone_i (spiXferDone)
);

// 100Mhz 1024bit -> 200Mhz 1024bit
axis_clock_converter_1 u_axis_clock_converted_0 (
  .s_axis_aresetn(peripheral_aresetn),  // input wire s_axis_aresetn
  .m_axis_aresetn(user_clk_resetn),  // input wire m_axis_aresetn
  .s_axis_aclk(clk100m/*sys_main_clk*/),        // input wire s_axis_aclk
  .s_axis_tvalid(tvalid_capture_1024),    // input wire s_axis_tvalid
  .s_axis_tready(tready_capture_1024),    // output wire s_axis_tready
  .s_axis_tdata(tdata_capture_1024),      // input wire [1023 : 0] s_axis_tdata
  .m_axis_aclk(user_clk_i),        // input wire m_axis_aclk
  .m_axis_tvalid(tvalid_capture_user_clk),    // output wire m_axis_tvalid
  .m_axis_tready(tready_capture_user_clk),    // input wire m_axis_tready
  .m_axis_tdata(tdata_capture_user_clk)      // output wire [1023 : 0] m_axis_tdata
);

// 200Mhz 1024bit -> 200Mhz 256bit
axis_dwidth_converter_1 u_axis_dwidth_converter_0 (
  .aclk (user_clk_i),
  .aresetn (user_clk_resetn),
  .s_axis_tvalid (tvalid_capture_user_clk),
  .s_axis_tready (tready_capture_user_clk), 
  .s_axis_tdata (tdata_capture_user_clk),
  .m_axis_tvalid (aurora_tx_valid),
  .m_axis_tready (aurora_tx_ready),
  .m_axis_tdata (aurora_tx_data)
);

aurora_64b66b_1 aurora_64b66b_0_i (
    // TX AXI4-S Interface
    .s_axi_tx_tdata(aurora_tx_data),
    .s_axi_tx_tvalid(aurora_tx_valid),
    .s_axi_tx_tready(aurora_tx_ready),

    // RX AXI4-S Interface
    .m_axi_rx_tdata(aurora_rx_data),
    .m_axi_rx_tvalid(aurora_rx_valid),

    // GTX Serial I/O
    .rxp(QSFP1_RX_P),
    .rxn(QSFP1_RX_N),
    .txp(QSFP1_TX_P),
    .txn(QSFP1_TX_N),

    //GTX Reference Clock Interface
    .refclk1_in(gt_125M_clk),
    .hard_err(),
    .soft_err(),
    // Status
    .channel_up(channel_up_aurora),
    .lane_up(lane_up_aurora),

    // System Interface
    .user_clk_out(user_clk_i),
    .mmcm_not_locked_out(),

    .sync_clk_out(),

    .reset_pb(pb_reset),
    .gt_rxcdrovrden_in('b0),
    .power_down('b0),
    .loopback('b0),
    .pma_init(pb_reset),
    .gt_pll_lock(),
//    .drp_clk_in(clk100m/*sys_main_clk*/),
    //---{
    //---}
    // ---------- AXI4-Lite input signals ---------------
    .s_axi_awaddr('b0),
    .s_axi_awvalid('b0),
    .s_axi_awready(),
    .s_axi_wdata('b0),
    .s_axi_wstrb('b0),
    .s_axi_wvalid('b0),
    .s_axi_wready(),
    .s_axi_bvalid(),
    .s_axi_bresp(),
    .s_axi_bready('b0),
    .s_axi_araddr('b0),
    .s_axi_arvalid('b0),
    .s_axi_arready('b0),
    .s_axi_rdata(),
    .s_axi_rvalid(),
    .s_axi_rresp(),
    .s_axi_rready('b0),

    //---------------------- GTXE2 COMMON DRP Ports ----------------------
//    .qpll_drpaddr_in('b0),
//    .qpll_drpdi_in('b0),
//    .qpll_drpdo_out(),
//    .qpll_drprdy_out(),
//    .qpll_drpen_in('b0),
//    .qpll_drpwe_in('b0),
    .init_clk(clk100m/*sys_main_clk*/),
    .link_reset_out(),

    // shared mode 7 series GT quad port placements starts
    .gt_qpllclk_quad1_out(),
    .gt_qpllrefclk_quad1_out(),

    // shared mode 7 series GT quad port placements ends
//    .gt_qpllrefclklost_out(),
//    .gt_qplllock_out(),

    .sys_reset_out(),
    .gt_reset_out(),

    .tx_out_clk()
);

//ila_3 ila_aurora_tx(
//    .clk(user_clk_i),
//    .probe0(aurora_tx_data),
//    .probe1(aurora_tx_valid),
//    .probe2(aurora_tx_ready),
//    .probe3(channel_up_aurora),
//    .probe4(lane_up_aurora)
//);

//ila_3 ila_aurora_rx(
//    .clk(user_clk_i),
//    .probe0(aurora_rx_data),
//    .probe1(aurora_rx_valid),
//    .probe2('b0),
//    .probe3(channel_up_aurora),
//    .probe4(lane_up_aurora)
//);

always @(posedge user_clk_i or negedge peripheral_aresetn) begin
  if (!peripheral_aresetn) begin
    user_clk_resetn_sync <= 2'b00;
  end else begin
    user_clk_resetn_sync <= {user_clk_resetn_sync[0], 1'b1};
  end
end
    
assign user_clk_resetn = user_clk_resetn_sync[1];
//assign user_clk_resetn = !pb_reset;

reg toggle;

always @ (posedge user_clk_i) begin
  if (led_cnt == 28'd124999999) begin
    led_cnt <= 28'd0;
    toggle <= ~toggle;
  end
  else
    led_cnt  <= led_cnt + 1'b1;
end

assign led = toggle;
assign locked = pll_locked;

endmodule
