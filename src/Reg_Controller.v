`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 11:00:03
// Design Name: 
// Module Name: Reg_Controller
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


module Reg_Controller(
input       clk     ,
input       rst_n   ,
input       [31:0]  idin0   ,
input       [31:0]  idin1   ,
output wire     [31:0]  idout0  ,
output wire     [31:0]  idout1  ,
//output [3:0]            led_o   ,
output reg              Frame3_EN, 
input [31:0]            Frame_counter
    );
reg [31:0] idin_reg0;
reg [31:0] idin_reg1;  
reg [31:0] idin_last0;
reg [31:0] idin_last1;    
//250M 250 000 000
//reg [31:0] timer;   
//reg [9:0] timer_1k; 
//reg [9:0] timer_250; 
//always @(posedge clk) begin
//    if(!rst_n)begin
//        timer <= 0;
//        timer_1k<=0;
//        timer_250<=0;
//    end else begin
        
//        if(timer_250 == 249 && timer_1k == 999)begin
//            timer_250 <= 0;
//            timer_1k <= 0;
//            timer <= timer + 1;
//        end else if(timer_1k == 999) begin
//            timer_1k <= 0; 
//            timer_250 <= timer_250 + 1;
//        end else begin  
//            timer_1k <= timer_1k + 1;
//        end
//    end
//end

 always @ (posedge clk) begin
    if(!rst_n)
    begin
        idin_reg0 <= 0;
        idin_reg1 <= 0;
        idin_last0 <= 0;
        idin_last1 <= 0;
    end
    else
    begin
        idin_reg0 <= idin0;
        idin_reg1 <= idin1;
        idin_last0 <= idin_reg0;
        idin_last1 <= idin_reg1;
    end
end
reg [3:0] reading_frame;
wire [3:0] led_port;
//reg LED_EN;
always @ (posedge clk) begin
    if(!rst_n)begin
        Frame3_EN <= 0;
//        LED_EN <= 0;
    end
    else if(idin_reg0 != idin_last0) begin
        Frame3_EN <= idin_reg0[0];
    end else if (idin_reg1 != idin_last1) begin
//        LED_EN <= !LED_EN;
    end
end
//led L1(clk,rst_n & LED_EN,led_port);
//assign led_o = led_port;
assign idout0 = Frame3_EN;
assign idout1 = Frame_counter;

endmodule