module ctrl_axi_lite_slave #(
    parameter ADDR_BITS=32,
    parameter DATA_BITS=32,
    parameter DATA_BYTES=DATA_BITS/8
)(
	//////////////clk and rst
    input   					s_axi_aclk,
    input   					s_axi_aresetn,
	////write addr channel	
    input[ADDR_BITS-1:0]		s_axi_awaddr,
    input   					s_axi_awvalid,
    output reg 					s_axi_awready,
	////write data channel
    input[DATA_BITS-1:0] 		s_axi_wdata,
    input[DATA_BYTES-1:0] 		s_axi_wstrb,
    input   					s_axi_wvalid,
    output reg					s_axi_wready,
	//write response channel
    output[1:0] 				s_axi_bresp,
    output reg 					s_axi_bvalid,
    input   					s_axi_bready,
	//read addr channel
    input[ADDR_BITS-1:0] 		s_axi_araddr,
    input   					s_axi_arvalid,
    output reg  				s_axi_arready,
	//read data channel
    output reg[DATA_BITS-1:0]	s_axi_rdata,
    output[1:0] 				s_axi_rresp,
    output reg 					s_axi_rvalid,
    input   					s_axi_rready,
	//////user write
    output reg[ADDR_BITS-1:0] 	wr_addr,
    output reg[DATA_BITS-1:0] 	wr_dout,
    output reg[DATA_BYTES-1:0]	wr_be,
    output  					wr_en,
	///////user rd
    output reg[ADDR_BITS-1:0]	rd_addr,
    input[DATA_BITS-1:0] 		rd_din,
	input						rd_ready,	//shu ju ready
    output  					rd_en
);

// AXI stage
//% Write Stage
//% Address acknowledge
always @(posedge s_axi_aclk)
begin
    if(!s_axi_aresetn)
		s_axi_awready <= 1'b1;
    else if(s_axi_awvalid && s_axi_awready) 
        s_axi_awready <= 1'b0; 
    else if(s_axi_bvalid && s_axi_bready) 
        s_axi_awready <= 1'b1;
end

//% Data acknowledge
always @(posedge s_axi_aclk)
begin
    if(!s_axi_aresetn)
        s_axi_wready <= 1'b1;
    else if(s_axi_wvalid && s_axi_wready) 
        s_axi_wready <= 1'b0;
    else if(s_axi_bvalid && s_axi_bready) 
        s_axi_wready <= 1'b1;
end

//% Addr write
always @(posedge s_axi_aclk)
begin
	if(!s_axi_aresetn)
		wr_addr <=0;
    else if(s_axi_awvalid && s_axi_awready) 
        wr_addr <= s_axi_awaddr;
end

//% Data write 
always @(posedge s_axi_aclk)
begin
    if(!s_axi_aresetn)
        wr_dout <=0;
    else if(s_axi_wvalid && s_axi_wready) 
        wr_dout <= s_axi_wdata;
end

//% Data mask
always @(posedge s_axi_aclk)
begin
    if(!s_axi_aresetn)
        wr_be <=0;
    else if(s_axi_wvalid && s_axi_wready) 
        wr_be <= s_axi_wstrb;
end

//% Write strobe
reg write_enable;

always @(posedge s_axi_aclk)
begin
    if(!s_axi_aresetn)
        write_enable <= 1'b0;
    else if((s_axi_awvalid&&s_axi_awready&&s_axi_wvalid&&s_axi_wready) 
        || (!s_axi_awready&&s_axi_wvalid&&s_axi_wready)
        || (!s_axi_wready&&s_axi_awvalid&&s_axi_awready)) 
        write_enable <= 1'b1;
    else if(write_enable) 
        write_enable <= 1'b0;
end

assign wr_en = write_enable;

//% Write response
always @(posedge s_axi_aclk)
begin
    if(!s_axi_aresetn)
        s_axi_bvalid <= 1'b0;
    else if(s_axi_bvalid && s_axi_bready) 
        s_axi_bvalid <= 1'b0;
    else if(write_enable) 
        s_axi_bvalid <= 1'b1; 
end

assign s_axi_bresp = 2'b00;

//% Read Stage
//% Read Address Acknowledge
always @(posedge s_axi_aclk)
begin
    if(!s_axi_aresetn)
        s_axi_arready <= 1'b1;
    else if(s_axi_arvalid && s_axi_arready)
        s_axi_arready <= 1'b0;
    else if(s_axi_rvalid && s_axi_rready)
        s_axi_arready <= 1'b1;
end

//% Read Addr
always @(posedge s_axi_aclk) 
begin
    if(!s_axi_aresetn) 
		rd_addr <= 0;
    else if(s_axi_arready && s_axi_arvalid) 
        rd_addr <= s_axi_araddr;
end

//% Read strobe
reg read_enable;

always @(posedge s_axi_aclk) 
begin
    if(!s_axi_aresetn)
        read_enable <= 1'b0;
    else if(s_axi_arready && s_axi_arvalid)
        read_enable <= 1'b1;
    else if(read_enable) 
		read_enable <= 1'b0;
end

assign rd_en = read_enable;

//% Read Data Response
always @(posedge s_axi_aclk) 
begin
    if(!s_axi_aresetn) 
        s_axi_rvalid <= 1'b0;
    else if(rd_ready) 
        s_axi_rvalid <= 1'b1;
    else if(s_axi_rvalid && s_axi_rready) 
        s_axi_rvalid <= 1'b0;
end

always @(posedge s_axi_aclk) 
begin
    if(!s_axi_aresetn) 
        s_axi_rdata <= 0;
    else if(rd_ready) 
        s_axi_rdata <= rd_din;
end

assign s_axi_rresp = 2'b00;

endmodule
