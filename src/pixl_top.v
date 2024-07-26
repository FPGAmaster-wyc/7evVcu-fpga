`define FRAME_HALF_CYCLE 3125

module pixl_top (
  
  input rstn,
  input clk10m,
  input clk20m,
  input clk100m,
  input clk200m,
  input clk125m,
  input clk250m,
  input [20:0] lvds_p1,
  input [20:0] lvds_n1,
  input clk_p11,
  input clk_n11,
  input [20:0] lvds_p2,
  input [20:0] lvds_n2,
  input clk_p21,
  input clk_n21,
  input [20:0] lvds_p3,
  input [20:0] lvds_n3,
  input clk_p31,
  input clk_n31,
  input [20:0] lvds_p4,
  input [20:0] lvds_n4,
  input clk_p41,
  input clk_n41,
  output reg [511:0] pixl_data_out,
  output reg pixl_data_out_en,
  output clk_spi,
  output mosi,
  output miso,
  output cs1,
  output cs2,
  output cs3,
  output cs4,
  output out_user,
  output out_last,
  output [31:0] out_1080_TDATA ,
  output        out_1080_TVALID,
  input         out_1080_TREADY,
  output [1023:0] AXIS_TDATA,
  output AXIS_TVALID,
  input AXIS_TREADY,
  input aurora_ready,
  input probe_out0
  
  ,output out_v_last
);

parameter VA = 500;

(* mark_debug="true" *)wire [508:0] data0_to_fifo;
(* mark_debug="true" *)wire data0_to_fifo_en;
wire         data0_to_fifo_clk  ;
wire [508:0] data1_to_fifo      ;
wire         data1_to_fifo_en   ;
wire         data1_to_fifo_clk  ;
wire [508:0] data2_to_fifo      ;
wire         data2_to_fifo_en   ;
wire         data2_to_fifo_clk  ;
wire [508:0] data3_to_fifo      ;
wire         data3_to_fifo_en   ;
wire         data3_to_fifo_clk  ;
(* mark_debug="true" *)wire data0_from_fifo_en;
(* mark_debug="true" *)wire [508:0] data0_from_fifo;
wire data0_from_fifo_clk;
wire data1_from_fifo_en;
wire [508:0] data1_from_fifo;
wire data1_from_fifo_clk;
wire data2_from_fifo_en;
wire [508:0] data2_from_fifo;
wire data2_from_fifo_clk;
wire data3_from_fifo_en;
wire [508:0] data3_from_fifo;
wire data3_from_fifo_clk;
wire frame_det0;
wire frame_det1;
wire frame_det2;
wire frame_det3;
(* mark_debug="true" *)wire frame_en;
reg [1:0] frame_det0_sync;
reg [1:0] frame_det1_sync;
reg [1:0] frame_det2_sync;
reg [1:0] frame_det3_sync;
reg [11:0] cnt_half_frame;
wire frame_det_sync_or;
wire fifo0_empty;
wire fifo1_empty;
wire fifo2_empty;
wire fifo3_empty;
wire fifo0_full;
wire fifo1_full;
wire fifo2_full;
wire fifo3_full;
wire data0_out_en;
wire data1_out_en;
wire data2_out_en;
wire data3_out_en;
assign data0_out_en = data0_from_fifo_en;
assign data1_out_en = data1_from_fifo_en;
assign data2_out_en = data2_from_fifo_en;
assign data3_out_en = data3_from_fifo_en;
(* mark_debug="true" *)wire pp_ram_full0;
(* mark_debug="true" *)wire pp_ram_full1;
(* mark_debug="true" *)wire pp_ram_full2;
(* mark_debug="true" *)wire pp_ram_full3;
(* mark_debug="true" *)wire [508:0] data0_out;
(* mark_debug="true" *)wire [508:0] data1_out;
(* mark_debug="true" *)wire [508:0] data2_out;
(* mark_debug="true" *)wire [508:0] data3_out;
wire [2:0] unused_wre0;
wire [2:0] unused_wre1;
wire [2:0] unused_wre2;
wire [2:0] unused_wre3;
(* mark_debug="true" *)reg err_fifo0_full;
(* mark_debug="true" *)reg err_fifo1_full;
(* mark_debug="true" *)reg err_fifo2_full;
(* mark_debug="true" *)reg err_fifo3_full;
//////////////////////////////////////////////////////////
always @(posedge clk125m or negedge rstn) begin
  if (!rstn) begin
    frame_det0_sync <= 2'b00;
    frame_det1_sync <= 2'b00;
    frame_det2_sync <= 2'b00;
    frame_det3_sync <= 2'b00;
  end else begin
    frame_det0_sync <= {frame_det0_sync[0], frame_det0};
    frame_det1_sync <= {frame_det1_sync[0], frame_det1};
    frame_det2_sync <= {frame_det2_sync[0], frame_det2};
    frame_det3_sync <= {frame_det3_sync[0], frame_det3};
  end
end

always @(posedge clk125m or negedge rstn) begin
  if (!rstn)
    cnt_half_frame <= 12'd0;
  else
    if (frame_det_sync_or)
      if (cnt_half_frame < `FRAME_HALF_CYCLE) 
        cnt_half_frame <= cnt_half_frame + 1'b1;
end

assign frame_en = ((cnt_half_frame == `FRAME_HALF_CYCLE)&&(aurora_ready)&&(probe_out0)) ? 1'b1 : 1'b0;

pixl_receive u_pixl_receive0 (
  .pixl_bit_p (lvds_p1),
  .pixl_bit_n (lvds_n1),
  .pixl_clk_p (clk_p11),
  .pixl_clk_n (clk_n11),
  .rstn       (rstn),
  .DATA_CLK   (data0_to_fifo_clk),  
  .DATA       (data0_to_fifo),
  .DATA_EN    (data0_to_fifo_en),
  .frame_det  (frame_det0),
  .frame_en   (frame_en)
);

pixl_receive u_pixl_receive1 (
  .pixl_bit_p (lvds_p2),
  .pixl_bit_n (lvds_n2),
  .pixl_clk_p (clk_p21),
  .pixl_clk_n (clk_n21),
  .rstn       (rstn),
  .DATA_CLK   (data1_to_fifo_clk),
  .DATA       (data1_to_fifo),
  .DATA_EN    (data1_to_fifo_en),
  .frame_det  (frame_det1),
  .frame_en   (frame_en)
);

pixl_receive u_pixl_receive2 (
  .pixl_bit_p (lvds_p3),
  .pixl_bit_n (lvds_n3),
  .pixl_clk_p (clk_p31),
  .pixl_clk_n (clk_n31),
  .rstn       (rstn),
  .DATA_CLK   (data2_to_fifo_clk),
  .DATA       (data2_to_fifo),
  .DATA_EN    (data2_to_fifo_en),
  .frame_det  (frame_det2),
  .frame_en   (frame_en)
);

pixl_receive u_pixl_receive3 (
  .pixl_bit_p (lvds_p4),
  .pixl_bit_n (lvds_n4),
  .pixl_clk_p (clk_p41),
  .pixl_clk_n (clk_n41),
  .rstn       (rstn),
  .DATA_CLK   (data3_to_fifo_clk),
  .DATA       (data3_to_fifo),
  .DATA_EN    (data3_to_fifo_en),
  .frame_det  (frame_det3),
  .frame_en   (frame_en)
);

assign data0_from_fifo_clk = clk125m;
assign data1_from_fifo_clk = clk125m;
assign data2_from_fifo_clk = clk125m;
assign data3_from_fifo_clk = clk125m;
assign data0_from_fifo_en = ((~fifo0_empty)&&(~pp_ram_full0)) ? 1'b1 : 1'b0;
assign data1_from_fifo_en = ((~fifo1_empty)&&(~pp_ram_full1)) ? 1'b1 : 1'b0;
assign data2_from_fifo_en = ((~fifo2_empty)&&(~pp_ram_full2)) ? 1'b1 : 1'b0;
assign data3_from_fifo_en = ((~fifo3_empty)&&(~pp_ram_full3)) ? 1'b1 : 1'b0;
assign data0_out = data0_from_fifo;
assign data1_out = data1_from_fifo;
assign data2_out = data2_from_fifo;
assign data3_out = data3_from_fifo;

always @(posedge clk125m or negedge rstn) begin
  if (!rstn)
    err_fifo0_full <= 1'b0;
  else
    if (fifo0_full&data0_to_fifo_en)
      err_fifo0_full <= 1'b1;
end
 
always @(posedge clk125m or negedge rstn) begin
  if (!rstn)
    err_fifo1_full <= 1'b0;
  else
    if (fifo1_full&data1_to_fifo_en)
      err_fifo1_full <= 1'b1;
end

always @(posedge clk125m or negedge rstn) begin
  if (!rstn)
    err_fifo2_full <= 1'b0;
  else
    if (fifo2_full&data2_to_fifo_en)
      err_fifo2_full <= 1'b1;
end

always @(posedge clk125m or negedge rstn) begin
  if (!rstn)
    err_fifo3_full <= 1'b0;
  else
    if (fifo3_full&data3_to_fifo_en)
      err_fifo3_full <= 1'b1;
end

fifo512bit_1k lvds0_fifo512bit_1k (
  .rst      (~rstn),
  .wr_clk   (data0_to_fifo_clk),
  .din      ({3'd0,data0_to_fifo}),
  .wr_en    (data0_to_fifo_en),
  
  .rd_clk   (data0_from_fifo_clk),
  .rd_en    (data0_from_fifo_en),
  .dout     ({unused_wre0,data0_from_fifo}),
  .full     (fifo0_full),
  .empty    (fifo0_empty),
  .rd_data_count (),
  .wr_data_count ()
//  .wr_rst_busy (),
//  .rd_rst_busy ()
);
///////////////////////////////////////////////////////////////////////////////////
fifo512bit_1k lvds1_fifo512bit_1k (
  .rst (~rstn),
  .wr_clk (data1_to_fifo_clk),
  .din ({3'd0,data1_to_fifo}),
  .wr_en (data1_to_fifo_en),
  .rd_clk (data1_from_fifo_clk),
  .rd_en (data1_from_fifo_en),
  .dout ({unused_wre1,data1_from_fifo}),
  .full (fifo1_full),
  .empty (fifo1_empty),
  .rd_data_count (),
  .wr_data_count()
//  .wr_rst_busy(),
//  .rd_rst_busy()
);

fifo512bit_1k lvds2_fifo512bit_1k (
  .rst (~rstn),
  .wr_clk (data2_to_fifo_clk),
  .din ({3'd0,data2_to_fifo}),
  .wr_en (data2_to_fifo_en),
  .rd_clk (data2_from_fifo_clk),
  .rd_en (data2_from_fifo_en),
  .dout ({unused_wre2,data2_from_fifo}),
  .full (fifo2_full),
  .empty (fifo2_empty),
  .rd_data_count (),
  .wr_data_count ()
//  .wr_rst_busy (),
//  .rd_rst_busy ()
);

fifo512bit_1k lvds3_fifo512bit_1k (
  .rst (~rstn),
  .wr_clk (data3_to_fifo_clk),
  .din ({3'd0,data3_to_fifo}),
  .wr_en (data3_to_fifo_en),
  .rd_clk (data3_from_fifo_clk),
  .rd_en (data3_from_fifo_en),
  .dout ({unused_wre3,data3_from_fifo}),
  .full (fifo3_full),
  .empty (fifo3_empty),
  .rd_data_count (),
  .wr_data_count ()
//  .wr_rst_busy (),
//  .rd_rst_busy ()
);

//---------------------------------------------------------------
//--config
wire cs_p;
wire clk2m;
reg [07:0] clk_cnt;
reg [07:0] load_cnt;
wire load;

always @ (posedge clk10m)
  if(!rstn)
    clk_cnt <= 8'd0;
  else
    clk_cnt <= clk_cnt+1'b1;

assign clk2m = clk_cnt[2];

always @ (posedge clk2m or negedge rstn)
  if(!rstn)
    load_cnt <= 8'd0;
  else if (&load_cnt)
    load_cnt <= load_cnt;
  else
    load_cnt <= load_cnt+1'b1;
    
assign load = (load_cnt == 250) ? 1'b1 : 1'b0;

spi_config u_spi_config(
  .clk (clk2m),
  .clk10m (clk10m),
  .rst_n (rstn),
  .load (load),
  .cs_spi (cs_p),
  .clk_spi (clk_spi),
  .mosi (mosi)
);

assign cs1 = cs_p;
assign cs2 = cs_p;
assign cs3 = cs_p;
assign cs4 = cs_p;

//---------------------------------------------------------------
//--qsfp
//design: litianci
(* MARK_DEBUG="true" *)wire query_en_0;
wire [399:0]query_data_0;
wire [12:0]query_addr_0;
reg refresh_ram_en_0;
wire refresh_ram_done_0;
wire [12:0]pull_addr;
wire [799:0]pull_data;
(* MARK_DEBUG="true" *)wire query_en_1;
wire [399:0]query_data_1;
wire [12:0]query_addr_1;
reg refresh_ram_en_1;
wire refresh_ram_done_1;
(* MARK_DEBUG="true" *)wire query_en_2;
wire [399:0]query_data_2;
wire [12:0]query_addr_2;
reg refresh_ram_en_2;
wire refresh_ram_done_2;
(* MARK_DEBUG="true" *)wire query_en_3;
wire [399:0]query_data_3;
wire [12:0]query_addr_3;
reg refresh_ram_en_3;
wire refresh_ram_done_3;
wire [511:0] data_in;
wire write_en;

assign data_in = data0_out;
assign write_en = data0_out_en;

wire [8:0] addr0;
wire [8:0] addr1;
wire [8:0] addr2;
wire [8:0] addr3;

assign addr0 = VA - data0_out[508:500];     ////��ַ��ת
assign addr1 = VA - data1_out[508:500];     ////��ַ��ת
assign addr2 = data2_out[508:500] - 1;     ////��ַ��ת
assign addr3 = data3_out[508:500] - 1;     ////��ַ��ת

proc_top_uram proc_sub0(
  // write fifo
  .clk100M_i        (clk125m),
  .clk100M_resetn_i (rstn),
  .capture_en_i     (write_en),
  .fifoFull_o       (),
//  .fifoDin_i        (data_in[508:0]),
  .fifoDin_i        ({addr0,reverse_bits(data0_out[499:0])}),           /// ��ַ��ת
  //read fifo
  .clk_200M         (clk250m),
  .rst_200M         (rstn),
  .pull_data        (pull_data),
  .pull_addr        (pull_addr),
  .addr_q           (query_addr_0), // i read addr
  .ce0              (query_en_0),   // i read enable
  .q0               (query_data_0),    // o query date
  .save_done        (refresh_ram_done_0),
  .write_enable     (refresh_ram_en_0)
);

proc_top_uram proc_sub1(
  // write fifo
  .clk100M_i(clk125m),
  .clk100M_resetn_i(rstn),
  .capture_en_i(data1_out_en),
  .fifoFull_o(),
//  .fifoDin_i(data1_out[508:0]),
 .fifoDin_i({addr1, data1_out[499:0]}),         ////��ַ+����
  //read fifo
  .clk_200M(clk250m),
  .rst_200M(rstn),
  .addr_q(query_addr_1), // i read addr
  .ce0(query_en_1),   // i read enable
  .q0(query_data_1),    // o query date
  .save_done(refresh_ram_done_1),
  .write_enable(refresh_ram_en_1)
);

proc_top_uram proc_sub2(
  // write fifo
  .clk100M_i(clk125m),
  .clk100M_resetn_i(rstn),
  .capture_en_i(data2_out_en),
  .fifoFull_o(),
  // .fifoDin_i(data2_out[508:0]),
  .fifoDin_i({addr2,reverse_bits(data2_out[499:0])}),
  //read fifo
  .clk_200M(clk250m),
  .rst_200M(rstn),
  .addr_q(query_addr_2), // i read addr
  .ce0(query_en_2),   // i read enable
  .q0(query_data_2),    // o query date
  .save_done(refresh_ram_done_2),
  .write_enable(refresh_ram_en_2)
);

proc_top_uram proc_sub3(
  // write fifo
  .clk100M_i(clk125m),
  .clk100M_resetn_i(rstn),
  .capture_en_i(data3_out_en),
  .fifoFull_o(),
//  .fifoDin_i(data3_out[508:0]),
  .fifoDin_i({addr3,data3_out[499:0]}),       ///����
  //read fifo
  .clk_200M(clk250m),
  .rst_200M(rstn),
  .addr_q(query_addr_3), // i read addr
  .ce0(query_en_3),   // i read enable
  .q0(query_data_3),    // o query date
  .save_done(refresh_ram_done_3),
  .write_enable(refresh_ram_en_3)
);            

(* mark_debug="true" *)wire [799:0] q_0_8bit;
(* mark_debug="true" *)wire [799:0] q_1_8bit;
(* mark_debug="true" *)wire [799:0] q_2_8bit;
(* mark_debug="true" *)wire [799:0] q_3_8bit;
reg [3:0] write_state;
reg [2:0] STATE_SAVE;
parameter IDLE_S = 3'd0;
parameter SAVE = 3'd1;
parameter OUT_S = 3'd2;
wire ap_done;
reg  ap_start;
reg [19:0] counter_datas;
assign out_user = counter_datas == 20'd0;   //ÿһ֡�ĵ�һ���ź�
assign out_last = counter_datas != 20'd0 && (counter_datas + 1) % 320 == 0; //�н����źţ�1024��

////////////////////////////////////////////////////////////////////////////////////////
assign out_v_last = (counter_datas == 20'd327680);      ////֡�����ź�


////////////////////////////////////////////////////////////////////////////////////////

always@(posedge clk250m )begin
  if (!rstn)begin
    STATE_SAVE <= IDLE_S;
    ap_start   <= 1'd0;
    write_state <= 4'd0;
  end else begin
    if (STATE_SAVE == IDLE_S)begin
      refresh_ram_en_0<= 1'd1;
      refresh_ram_en_1<= 1'd1;
      refresh_ram_en_2<= 1'd1;
      refresh_ram_en_3<= 1'd1;
      write_state <= 4'd0;
      STATE_SAVE <= OUT_S;
    end else if(STATE_SAVE == OUT_S) begin
      if (refresh_ram_done_0) begin
          refresh_ram_en_0<= 1'd0;
          write_state[0]<= 1'd1;
      end
      if (refresh_ram_done_1) begin
          refresh_ram_en_1<= 1'd0;
          write_state[1]<= 1'd1;
      end
      if (refresh_ram_done_2) begin
          refresh_ram_en_2<= 1'd0;
          write_state[2]<= 1'd1;
      end
      if (refresh_ram_done_3) begin
          refresh_ram_en_3<= 1'd0;
          write_state[3]<= 1'd1;
      end
      if (write_state == 4'b1111)begin
        ap_start <= 1'd1;
        STATE_SAVE <= SAVE;
      end else begin
        ap_start <= 1'd0;
        STATE_SAVE <= OUT_S;
      end
    end else if (STATE_SAVE == SAVE) begin
      if (ap_done) begin
        STATE_SAVE <= IDLE_S;
        ap_start <= 1'd0;
      end else begin
        STATE_SAVE <= SAVE;
        refresh_ram_en_0<= 1'd0;
        refresh_ram_en_1<= 1'd0;
        refresh_ram_en_2<= 1'd0;
        refresh_ram_en_3<= 1'd0;
        write_state  <= 4'b0000;
      end
    end
  end
end

genvar idx;
for (idx = 0; idx < 50; idx=idx+1) begin
    assign q_0_8bit[8*idx+:8] ={query_data_0[8*idx+:8]};
    assign q_1_8bit[8*idx+:8] ={query_data_1[8*idx+:8]};
    assign q_2_8bit[8*idx+:8] ={query_data_2[8*idx+:8]};
    assign q_3_8bit[8*idx+:8] ={query_data_3[8*idx+:8]};
end

//save_image_1280x1024 saveimg(
//  .ap_clk (clk250m),
//  .ap_rst_n (rstn),
//  .ap_start (ap_start),
//  .ap_done (ap_done),
//  .ap_idle (),
//  .ap_ready (),
//  .talpha (8'd12),
//  .window (8'd15),
//  .ram_a_address0 (query_addr_0),
//  .ram_a_ce0 (query_en_0),
//  .ram_a_q0 (q_0_8bit),
//  .ram_b_address0 (query_addr_1),
//  .ram_b_ce0 (query_en_1),
//  .ram_b_q0 (q_1_8bit),
//  .ram_c_address0 (query_addr_2),
//  .ram_c_ce0 (query_en_2),
//  .ram_c_q0 (q_2_8bit),
//  .ram_d_address0 (query_addr_3),
//  .ram_d_ce0 (query_en_3),
//  .ram_d_q0 (q_3_8bit),
//  .out_1280x1024_TDATA (out_1080_TDATA),
//  .out_1280x1024_TVALID (out_1080_TVALID),
//  .out_1280x1024_TREADY (out_1080_TREADY)
//);
save_image_1280x1024 saveimg(
        .ap_clk(clk250m),
        .ap_rst_n(rstn),
        .ap_start(ap_start),
        .ap_done(ap_done),
        .ap_idle(),
        .ap_ready(),
        .talpha(8'd4),
//        .talpha(8'd1),//
        .window(8'd50),
        .ram_a_address0(query_addr_0),
        .ram_a_ce0(query_en_0),
        .ram_a_q0(q_0_8bit),
        .ram_b_address0(query_addr_1),
        .ram_b_ce0(query_en_1),
        .ram_b_q0(q_1_8bit),
        .ram_c_address0(query_addr_2),
        .ram_c_ce0(query_en_2),
        .ram_c_q0(q_2_8bit),
        .ram_d_address0(query_addr_3),
        .ram_d_ce0(query_en_3),
        .ram_d_q0(q_3_8bit),
        .out_1280x1024_TDATA(out_1080_TDATA),
        .out_1280x1024_TVALID(out_1080_TVALID),
        .out_1280x1024_TREADY(out_1080_TREADY) /////////////////////////////////////////
);

always @(posedge clk250m ) begin
  if (!rstn)begin
    counter_datas <= 20'd0;
  end else begin
    if (out_1080_TVALID&&out_1080_TREADY)begin
      counter_datas <= counter_datas + 20'd1;
      //2413/8
     end
     else if(counter_datas == 20'd327680)begin   //ila  counter_datas
       counter_datas<= 20'd0;
     end
  end
end

(* mark_debug="true" *)wire [8:0] data0_out_9bit;
assign data0_out_9bit = data0_out[508:500];

/*pp_control*/
localparam IDLE = 2'd0;
localparam UPPER = 2'd1;
localparam LOWER = 2'd2;

function [499:0] reverse_bits;
input [499:0] bits;
integer i;
begin
  for (i=0;i<500;i=i+1) begin
    reverse_bits[i] = bits[499-i];
  end
end
endfunction

reg [1:0] state;
reg [1:0] nstate;
reg [8:0] cnt_rd;
wire rd_upper;
wire rd_lower;
wire upper_done;
wire lower_done;

wire pix_empty0;
wire [511:0] linePix0_reorder;
wire pix_rd0;
wire [508:0] pix_rdata0;
wire pix_rd_done0;
wire [8:0] pix_raddr0;

wire pix_empty1;
wire [511:0] linePix1_reorder;
wire pix_rd1;
wire [508:0] pix_rdata1;
wire pix_rd_done1;
wire [8:0] pix_raddr1;

wire pix_empty2;
wire [511:0] linePix2_reorder;
wire pix_rd2;
wire [508:0] pix_rdata2;
wire pix_rd_done2;
wire [8:0] pix_raddr2;

wire pix_empty3;
wire [511:0] linePix3_reorder;
wire pix_rd3;
wire [508:0] pix_rdata3;
wire pix_rd_done3;
wire [8:0] pix_raddr3;

wire [1023:0] linePix_upper; // upper half frame (vertically flipped)
wire [1023:0] linePix_lower; // lower half frame

wire fifo_full;
wire fifo_near_full;
wire fifo_empty;
wire [1023:0] fifo_dout;
wire fifo_rd;
reg fifo_wr;
wire [1023:0] fifo_din;
reg upper;

assign count_l=fifo_dout[1023:1012];
assign count_r=fifo_dout[511:500];

// stream interface
assign AXIS_TDATA = fifo_dout;
assign AXIS_TVALID = !fifo_empty;

assign fifo_rd = (AXIS_TVALID&&AXIS_TREADY) ? 1'b1 : 1'b0;

assign rd_upper = (state == UPPER) && !(pix_empty0||pix_empty1) && (fifo_rd ||
                    ((!fifo_full)&&(!(fifo_near_full && fifo_wr))));

assign rd_lower = (state == LOWER) && !(pix_empty2||pix_empty3) && (fifo_rd ||
                    ((!fifo_full)&&(!(fifo_near_full && fifo_wr))));

always @(posedge clk125m or negedge rstn) begin
  if (!rstn) begin
    fifo_wr <= 1'b0;
  end else begin
    fifo_wr <= rd_upper||rd_lower;
  end
end

// lag state change by one clock cycle
// to match ram read latency
always @(posedge clk125m or negedge rstn) begin
  if (!rstn) begin
    upper <= 1'b0;
  end else begin
    upper <= (state == UPPER) ? 1'b1 : 1'b0;
  end
end

assign fifo_din = upper ? linePix_upper : linePix_lower;

assign pix_rd0 = rd_upper;
assign pix_rd1 = rd_upper;
assign pix_rd2 = rd_lower;
assign pix_rd3 = rd_lower;
assign upper_done = (rd_upper&&(cnt_rd == (VA-1))) ? 1'b1 : 1'b0;
assign lower_done = (rd_lower&&(cnt_rd == (VA-1))) ? 1'b1 : 1'b0;

assign pix_rd_done0 = upper_done;
assign pix_rd_done1 = upper_done;
assign pix_rd_done2 = lower_done;
assign pix_rd_done3 = lower_done;

assign linePix_upper = {linePix1_reorder, linePix0_reorder};
assign linePix_lower = {linePix3_reorder, linePix2_reorder};

assign pix_raddr0 = (VA-1) - cnt_rd;
assign pix_raddr1 = (VA-1) - cnt_rd;
assign pix_raddr2 = cnt_rd;
assign pix_raddr3 = cnt_rd;

always @(posedge clk125m or negedge rstn) begin
  if (!rstn) begin
    state <= IDLE;
  end else begin
    state <= nstate;
  end
end

always @* begin
  nstate = state;
  case (state)
    IDLE: if (!(pix_empty0||pix_empty1)) begin
            nstate = UPPER;
          end
    UPPER: if (rd_upper&&(cnt_rd == (VA-1))) begin
             nstate = LOWER;
           end
    LOWER: if (rd_lower&&(cnt_rd == (VA-1))) begin
             nstate = IDLE;
           end
    default: nstate = state;
  endcase
end

// counter logic
always @(posedge clk125m or negedge rstn) begin
  if (!rstn) begin
    cnt_rd <= 9'd0;
  end else begin
    if (((state==UPPER)&&rd_upper)||((state==LOWER)&&rd_lower)) begin
      cnt_rd <= cnt_rd + 1'b1;
      if (cnt_rd == (VA-1)) begin
        cnt_rd <= 9'd0;
      end
    end
  end
end

// kick off capture upon the detection of the earliest half_frame
assign frame_det_sync_or = frame_det0_sync[1]|frame_det1_sync[1]|frame_det2_sync[1]|frame_det3_sync[1];
// sub-circuit 0 has normal order horizontally, vertically flipped
assign linePix0_reorder = {3'b000,pix_rdata0};
assign linePix1_reorder = {3'b010,pix_rdata1[508:500],reverse_bits(pix_rdata1[499:0])};
// sub-circuit 2 has normal order
assign linePix2_reorder = {3'b100,pix_rdata2};
assign linePix3_reorder = {3'b110,pix_rdata3[508:500],reverse_bits(pix_rdata3[499:0])};

syncFifo1 # (
  .FIFO_WIDTH (1024),
  .FIFO_DEPTH (16)
) u_syncFifo0 (
  .full_o (fifo_full),
  .near_full_o (fifo_near_full),
  .empty_o (fifo_empty),
  .dout_o (fifo_dout),

  .clk_i (clk125m),
  .resetz_i (rstn),
  .rd_i (fifo_rd),
  .wr_i (fifo_wr),
  .din_i (fifo_din)
);

/////////////////////////////////////////////////////////////////////////////////////////////2023/11/18
(* mark_debug="true" *)reg down_sampling_reg0;
(* mark_debug="true" *)wire [8:0] waddr0;
(* mark_debug="true" *)reg [8:0] cnt_wr0;
(* mark_debug="true" *)wire wr_done0;
(* mark_debug="true" *)reg down_sampling_reg1;
(* mark_debug="true" *)wire [8:0] waddr1;
(* mark_debug="true" *)reg [8:0] cnt_wr1;
(* mark_debug="true" *)wire wr_done1;
(* mark_debug="true" *)reg down_sampling_reg2;
(* mark_debug="true" *)wire [8:0] waddr2;
(* mark_debug="true" *)reg [8:0] cnt_wr2;
(* mark_debug="true" *)wire wr_done2;
(* mark_debug="true" *)reg down_sampling_reg3;
(* mark_debug="true" *)wire [8:0] waddr3;
(* mark_debug="true" *)reg [8:0] cnt_wr3;
(* mark_debug="true" *)wire wr_done3;

/*******************************************************HERE IS PPRAM 0 ************************************************************/
always @(posedge clk125m or negedge rstn) begin
  if (!rstn) begin
    down_sampling_reg0 <= 'd1;
  end else begin
    if (data0_out_en) begin
      if (waddr0 == (VA-1)) begin
        down_sampling_reg0<=down_sampling_reg0;
      end
    end
  end
end
wire [508:0] pix_rdata0_odd;
/*wire [508:0] pix_rdata0_even;*/
wire pix_empty0_odd;
/*wire pix_empty0_even;*/
wire pp_ram_full0_odd;
/*wire pp_ram_full0_even;*/

pp_pix #(.VA(VA)) u_pp_pix0 (
  .clk_i                (clk125m),
  .resetz_i             (rstn),
  .pp_ram_wr_done_i     (wr_done0&(down_sampling_reg0=='d1)  ),
  .pp_ram_rd_done_i     (pix_rd_done0                       ),
  .pp_ram_full_o        (pp_ram_full0_odd                       ),
  .pp_ram_empty_o       (pix_empty0_odd                         ),
  .pix_raddr_i          (pix_raddr0                         ),
  .pix_rd_i             (pix_rd0                            ),
  .pix_waddr_i          (waddr0                             ),
  .pix_wdata_i          (data0_out                          ),
  .pix_wr_i             (data0_out_en&down_sampling_reg0    ),
  .pix_rdata_o          (pix_rdata0_odd                         )
);
//pp_pix #(.VA(VA)) u_pp_pix0_downSampling (
//  .clk_i (clk125m),
//  .resetz_i (rstn),
//  .pp_ram_wr_done_i     (wr_done0&(down_sampling_reg0=='d0)   ),
//  .pp_ram_rd_done_i     (pix_rd_done0                       ),
//  .pp_ram_full_o        (pp_ram_full0_even                       ),
//  .pp_ram_empty_o       (pix_empty0_even                         ),
//  .pix_raddr_i          (pix_raddr0                         ),
//  .pix_rd_i             (pix_rd0                            ),
//  .pix_waddr_i          (waddr0                             ),
//  .pix_wdata_i          (data0_out                          ),
//  .pix_wr_i             (data0_out_en& (!down_sampling_reg0)),
//  .pix_rdata_o          (pix_rdata0_even                         )
//);
assign pix_rdata0 = /*pix_rdata0_even|*/ pix_rdata0_odd;
assign pix_empty0 = /*pix_empty0_even|*/ pix_empty0_odd;
assign pp_ram_full0 = /*pp_ram_full0_even |*/ pp_ram_full0_odd;
assign wr_done0 = (data0_out_en&&(waddr0 == (VA - 1))) ? 1'b1 : 1'b0;
assign waddr0 = data0_out[508:500] - 1;
// assign waddr0 = data0_out[508:500];


/*******************************************************HERE IS PPRAM 1 ************************************************************/
always @(posedge clk125m or negedge rstn) begin
  if (!rstn) begin
    down_sampling_reg1 <= 'd1;
  end else begin
    if (data1_out_en) begin
      if (waddr1 == (VA-1)) begin
        down_sampling_reg1<=down_sampling_reg1;
      end
    end
  end
end
wire [508:0] pix_rdata1_odd;
/*wire [508:0] pix_rdata1_even;*/
wire pix_empty1_odd;
/*wire pix_empty1_even;*/
wire pp_ram_full1_odd;
/*wire pp_ram_full1_even;*/

pp_pix #(.VA(VA)) u_pp_pix1 (
  .clk_i (clk125m),
  .resetz_i (rstn),
  .pp_ram_wr_done_i     (wr_done1&(down_sampling_reg1=='d1)  ),
  .pp_ram_rd_done_i     (pix_rd_done1                       ),
  .pp_ram_full_o        (pp_ram_full1_odd                       ),
  .pp_ram_empty_o       (pix_empty1_odd                         ),
  .pix_raddr_i          (pix_raddr1                         ),
  .pix_rd_i             (pix_rd1                            ),
  .pix_waddr_i          (waddr1                             ),
  .pix_wdata_i          (data1_out                          ),
  .pix_wr_i             (data1_out_en&down_sampling_reg1    ),
  .pix_rdata_o          (pix_rdata1_odd                         )
);
//pp_pix #(.VA(VA)) u_pp_pix1_downSampling (
//  .clk_i (clk125m),
//  .resetz_i (rstn),
//  .pp_ram_wr_done_i     (wr_done1&(down_sampling_reg1=='d0)   ),
//  .pp_ram_rd_done_i     (pix_rd_done1                       ),
//  .pp_ram_full_o        (pp_ram_full1_even                       ),
//  .pp_ram_empty_o       (pix_empty1_even                         ),
//  .pix_raddr_i          (pix_raddr1                         ),
//  .pix_rd_i             (pix_rd1                            ),
//  .pix_waddr_i          (waddr1                             ),
//  .pix_wdata_i          (data1_out                          ),
//  .pix_wr_i             (data1_out_en& (!down_sampling_reg1)),
//  .pix_rdata_o          (pix_rdata1_even                         )
//);
assign pix_rdata1 = /*pix_rdata1_even|*/ pix_rdata1_odd;
assign pix_empty1 = /*pix_empty1_even|*/ pix_empty1_odd;
assign pp_ram_full1 = /*pp_ram_full1_even |*/ pp_ram_full1_odd;
assign wr_done1 = (data1_out_en&&(waddr1 == (VA - 1))) ? 1'b1 : 1'b0;
assign waddr1 = data1_out[508:500] - 1;
// assign waddr1 = data1_out[508:500];


/*******************************************************HERE IS PPRAM 2 ************************************************************/
always @(posedge clk125m or negedge rstn) begin
  if (!rstn) begin
    down_sampling_reg2 <= 'd1;
  end else begin
    if (data2_out_en) begin
      if (waddr2 == (VA-1)) begin
        down_sampling_reg2<=down_sampling_reg2;
      end
    end
  end
end
wire [508:0] pix_rdata2_odd;
/*wire [508:0] pix_rdata2_even;*/
wire pix_empty2_odd;
/*wire pix_empty2_even;*/
wire pp_ram_full2_odd;
/*wire pp_ram_full2_even;*/

pp_pix #(.VA(VA)) u_pp_pix2 (
  .clk_i (clk125m),
  .resetz_i (rstn),
  .pp_ram_wr_done_i     (wr_done2&(down_sampling_reg2=='d1)  ),
  .pp_ram_rd_done_i     (pix_rd_done2                       ),
  .pp_ram_full_o        (pp_ram_full2_odd                       ),
  .pp_ram_empty_o       (pix_empty2_odd                         ),
  .pix_raddr_i          (pix_raddr2                         ),
  .pix_rd_i             (pix_rd2                            ),
  .pix_waddr_i          (waddr2                             ),
  .pix_wdata_i          (data2_out                          ),
  .pix_wr_i             (data2_out_en&down_sampling_reg2    ),
  .pix_rdata_o          (pix_rdata2_odd                         )
);
//pp_pix #(.VA(VA)) u_pp_pix2_downSampling (
//  .clk_i (clk125m),
//  .resetz_i (rstn),
//  .pp_ram_wr_done_i     (wr_done2&(down_sampling_reg2=='d0)   ),
//  .pp_ram_rd_done_i     (pix_rd_done2                       ),
//  .pp_ram_full_o        (pp_ram_full2_even                       ),
//  .pp_ram_empty_o       (pix_empty2_even                         ),
//  .pix_raddr_i          (pix_raddr2                         ),
//  .pix_rd_i             (pix_rd2                            ),
//  .pix_waddr_i          (waddr2                             ),
//  .pix_wdata_i          (data2_out                          ),
//  .pix_wr_i             (data2_out_en& (!down_sampling_reg2)),
//  .pix_rdata_o          (pix_rdata2_even                         )
//);
assign pix_rdata2 = /*pix_rdata2_even|*/ pix_rdata2_odd;
assign pix_empty2 = /*pix_empty2_even|*/ pix_empty2_odd;
assign pp_ram_full2 = /*pp_ram_full2_even |*/ pp_ram_full2_odd;
assign wr_done2 = (data2_out_en&&(waddr2 == (VA - 1))) ? 1'b1 : 1'b0;
assign waddr2 = data2_out[508:500] - 1;


/*******************************************************HERE IS PPRAM 3 ************************************************************/
always @(posedge clk125m or negedge rstn) begin
  if (!rstn) begin
    down_sampling_reg3 <= 'd1;
  end else begin
    if (data3_out_en) begin
      if (waddr3 == (VA-1)) begin
        down_sampling_reg3<=down_sampling_reg3;
      end
    end
  end
end
wire [508:0] pix_rdata3_odd;
/*wire [508:0] pix_rdata3_even;*/
wire pix_empty3_odd;
/*wire pix_empty3_even;*/
wire pp_ram_full3_odd;
/*wire pp_ram_full3_even;*/

pp_pix #(.VA(VA)) u_pp_pix3 (
  .clk_i (clk125m),
  .resetz_i (rstn),
  .pp_ram_wr_done_i     (wr_done3&(down_sampling_reg3=='d1)  ),
  .pp_ram_rd_done_i     (pix_rd_done3                       ),
  .pp_ram_full_o        (pp_ram_full3_odd                       ),
  .pp_ram_empty_o       (pix_empty3_odd                         ),
  .pix_raddr_i          (pix_raddr3                         ),
  .pix_rd_i             (pix_rd3                            ),
  .pix_waddr_i          (waddr3                             ),
  .pix_wdata_i          (data3_out                          ),
  .pix_wr_i             (data3_out_en&down_sampling_reg3    ),
  .pix_rdata_o          (pix_rdata3_odd                         )
);
//pp_pix #(.VA(VA)) u_pp_pix3_downSampling (
//  .clk_i (clk125m),
//  .resetz_i (rstn),
//  .pp_ram_wr_done_i     (wr_done3&(down_sampling_reg3=='d0)   ),
//  .pp_ram_rd_done_i     (pix_rd_done3                       ),
//  .pp_ram_full_o        (pp_ram_full3_even                       ),
//  .pp_ram_empty_o       (pix_empty3_even                         ),
//  .pix_raddr_i          (pix_raddr3                         ),
//  .pix_rd_i             (pix_rd3                            ),
//  .pix_waddr_i          (waddr3                             ),
//  .pix_wdata_i          (data3_out                          ),
//  .pix_wr_i             (data3_out_en& (!down_sampling_reg3)),
//  .pix_rdata_o          (pix_rdata3_even                         )
//);
assign pix_rdata3 = /*pix_rdata3_even|*/ pix_rdata3_odd;
assign pix_empty3 = /*pix_empty3_even|*/ pix_empty3_odd;
assign pp_ram_full3 = /*pp_ram_full3_even |*/ pp_ram_full3_odd;
assign wr_done3 = (data3_out_en&&(waddr3 == (VA - 1))) ? 1'b1 : 1'b0;
assign waddr3 = data3_out[508:500] - 1;

endmodule
