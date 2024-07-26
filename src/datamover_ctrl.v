`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/14 11:30:35
// Design Name: 
// Module Name: datamover_ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module datamover_ctrl(
    input   wire            axis_clk                ,
    input   wire            axis_rstn               ,

    input   wire    [63:0]  ddr_address             ,
    input   wire    [63:0]  data_size               ,
    input   wire            start                   ,
    output  reg             finish                  ,
    //CMD
    output  wire    [103:0] S_AXIS_CMD_tdata        ,
    input   wire            S_AXIS_CMD_tready       ,
    output  wire            S_AXIS_CMD_tvalid       ,
    //STS
    input   wire    [7:0]   M_AXIS_STS_tdata        ,
    input   wire    [0:0]   M_AXIS_STS_tkeep        ,
    input   wire            M_AXIS_STS_tlast        ,
    output  wire            M_AXIS_STS_tready       ,
    input   wire            M_AXIS_STS_tvalid       ,

    output  reg     [63:0]  addra_read  = 'h0       ,
    output  reg     [63:0]  data_cnt    = 'd0       ,
    output  reg     [1:0]   state       = 'd0
    );

assign M_AXIS_STS_tready = 1;

reg en = 'd0;
// reg [3:0] state = 'd0;

(* ASYNC_REG="true" *)reg start_r0 = 'd0;
(* ASYNC_REG="true" *)reg start_r1 = 'd0;
(* ASYNC_REG="true" *)reg [63:0] ddr_address_r0 = 'd0;
(* ASYNC_REG="true" *)reg [63:0] ddr_address_r1 = 'd0;
(* ASYNC_REG="true" *)reg [63:0] data_size_r0 = 'd0;
(* ASYNC_REG="true" *)reg [63:0] data_size_r1 = 'd0;

reg [1:0] start_buf = 'd0;
reg [0:0] start_pos = 'd0;

//reg [63:0] data_cnt = 'd0;

reg pre_finish = 1'b0;
reg [7:0] finish_shift = 8'b0;

always@(posedge axis_clk) begin
    ddr_address_r0 <= ddr_address;
    ddr_address_r1 <= ddr_address_r0;
    end

always@(posedge axis_clk) begin
    data_size_r0 <= data_size;
    data_size_r1 <= data_size_r0;
    end

always@(posedge axis_clk) begin
    start_r0 <= start;
    start_r1 <= start_r0;
    end

always@(posedge axis_clk) begin
    start_buf <= {start_buf[0:0],start_r1};
    start_pos <= ~start_buf[1] & start_buf[0];
    end

always@(posedge axis_clk) begin
    if(start_pos)
        data_cnt <= 0;
    else if(M_AXIS_STS_tready & M_AXIS_STS_tvalid & M_AXIS_STS_tlast)
        data_cnt <= data_cnt + 16'h1000;
    else
        data_cnt <= data_cnt;
    end

always@(posedge axis_clk) begin
    if(start_pos)
        en <= 1;
    else if((data_cnt + 16'h1000) >= data_size_r1)
        en <= 0;
    else
        en <= en;
    end

//reg [63:0] addra_read = 'h0000000000000000;

assign S_AXIS_CMD_tvalid = (S_AXIS_CMD_tready & (state == 1));
//assign S_AXIS_CMD_tdata = {8'h0,addra_read,16'h4080,16'h1000};
assign S_AXIS_CMD_tdata = {8'h0,addra_read,16'h0080,16'h1000};//È¥³ýtlastÐÅºÅ

always@(posedge axis_clk) begin
    if(start_pos)
        addra_read <= ddr_address_r1;
    else if(S_AXIS_CMD_tready & (state == 1))
        addra_read <= addra_read + 16'h1000;
    end

always@(posedge axis_clk) begin
    case(state)

    2'd0:
        if(en)
            state <= 1;
    2'd1:
        if(S_AXIS_CMD_tready)
            state <= 2;
    2'd2:
        if(M_AXIS_STS_tready & M_AXIS_STS_tvalid & M_AXIS_STS_tlast)
            state <= 0;

    default:state <= 0;

    endcase
    end

always@(posedge axis_clk) begin
    pre_finish <= (en == 1'b0) && (M_AXIS_STS_tvalid == 1'b1);
    end

always@(posedge axis_clk) begin
    finish_shift <= {finish_shift[6:0],pre_finish};
    finish <= |finish_shift;
    end

endmodule
