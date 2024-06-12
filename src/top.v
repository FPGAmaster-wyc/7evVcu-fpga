`timescale 1ns / 1ns


module top # (
  `ifdef SIMULATION_MODE
  parameter SIMULATION            = "TRUE", 
  `else
  parameter SIMULATION            = "FALSE",
  `endif
  parameter DATA_WIDTH     = 18,
    parameter BURST_LENGTH   = 4,
    parameter APP_DATA_WIDTH = 72, 
    parameter APP_ADDR_WIDTH = 21
) (
    //  input                  sys_rst // Common port for all controllers
    //  ,
    input				 GCLK
    //sensor lvds
    //lvds
    ,input	[20:0]	lvds_p1
    ,input	[20:0]	lvds_n1
    ,input			clk_p11
    ,input			clk_n11 

    ,input	[20:0]	lvds_p2
    ,input	[20:0]	lvds_n2
    ,input			clk_p21
    ,input			clk_n21

    ,input	[20:0]	lvds_p3
    ,input	[20:0]	lvds_n3
    ,input			clk_p31
    ,input			clk_n31

    ,input	[20:0]	lvds_p4
    ,input	[20:0]	lvds_n4
    ,input			clk_p41
    ,input			clk_n41

    //sensor spi
    ,output PDLU_EN
    ,output PDLU_pixel_RSTN
    ,output PDLU_RSTN
    ,output PDRU_Mclk_20M

    ,output    wire          clk_spi // spi�ڲ�ʱ��
    ,output    wire          mosi
    // ,input    wire          miso
    ,output wire 			cs1
    ,output wire 			cs2
    ,output wire 			cs3
    ,output wire 			cs4
  
    //  //   output locked, 
    //  //   output QSFP_SCL,
    //  //   inout QSFP_SDA,
    
    ,input MGT117_P
    ,input MGT117_N
    ,output [3:0] QSFP1_TX_P
    ,output [3:0] QSFP1_TX_N
    ,input  [3:0] QSFP1_RX_P
    ,input  [3:0] QSFP1_RX_N
    
    // //status
    ,output 			led

    //  //   input F_QSFP1_RESETL,
    //  //   input F_QSFP1_INTL,
    //  //   input F_QSFP1_MODPRSL, 
    //  //   input F_QSFP1_MODSELL
    //  //uart

);

wire GCLK_50M;

BUFG BUFG_inst (
   .O(GCLK_50M), // 1-bit output: Clock output
   .I(GCLK    )  // 1-bit input: Clock input
);

    reg aurora_reg1;
    reg aurora_reg2;
    reg aurora_setup;
    (* MARK_DEBUG="true" *)reg Aurora_ERROR;    
    always@(posedge GCLK_50M)
    begin
        if(!rstn)begin
            aurora_reg1 <= 0;
            aurora_reg2 <= 0;     
            aurora_setup<= 0;     
            Aurora_ERROR<= 0;  
        end else begin
            if(channel_up_aurora)begin
                aurora_setup<=1;
            end
            if(aurora_setup == 1)begin
                aurora_reg1 <= channel_up_aurora;
                aurora_reg2 <= aurora_reg1;
            end
            if((aurora_reg1 == 0) && (aurora_reg2 == 1))begin
                Aurora_ERROR<=1;
            end
        end
    end
    
    // // reg probe_out0;
    wire sys_rst;

/*    vio_0 vio1 (
      .clk(GCLK),                // input wire clk
      .probe_out0(probe_out0)  // output wire [0 : 0] probe_out0
    );*/
    reg [23:0] rst_cnt;
    always @ (posedge clk20m)begin
        rst_cnt	<= rst_cnt + 1;
    end    
    // always @ (posedge clk20m)begin
    //     if(rst_cnt[23] == 1)
    //         probe_out0 <=1;
    // end
     
    (* MARK_DEBUG="true" *)wire[119:0] AXI_DATA;
    (* MARK_DEBUG="true" *)wire       AXI_VALID;
    (* MARK_DEBUG="true" *)wire       AXI_READY;
    (* MARK_DEBUG="true" *)wire        AXI_USER;
    (* MARK_DEBUG="true" *)wire        AXI_LAST;

//    assign AXI_READY = 1;

wire  sys_locked;

    // clk_wiz_0 clk_wiz_0 (
        // .clk_out1   (sys_main_clk   ),
        // .locked     (sys_locked), // output locked
        // .clk_in1    (GCLK_50M      )
    // );

    assign rstn=sys_rst;

    wire clk10m    ;
    wire clk20m    ;
    wire clk100m   ;
    wire clk125m   ;
    wire clk200m   ;
    wire clk250m   ;
    wire pll_locked;
    
    assign sys_rst = pll_locked;
    
    clk_wiz_1 clk_wiz_1_inst(
        .clk_out1(clk10m    ), // 10M
        .clk_out2(clk20m    ), // 10M
        .clk_out3(clk100m   ), // 100M
        .clk_out4(clk200m   ), // 200M
        .clk_out5(clk125m   ), // 125M
        .clk_out6(clk250m   ), // 250M
        // .reset(~rstn), // input reset
        .locked(pll_locked), // output locked
        .clk_in1(GCLK_50M)); // input clk_in1
    //debug
    //    assign sys_main_clk = clk200m;
    reg [23:0] led_cnt;
    always @ (posedge clk20m)begin
        led_cnt	<= led_cnt + 1;
    end
    assign led = led_cnt[23];
    //*************************************************************
    wire pixl_rstn;
    reg [25:0] pixl_rstn_cnt;
    always @ (posedge clk20m)
    if(~pll_locked)
        pixl_rstn_cnt	<= 0;
    else if(&pixl_rstn_cnt)
        pixl_rstn_cnt	<= pixl_rstn_cnt;
    else
        pixl_rstn_cnt	<= pixl_rstn_cnt + 1;


    assign PDLU_EN	= (pixl_rstn_cnt	<	20) ?	1'b0	:	1'b1;
    assign PDLU_RSTN	=(pixl_rstn_cnt	<	20) ?	1'b0	:	1'b1;
    assign PDLU_pixel_RSTN	=(pixl_rstn_cnt	<	2000) ?	1'b0	:	1'b1;
    assign PDRU_Mclk_20M	=clk20m;

    assign pixl_rstn	= (pixl_rstn_cnt	<	20000) ?	1'b0	:	1'b1;

    // assign PDRU_Mclk_20M	=(pixl_rstn_cnt	<	220100) ?	1'b0	:	clk20m;

    // assign PDLU_EN	= 1'b1;
    // assign PDLU_RSTN	=rstn;
    // assign PDLU_pixel_RSTN	=rstn;
    // assign PDRU_Mclk_20M	=clk20m;
    //************************************************************

    wire [511:0] pixl_data_out;
    wire 		pixl_data_out_en;
    wire out_user;
    wire out_last;
    (* KEEP = "true" *)wire [31:0] out_1080_TDATA;
    (* KEEP = "true" *)wire out_1080_TVALID;
    (* KEEP = "true" *)wire out_1080_TREADY;
    
    //GT  
    (* mark_debug= "TRUE" *)wire [1023:0] AXIS_TDATA;
    (* mark_debug= "TRUE" *)wire AXIS_TVALID;
    (* mark_debug= "TRUE" *)wire AXIS_TREADY;

// wire probe_out0;
    // vio_rst vio_rst (
      // .clk       (GCLK_50M   ),                // input wire clk
      // .probe_out0(probe_out0 )  // output wire [0 : 0] probe_out0
    // );

    pixl_top u_pixl_top(
        .rstn       ( rstn  &&	pixl_rstn &&    pll_locked/* && probe_out0*/),
        // .rstn       ( rstn  &&	pixl_rstn && pll_locked && probe_out0),
        .clk10m     ( clk10m     ),
        .clk20m     ( clk20m     ),
        .clk100m    ( clk100m    ),
        .clk200m    ( clk200m    ),
        .clk125m	(clk125m     ),
        .clk250m    (clk250m     ),
        .lvds_p1    ( lvds_p1    ),
        .lvds_n1    ( lvds_n1    ),
        .clk_p11    ( clk_p11    ),
        .clk_n11    ( clk_n11    ),
        .lvds_p2    ( lvds_p2    ),
        .lvds_n2    ( lvds_n2    ),
        .clk_p21    ( clk_p21    ),
        .clk_n21    ( clk_n21    ),
        .lvds_p3    ( lvds_p3    ),
        .lvds_n3    ( lvds_n3    ),
        .clk_p31    ( clk_p31    ),
        .clk_n31    ( clk_n31    ),
        .lvds_p4    ( lvds_p4    ),
        .lvds_n4    ( lvds_n4    ),
        .clk_p41    ( clk_p41    ),
        .clk_n41    ( clk_n41    ),

        .pixl_data_out		(pixl_data_out),
        .pixl_data_out_en	(pixl_data_out_en),

        .clk_spi    ( clk_spi    ),
        .mosi       ( mosi       ),
        .miso       (            ),
        .cs1        ( cs1        ),
        .cs2        ( cs2        ),
        .cs3        ( cs3        ),
        .cs4        ( cs4        ),
        .out_user   (out_user    ),
        .out_last   (out_last    ),
        .out_1080_TDATA (out_1080_TDATA ),
        .out_1080_TVALID(out_1080_TVALID),
        .out_1080_TREADY(out_1080_TREADY),

        .AXIS_TDATA (     AXIS_TDATA           ),
        .AXIS_TVALID(     AXIS_TVALID          ),
        .AXIS_TREADY(     AXIS_TREADY         ),
        .aurora_ready(   channel_up_aurora    ),
        .probe_out0  (1)
    );
    assign AXI_VALID = out_1080_TVALID;
    assign AXI_DATA  = {
    out_1080_TDATA[24+:8],2'b0,out_1080_TDATA[24+:8],2'b0,out_1080_TDATA[24+:8],2'b0,
    out_1080_TDATA[16+:8],2'b0,out_1080_TDATA[16+:8],2'b0,out_1080_TDATA[16+:8],2'b0,
    out_1080_TDATA[8+:8],2'b0,out_1080_TDATA[8+:8],2'b0,out_1080_TDATA[8+:8],2'b0,
    out_1080_TDATA[0+:8],2'b0,out_1080_TDATA[0+:8],2'b0,out_1080_TDATA[0+:8],2'b0};

    assign out_1080_TREADY = AXI_READY;   //jie ddr��

    //assign out_1080_TREADY = 1;

    assign AXI_USER = out_user;
    assign AXI_LAST = out_last;

    wire[31:0]    M_AXI_BUFF_DATA;
    wire          M_AXI_BUFF_VALID;
    wire          M_AXI_BUFF_READY;
    wire          M_AXI_BUFF_USER;
    wire          M_AXI_BUFF_LAST;

    wire[119:0]   S_AXI_BUFF_DATA;
    wire          S_AXI_BUFF_VALID;
    wire          S_AXI_BUFF_READY;
    wire          S_AXI_BUFF_USER;
    wire          S_AXI_BUFF_LAST;

    assign  S_AXI_BUFF_VALID  = M_AXI_BUFF_VALID;
    assign  S_AXI_BUFF_READY  = M_AXI_BUFF_READY;
    assign  S_AXI_BUFF_USER   = M_AXI_BUFF_USER;
    assign  S_AXI_BUFF_LAST   = M_AXI_BUFF_LAST;

    assign S_AXI_BUFF_DATA  = {
    M_AXI_BUFF_DATA[24+:8],2'b0,M_AXI_BUFF_DATA[24+:8],2'b0,M_AXI_BUFF_DATA[24+:8],2'b0,
    M_AXI_BUFF_DATA[16+:8],2'b0,M_AXI_BUFF_DATA[16+:8],2'b0,M_AXI_BUFF_DATA[16+:8],2'b0,
    M_AXI_BUFF_DATA[8+:8],2'b0,M_AXI_BUFF_DATA[8+:8],2'b0,M_AXI_BUFF_DATA[8+:8],2'b0,
    M_AXI_BUFF_DATA[0+:8],2'b0,M_AXI_BUFF_DATA[0+:8],2'b0,M_AXI_BUFF_DATA[0+:8],2'b0};

       design_1_wrapper block_design
        (.Op2_0(rstn),
         .S_AXIS_0_tdata(out_1080_TDATA),//֮ǰȷʵ�ǽ�DP��Ϊ������10bit��Ϣ������˿�λ������û���ˣ�4����һ��������32bit
         .S_AXIS_0_tlast(AXI_LAST),
         .S_AXIS_0_tready(AXI_READY),
         .S_AXIS_0_tstrb(4'hF),
         .S_AXIS_0_tuser(AXI_USER),
         .S_AXIS_0_tvalid(AXI_VALID),
         .S_AXIS_ACLK_0(clk250m)
         );

    //GT need

    //wire sys_main_clk; // 100Mhz
    wire gt_125M_clk; // norminal 125Mhz, actually 135Mhz
    wire sys_clk;
    wire user_clk_i;
    wire user_clk_resetn;
    reg [1:0] user_clk_resetn_sync;
    wire [3:0]    gt_powergood;
    (* KEEP = "true" *)wire peripheral_aresetn;

//////////////
    (* mark_debug= "TRUE" *)   wire channel_up_aurora       ;
    (* mark_debug= "TRUE" *)   wire lane_up_aurora          ;

    (* MARK_DEBUG="true" *)    wire aurora_tx_ready;
    (* MARK_DEBUG="true" *)    wire aurora_tx_valid;
    // (* MARK_DEBUG="true" *)    wire [63:0] aurora_tx_data;
    // (* MARK_DEBUG="true" *)    wire [63:0] aurora_rx_data;
    
    (* MARK_DEBUG="true" *)    wire [255:0] aurora_tx_data;
    (* MARK_DEBUG="true" *)    wire [255:0] aurora_rx_data;
    
    (* DONT_TOUCH = "TRUE" *) wire [255:0] tx_data256;
    
    (* MARK_DEBUG="true" *)    wire aurora_rx_valid;
    (* MARK_DEBUG="true" *)    wire aurora_rx_ready;
    (* MARK_DEBUG="true" *)    wire [1:0] Aurora_Tx_channel;
    (* MARK_DEBUG="true" *)    wire [8:0] Aurora_Tx_address;
    
    // assign Aurora_Tx_channel = aurora_tx_data[63:62];
    // assign Aurora_Tx_address = aurora_tx_data[61:52];    //10bit
        //2 0 9 
    assign Aurora_Tx_channel = aurora_tx_data[255:254];     //2
//    assign Aurora_Tx_address = aurora_tx_data[253:245];     //9bit
    assign Aurora_Tx_address = aurora_tx_data[253:244];     //10bit
    
    assign tx_data256 = aurora_tx_data;     //9bit
    
    //(* MARK_DEBUG="true" *) wire MGT117_CLK;
    //assign MGT117_CLK = MGT117_P;
    //gt_CLK
    // IBUFDS RXD_FPGA_diff 
    // (
    //  .I(MGT117_P),
    //  .IB(MGT117_N),
    //  .O(gt_125M_clk)
    //    );

    (* mark_debug= "TRUE" *)wire tvalid_capture_user_clk;
    (* mark_debug= "TRUE" *)wire tready_capture_user_clk;
    (* mark_debug= "TRUE" *)wire [1023:0]tdata_capture_user_clk;
  
ila_aurora ila_aurora (
	.clk    (user_clk_i           ), // input wire clk
	.probe0 (channel_up_aurora    ), // input wire [0:0]  probe0  
	.probe1 (lane_up_aurora       ), // input wire [0:0]  probe1
	.probe2 (aurora_tx_ready      ), // input wire [0:0]  probe1
	.probe3 (aurora_tx_valid      ), // input wire [0:0]  probe1
	.probe4 (aurora_tx_data       ), // input wire [255:0]  probe1
	.probe5 (aurora_rx_data       ), // input wire [255:0]  probe1
	.probe6 (aurora_rx_valid      ), // input wire [0:0]  probe1
	.probe7 (aurora_rx_ready      ), // input wire [0:0]  probe1
	.probe8 (Aurora_Tx_channel    ), // input wire [1:0]  probe1
	.probe9 (Aurora_Tx_address    ),  // input wire [8:0]  probe1
    
	.probe10(tvalid_capture_user_clk    ), // input wire [0:0]  probe1
	// .probe11(tready_capture_user_clk    ), // input wire [0:0]  probe1
	.probe11(tx_data256                 ) // input wire [255:0]  probe1
	// .probe12(tdata_capture_user_clk     ), // input wire [1023:0]  probe1
	// .probe13(gt_powergood               ) // input wire [3:0]  probe1
);
    
    // //100Mhz 1024bit -> 200Mhz 1024bit
    axis_clock_converter_0 u_axis_clock_converted_0 (
        .s_axis_aresetn (rstn                   ), // input wire s_axis_aresetn
        .m_axis_aresetn (user_clk_resetn        ), // input wire m_axis_aresetn
        .s_axis_aclk    (clk125m/*sys_main_clk*/), // input wire s_axis_aclk
        .s_axis_tvalid  (AXIS_TVALID            ), // input wire s_axis_tvalid
        .s_axis_tready  (AXIS_TREADY            ), // output wire s_axis_tready
        .s_axis_tdata   (AXIS_TDATA             ), // input wire [1023 : 0] s_axis_tdata
        .m_axis_aclk    (user_clk_i             ), // input wire m_axis_aclk
        .m_axis_tvalid  (tvalid_capture_user_clk), // output wire m_axis_tvalid
        .m_axis_tready  (tready_capture_user_clk), // input wire m_axis_tready
        .m_axis_tdata   (tdata_capture_user_clk ) // output wire [1023 : 0] m_axis_tdata
    );////156.25  10.8/6 = 

    // //200Mhz 1024bit -> 200Mhz 256bit
    axis_dwidth_converter_0 u_axis_dwidth_converter_0 (
        .aclk           (user_clk_i             ),
        .aresetn        (user_clk_resetn        ),
        .s_axis_tvalid  (tvalid_capture_user_clk),
        .s_axis_tready  (tready_capture_user_clk),
        .s_axis_tdata   (tdata_capture_user_clk ),
        .m_axis_tvalid  (aurora_tx_valid        ),
        .m_axis_tready  (aurora_tx_ready        ),
        .m_axis_tdata   (aurora_tx_data         )
    );

    aurora_64b66b_0 aurora_64b66b_0_i (
        //// TX AXI4-S Interface
        .s_axi_tx_tdata (aurora_tx_data ),            // input wire [0 : 255] s_axi_tx_tdata
        .s_axi_tx_tvalid(aurora_tx_valid),
        .s_axi_tx_tready(aurora_tx_ready),
        // //RX AXI4-S Interface
        .m_axi_rx_tdata (aurora_rx_data ),        //256bit  // output wire [0 : 255] m_axi_rx_tdata
        .m_axi_rx_tvalid(aurora_rx_valid),
        // //GTX Serial I/O
        .rxp(QSFP1_RX_P),
        .rxn(QSFP1_RX_N),
        .txp(QSFP1_TX_P),
        .txn(QSFP1_TX_N),
        //  //GTX Reference Clock Interface
        // .refclk1_in(gt_125M_clk),
        .gt_refclk1_p(MGT117_P), // input wire gt_refclk1_p
        .gt_refclk1_n(MGT117_N), // input wire gt_refclk1_n
        .hard_err    (),
        .soft_err    (),
        // //Status
        .channel_up(channel_up_aurora),
        .lane_up   (lane_up_aurora   ),
        // //System Interface
        .user_clk_out(user_clk_i),
        .mmcm_not_locked_out(),
        .sync_clk_out(),
        .reset_pb         (pb_reset),
        .gt_rxcdrovrden_in('b0),
        .power_down       ('b0),
        .loopback         ('b0),
        .pma_init         (pb_reset),
        .gt_pll_lock      (),
        //  //  .drp_clk_in(clk100m),
        //   // .drp_clk_in(clk100m//sys_main_clk/),
        // ///{
        // ///}
        // //////////// AXI4-Lite input signals /////////////
        .s_axi_awaddr('b0),
        .s_axi_awaddr_lane1('b0),                    // input wire [31 : 0] s_axi_awaddr_lane1
        .s_axi_awaddr_lane2('b0),                    // input wire [31 : 0] s_axi_awaddr_lane2
        .s_axi_awaddr_lane3('b0),                    // input wire [31 : 0] s_axi_awaddr_lane3        
        .s_axi_rresp(),
        .s_axi_rresp_lane1(),                      // output wire [1 : 0] s_axi_rresp_lane1
        .s_axi_rresp_lane2(),                      // output wire [1 : 0] s_axi_rresp_lane2
        .s_axi_rresp_lane3(),                      // output wire [1 : 0] s_axi_rresp_lane3        
        .s_axi_bresp(),
        .s_axi_bresp_lane1(),                      // output wire [1 : 0] s_axi_bresp_lane1
        .s_axi_bresp_lane2(),                      // output wire [1 : 0] s_axi_bresp_lane2
        .s_axi_bresp_lane3(),                      // output wire [1 : 0] s_axi_bresp_lane3        
        .s_axi_wstrb('b0),
        .s_axi_wstrb_lane1('b0),                      // input wire [3 : 0] s_axi_wstrb_lane1
        .s_axi_wstrb_lane2('b0),                      // input wire [3 : 0] s_axi_wstrb_lane2
        .s_axi_wstrb_lane3('b0),                      // input wire [3 : 0] s_axi_wstrb_lane3        
        .s_axi_wdata('b0),
        .s_axi_wdata_lane1('b0),                      // input wire [31 : 0] s_axi_wdata_lane1
        .s_axi_wdata_lane2('b0),                      // input wire [31 : 0] s_axi_wdata_lane2
        .s_axi_wdata_lane3('b0),                      // input wire [31 : 0] s_axi_wdata_lane3        
        .s_axi_araddr('b0),
        .s_axi_araddr_lane1('b0),                    // input wire [31 : 0] s_axi_araddr_lane1
        .s_axi_araddr_lane2('b0),                    // input wire [31 : 0] s_axi_araddr_lane2
        .s_axi_araddr_lane3('b0),                    // input wire [31 : 0] s_axi_araddr_lane3        
        .s_axi_rdata(),
        .s_axi_rdata_lane1(),                      // output wire [31 : 0] s_axi_rdata_lane1
        .s_axi_rdata_lane2(),                      // output wire [31 : 0] s_axi_rdata_lane2
        .s_axi_rdata_lane3(),                      // output wire [31 : 0] s_axi_rdata_lane3        
        .s_axi_bready('b0),
        .s_axi_bready_lane1('b0),                    // input wire s_axi_bready_lane1
        .s_axi_bready_lane2('b0),                    // input wire s_axi_bready_lane2
        .s_axi_bready_lane3('b0),                    // input wire s_axi_bready_lane3        
        .s_axi_awvalid('b0),
        .s_axi_awvalid_lane1('b0),                  // input wire s_axi_awvalid_lane1
        .s_axi_awvalid_lane2('b0),                  // input wire s_axi_awvalid_lane2
        .s_axi_awvalid_lane3('b0),                  // input wire s_axi_awvalid_lane3        
        .s_axi_awready(),
        .s_axi_awready_lane1(),                  // output wire s_axi_awready_lane1
        .s_axi_awready_lane2(),                  // output wire s_axi_awready_lane2
        .s_axi_awready_lane3(),                  // output wire s_axi_awready_lane3        
        .s_axi_wvalid('b0),
        .s_axi_wvalid_lane1('b0),                    // input wire s_axi_wvalid_lane1
        .s_axi_wvalid_lane2('b0),                    // input wire s_axi_wvalid_lane2
        .s_axi_wvalid_lane3('b0),                    // input wire s_axi_wvalid_lane3        
        .s_axi_wready(),
        .s_axi_wready_lane1(),                    // output wire s_axi_wready_lane1
        .s_axi_wready_lane2(),                    // output wire s_axi_wready_lane2
        .s_axi_wready_lane3(),                    // output wire s_axi_wready_lane3        
        .s_axi_bvalid(),
        .s_axi_bvalid_lane1(),                    // output wire s_axi_bvalid_lane1
        .s_axi_bvalid_lane2(),                    // output wire s_axi_bvalid_lane2
        .s_axi_bvalid_lane3(),                    // output wire s_axi_bvalid_lane3        
        .s_axi_arvalid('b0),
        .s_axi_arvalid_lane1('b0),                  // input wire s_axi_arvalid_lane1
        .s_axi_arvalid_lane2('b0),                  // input wire s_axi_arvalid_lane2
        .s_axi_arvalid_lane3('b0),                  // input wire s_axi_arvalid_lane3        
        .s_axi_arready(), 
        .s_axi_arready_lane1(),                  // output wire s_axi_arready_lane1
        .s_axi_arready_lane2(),                  // output wire s_axi_arready_lane2
        .s_axi_arready_lane3(),                  // output wire s_axi_arready_lane3        
        .s_axi_rvalid(),
        .s_axi_rvalid_lane1(),                    // output wire s_axi_rvalid_lane1
        .s_axi_rvalid_lane2(),                    // output wire s_axi_rvalid_lane2
        .s_axi_rvalid_lane3(),                    // output wire s_axi_rvalid_lane3        
        .s_axi_rready('b0),
        .s_axi_rready_lane1('b0),                    // input wire s_axi_rready_lane1
        .s_axi_rready_lane2('b0),                    // input wire s_axi_rready_lane2
        .s_axi_rready_lane3('b0),                    // input wire s_axi_rready_lane3        
        // //////////////////////GTXE2 COMMON DRP Ports /////////////////////
        //    .qpll_drpaddr_in('b0),
        //    .qpll_drpdi_in('b0),
        //    .qpll_drpdo_out(),
        //    .qpll_drprdy_out(),
        //    .qpll_drpen_in('b0),
        //    .qpll_drpwe_in('b0),
        // .init_clk(clk100m//sys_main_clk//),
        .init_clk(clk100m),
        .link_reset_out(),
        // shared mode 7 series GT quad port placements starts
        .gt_qpllclk_quad1_out   (),
        .gt_qpllrefclk_quad1_out(),
        .gt_qpllrefclklost_quad1_out(),  // output wire gt_qpllrefclklost_quad1_out
        .gt_qplllock_quad1_out(),              // output wire gt_qplllock_quad1_out
  
        .gt_refclk1_out(),        // output wire gt_refclk1_out
        .gt_powergood(gt_powergood),            // output wire [3 : 0] gt_powergood

        // shared mode 7 series GT quad port placements ends
        // .gt_qpllrefclklost_out(),
        // .gt_qplllock_out(),
        .sys_reset_out(),
        .gt_reset_out(),
        .tx_out_clk()
    );

    wire gt_powergood_all;
    assign gt_powergood_all =&gt_powergood;    
    assign locked = pll_locked;
    //debug
    assign peripheral_aresetn = pll_locked;
    always @(posedge user_clk_i or negedge peripheral_aresetn) begin
        if (!peripheral_aresetn) begin
            user_clk_resetn_sync <= 2'b00;
        end else begin
            user_clk_resetn_sync <= {user_clk_resetn_sync[0], 1'b1};
        end
    end

    assign user_clk_resetn = user_clk_resetn_sync[1];
////


endmodule




