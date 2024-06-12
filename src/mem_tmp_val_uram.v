`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2023 05:48:09 AM
// Design Name: 
// Module Name: mem_tmp_val
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


module mem_tmp_val_uram#(
parameter SPIKE_LEN = 50,
parameter MEM_WIDTH = 800,
parameter MAX_LOOP  = 5000,
parameter FRAME     = 8
)(
input         clk_200M,
input         rst_200M,
//output          pull_data,
input [SPIKE_LEN-1:0]  spike_data_i, //spike data
input                  spike_valid,
input [12:0]           spike_addr,
//data
output pull_data,
output counter_line_get,
input  [12:0]addr_q, // i read addr
input  ce0,   // i read enable
output [399:0]q0,    // o query date
output save_done,
input write_enable
);
reg [7:0 ]    counter_frame;
reg           pipe_line_gen;
// counter for line(total 5000) //9bit data check TODO
// counter for frame 
reg [12:0]   counter_line_set;
reg [12:0]   counter_line_calc_nop;
reg [12:0]   counter_line_nop_wait_getdata;
wire [12:0]   counter_line_get;
assign counter_line_get = spike_addr;
reg [SPIKE_LEN-1:0]  spike_data;
reg [SPIKE_LEN-1:0]  spike_data_wait;
reg [SPIKE_LEN-1:0]  spike_data_wait_2;
wire data_proc_get;
assign data_proc_get = spike_valid;
reg data_proc_nop;
reg data_proc_set;
reg data_save_set;
reg data_save_set_nop_1;
reg data_save_set_nop_2;
always @(posedge clk_200M ) begin
  if(!rst_200M)begin
    counter_line_set <= 'd0;
    counter_line_calc_nop <='d0;
    counter_line_nop_wait_getdata<='d0;
    spike_data_wait<='d0;
    spike_data_wait_2<='d0;
    // counter_line_get <= 'd0;
    pipe_line_gen <= 'd0;
    counter_frame <= 'd0;
    // data_proc_get<='d0;
    data_proc_nop<='d0;
    data_proc_set<='d0;
    data_save_set<='d0;
    spike_data   <='d0;
    data_save_set_nop_1 <= 'd0;
    data_save_set_nop_2 <= 'd0;
  end
  else if(spike_valid) begin
    // counter_line_get <= spike_addr;
    spike_data_wait <= spike_data_i;
    spike_data_wait_2<= spike_data_wait;
    spike_data <=spike_data_wait_2;
    counter_line_nop_wait_getdata <= counter_line_get;
    counter_line_calc_nop <= counter_line_nop_wait_getdata;
    counter_line_set <= counter_line_calc_nop;

    data_proc_nop <= data_proc_get;
    data_proc_set <= data_proc_nop;
    if(spike_addr == 13'd4999) begin
      counter_frame <= counter_frame + 1'd1;
    end
    if(counter_frame > 8'd0 && counter_line_get == 13'd0)begin
      pipe_line_gen <= 1'd1;
    end
    if(counter_frame == FRAME) begin
      counter_frame <= 8'd0;
    end
    if(counter_frame == FRAME - 1 )begin
      data_save_set_nop_1 <= 1'd1;
      data_save_set_nop_2 <= data_save_set_nop_1;
      data_save_set <= data_save_set_nop_2;

    end else begin
      data_save_set_nop_1 <= 1'd0;
      data_save_set_nop_2 <= data_save_set_nop_1;
      data_save_set <= data_save_set_nop_2;
    end
  end
end
// 1r1w mem , 400 x 5k per line 400 .
//       | 0~199 tmp | 200~399 val .
//       | 0~3 4~7 ... i*4~(i+1)*4-1 ... 196~199 each 4bit is valid data.
// input spike 50 bit so each time we get and set 400 bit : 50(spike)x4(bit)x2(val/tmp).
// below is get and set logic.
wire [MEM_WIDTH-1:0]  pull_data;
reg  [MEM_WIDTH-1:0]  push_data;
reg  [MEM_WIDTH-1:0]  push_data_prepare;
always @(posedge clk_200M ) begin
  if(!rst_200M) begin
    push_data <= 'd0;
  end else begin
    if(spike_valid)begin
      push_data <= push_data_prepare;
    end
  end
end
integer i;
always @(posedge clk_200M ) begin
    if(!rst_200M) begin
    push_data_prepare <= 'd0;
  end else begin
    if(spike_valid) begin
    //
       if(!pipe_line_gen)begin // pipe line init , we can't get any date from mem. so only write.
         for (i = 0;i < SPIKE_LEN; i=i+1) begin
           if(spike_data_wait[i]==1'd0)begin
             push_data_prepare[(i*8)+:8] <= 8'd2;
             push_data_prepare[(i*8+400)+:8] <= 8'd255;;//keep val not change.
           end else begin
             push_data_prepare[(i*8)+:8] <= 8'd1;
             push_data_prepare[(i*8+400)+:8] <= 8'd1; //data_save_set/search window end,save window size.
           end
         end
       end else begin
       //
        for (i = 0;i < SPIKE_LEN; i=i+1) begin
  //search window , truth table: 
  /*|spike | tmp   |        | tmp  |  spike  |  val |
  * |  1   |  1    |        |  e,f |    0    |   f  |
  * |  0   | tmp+1 |        |  <f  |    1    |  tmp |
  *                         |  >f  |    1    |   f  |
  *                         |  <e  |    0    |  --- |
  */
          if(spike_data_wait[i]==1'd0)begin
            if(pull_data[(i*8)+:8] >= 8'd254)begin
              push_data_prepare[(i*8)+:8] <= 8'd255;//after add, will full, defend overflow.
              push_data_prepare[(i*8+400)+:8] <= 8'd255; //almost full or overflow, trans tmp to val.
            end else begin
              push_data_prepare[(i*8)+:8] <= pull_data[(i*8)+:8] + 8'd1;
              push_data_prepare[(i*8+400)+:8] <= pull_data[(i*8+400)+:8];//keep val not change.
            end
          end else begin
            push_data_prepare[(i*8)+:8] <= 8'd1;
            push_data_prepare[(i*8+400)+:8] <= pull_data[(i*8)+:8]; //data_save_set/search window end,save window size.
          end
        end
      end
     end//
    
  end
end 


reg save_done;
reg frame_begin;
reg write_enable_reg;
always @(posedge clk_200M) begin
  if(!rst_200M)begin
    frame_begin <= 1'd0;
    write_enable_reg<= 1'd0;
    save_done<=1'd0;
  end else if (write_enable)begin
    if(counter_line_set != 13'd4999)begin
      
    end else begin
      if(write_enable_reg == 1'd1) begin
        save_done <= 1'd1;
        write_enable_reg <= 1'd0;
      end else begin
        write_enable_reg <= 1'd1;
        save_done<= 1'd0;
      end
    end
  end else begin
    write_enable_reg <= 1'd0;
    save_done<=1'd0;
  end
end

  //recon data / per FRAME frame.
  


wire [799:0]pull_data_4000;
wire [799:0]pull_data_1000;
wire en0;
wire en1;
//assign counter_line_get = spike_addr;
wire choice0;
wire choice1;
assign choice0=(counter_line_get<4000)?1'b1:1'b0;
assign choice1=(counter_line_set<4000)?1'b1:1'b0;

sum_io_empty_12_ram recon0(
  .addr0(counter_line_get), // i read addr
  .ce0(data_proc_get&spike_valid&choice0),   // i read enable
  .choice0(choice0),
  .q0(pull_data_4000),    // o query date
  .addr1(counter_line_set), // i write addr
  .ce1(data_proc_set&spike_valid&choice1),   // i
  .d1(push_data),    // i write data
  .we1({100{data_proc_set&spike_valid}}),   // i write enable
//  .q1(),    // o
  .en0(en0),
  .clk(clk_200M)   // i CLK  500x500x4x4bitx3 = 12Mb bram 16 13 3 400x 5000
  );
  
sum_io_empty_3_ram recon1(
  .addr0(counter_line_get), // i read addr
  .ce0(data_proc_get&spike_valid&(~choice0)),   // i read enable
  .choice0(~choice0),
  .q0(pull_data_1000),    // o query date
  .addr1(counter_line_set), // i write addr
  .ce1(data_proc_set&spike_valid&(~choice1)),   // i
  .d1(push_data),    // i write data
  .we1({100{data_proc_set&spike_valid}}),   // i write enable
//  .q1(),    // o
  .en1(en1),
  .clk(clk_200M)   // i CLK  500x500x4x4bitx3 = 12Mb bram 16 13 3 400x 5000
  );
assign pull_data=en0?pull_data_4000:pull_data_1000;
//  assign pull_data=({800{en0}}&pull_data_4000)+({800{en1}}&pull_data_1000);
//assign pull_data=(~en1)?(choice0?pull_data_4000:pull_data_1000):pull_data_1000;
//  sum_io_empty_12_ram#(
//    .DWIDTH(400)
//    ) recon0(
//  .addr0(addr_q), // i read addr
//  .ce0(ce0&choice0),   // i read enable
//  .q0(q0_reg_0),    // o query date
//  .addr1(counter_line_set), // i write addr
//  .ce1(spike_valid&write_enable_reg&choice1),   // i
//  .d1(push_data[799:400]),    // i write data
//  .we1({50{spike_valid&write_enable_reg&choice1}}),   // i write enable
////  .q1(),    // o
//  .clk(clk_200M),   // i CLK  500x500x4x4bitx3 = 12Mb bram 16 13 3 400x 5000
//  .en0(en0)
//  );
//    sum_io_empty_3_ram recon2(
//  .addr0(addr_q), // i read addr
//  .ce0(ce0&(~choice0)),   // i read enable
//  .q0(q0_reg_1),    // o query date
//  .addr1(counter_line_set), // i write addr
//  .ce1(spike_valid&write_enable_reg&(~choice1)),   // i
//  .d1(push_data[799:400]),    // i write data
//  .we1({50{spike_valid&write_enable_reg&(~choice1)}}),   // i write enable
////  .q1(),    // o
//  .clk(clk_200M),   // i CLK  500x500x4x4bitx3 = 12Mb bram 16 13 3 400x 5000
//   .en1(en1)
//  );
//  assign q0=({400{choice0}}&q0_reg_0)+({400{~choice0}}&q0_reg_1)+(q0_reg_0&q0_reg_1);//                   e  
//    assign q0=({400{en0}}&q0_reg_0)+({400{en1}}&q0_reg_1);
//  //recon data / per FRAME frame.
  sum_io_empty_ram recon2(
  .addr0(addr_q), // i read addr
  .ce0(ce0),   // i read enable
  .q0(q0),    // o query date
  .addr1(counter_line_set), // i write addr
  .ce1(spike_valid&write_enable_reg),   // i
  .d1(push_data[799:400]),    // i write data
  .we1({50{spike_valid&write_enable_reg}}),   // i write enable
//  .q1(),    // o
  .clk(clk_200M)   // i CLK  500x500x4x4bitx3 = 12Mb bram 16 13 3 400x 5000
  );
endmodule