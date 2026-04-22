`ifndef FIFO_BFM_RD_INCR_ALLIGNED_SEQUENCE_INCLUDED_
`define FIFO_BFM_RD_INCR_ALLIGNED_SEQUENCE_INCLUDED_

class fifo_bfm_rd_incr_alligned_sequence extends base_sequence;

  bit[3:0] arlenn;
  bit [31:0] addr;
  bit[1:0] arburstt;
  bit[2:0] arsizee;

  `uvm_object_utils(fifo_bfm_rd_incr_alligned_sequence)

  function new(string name="fifo_bfm_rd_incr_alligned_sequence");
    super.new(name);
  endfunction

  virtual task body();
    begin
      write_fifo_seq_item req;
      req = write_fifo_seq_item::type_id::create("req");
      repeat(1) begin
        start_item(req);
        $display("john address in sequence=%h", addr);
        $display("john arlen in sequence=%h",  arlenn);
        $display("john arburst in sequence=%h", arburstt);
        $display("john arsize in sequence=%h",  arsizee);
        assert(req.randomize() with {req.type_of_pkt==1 &&
                                     req.araddr==addr    &&
                                     req.arlen==arlenn   &&
                                     req.arburst==arburstt &&
                                     req.arsize==arsizee;});
        finish_item(req);
      end
    end
  endtask

endclass
`endif
