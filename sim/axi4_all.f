// =====================================================================
// axi4_all.f — Unified compile file for BOTH AXI tests and FIFO tests
//
// Compile:   vlog -sv +acc +cover -f ../axi4_all.f
// Run FIFO:  vsim work.top       +UVM_TESTNAME=<fifo_test>
// Run AXI:   vsim work.hdl_top work.hvl_top +UVM_TESTNAME=<axi_test>
// =====================================================================

// =====================================================================
// +incdir paths
// =====================================================================
+incdir+../../src/globals/
+incdir+../../src/rtl/

+incdir+../../src/verif/vip/axi_slave_vip/
+incdir+../../src/verif/bfm/write_fifo/
+incdir+../../src/verif/bfm/write_fifo/fifo_interface
+incdir+../../src/verif/tb/env/
+incdir+../../src/verif/tb/test/
+incdir+../../src/verif/tb

+incdir+../../src/hdl_top/
+incdir+../../src/hdl_top/axi4_interface/
+incdir+../../src/hdl_top/master_agent_bfm/
+incdir+../../src/hdl_top/slave_agent_bfm/

+incdir+../../src/hvl_top/
+incdir+../../src/hvl_top/env/
+incdir+../../src/hvl_top/env/virtual_sequencer/
+incdir+../../src/hvl_top/master/
+incdir+../../src/hvl_top/slave/
+incdir+../../src/hvl_top/test/
+incdir+../../src/hvl_top/testlists/
+incdir+../../src/hvl_top/test/sequences/
+incdir+../../src/hvl_top/test/sequences/master_sequences/
+incdir+../../src/hvl_top/test/sequences/slave_sequences/
+incdir+../../src/hvl_top/test/virtual_sequences/

// =====================================================================
// RTL
// =====================================================================
../../src/rtl/AXI_MASTER_WRITE_CONTROL.v
../../src/rtl/AXI_MASTER_READ_CONTROL.v
../../src/rtl/sync_fifo.v
../../src/rtl/design_fifo.v
../../src/rtl/decoder.v
../../src/rtl/AXI_Master.v
../../src/rtl/Top_Module_AXI4.v
../../src/rtl/write_response_handler.v

// =====================================================================
// Step 1: Globals (no dependencies)
// =====================================================================
../../src/globals/axi4_globals_pkg.sv

// =====================================================================
// Step 2: Interfaces (no package dependencies)
// =====================================================================
../../src/hdl_top/axi4_interface/axi4_if.sv
../../src/verif/bfm/write_fifo/fifo_interface/fifo_intf.sv

// =====================================================================
// Step 3: FIFO BFM package (depends on globals only)
// Must come before axi4_slave_pkg (VIP version imports write_fifo_pkg)
// =====================================================================
../../src/verif/bfm/write_fifo/write_fifo_pkg.sv

// =====================================================================
// Step 4: HVL packages that do NOT depend on BFM modules
//   axi4_master_pkg — needed by master BFM modules
//   axi4_slave_pkg  — needed by slave BFM modules
// Only ONE definition of axi4_slave_pkg compiled (VIP version)
// =====================================================================
../../src/hvl_top/master/axi4_master_pkg.sv
../../src/verif/vip/axi_slave_vip/axi_slave_pkg.sv

// =====================================================================
// Step 5: HDL BFM modules
// These import axi4_master_pkg / axi4_slave_pkg so must come AFTER step 4
// =====================================================================
../../src/hdl_top/master_agent_bfm/axi4_master_driver_bfm.sv
../../src/hdl_top/master_agent_bfm/axi4_master_monitor_bfm.sv
../../src/hdl_top/master_agent_bfm/axi4_master_agent_bfm.sv
../../src/hdl_top/slave_agent_bfm/axi4_slave_driver_bfm.sv
../../src/hdl_top/slave_agent_bfm/axi4_slave_monitor_bfm.sv
../../src/hdl_top/slave_agent_bfm/axi4_slave_agent_bfm.sv

// =====================================================================
// Step 6: Assertions (depend on BFM modules being defined)
// =====================================================================
../../src/hdl_top/master_assertions.sv
../../src/hdl_top/slave_assertions.sv
../../src/hdl_top/tb_slave_assertions.sv

// =====================================================================
// Step 7: Sequence packages (depend on axi4_slave_pkg/master_pkg)
// =====================================================================
../../src/hvl_top/test/sequences/master_sequences/axi4_master_seq_pkg.sv
../../src/hvl_top/test/sequences/slave_sequences/axi4_slave_seq_pkg.sv

// =====================================================================
// Step 8: AXI Env + Virtual sequences + AXI Test package
// =====================================================================
../../src/hvl_top/env/axi4_env_pkg.sv
../../src/hvl_top/test/virtual_sequences/axi4_virtual_seq_pkg.sv
../../src/hvl_top/test/axi4_test_pkg.sv

// =====================================================================
// Step 9: FIFO Testbench env + test packages
// =====================================================================
../../src/verif/tb/env/env_package.sv
../../src/verif/tb/test/test_pkg.sv

// =====================================================================
// Step 10: Top modules
// hdl_top + hvl_top for AXI tests
// top for FIFO tests
// =====================================================================
../../src/hdl_top/hdl_top.sv
../../src/hvl_top/hvl_top.sv
../../src/verif/tb/top.sv
