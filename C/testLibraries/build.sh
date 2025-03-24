if [ "$1" = "-sim" ]; then
    make clean
    make sim
    make dump > bin/dump.txt
    # python3  scripts/elfToSvh.py bin/main.elf ~/workspace/TestCPU/src/programs/testLibProgram.svh LibProgram
    python3  scripts/elfToSvh.py bin/main.elf bin/testLibProgram.svh LibProgram
else 
    make clean
    make dump > bin/dump.txt
    python3  scripts/elfToC_new.py bin/main.elf ~/workspace/TestCPU/src/programs/testLibProgram.h LibProgram
    python3  scripts/elfToC_new.py bin/main.elf bin/testLibProgram.h LibProgram
fi
riscv32-unknown-elf-objdump -D bin/main.elf > bin/disas.txt
# executePython -c bin/main.elf ~/workspace/TestCPU/src/programs/testUARTLibProgram.h UARTLibProgram