make dump > bin/dump.txt
# riscv32-unknown-elf-objdump -D bin/main.elf > bin/disas.txt
# executePython -c bin/main.elf ~/workspace/TestCPU/src/programs/testUARTLibProgram.h UARTLibProgram
python3  scripts/elfToC_new.py bin/main.elf ~/workspace/TestCPU/src/programs/testUARTLibProgram.h UARTLibProgram
# python3  scripts/elfToC_new.py bin/main.elf bin/testUARTLibProgram.h UARTLibProgram