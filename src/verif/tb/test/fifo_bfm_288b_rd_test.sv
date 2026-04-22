`ifndef FIFO_BFM_288B_RD_TEST_INCLUDED_
`define FIFO_BFM_288B_RD_TEST_INCLUDED_

class fifo_bfm_288b_rd_test extends fifo_base_test;
  `uvm_component_utils(fifo_bfm_288b_rd_test)
  bit[3:0] arlenn = 8;
  bit [31:0] addr;
  bit[1:0] arburstt = 1;
  bit[2:0] arsizee = 2;

  fifo_bfm_rd_incr_alligned_sequence fifo_bfm_rd_incr_alligned_sequence_h;
  axi4_slave_nbk_read_32b_transfer_seq axi4_slave_nbk_read_32b_transfer_seq_h;

  function new(string name = "fifo_bfm_288b_rd_test",uvm_component parent = null);
    super.new(name, parent);
    void'(std::randomize(addr) with {addr%((2**arsizee)*8)==0;});
    $display("address in sequence=%h",addr);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    axi4_slave_nbk_read_32b_transfer_seq_h = axi4_slave_nbk_read_32b_transfer_seq::type_id::create("axi4_slave_nbk_read_32b_transfer_seq_h");
    fifo_bfm_rd_incr_alligned_sequence_h = fifo_bfm_rd_incr_alligned_sequence::type_id::create("fifo_bfm_rd_incr_alligned_sequence_h");
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(),$sformatf("fifo_bfm_288b_rd_test"),UVM_LOW)
    phase.raise_objection(this);
    fifo_bfm_rd_incr_alligned_sequence_h.arlenn   = arlenn;
    fifo_bfm_rd_incr_alligned_sequence_h.addr     = addr;
    fifo_bfm_rd_incr_alligned_sequence_h.arburstt = arburstt;
    fifo_bfm_rd_incr_alligned_sequence_h.arsizee  = arsizee;
    fork
      begin
        forever begin
          axi4_slave_nbk_read_32b_transfer_seq_h.start(env_h.axi_slave_agent_h.axi4_slave_read_seqr_h);
        end
      end
    join_none
    fifo_bfm_rd_incr_alligned_sequence_h.start(env_h.write_fifo_agent_h.write_fifo_sequencer_h);
    phase.drop_objection(this);
  endtask
endclass
`endif
