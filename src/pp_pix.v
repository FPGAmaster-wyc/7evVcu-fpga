//------------------------------------------------------------------------------
// Boyahualu Tech, all rights reserved.
//------------------------------------------------------------------------------

`timescale 1ns/1ps

module pp_pix #(
    parameter VA = 500
) (
  input clk_i,
  input resetz_i,
  input pp_ram_wr_done_i,
  input pp_ram_rd_done_i,
  output pp_ram_full_o,
  output pp_ram_empty_o,
  input [8:0] pix_raddr_i,
  input pix_rd_i,
  input [8:0] pix_waddr_i,
  input [508:0] pix_wdata_i,
  input pix_wr_i,
  output [508:0] pix_rdata_o
);

wire [10:0] pix_mem_raddr;
wire pix_mem_rd_n;
wire [508:0] pix_mem_rdata;
wire [10:0] pix_mem_waddr;
wire [508:0] pix_mem_wdata;
wire pix_mem_wr_n;
wire pix_pp_ram0_empty;
wire pix_pp_ram0_full;

assign pp_ram_full_o = pix_pp_ram0_full;

assign pp_ram_empty_o = pix_pp_ram0_empty;

//------------------------------------------------------------------------------
// pingpong ram type 0 for pix, pingpong depth 4
//------------------------------------------------------------------------------

pp_ram2_r_w_ctrl #(
  .ADDR_WIDTH (9),
  .DATA_WIDTH (509),
  .NUM_WORDS (VA),
  .PPRAM_DEPTH (4),
  .WRITE_BIT_ENABLE (0)
) u_pix_pp_ram0_0 (
  .clk_i (clk_i),
  .resetz_i (resetz_i),
  .pp_ram_full_o (pix_pp_ram0_full),
  .pp_ram_wr_done_i (pp_ram_wr_done_i),
  .pp_ram_empty_o (pix_pp_ram0_empty),
  .pp_ram_rd_done_i (pp_ram_rd_done_i),
  .waddr_i (pix_waddr_i),
  .wr_i (pix_wr_i),
  .wdata_i (pix_wdata_i),
  .raddr_i (pix_raddr_i),
  .rd_i (pix_rd_i),
  .rdata_o (pix_rdata_o),
  .mem_waddr_o (pix_mem_waddr),
  .mem_wr_n_o (pix_mem_wr_n),
  .mem_wdata_o (pix_mem_wdata),
  .mem_raddr_o (pix_mem_raddr),
  .mem_rd_n_o (pix_mem_rd_n),
  .mem_rdata_i (pix_mem_rdata)
);

mem_1r1w_2000x509 u_mem_pix (
  .wclk (clk_i),
  .waddr (pix_mem_waddr),
  .wen (pix_mem_wr_n),
  .rclk (clk_i),
  .raddr (pix_mem_raddr),
  .ren (pix_mem_rd_n),
  .din (pix_mem_wdata),
  .dout (pix_mem_rdata)
);

endmodule
