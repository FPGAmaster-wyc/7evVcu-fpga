`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/10 15:30:54
// Design Name: 
// Module Name: frame_freq_ctrl
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


module frame_freq_ctrl(
    input               AXIS_CLK            ,
    input               AXIS_RSTN           ,
    //ccd_data
    input       [31:0]  S_AXIS_tdata        ,
    input       [3:0]   S_AXIS_tkeep        ,
    input               S_AXIS_tlast        ,
    output              S_AXIS_tready       ,
    input               S_AXIS_tvalid       ,
    //data_mover
    output  reg [31:0]  M_AXIS_tdata        ,
    output  reg [3:0]   M_AXIS_tkeep        ,
    output  reg         M_AXIS_tlast        ,
    input               M_AXIS_tready       ,
    output  reg         M_AXIS_tvalid       ,
    //ctrl
    // input               ccd_start           ,
    //
    output  reg [63:0]  data_size           ,
    output  reg [63:0]  ddr_address         ,
    output  reg         start               ,
    //intr
    input               mover_finish        ,
    output  reg [1:0]   flag = 2'd0
    );


//////////////////////////////////////////////////////////////////////////////
reg [31:0]   ready_cnt;
wire ccd_start;

always@(posedge AXIS_CLK)
begin
    if( !AXIS_RSTN )
        ready_cnt <= 32'd0;
    else if (ready_cnt == 32'd1000000000)             //////4*1000000000=4s
        ready_cnt <= ready_cnt;
    else
        ready_cnt <= ready_cnt +1;
end

assign ccd_start = (ready_cnt == 32'd1000000000) ? 1'b1 : 1'b0;

//////////////////////////////////////////////////////////////////////////////

reg [31:0]  cnt;
assign S_AXIS_tready = 1'b1;      
// assign S_AXIS_tready = M_AXIS_tready;

localparam DELAY_NUM = 4_000_000;//16ms

reg [7:0] frame_state = 8'd0;
reg [31:0] delay_cnt = 8'd0;
reg ping_pang_flag = 1'd0;

reg [1:0] ccd_start_buf = 2'b00;
reg [0:0] ccd_start_pos = 1'b0;

(* ASYNC_REG="true" *)reg [0:0] mover_finish_r0 = 1'b0;
(* ASYNC_REG="true" *)reg [0:0] mover_finish_r1 = 1'b0;
reg [1:0] mover_finish_buf = 2'b00;
reg [0:0] mover_finish_pos = 1'b0;

always@(posedge AXIS_CLK) begin
    ccd_start_buf <= {ccd_start_buf[0],ccd_start};
    ccd_start_pos <= (ccd_start_buf[1] == 1'b0) && (ccd_start_buf[0] == 1'b1);
    end

always@(posedge AXIS_CLK) begin
    mover_finish_r0 <= mover_finish;
    mover_finish_r1 <= mover_finish_r0;
    end

always@(posedge AXIS_CLK) begin
    mover_finish_buf <= {mover_finish_buf[0],mover_finish_r1};
    mover_finish_pos <= (mover_finish_buf[1] == 1'b0) && (mover_finish_buf[0] == 1'b1);
    end

always@(posedge AXIS_CLK) begin
    if(AXIS_RSTN == 0) begin
        M_AXIS_tdata  <= 32'b0;
        M_AXIS_tkeep  <= 4'b0;
        M_AXIS_tlast  <= 1'b0;
        M_AXIS_tvalid <= 1'b0;
        delay_cnt <= 32'd0;
        ping_pang_flag <= 1'd0;
        frame_state <= 8'd0;
        end
    else begin
        case(frame_state)
            8'd0:begin
                if(ccd_start_pos == 1'b1)
                    frame_state <= 8'd1;
                end
            8'd1:begin
                M_AXIS_tdata  <= 32'b0;
                M_AXIS_tkeep  <= 4'b0;
                M_AXIS_tlast  <= 1'b0;
                M_AXIS_tvalid <= 1'b0;
                if(S_AXIS_tlast == 1'b1)
                    frame_state <= 8'd2;
                    cnt <= 32'b0;
                end
            8'd2:begin
                M_AXIS_tdata  <= S_AXIS_tdata ;
                M_AXIS_tkeep  <= S_AXIS_tkeep ;
                M_AXIS_tlast  <= S_AXIS_tlast ;
                M_AXIS_tvalid <= S_AXIS_tvalid;
                cnt <= cnt + 1;
                if(S_AXIS_tlast)
                    frame_state <= 8'd3;
                    cnt <= 32'b0;
                end
            8'd3:begin
                M_AXIS_tdata  <= 32'b0;
                M_AXIS_tkeep  <= 4'b0;
                M_AXIS_tlast  <= 1'b0;
                M_AXIS_tvalid <= 1'b0;
                if(mover_finish_pos == 1'b1)
                    frame_state <= 8'd4;
                end
            8'd4:begin
                if(delay_cnt == DELAY_NUM-1) begin
                    frame_state <= 8'd5;
                    delay_cnt <= 32'd0;
                    end
                else
                    delay_cnt <= delay_cnt + 1;
                end
            8'd5:begin
                ping_pang_flag <= ~ping_pang_flag;
                frame_state <= 8'd1;
                // frame_state <= 8'd0;
                end
            default:frame_state <= 8'd0;
        endcase
        end
    end

always@(posedge AXIS_CLK) begin
    data_size   <= 64'd1280*64'd1024;
    end

always@(posedge AXIS_CLK) begin
    case(ping_pang_flag)
        0:ddr_address <= 64'h4000_0000;
        1:ddr_address <= 64'h6000_0000;
    endcase
    end

always@(posedge AXIS_CLK) begin
    if((frame_state == 8'd1) && (S_AXIS_tlast == 1'b1))
        start <= 1'b1;
    else
        start <= 1'b0;
    end

always@(posedge AXIS_CLK) begin
    if(mover_finish_pos == 1'b1) begin
        case(ping_pang_flag)
            0:flag <= 2'd1;
            1:flag <= 2'd2;
        endcase
        end
    else
        flag <= flag;
    end


endmodule
