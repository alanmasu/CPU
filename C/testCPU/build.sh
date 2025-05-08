#!/bin/bash

make
make dump > bin/dump.txt
executePython -sv bin/main.elf data_array > bin/arr.svh
