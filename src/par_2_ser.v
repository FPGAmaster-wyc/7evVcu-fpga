module par_2_ser#(
parameter PAR_WIDTH   = 509,
parameter SER_WIDTH   = 50,
parameter CYCLE_TIMES = 10
)(
  input     aclk_i,
  input     aresetn_i,
  output    fifoRd_o,
  input     fifoEmpty_i,
  input     [PAR_WIDTH-1:0 ]fifoDout_i,
  output    wire [SER_WIDTH-1:0] SER_Dout_o,
  output    reg SER_valid_o,
  output    reg [12:0]  SER_mem_addr
  /*4 5 6 7 8 9 10 11 12 line_addr 0 1 2 3 loop addr*/
);
reg [SER_WIDTH-1:0] data_reverse;
reg [3:0]           loop;
reg [PAR_WIDTH-1:0] cache_PAR;
reg [12:0]          addr_cache;
assign fifoRd_o = !fifoEmpty_i;
always @(posedge aclk_i or negedge aresetn_i) begin
    if(!aresetn_i)begin
        cache_PAR <= 'd0;
        data_reverse  <= 'd0;
        loop <= 'd0;
    end else begin
        if(fifoRd_o|(loop>4'd0)) begin
            SER_valid_o <= 1'd1;
            loop <= loop + 4'd1;
            case (loop)
                4'd0:
                begin 
                    data_reverse  <= fifoDout_i[SER_WIDTH*9+:SER_WIDTH]; 
                    cache_PAR <= fifoDout_i;
                end
                4'd1:data_reverse  <= cache_PAR[SER_WIDTH*8+:SER_WIDTH];
                4'd2:data_reverse  <= cache_PAR[SER_WIDTH*7+:SER_WIDTH];
                4'd3:data_reverse  <= cache_PAR[SER_WIDTH*6+:SER_WIDTH];
                4'd4:data_reverse  <= cache_PAR[SER_WIDTH*5+:SER_WIDTH];
                4'd5:data_reverse  <= cache_PAR[SER_WIDTH*4+:SER_WIDTH];
                4'd6:data_reverse  <= cache_PAR[SER_WIDTH*3+:SER_WIDTH];
                4'd7:data_reverse  <= cache_PAR[SER_WIDTH*2+:SER_WIDTH];
                4'd8:data_reverse  <= cache_PAR[SER_WIDTH*1+:SER_WIDTH];
                4'd9:
                begin 
                    data_reverse  <= cache_PAR[SER_WIDTH*0+:SER_WIDTH];
                    loop <= 4'd0;
                end
                default: data_reverse  <= 50'd666;
            endcase
        end else begin
            SER_valid_o <= 1'd0;
        end 
    end
end

genvar i;
for ( i = 0; i<50; i=i+1) begin
    assign SER_Dout_o[i] = data_reverse[49-i];
end

always @(posedge aclk_i or negedge aresetn_i) begin
    if(!aresetn_i)begin
        addr_cache <= 'd0;
        SER_mem_addr  <= 'd0;
    end else begin
        if(fifoRd_o|(loop>4'd0))begin
            if(loop == 4'd0)begin
                addr_cache <= {fifoDout_i[508:500],3'd0}+{2'd0,fifoDout_i[508:500],1'd0};
                SER_mem_addr <= {fifoDout_i[508:500],3'd0}+{2'd0,fifoDout_i[508:500],1'd0};
            end else begin
                SER_mem_addr <= addr_cache + loop;
            end
        end
    end
end

endmodule