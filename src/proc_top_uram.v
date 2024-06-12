`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2023 10:58:21 PM
// Design Name: 
// Module Name: proc_top
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


module proc_top_uram(
// write fifo
  input clk100M_i,
  input clk100M_resetn_i,
  input capture_en_i,
  output fifoFull_o,
  input [509-1:0 ]fifoDin_i,
//  input [FIFO_WIDTH-1:0 ]fifoDin_i,
//read fifo
  input clk_200M,
  input rst_200M,
  output [799:0] pull_data,
  output [12:0]  pull_addr,
  input [12:0]addr_q, // i read addr
  input ce0,   // i read enable
  output [399:0]q0,    // o query date
  output save_done,
  input write_enable
    );
parameter FIFO_WIDTH = 509;
wire [FIFO_WIDTH-1:0 ]fifoDout;
wire fifoEmpty;
wire fifoRd;

    /*
 # in  : 100M * 500 (5   cycle) 
 # out : 200M * 50  (per cycle)
 # total : 100x500/5 = 200x50
*/
asyncFifo #(
  .FIFO_WIDTH (FIFO_WIDTH),//50 10cycle? 
  .FIFO_DEPTH (16)
) m_asyncFifo_0 (

  .clk100M_i(clk100M_i),
  .clk100M_resetn_i(clk100M_resetn_i),
  .capture_en_i(capture_en_i),
  .fifoFull_o(fifoFull_o),
  .fifoDin_i(fifoDin_i),

  .aclk_i(clk_200M),
  .aresetn_i(rst_200M),
  .fifoRd_i(fifoRd),
  .fifoEmpty_o(fifoEmpty),
  .fifoDout_o (fifoDout)
);   
/*          __________________proc_top________________________
*           |    m_asyncFifo_0    m_p2s           m_mem      |
*_________  |    _________       _________       _________   |
*|       |  |    |   F   |       |  par  |       |       |   |
*|       |  |    |   I   |       |   to  |       |   M   |   |
*|pixel  |--|--->|   F   |------>|  ser  |------>|   E   |   |
*|reorder|  |    |   O   |       |       |       |   M   |   |
*|_______|  |    |_______|       |_______|       |_______|   |
*           |________________________________________________|
*************/

(* MARK_DEBUG="true" *)wire [49:0] spike_data;
(* MARK_DEBUG="true" *)wire [12:0] spike_addr;
(* MARK_DEBUG="true" *)wire        spike_valid;

// ila_spike ila_spike (
//	 .clk   (clk_200M     ), // input wire clk
//	 .probe0(spike_data   ), // input wire [49:0]  probe0  
//	 .probe1(spike_addr   ), // input wire [12:0]  probe1 
//     .probe2(spike_valid  )
// );


par_2_ser#(
.PAR_WIDTH   (509),
.SER_WIDTH   (50),
.CYCLE_TIMES (10)
) m_p2s(
.aclk_i(clk_200M),
.aresetn_i(rst_200M),
.fifoRd_o(fifoRd),
.fifoEmpty_i(fifoEmpty),
.fifoDout_i(fifoDout),
.SER_Dout_o(spike_data),
.SER_valid_o(spike_valid),
.SER_mem_addr(spike_addr)
); 


mem_tmp_val_uram#(
.SPIKE_LEN(50),
.MEM_WIDTH(800),
.MAX_LOOP (5000),
.FRAME    (8)
) m_mem(
.clk_200M(clk_200M),
.rst_200M(rst_200M),
.spike_data_i(spike_data),  //spike data
.spike_valid(spike_valid),
.spike_addr(spike_addr),
/*          __________________proc_top________________________
*           |    m_asyncFifo_0    m_p2s           m_mem      |
*_________  |    _________       _________       _________   |
*|       |  |    |   F   |       |  par  |       |       |   |
*|       |  |    |   I   |       |   to  |       |   M   |   |
*|pixel  |--|--->|   F   |------>|  ser  |------>|   E   |   |
*|reorder|  |    |   O   |       |       |       |   M   |   |
*|_______|  |    |_______|       |_______|       |_______|   |
*           |________________________________________________|
*************/
.pull_data(pull_data),
.counter_line_get(pull_addr),
.addr_q(addr_q), // i read addr
.ce0(ce0),   // i read enable
.q0(q0),    // o query date
.save_done(save_done),
.write_enable(write_enable)
);
endmodule
