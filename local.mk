# Rules of this product, read at the end of the template's Makefile (see the
# README of the template, "Rules of the product: local.mk").

# The testbenches include the RISC-V test programs as .svh files, generated
# into out/riscv/test/sim/ by the build of riscv/tests: make sim builds them
# first.
sim: riscv-tests

riscv-tests:
	$(MAKE) -C riscv/tests sim

.PHONY: riscv-tests
