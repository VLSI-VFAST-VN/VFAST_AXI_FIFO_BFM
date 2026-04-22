Steps to run simulation:

///////////////////////////////////////////////////////////////////////////////////
// To run a test, first go to the sim directory shown in below path
AXI_FIFO_BFM/sim/questasim/

// To compile setup:
  make compile

// To simulate the test:
  make simulate test=<TEST_NAME>

(or)

// To compile and simulate at a time
makeall test=<TEST_NAME>

////////////////////////////////////////////////////////////////////////////////////

Below are the paths for test cases and sequences

// Test cases path:
AXI_FIFO_BFM/src/axi_fifo_bfm/test/test/

// Sequences path:
AXI_FIFO_BFM/src/axi_fifo_bfm/test/sequence/

make compile_axi
make simulate_axi test=axi4_blocking_8b_write_read_test uvm_verbosity=UVM_MEDIUM


make compile
make simulate test=fifo_bfm_32b_wr_incr_alligned_test_awlen_0

make regression testlist_name=axi4_transfers_regression.list
make regression testlist_name=fifo_all_regression.list




