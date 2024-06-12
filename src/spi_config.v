`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:52:31 06/21/2021 
// Design Name: 
// Module Name:    spi_config 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

`define VIO;

module spi_config (
    
    input     wire          clk, // 2MHz, 500ns
	input 		wire clk10m,
    input     wire          rst_n,

	input     wire          load,
    
	output    wire          cs_spi,
    output    wire          clk_spi, // spi内部时钟
    output    wire          mosi
);


//-------------------------------- internal signals ------------------------------//
reg         	cs_p;
reg             cs_p_d1         ;

reg   [7:0]     cnt_reg         ;  // �?要配置的寄存器计数器,�?�?31�?!
reg   [7:0]     cnt_clk         ;  // 每个寄存器需要的时钟数计数器


reg   [13:0]    data_reg        ;  // 地址+指令+数据

  reg 		    mosi_reg    ;

  reg [13:0]		mid_data_reg;
  reg           sdio            ;
  reg           cs              ;
  reg           sclk            ;


//------------------------------------ parameter ----------------------------------//
parameter NUM_CLK = 8'd26     ;  // 每个寄存器需要的时钟�?
parameter NUM_REG = 8'd32      ;  // �?要配置的寄存器个�?


//------------------------------------ main code ----------------------------------//
wire vio_valid;
wire reload;
wire [13:0] probe_out0; 
wire [13:0] probe_out1;
wire [13:0] probe_out2;
wire [13:0] probe_out3;
wire [13:0] probe_out4;
wire [13:0] probe_out5;
wire [13:0] probe_out6;
wire [13:0] probe_out7;
wire [13:0] probe_out8;
wire [13:0] probe_out9;
wire [13:0] probe_out10;
wire [13:0] probe_out11;
wire [13:0] probe_out12;
wire [13:0] probe_out13;
wire [13:0] probe_out14;
wire [13:0] probe_out15;
wire [13:0] probe_out16;
wire [13:0] probe_out17;
wire [13:0] probe_out18;
wire [13:0] probe_out19;
wire [13:0] probe_out20;
wire [13:0] probe_out21;
wire [13:0] probe_out22;
wire [13:0] probe_out23;
wire [13:0] probe_out24;
wire [13:0] probe_out25;
wire [13:0] probe_out26;
wire [13:0] probe_out27;
wire [13:0] probe_out28;
wire [13:0] probe_out29;
wire [13:0] probe_out30;
wire [13:0] probe_out31;

always @(negedge clk) begin
	if(vio_valid)begin
    case(cnt_reg)
        // Serial Port Configuration
        8'd1    : data_reg <= probe_out0; // 5'd11 = 0000_0000
        8'd2    : data_reg <= probe_out1; // 5'd31 = 0010_1111, 256�?
        8'd3    : data_reg <= probe_out2; // 5'd00 = 0000_0000
        8'd4    : data_reg <= probe_out3; // 5'd01 = 0000_0000
        8'd5    : data_reg <= probe_out4; // 5'd02 = 0000_0000
        8'd6    : data_reg <= probe_out5; // 5'd03 = 0000_0000
        8'd7    : data_reg <= probe_out6; // 5'd04 = 0000_0100
        8'd8    : data_reg <= probe_out7; // 5'd05 = 0000_0000
        8'd9    : data_reg <= probe_out8; // 5'd06 = 0000_1111
        8'd10   : data_reg <= probe_out9; // 5'd07 = 0000_0000
        8'd11   : data_reg <= probe_out10;  // 5'd08 = 0000_0000
        8'd12   : data_reg <= probe_out11;  // 5'd09 = 0000_0000
        8'd13   : data_reg <= probe_out12;  // 5'd10 = 0000_0001
        8'd14   : data_reg <= probe_out13;  // 5'd12 = 0000_0001
        8'd15   : data_reg <= probe_out14;  // 5'd13 = 0000_0000
        8'd16   : data_reg <= probe_out15;  // 5'd14 = 0010_1111
        8'd17   : data_reg <= probe_out16;  // 5'd15 = 0000_0010
        8'd18   : data_reg <= probe_out17;  // 5'd16 = 0000_1000
        8'd19   : data_reg <= probe_out18;  // 5'd17 = 0001_1111
        8'd20   : data_reg <= probe_out19;  // 5'd18 = 0101_1110
        8'd21   : data_reg <= probe_out20;  // 5'd19 = 0011_0110
        8'd22   : data_reg <= probe_out21;  // 5'd20 = 0010_0010
        8'd23   : data_reg <= probe_out22;  // 5'd21 = 0000_0000
        8'd24   : data_reg <= probe_out23;  // 5'd22 = 0000_0000
        8'd25   : data_reg <= probe_out24;  // 5'd23 = 0011_1100
        8'd26   : data_reg <= probe_out25;  // 5'd24 = 0000_0000
        8'd27   : data_reg <= probe_out26;  // 5'd25 = 0000_1000
        8'd28   : data_reg <= probe_out27;  // 5'd26 = 0000_1000
        8'd29   : data_reg <= probe_out28;  // 5'd27 = 0000_0000
        8'd30   : data_reg <= probe_out29;  // 5'd28 = 0000_0000
        8'd31   : data_reg <= probe_out30;  // 5'd29 = 0000_0000
        8'd32   : data_reg <= probe_out31;  // 5'd30 = 0000_0000
			  default : data_reg <= 14'dZ;
    endcase

	end
	else begin
    case(cnt_reg)
        // Serial Port Configuration
        8'd1    : data_reg <= 14'b01001_1_0000_0000;  // 5'd11 = 0000_0000  test enable
        8'd2    : data_reg <= 14'b01011_1_0000_0000;  // 5'd31 = 0010_1111, 256�?
        8'd3    : data_reg <= 14'b01011_1_0000_0000;  // 5'd00 = 0000_0001
        8'd4    : data_reg <= 14'b01011_1_0000_0000;  // 5'd01 = 0000_0000
        8'd5    : data_reg <= 14'b01011_1_0000_0000;  // 5'd02 = 0000_0111
        8'd6    : data_reg <= 14'b01011_1_0000_0000;  // 5'd03 = 0000_0000
        8'd7    : data_reg <= 14'b01011_1_0000_0000;  // 5'd04 = 0000_0100
        8'd8    : data_reg <= 14'b01011_1_0000_0000;  // 5'd05 = 0000_0000
        8'd9    : data_reg <= 14'b01011_1_0000_0000;  // 5'd06 = 0000_1111

        8'd10   : data_reg <= 14'b01011_1_0000_0000;  // 5'd07 = 0000_1000

        8'd11   : data_reg <= 14'b01011_1_0000_0000;  // 5'd08 = 0000_0000
        8'd12   : data_reg <= 14'b01011_1_0000_0000;  // 5'd09 = 0000_0000
        8'd13   : data_reg <= 14'b01011_1_0000_0000;  // 5'd10 = 0000_0001
        8'd14   : data_reg <= 14'b01011_1_0000_0000;  // 5'd12 = 0000_0001
        8'd15   : data_reg <= 14'b01011_1_0000_0000;  // 5'd13 = 0000_0000
        8'd16   : data_reg <= 14'b01011_1_0000_0000;  // 5'd14 = 0010_1111
        8'd17   : data_reg <= 14'b01011_1_0000_0000;  // 5'd15 = 0000_0010
        8'd18   : data_reg <= 14'b01011_1_0000_0000;  // 5'd16 = 0000_1000
        8'd19   : data_reg <= 14'b01011_1_0000_0000;  // 5'd17 = 0001_1111
        8'd20   : data_reg <= 14'b01011_1_0000_0000;  // 5'd18 = 0101_1110
        8'd21   : data_reg <= 14'b01011_1_0000_0000;  // 5'd19 = 0011_0110
        8'd22   : data_reg <= 14'b01011_1_0000_0000;  // 5'd20 = 0010_0010
        8'd23   : data_reg <= 14'b01011_1_0000_0000;  // 5'd21 = 0000_0000
        8'd24   : data_reg <= 14'b01011_1_0000_0000;  // 5'd22 = 0000_0000
        8'd25   : data_reg <= 14'b01011_1_0000_0000;  // 5'd23 = 0011_1100
        8'd26   : data_reg <= 14'b01011_1_0000_0000;  // 5'd24 = 0000_0000
        8'd27   : data_reg <= 14'b01011_1_0000_0000;  // 5'd25 = 0000_1000
        8'd28   : data_reg <= 14'b01011_1_0000_0000;  // 5'd26 = 0000_1000

        8'd29   : data_reg <= 14'b01011_1_0000_0000;  // 5'd27 = 0000_1000

        8'd30   : data_reg <= 14'b01011_1_0000_0000;  // 5'd28 = 0000_0000

        8'd31   : data_reg <= 14'b01011_1_0000_0000;  // 5'd29 = 0000_1000

        8'd32   : data_reg <= 14'b01011_1_0000_0000;  // 5'd30 = 0000_0000
			  default : data_reg <= 14'dZ;
    endcase
	end
end


reg [07:0] c_state;
reg [07:0] n_state;

always @ (negedge clk or negedge rst_n)
	if(!rst_n)
		c_state	<= 8'd0;
	else
		c_state	<= n_state;
		
always @ (c_state  or load or cnt_reg or cnt_clk)
	case(c_state)
		0 : begin
			if(load||reload)
				n_state	= 8'd1;
			else
				n_state	= 8'd0;
		end
		1 : begin
				n_state	= 8'd11;
		end
		11 : begin
				n_state	= 8'd2;
		end
		2 : begin
				n_state	= 8'd3;
		end
		3 : begin
			if(cnt_clk<8'd14)
				n_state	= 8'd2;
			else
				n_state	= 8'd4;
		end
		4 : begin
				n_state	= 8'd14;
		end
		14 : begin
			if(cnt_reg<33)
				n_state	= 8'd1;
			else
				n_state	= 8'd5;
		end
		5:	n_state	= 8'd0;
		default:n_state	= 8'd0;
	endcase

always @ (negedge clk or negedge rst_n)
	if(!rst_n)begin
		sdio <= 1'b0;
		cs   <= 1'b0;
		sclk <= 1'b1;
        cnt_clk <= 0;
        cnt_reg <= 1;
        mid_data_reg <= 14'b0;
	end
	else
		case(n_state)
			0 : begin
				sdio <= 1'b0;
				cs   <= 1'b0;
				sclk <= 1'b1;
        		cnt_clk <= 0;
       			cnt_reg <= 1;
        		mid_data_reg <= 14'b0;
			end
			1 : begin
				sdio <= 1'b0;
				cs   <= 1'b1;
				sclk <= 1'b1;
			end
			11 : begin
				sdio <= 1'b0;
				cs   <= 1'b1;
				sclk <= 1'b1;
        		mid_data_reg <= data_reg;
			end
			2 : begin
				sdio <= mid_data_reg[13];
				cs   <= 1'b1;
				sclk <= 1'b0;
				cnt_clk <= cnt_clk + 1;
			end
			3 : begin
              	mid_data_reg <= {mid_data_reg[12:0],1'b0};
				sdio <= sdio;
				cs   <= 1'b1;
				sclk <= 1'b1;
			end
			4 : begin
				sdio <= 1'b0;
				cs   <= 1'b0;
				sclk <= 1'b1;
			end
			14 : begin
				sdio <= 1'b0;
				cs   <= 1'b0;
				sclk <= 1'b1;
        		cnt_clk <= 0;
				if(cnt_reg<33)
					cnt_reg <= cnt_reg + 1;

			end
			5 : begin
				sdio <= 1'b0;
				cs   <= 1'b0;
				sclk <= 1'b1;
        		cnt_clk <= 0;
        		cnt_reg <= 0;
        		mid_data_reg <= 14'b0;
			end
			default: begin
				sdio <= 1'b0;
				cs   <= 1'b0;
				sclk <= 1'b1;
        		cnt_clk <= 0;
        		cnt_reg <= 0;
			end
		endcase

assign mosi	= sdio;
assign clk_spi	= sclk;
assign cs_spi	= cs;

//----------------------------------------------
//vio_2 vio_2_inst (
//  .clk(clk10m),                  // input wire clk
//  .probe_out0 (probe_out0	),    // output wire [13 : 0] probe_out0
//  .probe_out1 (probe_out1	),    // output wire [13 : 0] probe_out1
//  .probe_out2 (probe_out2	),    // output wire [13 : 0] probe_out2
//  .probe_out3 (probe_out3	),    // output wire [13 : 0] probe_out3
//  .probe_out4 (probe_out4	),    // output wire [13 : 0] probe_out4
//  .probe_out5 (probe_out5	),    // output wire [13 : 0] probe_out5
//  .probe_out6 (probe_out6	),    // output wire [13 : 0] probe_out6
//  .probe_out7 (probe_out7	),    // output wire [13 : 0] probe_out7
//  .probe_out8 (probe_out8	),    // output wire [13 : 0] probe_out8
//  .probe_out9 (probe_out9	),    // output wire [13 : 0] probe_out9
//  .probe_out10(probe_out10),  // output wire [13 : 0] probe_out10
//  .probe_out11(probe_out11),  // output wire [13 : 0] probe_out11
//  .probe_out12(probe_out12),  // output wire [13 : 0] probe_out12
//  .probe_out13(probe_out13),  // output wire [13 : 0] probe_out13
//  .probe_out14(probe_out14),  // output wire [13 : 0] probe_out14
//  .probe_out15(probe_out15),  // output wire [13 : 0] probe_out15
//  .probe_out16(probe_out16),  // output wire [13 : 0] probe_out16
//  .probe_out17(probe_out17),  // output wire [13 : 0] probe_out17
//  .probe_out18(probe_out18),  // output wire [13 : 0] probe_out18
//  .probe_out19(probe_out19),  // output wire [13 : 0] probe_out19
//  .probe_out20(probe_out20),  // output wire [13 : 0] probe_out20
//  .probe_out21(probe_out21),  // output wire [13 : 0] probe_out21
//  .probe_out22(probe_out22),  // output wire [13 : 0] probe_out22
//  .probe_out23(probe_out23),  // output wire [13 : 0] probe_out23
//  .probe_out24(probe_out24),  // output wire [13 : 0] probe_out24
//  .probe_out25(probe_out25),  // output wire [13 : 0] probe_out25
//  .probe_out26(probe_out26),  // output wire [13 : 0] probe_out26
//  .probe_out27(probe_out27),  // output wire [13 : 0] probe_out27
//  .probe_out28(probe_out28),  // output wire [13 : 0] probe_out28
//  .probe_out29(probe_out29),  // output wire [13 : 0] probe_out29
//  .probe_out30(probe_out30),  // output wire [13 : 0] probe_out30
//  .probe_out31(probe_out31),  // output wire [13 : 0] probe_out31
//  .probe_out32(vio_valid),  // output wire [0 : 0] probe_out32
//  .probe_out33(reload)  // output wire [0 : 0] probe_out32
//);


endmodule
