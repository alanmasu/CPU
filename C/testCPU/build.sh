#!/bin/bash

make
make dump > bin/dump.txt
executePython -c bin/main.elf ~/workspace/Test_GPIO/src/programs/testProgram.h testProgram
