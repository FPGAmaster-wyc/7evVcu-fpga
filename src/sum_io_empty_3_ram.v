`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/08 20:43:25
// Design Name: 
// Module Name: sum_io_empty_3_ram
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
module sum_io_empty_3_ram(addr0, ce0, q0, addr1, ce1, d1, we1,  clk ,en1,choice0);

parameter DWIDTH = 800;
parameter AWIDTH = 13;
parameter MEM_SIZE = 1000;
parameter COL_WIDTH = 8;
parameter NUM_COL = (DWIDTH/COL_WIDTH);

input[AWIDTH-1:0] addr0;
input ce0;
output reg[DWIDTH-1:0] q0;
input[AWIDTH-1:0] addr1;
input ce1;
input[DWIDTH-1:0] d1;
input [NUM_COL-1:0] we1;
input clk;
output reg en1;
input choice0;
////(* ram_style = "hls_ultra", cascade_height = 1 *)reg [DWIDTH-1:0] ram[0:MEM_SIZE-1];
(* ram_style = "block", cascade_height = 1 *)reg [DWIDTH-1:0] ram[0:MEM_SIZE-1];
//(* ram_style = "distributed", cascade_height = 1 *)reg [DWIDTH-1:0] ram[MEM_SIZE-1:0];
//(* ram_style = "distributed", cascade_height = 1 *)reg [DWIDTH-1:0] ram[0:MEM_SIZE-1];
genvar i;

always @(posedge clk) begin
    if (ce0) begin
        q0 <= ram[addr0-(5000-MEM_SIZE)];
end
end

always @(posedge clk) begin
    en1<=choice0;
end
//always @(posedge clk) begin
//    if (ce0) begin
//        en1<=1'b1;
//    end
//    else
//        en1<=1'b0;
//end


generate
    for (i=0;i<NUM_COL;i=i+1) begin
        always @(posedge clk) begin
            if (ce1) begin
                if (we1[i])
                    ram[addr1-(5000-MEM_SIZE)][i*COL_WIDTH +: COL_WIDTH] <= d1[i*COL_WIDTH +: COL_WIDTH]; 
            end
        end
    end
endgenerate


endmodule

`timescale 1 ns / 1 ps
module sum_io_empty_3(
    reset,
    clk,
    address0,
    ce0,
    q0,
    address1,
    ce1,
    we1,
    d1);

parameter DataWidth = 32'd400;
parameter AddressRange = 32'd1000;
parameter AddressWidth = 32'd13;
input reset;
input clk;
input[AddressWidth - 1:0] address0;
input ce0;
output[DataWidth - 1:0] q0;
input[AddressWidth - 1:0] address1;
input ce1;
input[DataWidth/8 - 1:0] we1;
input[DataWidth - 1:0] d1;



sum_io_empty_3_ram sum_io_empty_3_ram_U(
    .clk( clk ),
    .addr0( address0 ),
    .ce0( ce0 ),
    .q0( q0 ),
    .addr1( address1 ),
    .ce1( ce1 ),
    .we1( we1 ),
    .d1( d1 ));

//endmodule

endmodule
