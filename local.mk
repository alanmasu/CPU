# Rules of this product, read at the end of the template's Makefile (see the
# README of the template, "Rules of the product: local.mk").

# The testbenches include the RISC-V test programs as .svh files, generated
# into out/riscv/test/sim/ by the build of riscv/tests: make sim builds them
# first. make project and make sync need them too: if the headers are missing
# when the project is created, Vivado cannot parse test_CPU_wh_AXI.sv,
# disables it and picks another top for CPU_sim, without an error.
sim project sync: riscv-tests

riscv-tests:
	$(MAKE) -C riscv/tests sim

.PHONY: riscv-tests
