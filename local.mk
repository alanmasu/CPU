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
# programs as .h files, generated into out/riscv/test/vitis/, and the blink
# example from out/riscv/examples/vitis/ (both include directories of
# TestApp): the Vitis targets build them first.
vitis vitis_build: riscv_tests_board riscv_examples_board

riscv_tests_board:
	$(MAKE) -C riscv/tests board

riscv_examples_board:
	$(MAKE) -C riscv/examples

# LoaderApp includes out/riscv/loader/program.h, which make writes when run in
# the folder of a RISC-V program. After a clone there is none, and the build
# of LoaderApp would stop: example_GPIO_Blink is exported as the default
# program. The rule has no prerequisites, so it runs only when the header is
# missing.
vitis vitis_build: out/riscv/loader/program.h

out/riscv/loader/program.h:
	$(MAKE) -C riscv/examples/example_GPIO_Blink

.PHONY: riscv_tests riscv_tests_board riscv_examples_board
