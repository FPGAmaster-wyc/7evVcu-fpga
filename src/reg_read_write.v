`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/06 16:43:11
// Design Name: 
// Module Name: reg_read_write
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
module reg_read_write #(
    parameter ADDR_BITS = 8,
    parameter DATA_BITS = 32
    )(
    input      axi_lite_clk              ,
    input      axi_lite_rst_n            ,
    //////////////////////////////////////user write
    input      [ADDR_BITS - 1:0] wr_addr ,
    input      [DATA_BITS - 1:0] wr_din  ,
    input      [DATA_BITS/8-1:0] wr_be   ,
    input                        wr_en   ,
    //////////////////////////////////////user read
    input      [ADDR_BITS - 1:0] rd_addr ,
    output reg [DATA_BITS - 1:0] rd_dout ,
    output reg                   rd_ready,
    input                        rd_en   ,
    
    input  [1:0]                flag
    
   
    );
    
    /////////////////////////////////////////////////寄存�? 参数实列
    reg [DATA_BITS-1:0] wr_reg_0  = 0;
    reg [DATA_BITS-1:0] wr_reg_1  = 0;
    reg [DATA_BITS-1:0] wr_reg_2  = 0;
    reg [DATA_BITS-1:0] wr_reg_3  = 0;
    reg [DATA_BITS-1:0] wr_reg_4  = 0;
    reg [DATA_BITS-1:0] wr_reg_5  = 0;
    reg [DATA_BITS-1:0] wr_reg_6  = 0;
    reg [DATA_BITS-1:0] wr_reg_7  = 0;
    reg [DATA_BITS-1:0] wr_reg_8  = 0;
    reg [DATA_BITS-1:0] wr_reg_9  = 0;
    reg [DATA_BITS-1:0] wr_reg_10 = 0;
    reg [DATA_BITS-1:0] wr_reg_11 = 0;
    reg [DATA_BITS-1:0] test_reg  = 0;
    
    always@(posedge axi_lite_clk)
    begin
        if(wr_en)
        begin
            case(wr_addr)
                8'h00  : wr_reg_0  <= wr_din;
                8'h04  : wr_reg_1  <= wr_din;
                8'h08  : wr_reg_2  <= wr_din;
                8'h0c  : wr_reg_3  <= wr_din;
                8'h10  : wr_reg_4  <= wr_din;
                8'h14  : wr_reg_5  <= wr_din;//only read 寄存器写入无意义
                8'h18  : wr_reg_6  <= wr_din;
                8'h1c  : wr_reg_7  <= wr_din;
                8'h20  : wr_reg_8  <= wr_din;//only read 寄存器写入无意义
                8'h24  : wr_reg_9  <= wr_din;
                8'h28  : wr_reg_10 <= wr_din;
                8'h2c  : wr_reg_11 <= wr_din;//备用
                default: test_reg  <= wr_din;
            endcase
        end    
    end
    
    always@(posedge axi_lite_clk)
    begin
        if(~axi_lite_rst_n)
            rd_ready <=1'b0;
        else if(rd_en)
            rd_ready <=1'b1;
        else
            rd_ready <=1'b0;
    end
    
    wire [31:0] wr_reg6;
    
    always@(posedge axi_lite_clk)
    begin
        if(rd_en)
        begin
            case(rd_addr)
                8'h00  : rd_dout <= flag ;
                8'h04  : rd_dout <= wr_reg_1 ;
//                8'h04  : rd_dout <= flag     ;  //only read 
                8'h08  : rd_dout <= wr_reg_2 ;
                8'h0c  : rd_dout <= wr_reg_3 ;
                8'h10  : rd_dout <= wr_reg_4 ;
//                8'h14  : rd_dout <= uart0_data_in;// only read
                8'h18  : rd_dout <= wr_reg_6 ;
                8'h1c  : rd_dout <= wr_reg_7 ;
//                8'h20  : rd_dout <= uart1_data_in;// only read
                8'h24  : rd_dout <= wr_reg_9 ;
                8'h28  : rd_dout <= wr_reg_10;
                8'h2c  : rd_dout <= wr_reg_11;
                default: rd_dout <= test_reg;
            endcase
        end    
    end

    
endmodule
