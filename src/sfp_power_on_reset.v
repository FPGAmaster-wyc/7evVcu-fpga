`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/03 13:00:12
// Design Name: 
// Module Name: sfp_power_on_reset
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


module sfp_power_on_reset #(
	parameter GTH_RESET =50,
	parameter CORE_RESET =50
)(
	input init_clk,
	input sys_rst,
	output reg pma_init,
	output reg reset_pb
    );
		
reg[31:0]reset_cnt;
	
always@(posedge init_clk)	
begin
	if(sys_rst)
		reset_cnt <=0;
	else if(reset_cnt < (GTH_RESET+CORE_RESET))	
		reset_cnt <=reset_cnt + 1'b1;
end


always@(posedge init_clk)	
begin
	pma_init <=(reset_cnt < GTH_RESET);
end
 
always@(posedge init_clk)	
begin
	reset_pb <=(reset_cnt < CORE_RESET);
end 
	
endmodule
