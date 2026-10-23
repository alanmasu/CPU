import argparse
import os
from elftools.elf.elffile import ELFFile

def is_data_symbol(symbol):
    return symbol['st_info']['type'] == 'STT_OBJECT'

def is_valid_symbol(symbol):
    return (
        symbol['st_shndx'] != 'SHN_UNDEF' and
        isinstance(symbol['st_value'], int) and
        symbol['st_value'] != 0
    )

def extract_data_symbols(elf_path):
    symbols = []
    with open(elf_path, 'rb') as f:
        elf = ELFFile(f)
        symtab = elf.get_section_by_name('.symtab')
        if symtab is None:
            print("Nessuna sezione .symtab trovata.")
            return symbols

        for symbol in symtab.iter_symbols():
            if is_data_symbol(symbol) and is_valid_symbol(symbol):
                symbols.append((f"{symbol.name}_ADDR", symbol['st_value']))
    return symbols

def generate_definitions(symbols, fmt):
    lines = []
    for name, addr in symbols:
        if fmt == 'c':
            lines.append(f"#ifndef {name}")
            lines.append(f"\t#define {name} 0x{addr:08X}")
            lines.append(f"#endif\n")
        elif fmt == 'sv':
            lines.append(f"`ifndef {name}")
            lines.append(f"\t`define {name} 32'h{addr:08X}")
            lines.append(f"`endif\n")
    return lines

def main():
    parser = argparse.ArgumentParser(description="Estrai indirizzi di variabili da un file ELF.")
    parser.add_argument("elf_file", help="Path al file ELF")
    parser.add_argument("-f", "--format", choices=['c', 'sv'], default='c',
                        help="Formato di output: c (.h) [default] o sv (.svh)")
    parser.add_argument("-o", "--output", required=True, help="File di output (.h o .svh)")
    parser.add_argument("-a", "--append", action="store_true", help="Aggiungi all'output invece di sovrascrivere")
    args = parser.parse_args()

    symbols = extract_data_symbols(args.elf_file)
    if not symbols:
        print("Nessuna variabile trovata.")
        return

    lines = generate_definitions(symbols, args.format)

    if not lines:
        print("Nessun simbolo da scrivere.")
        return

    new_content = '\n'.join(lines) + '\n'

    if args.append and os.path.exists(args.output):
        with open(args.output, 'r') as f:
            existing_content = f.read()
        with open(args.output, 'w') as f:
            f.write(new_content + existing_content)
    else:
        with open(args.output, 'w') as f:
            f.write(new_content)

    print(f"{len(symbols)} simboli scritti in '{args.output}' come formato {args.format.upper()}.")

if __name__ == "__main__":
    main()
