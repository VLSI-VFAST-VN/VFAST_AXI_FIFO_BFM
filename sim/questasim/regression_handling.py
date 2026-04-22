#-----------------------------------------------------------------------
#Description : Opening a file and searching for a pattern in read mode
#Function Used : search()
#-----------------------------------------------------------------------
import re
import sys
import os
import time
from datetime import datetime

## Variables
reg_list_array = []
debug = 0

# Get regression list as input
regression_list = str(sys.argv[1])
if debug:
  print(regression_list)

# Reading the file
path = "../../src/hvl_top/testlists/" + regression_list
if debug:
  print(path)

with open(path,'r') as f:
  for line in f:
    match = re.search('\#', line)
    if(match):
      continue

    match = re.search(r'(\S+_test\S*)', line)
    if(match):
      reg_list_array.append(match.group(1))
      if debug:
        print(match.group(1))

# Regression result file
run_timestamp  = time.strftime("%d%m%Y-%H%M%S")
result_filename = "regression_result_" + regression_list.replace(".list","") + "_" + run_timestamp + ".txt"

pass_list = []
fail_list = []

def check_log(log_path):
  """Return (passed, uvm_errors, uvm_fatals) from a sim log."""
  uvm_errors  = 0
  uvm_fatals  = 0
  sim_errors  = 0
  if not os.path.isfile(log_path):
    return False, 0, 1   # no log = fatal
  with open(log_path, 'r') as f:
    for ln in f:
      if re.search(r'UVM_FATAL', ln):
        uvm_fatals += 1
      if re.search(r'UVM_ERROR\s+[^0]', ln):
        uvm_errors += 1
      if re.search(r'^Error', ln):
        sim_errors += 1
  passed = (uvm_fatals == 0 and uvm_errors == 0 and sim_errors == 0)
  return passed, uvm_errors, uvm_fatals

for testname in reg_list_array:
  timestr = time.strftime("%d%m%Y-%H%M%S")
  if debug:
    print("time string : ", timestr)

  test_folder = testname + "_" + timestr

  # Auto-detect test type: AXI tests start with "axi4_", FIFO tests start with "fifo_"
  if testname.startswith("axi4_"):
    make_target = "simulate_axi"
  else:
    make_target = "simulate"

  cmd = "make " + make_target + " test_folder=" + test_folder + " test=" + testname
  if debug:
    print(cmd)
  os.system(cmd)

  # Parse log to determine PASS/FAIL
  log_path = test_folder + "/" + testname + ".log"
  passed, uvm_errors, uvm_fatals = check_log(log_path)
  if passed:
    pass_list.append(testname)
  else:
    fail_list.append((testname, uvm_errors, uvm_fatals))

# Write regression result file
total   = len(reg_list_array)
n_pass  = len(pass_list)
n_fail  = len(fail_list)

with open(result_filename, 'w') as rf:
  rf.write("=" * 70 + "\n")
  rf.write("  REGRESSION RESULT REPORT\n")
  rf.write("  List      : {}\n".format(regression_list))
  rf.write("  Timestamp : {}\n".format(run_timestamp))
  rf.write("=" * 70 + "\n\n")
  rf.write("  Total  : {}\n".format(total))
  rf.write("  PASSED : {}\n".format(n_pass))
  rf.write("  FAILED : {}\n\n".format(n_fail))

  rf.write("-" * 70 + "\n")
  rf.write("  PASSED TESTS ({}/{})\n".format(n_pass, total))
  rf.write("-" * 70 + "\n")
  for t in pass_list:
    rf.write("  [PASS]  {}\n".format(t))

  rf.write("\n")
  rf.write("-" * 70 + "\n")
  rf.write("  FAILED TESTS ({}/{})\n".format(n_fail, total))
  rf.write("-" * 70 + "\n")
  for t, errs, fatals in fail_list:
    rf.write("  [FAIL]  {}  (UVM_ERROR={}, UVM_FATAL={})\n".format(t, errs, fatals))

  rf.write("\n" + "=" * 70 + "\n")

# Print summary to terminal
print("")
print("=" * 70)
print("  REGRESSION SUMMARY")
print("  Total : {}  |  PASSED : {}  |  FAILED : {}".format(total, n_pass, n_fail))
print("  Result file: {}".format(result_filename))
print("=" * 70)
print("")
