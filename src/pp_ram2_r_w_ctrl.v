
`timescale 1ns/1ps

module pp_ram2_r_w_ctrl #(
parameter ADDR_WIDTH = 7    ,
parameter DATA_WIDTH = 32   ,
parameter NUM_WORDS = 68   ,
parameter PPRAM_DEPTH = 2   ,
parameter WRITE_BIT_ENABLE = 0
  )(
  clk_i               ,
  resetz_i            ,
  pp_ram_full_o       ,
  pp_ram_wr_done_i    ,
  pp_ram_empty_o      ,
  pp_ram_rd_done_i    ,
  waddr_i             ,
  wr_i                ,
  wdata_i             ,
  raddr_i             ,
  rd_i                ,
  rdata_o             ,
  mem_waddr_o         ,
  mem_wr_n_o          , 
  mem_wdata_o         ,
  mem_raddr_o         ,
  mem_rd_n_o          ,
  mem_rdata_i
);

function integer clog2;
  // Value to calculate clog2 on
  input integer value;
begin
  value = value - 1;
  for (clog2=0; value>0; clog2=clog2+1) begin
      value = value >> 1;
  end
end
endfunction

localparam MEM_INDEX_WIDTH = clog2(PPRAM_DEPTH);
localparam MEM_ADDR_WIDTH  = MEM_INDEX_WIDTH + ADDR_WIDTH ;
localparam WR_WIDTH = (WRITE_BIT_ENABLE == 0) ? 1'b1 : DATA_WIDTH ;

input                                         clk_i               ;
input                                         resetz_i            ;

output                                        pp_ram_full_o       ;
input                                         pp_ram_wr_done_i    ;
output                                        pp_ram_empty_o      ;
input                                         pp_ram_rd_done_i    ;

input      [ADDR_WIDTH -1      :  0   ]       waddr_i             ;
input      [WR_WIDTH - 1       :  0   ]       wr_i                ;
input      [DATA_WIDTH -1      :  0   ]       wdata_i             ;
input      [ADDR_WIDTH -1      :  0   ]       raddr_i             ;
input                                         rd_i                ;
output     [DATA_WIDTH -1      :  0   ]       rdata_o             ;

output     [MEM_ADDR_WIDTH - 1 :  0   ]       mem_waddr_o         ;
output     [WR_WIDTH -1        :  0   ]       mem_wr_n_o          ; 
output     [DATA_WIDTH -1      :  0   ]       mem_wdata_o         ;
output     [MEM_ADDR_WIDTH - 1 :  0   ]       mem_raddr_o         ;
output                                        mem_rd_n_o          ;
input      [DATA_WIDTH - 1     :  0   ]       mem_rdata_i         ;

reg [   (MEM_INDEX_WIDTH - 1 ) : 0  ]   rdPtr ;
reg                                     rdWrap;
reg [   (MEM_INDEX_WIDTH - 1 ) : 0  ]   wrPtr ;
reg                                     wrWrap;

always@(posedge clk_i or negedge resetz_i) begin
    if(!resetz_i) begin
        wrPtr   <= {(MEM_INDEX_WIDTH){1'b0}};
        wrWrap  <= 1'b0 ; 
    end
    else begin
        if(pp_ram_wr_done_i && (!pp_ram_full_o)) begin
            wrPtr <= wrPtr + 1'b1 ;
            if(wrPtr >= (PPRAM_DEPTH - 1)) begin
                wrPtr <= {(MEM_INDEX_WIDTH){1'b0}};
                wrWrap <= ~wrWrap ;
            end 
        end
    end
end

always@(posedge clk_i or negedge resetz_i) begin
    if(!resetz_i) begin
        rdPtr   <= {(MEM_INDEX_WIDTH){1'b0}} ;
        rdWrap  <= 1'b0 ; 
    end
    else begin
        if(pp_ram_rd_done_i && (!pp_ram_empty_o)) begin
            rdPtr <= rdPtr + 1'b1 ;
            if(rdPtr >= (PPRAM_DEPTH - 1)) begin
                rdPtr <= {(MEM_INDEX_WIDTH){1'b0}};
                rdWrap <= ~rdWrap ;
            end 
        end
    end
end

assign pp_ram_empty_o = (rdPtr == wrPtr)&&(wrWrap==rdWrap);
assign pp_ram_full_o = (rdPtr == wrPtr)&&(wrWrap!=rdWrap);


assign mem_waddr_o = (wrPtr*NUM_WORDS) + waddr_i;

assign mem_wr_n_o  = ~wr_i | {WR_WIDTH{pp_ram_full_o}}  ;

assign mem_wdata_o = wdata_i                ;

assign mem_raddr_o = (rdPtr*NUM_WORDS) + raddr_i;
assign mem_rd_n_o  = ~rd_i | pp_ram_empty_o ;
assign rdata_o   = mem_rdata_i              ;


endmodule
