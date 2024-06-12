/*
 *  synchronous fifo, note only FIFO_DEPTH = pow of 2
 *  is valid
 *
 *  xwen 20171225
 *
 *  xwen 20180728
 *
 *    a) added near_full_o port (asserted when there's one vacancy left)
 *    b) removed comparing logic since fifo pointers naturally fall off
 *
 *  xwen 20180920
 *    
 *    put fifoMem and wrPtr logic in two blocks (their reset behavior differs)
 */

module syncFifo1 # (
  parameter integer FIFO_WIDTH = 32,
  parameter integer FIFO_DEPTH = 16
) (

  output wire full_o,
  output wire near_full_o,
  output wire empty_o,
  output wire [(FIFO_WIDTH-1):0] dout_o,

  input wire clk_i,
  input wire resetz_i,
  input wire rd_i,
  input wire wr_i,
  input wire [(FIFO_WIDTH-1):0] din_i
);

function integer clog2;
  // Value to calculate clog2 on
  input integer value;
begin
  for (clog2=0; value>0; clog2=clog2+1) begin
    value = value >> 1;
  end
end
endfunction

localparam PTR_WIDTH = clog2(FIFO_DEPTH);   // 2^PTR_WIDTH >= 2*FIFO_DEPTH

reg [(FIFO_WIDTH-1):0] fifoMem[0:FIFO_DEPTH-1];
reg [(PTR_WIDTH-1):0] rdPtr;
reg [(PTR_WIDTH-1):0] wrPtr;


/* write cycle */
always @(posedge clk_i or negedge resetz_i) begin
  if (!resetz_i)
    begin
      wrPtr <= {(PTR_WIDTH){1'b0}};
    end
  else
    begin
      if (wr_i&&(!full_o))   // do not write a full fifo
        begin
          wrPtr <= wrPtr + 1'b1;
        end
      // synthesis translate_off
      if (wr_i&&full_o) begin
        $write("fifo overflow at %t, stop.\n", $time);
        $stop;
      end
      // synthesis translate_on
    end
end

always @(posedge clk_i) begin
      if (wr_i&&(!full_o))   // do not write a full fifo
      begin
          fifoMem[wrPtr[PTR_WIDTH-2:0]] <= din_i;
      end
end

/* read cycle */
always @(posedge clk_i or negedge resetz_i) begin
  if (!resetz_i)
    begin
      rdPtr <= {(PTR_WIDTH){1'b0}};
    end
  else
    begin
      if (rd_i&&(!empty_o))   // do not advance read pointer for empty fifo
        begin
          rdPtr <= rdPtr + 1'b1;
        end
      // synthesis translate_off
      if (rd_i&&empty_o) begin
        $write("fifo underflow at %t, stop.\n", $time);
        $stop;
      end
      // synthesis translate_on
   end
end

assign dout_o = fifoMem[rdPtr[PTR_WIDTH-2:0]];
assign empty_o = (rdPtr == wrPtr);
assign full_o = (wrPtr[PTR_WIDTH-1]!=rdPtr[PTR_WIDTH-1])
                  &&(wrPtr[PTR_WIDTH-2:0]==rdPtr[PTR_WIDTH-2:0]);
// below expression holds true for both
// (wrPtr > rdPtr) and wrPtr < rdPtr
assign near_full_o = ((wrPtr-rdPtr)=={(PTR_WIDTH-1){1'b1}});

endmodule
