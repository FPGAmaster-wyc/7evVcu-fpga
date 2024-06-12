/*

  simple pix receive module
  operates on pixl clock

  xwen 20231123
*/
module pixl_receive #(
    parameter DATA_WIDTH = 21    
) (
    input [DATA_WIDTH-1:0] pixl_bit_p,
    input [DATA_WIDTH-1:0] pixl_bit_n,
    input pixl_clk_p,
    input pixl_clk_n,
    input rstn,
    output DATA_CLK,
    output [508:0] DATA,
    output reg DATA_EN,
    output reg frame_det,
    input frame_en
);

wire [DATA_WIDTH-1:0] pixl_bit;
(* IOB = "TRUE" *) reg [DATA_WIDTH-1:0] pixl_io;
reg [DATA_WIDTH-2:0] pixl_sav;
reg [24:0] data_out_25bit[DATA_WIDTH-2:0];
wire pixl_clk;
wire [499:0] data_out_500bit;
reg [8:0] line;
reg [1:0] rstn_sync;
wire rst_pixl_clk;
(* mark_debug="true" *)wire frame;
reg shift_en;
reg [4:0] cnt_pixl;
reg [1:0] frame_en_sync;

IBUFDS diff_pixl_clk0 (
  .O (pixl_clk),
  .I (pixl_clk_p),
  .IB (pixl_clk_n)
);

always @(posedge pixl_clk or negedge rstn) begin
  if (!rstn)
    rstn_sync <= 2'b00;
  else
    rstn_sync <= {rstn_sync[0], 1'b1};
end

assign rst_pixl_clk = rstn_sync[1];

always @(posedge pixl_clk or negedge rst_pixl_clk) begin
  if (!rst_pixl_clk)
    frame_en_sync <= 2'b00;
  else
    frame_en_sync <= {frame_en_sync[0], frame_en};
end

genvar i;
generate
  for (i=0;i<DATA_WIDTH;i=i+1) begin: pins
    IBUFDS diff_pixl_dat (
      .O (pixl_bit[i]),
      .I (pixl_bit_p[i]),
      .IB (pixl_bit_n[i])
    );
  end

  for (i=0;i<DATA_WIDTH-1;i=i+1) begin: data
    always @(posedge pixl_clk) begin
      if (shift_en) begin
        data_out_25bit[i] <= {pixl_sav[i], data_out_25bit[i][24:1]};
      end
    end
    assign data_out_500bit[(i+1)*25-1:i*25] = data_out_25bit[i];
  end
endgenerate

always @(posedge pixl_clk or negedge rst_pixl_clk) begin
  if (!rst_pixl_clk) begin
    pixl_io <= {DATA_WIDTH{1'b0}};
    pixl_sav <= {(DATA_WIDTH-1){1'b0}};
  end else begin
    pixl_io <= pixl_bit;
    pixl_sav <= pixl_io[DATA_WIDTH-2:0];
  end
end

assign frame = pixl_io[DATA_WIDTH-1]; // MSB is frame signal

always @(posedge pixl_clk or negedge rst_pixl_clk) begin
  if (!rst_pixl_clk) begin
    frame_det <= 1'b0;
    shift_en <= 1'b0;
  end else begin
    if (frame) begin
      frame_det <= 1'b1;
      shift_en <= frame_en_sync[1];
    end
  end
end

always @(posedge pixl_clk or negedge rst_pixl_clk) begin
  if (!rst_pixl_clk) begin
    cnt_pixl <= 5'd0;
  end else
    if (shift_en) begin
      cnt_pixl <= cnt_pixl+1'b1;
      if (cnt_pixl == 5'd24) begin
        cnt_pixl <= 5'd0;
      end
    end
end

always @(posedge pixl_clk or negedge rst_pixl_clk) begin
  if (!rst_pixl_clk) begin
    DATA_EN <= 1'b0;
  end else begin
    DATA_EN <= (cnt_pixl == 5'd24) ? 1'b1 : 1'b0;
  end
end

always @(posedge pixl_clk or negedge rst_pixl_clk) begin
  if (!rst_pixl_clk)
    line <= 9'd0;
  else
    if (DATA_EN) begin
      line <= line + 1'b1;
      if (line == 9'd499)
        line <= 9'd0;
    end
end

assign DATA = {line+1'b1, data_out_500bit};
assign DATA_CLK = pixl_clk;

///////////////////////////////////////////////////////////////////////
reg [19:0] data_out_25bit_20;
reg [19:0] DATA_20;

always@(posedge pixl_clk) begin
data_out_25bit_20 <= data_out_500bit[ 19:  0];
end

// ila_sensor q_ila (
	// .clk   (pixl_clk           ),   // input wire clk
	// .probe0(data_out_25bit_20  ),   //    20bit
	// .probe1(1'b0               )    //    1bit
// );



endmodule
