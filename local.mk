# Rules of this product, read at the end of the template's Makefile (see the
# README of the template, "Rules of the product: local.mk").

# The testbenches include the RISC-V test programs as .svh files, generated
# into out/riscv/test/sim/ by the build of riscv/tests: make sim builds them
# first. make project and make sync need them too: if the headers are missing
# when the project is created, Vivado cannot parse test_CPU_wh_AXI.sv,
# disables it and picks another top for CPU_sim, without an error.
sim project sync: riscv_tests

riscv_tests:
	$(MAKE) -C riscv/tests sim

# TestApp, the test suite of sw/vitis, includes the board build of the same
# programs as .h files, generated into out/riscv/test/vitis/ (an include
# directory of TestApp): the Vitis targets build them first.
vitis vitis_build: riscv_tests_board

riscv_tests_board:
	$(MAKE) -C riscv/tests board

.PHONY: riscv_tests riscv_tests_board
