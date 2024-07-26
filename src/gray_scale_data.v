`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/10 09:54:39
// Design Name: 
// Module Name: gray_scale_data
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


module gray_scale_data#(
    parameter SIM = 0,
    parameter SIM_FILE_DIR = "././"
    )(
    input           data_clk    ,
    output          h_last      ,
    output          v_last      ,
    output          tvalid      ,
    output  [31:0]  tdata
    );

localparam L_MUN = 1280/4;//4像素输出
localparam H_MUN = 1024;
localparam BLACK_NUM = 768;
localparam DELAY_NUM = 2048;

reg [15:0] l_cnt = 16'd0;
reg [15:0] h_cnt = 16'd0;
reg [15:0] black_cnt = 16'd0;
reg [15:0] delay_cnt = 16'd0;

reg h_last_r = 1'b0;
reg v_last_r = 1'b0;
reg tvalid_r = 1'b0;
reg [31:0] tdata_r = 32'd0;

reg [7:0] ccd_state = 'd0;

always@(posedge data_clk) begin
    case(ccd_state)
        8'd0:begin
            l_cnt <= 16'd0;
            h_cnt <= 16'd0;
            black_cnt <= 16'd0;
            delay_cnt <= 16'd0;
            ccd_state <= 8'd1;
            end
        8'd1:begin
            if(l_cnt == L_MUN-1) begin
                l_cnt <= 16'd0;
                ccd_state <= 8'd2;
                end
            else
                l_cnt <= l_cnt + 16'd1;
            end
        8'd2:begin
            if(black_cnt == BLACK_NUM-1) begin
                black_cnt <= 16'd0;
                ccd_state <= 8'd3;
                end
            else
                black_cnt <= black_cnt + 16'd1;
            end
        8'd3:begin
            if(h_cnt == H_MUN-1) begin
                h_cnt <= 16'd0;
                ccd_state <= 8'd4;
                end
            else begin
                h_cnt <= h_cnt + 16'd1;
                ccd_state <= 8'd1;
                end
            end
        8'd4:begin
            if(delay_cnt == DELAY_NUM-1) begin
                delay_cnt <= 16'd0;
                ccd_state <= 8'd0;
                end
            else
                delay_cnt <= delay_cnt + 16'd1;
            end
        default:ccd_state <= 8'd0;
    endcase
    end

always@(posedge data_clk) begin
    h_last_r <= (l_cnt == L_MUN-1);
    v_last_r <= (h_cnt == H_MUN-1) && (l_cnt == L_MUN-1);
    tvalid_r <= (ccd_state == 8'd1);
    end

always@(posedge data_clk) begin
    tdata_r <= {4{h_cnt[9:2]}};//1024转换到256的灰阶
    end

assign h_last = h_last_r;
assign v_last = v_last_r;
assign tvalid = tvalid_r;
assign tdata = tdata_r;

generate
if(SIM == 1) begin

reg [1023:0] file0;

initial file0 = {SIM_FILE_DIR,"ccd_data.txt"};

integer w_file0;//定义文件句柄

initial w_file0 = $fopen(file0,"w");

always@(posedge data_clk) begin
    if(tvalid == 1'b1)
        $fdisplay(w_file0,"%d",$unsigned(tdata[7:0]));
    end

always@(posedge data_clk) begin
    if(ccd_state == 8'd4) begin
        $fclose(w_file0);
        $display("Save Successfully");
        end
    end

end
endgenerate

endmodule
