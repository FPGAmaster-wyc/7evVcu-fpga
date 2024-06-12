module mem_1r1w_2000x509 (

  input wclk,
  input [10:0] waddr,
  input wen,
  input rclk,
  input [10:0] raddr,
  input ren,
  input [508:0] din,
  output [508:0] dout
);

  reg [508:0] mem [0:1999];
  reg [508:0] dout_int;

  always @(posedge wclk) begin
    if (!wen) begin
      mem[waddr] <= din;
    end
  end

  always @(posedge rclk) begin
    if (!ren) begin
      dout_int <= mem[raddr];
    end
  end

  assign dout = dout_int;


  //synopsys translate_off
  `ifdef RAM_CONFLICT_DETECT
  always @(posedge wclk or posedge rclk) begin
    if (ren===1'b0 && wen===1'b0 && (waddr===raddr)) begin
      $display("%m ERROR:RAM R/W confilict at %h\n",waddr);                                                                                                                                             
      $stop;
    end 
  end
  `endif
  //synopsys translate_on

endmodule
