"""Export a RISC-V ELF into the files that load it into the core's memories.

Formats:
  h    C header for the Vitis applications on the Zynq
  svh  SystemVerilog header for the testbenches
  coe  memory initialisation files for the Block Memory Generator: one for
       the instruction memory (-o) and one for the data memory (--data-output)

The h and svh files contain, every name starting with the prefix (by default
the name of the ELF without extension):
  <prefix>_<SECTION>_ADDR / _SIZE   for .text, .const, .data, .bss
  <prefix>_GLOBAL_POINTER_VAL       value of __global_pointer$
  <prefix>_<symbol>_ADDR            address of every data symbol of the program
  <prefix>_text, _const, _data      contents of the sections, in 32-bit words

Examples:
  python3 elfexport.py test_BTPU.elf --format svh -o test_BTPU.svh
  python3 elfexport.py prog.elf --format coe -o instr.coe --data-output data.coe

Requires pyelftools (tools/activate installs it in pyEnv/).
"""

import argparse
import os
import sys

from elftools.elf.elffile import ELFFile
from elftools.elf.sections import SymbolTableSection

SECTIONS = ['.text', '.const', '.data', '.bss']


def read_elf(path):
    """Return the sections, the global pointer and the data symbols of an ELF."""
    with open(path, 'rb') as f:
        elf = ELFFile(f)
        sections = {}
        for name in SECTIONS:
            section = elf.get_section_by_name(name)
            if section is None:
                continue
            # .bss has no contents in the file, only an address and a size
            if name == '.bss':
                data = b''
            else:
                data = section.data()
            sections[name] = (section['sh_addr'], section['sh_size'], data)

        global_pointer = None
        symbols = []
        for section in elf.iter_sections():
            if not isinstance(section, SymbolTableSection):
                continue
            for symbol in section.iter_symbols():
                if symbol.name == '__global_pointer$':
                    global_pointer = symbol['st_value']
                is_data = symbol['st_info']['type'] == 'STT_OBJECT'
                is_defined = symbol['st_shndx'] != 'SHN_UNDEF' and symbol['st_value'] != 0
                if is_data and is_defined:
                    symbols.append((symbol.name, symbol['st_value']))
    return sections, global_pointer, symbols


def words(data):
    """Split little-endian bytes into 32-bit words, as hexadecimal strings."""
    return ['%08x' % int.from_bytes(data[i:i + 4], 'little') for i in range(0, len(data), 4)]


def defines(prefix, sections, global_pointer, symbols):
    """Return (name, value) of every define, in the order they are written."""
    result = []
    for name, address in symbols:
        result.append((f'{prefix}_{name}_ADDR', address))
    for name in SECTIONS:
        if name not in sections:
            continue
        address, size, _ = sections[name]
        # An empty section other than .text has nothing to load
        if size == 0 and name != '.text':
            continue
        upper = name[1:].upper()
        result.append((f'{prefix}_{upper}_ADDR', address))
        result.append((f'{prefix}_{upper}_SIZE', size))
    if global_pointer is not None:
        result.append((f'{prefix}_GLOBAL_POINTER_VAL', global_pointer))
    return result


def write_h(path, prefix, sections, global_pointer, symbols):
    lines = ['#include <stdint.h>', '']
    for name, value in defines(prefix, sections, global_pointer, symbols):
        if name.endswith('_SIZE'):
            lines.append(f'#define {name} {value}')
        else:
            lines.append(f'#define {name} 0x{value:08x}')
    lines.append('')
    for name in ['.text', '.const', '.data']:
        if name not in sections or sections[name][1] == 0:
            continue
        lines.append(f'const uint32_t {prefix}_{name[1:]}[] = {{')
        for word in words(sections[name][2]):
            lines.append(f'    0x{word},')
        # A last zero word, as the loaders expect
        lines.append('    0')
        lines.append('};')
        lines.append('')
    with open(path, 'w') as f:
        f.write('\n'.join(lines))


def write_svh(path, prefix, sections, global_pointer, symbols):
    lines = []
    for name, value in defines(prefix, sections, global_pointer, symbols):
        if name.endswith('_SIZE'):
            lines.append(f'`define {name} {value}')
        else:
            lines.append(f"`define {name} 32'h{value:08x}")
    lines.append('')
    for name in ['.text', '.const', '.data']:
        if name not in sections or sections[name][1] == 0:
            continue
        lines.append(f"logic [31:0] {prefix}_{name[1:]} [] = '{{")
        for word in words(sections[name][2]):
            lines.append(f"    32'h{word},")
        # A last zero word, as the testbenches expect
        lines.append("    32'h00000000")
        lines.append('};')
        lines.append('')
    with open(path, 'w') as f:
        f.write('\n'.join(lines))


def coe(data_words):
    lines = ['memory_initialization_radix=16;', 'memory_initialization_vector=']
    for i, word in enumerate(data_words):
        if i == len(data_words) - 1:
            lines.append(word + ';')
        else:
            lines.append(word + ',')
    return '\n'.join(lines) + '\n'


def write_coe(instr_path, data_path, sections, instr_base, data_base):
    """Write the instruction memory from .text, the data memory from .const and .data."""
    if '.text' not in sections:
        raise ValueError('the ELF has no .text section')
    address, _, data = sections['.text']
    padding = (address - instr_base) // 4
    with open(instr_path, 'w') as f:
        f.write(coe(['00000000'] * padding + words(data)))

    image = b''
    for name in ['.const', '.data']:
        if name not in sections or sections[name][1] == 0:
            continue
        address, size, data = sections[name]
        # Fill the gap between the end of the image and the section with zeros
        image += b'\0' * (address - data_base - len(image))
        image += data
    if image:
        with open(data_path, 'w') as f:
            f.write(coe(words(image)))


def main():
    parser = argparse.ArgumentParser(description='Export a RISC-V ELF for the Vitis applications, the testbenches or the memory initialisation.')
    parser.add_argument('elf', help='ELF file to export')
    parser.add_argument('--format', required=True, choices=['h', 'svh', 'coe'], help='output format')
    parser.add_argument('-o', '--output', required=True, help='output file (for coe: the instruction memory)')
    parser.add_argument('--prefix', help='prefix of every name, default: name of the ELF without extension')
    parser.add_argument('--data-output', help='coe only: output file of the data memory')
    parser.add_argument('--instr-base', default='0x40000000', help='coe only: base address of the instruction memory')
    parser.add_argument('--data-base', default='0x40010000', help='coe only: base address of the data memory')
    args = parser.parse_args()

    prefix = args.prefix
    if prefix is None:
        prefix = os.path.splitext(os.path.basename(args.elf))[0]

    try:
        sections, global_pointer, symbols = read_elf(args.elf)
        if args.format == 'h':
            write_h(args.output, prefix, sections, global_pointer, symbols)
        elif args.format == 'svh':
            write_svh(args.output, prefix, sections, global_pointer, symbols)
        else:
            if args.data_output is None:
                raise ValueError('--format coe needs --data-output')
            write_coe(args.output, args.data_output, sections, int(args.instr_base, 16), int(args.data_base, 16))
    except (OSError, ValueError) as error:
        print(f'elfexport: {args.elf}: {error}', file=sys.stderr)
        sys.exit(1)
    print(f'elfexport: {args.output}')


if __name__ == '__main__':
    main()
