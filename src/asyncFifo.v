//
//
//
//
// async fifo wrapper
//
//
// -- xwen 20180131
//
`timescale 1ns/1ps

module asyncFifo #(
  parameter FIFO_WIDTH = 100,
  parameter FIFO_DEPTH = 128
) (

  input clk100M_i,
  input clk100M_resetn_i,
  input capture_en_i,
  output fifoFull_o,
  input [FIFO_WIDTH-1:0 ]fifoDin_i,

  input aclk_i,
  input aresetn_i,
  input fifoRd_i,
  output fifoEmpty_o,
  output [FIFO_WIDTH-1:0] fifoDout_o
);

function integer clog2;
input integer value;
begin
  for (clog2=0; value>0; clog2=clog2+1) begin
    value = value >> 1;
  end
end
endfunction

localparam ASIZE = clog2(FIFO_DEPTH);

wire fifoWr; 
reg [1:0] fifoWrSync;
wire [FIFO_WIDTH-1:0] fifoDin_int;

assign fifoWr = capture_en_i;
assign fifoDin_int = fifoDin_i;


fifo1 #(.DSIZE(FIFO_WIDTH), .ASIZE(ASIZE)) u_fifo1 (
  .rdata (fifoDout_o),
  .wfull (fifoFull_o),
  .rempty (fifoEmpty_o),
  .wdata (fifoDin_int),
  .winc (fifoWr),
  .wclk (clk100M_i),
  .wrst_n (clk100M_resetn_i),
  .rinc (fifoRd_i),
  .rclk (aclk_i),
  .rrst_n (aresetn_i)
);

endmodule
