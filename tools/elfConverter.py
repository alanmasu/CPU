import argparse
from elftools.elf.elffile import ELFFile # type: ignore
from elftools.elf.sections import SymbolTableSection # type: ignore

def extract_section_data(elf, section_name):
    """Restituisce i dati della sezione, il suo indirizzo e la sua dimensione."""
    section = elf.get_section_by_name(section_name)
    if section:
        return section.data(), section['sh_addr'], section['sh_size']
    else:
        return None, None, None

def get_symbol_address(elf, symbol_name):
    """Trova l'indirizzo di un simbolo nell'ELF."""
    for section in elf.iter_sections():
        if isinstance(section, SymbolTableSection):
            for symbol in section.iter_symbols():
                if symbol.name == symbol_name:
                    return symbol.entry.st_value
    return None

def extract_text_section_to_c(file_path, output_path, programName):
    try:
        with open(file_path, 'rb') as f:
            elf = ELFFile(f)
            
            # Estrazione dei dati delle sezioni
            text_data, text_address, text_size = extract_section_data(elf, '.text')
            const_data, const_address, const_size = extract_section_data(elf, '.const')
            data_data, data_address, data_size = extract_section_data(elf, '.data')
            _, bss_address, bss_size = extract_section_data(elf, '.bss')
            
            # Ottenere il valore del simbolo __global_pointer
            global_pointer_val = get_symbol_address(elf, '__global_pointer$')
            
            # Converte i byte della sezione .text in formato esadecimale
            text_instructions = []
            if text_data:
                for i in range(0, len(text_data), 4):
                    word = text_data[i:i+4]
                    hex_word = ''.join(f'{byte:02x}' for byte in reversed(word))
                    text_instructions.append(hex_word)
            
            # Converte i byte della sezione .const (.rodata) in formato esadecimale
            const_instructions = []
            if const_data:
                for i in range(0, len(const_data), 4):
                    word = const_data[i:i+4]
                    hex_word = ''.join(f'{byte:02x}' for byte in reversed(word))
                    const_instructions.append(hex_word)
                    
            # Converte i byte della sezione .data (.rodata) in formato esadecimale
            data_instructions = []
            if data_data:
                for i in range(0, len(data_data), 4):
                    word = data_data[i:i+4]
                    hex_word = ''.join(f'{byte:02x}' for byte in reversed(word))
                    data_instructions.append(hex_word)
            
            # Genera il contenuto del file .c
            c_content = "#include <stdint.h>\n\n"
            
            # Aggiunge le #define per indirizzi e dimensioni
            c_content += f"#define {programName}_TEXT_ADDR 0x{text_address:08x}\n"
            c_content += f"#define {programName}_TEXT_SIZE {text_size}\n"
            if const_address is not None and const_size > 0:
                c_content += f"#define {programName}_CONST_ADDR 0x{const_address:08x}\n"
                c_content += f"#define {programName}_CONST_SIZE {const_size}\n"
            else:
                c_content += "// .const section non trovata\n"
                
            if bss_address is not None:
                c_content += f"#define {programName}_BSS_ADDR 0x{bss_address:08x}\n"
                c_content += f"#define {programName}_BSS_SIZE {bss_size}\n"
            else:
                c_content += "// .bss section non trovata\n"
                
            if data_address is not None and data_size > 0:
                c_content += f"#define {programName}_DATA_ADDR 0x{data_address:08x}\n"
                c_content += f"#define {programName}_DATA_SIZE {data_size}\n"
            else:
                c_content += "// .data section non trovata\n"
                        
            c_content += "\n"
            
            # Aggiunge i dati della sezione .text
            c_content += f"const uint32_t {programName}_text[] = {{\n"
            c_content += ',\n'.join(f"    0x{instr}" for instr in text_instructions)
            c_content += ",\n    0\n};\n\n"
            
            # Aggiunge i dati della sezione .const (.rodata), se presenti
            if const_data:
                c_content += f"const uint32_t {programName}_const[] = {{\n"
                c_content += ',\n'.join(f"    0x{instr}" for instr in const_instructions)
                c_content += ",\n    0\n};\n\n"
            else:
                c_content += f"// Nessun dato nella sezione .const\n\n"
            
            # Aggiunge i dati della sezione .data, se presenti
            if data_data:
                c_content += f"const uint32_t {programName}_data[] = {{\n"
                c_content += ',\n'.join(f"    0x{instr}" for instr in data_instructions)
                c_content += ",\n    0\n};\n\n"
            else:
                c_content += f"// Nessun dato nella sezione .data\n\n"
            
            # Salva il file .c
            with open(output_path, 'w') as out_file:
                out_file.write(c_content)
            
            print(f"File .c generato con successo: '{output_path}'.")

    except Exception as e:
        print(f"Errore durante l'estrazione della sezione .text: {e}")
        
def extract_text_section_to_sv(file_path, output_path, programName):
    try:
        with open(file_path, 'rb') as f:
            elf = ELFFile(f)

            text_data, text_address, text_size = extract_section_data(elf, '.text')
            const_data, const_address, const_size = extract_section_data(elf, '.const')
            data_data, data_address, data_size = extract_section_data(elf, '.data')
            bss_data, bss_address, bss_size = extract_section_data(elf, '.bss')

            def format_section_sv(name, data):
                if not data:
                    return f"// Nessun dato nella sezione {name}\n"
                result = f"logic [31:0] {programName}_{name} [] = '{{\n"
                for i in range(0, len(data), 4):
                    word = data[i:i+4]
                    hex_word = ''.join(f'{byte:02x}' for byte in reversed(word))
                    result += f"    32'h{hex_word},\n"
                result += "    32'h00000000\n};\n\n"
                return result

            sv_content = f"`define {programName}_TEXT_ADDR 32'h{text_address:08x}\n"
            sv_content += f"`define {programName}_TEXT_SIZE {text_size}\n"

            if const_address is not None and const_size > 0:
                sv_content += f"`define {programName}_CONST_ADDR 32'h{const_address:08x}\n"
                sv_content += f"`define {programName}_CONST_SIZE {const_size}\n"
            if data_address is not None and data_size > 0:
                sv_content += f"`define {programName}_DATA_ADDR 32'h{data_address:08x}\n"
                sv_content += f"`define {programName}_DATA_SIZE {data_size}\n"
            if bss_address is not None and bss_size > 0:
                sv_content += f"`define {programName}_BSS_ADDR 32'h{bss_address:08x}\n"
                sv_content += f"`define {programName}_BSS_SIZE {bss_size}\n"

            global_pointer_val = get_symbol_address(elf, '__global_pointer$')
            if global_pointer_val is not None:
                sv_content += f"`define GLOBAL_POINTER_VAL 32'h{global_pointer_val:08x}\n"

            sv_content += "\n"
            sv_content += format_section_sv("text", text_data)
            sv_content += format_section_sv("const", const_data)
            sv_content += format_section_sv("data", data_data)

            with open(output_path, 'w') as out_file:
                out_file.write(sv_content)

            print(f"File SystemVerilog generato con successo: '{output_path}'.")

    except Exception as e:
        print(f"Errore durante l'estrazione per SystemVerilog: {e}")

def extract_text_section_to_coe_dual(file_path, instr_output, data_output, instr_base, data_base):
    try:
        with open(file_path, 'rb') as f:
            elf = ELFFile(f)

            # Estrai le sezioni
            text_data, text_addr, _ = extract_section_data(elf, '.text')
            data_data, data_addr, _ = extract_section_data(elf, '.data')
            const_data, const_addr, _ = extract_section_data(elf, '.const')

            # ---- Funzione helper per costruire un file .coe ----
            def build_coe_section(section_data, section_addr, base_addr):
                words = []
                if section_addr is not None and section_addr > base_addr:
                    offset_words = (section_addr - base_addr) // 4
                    words += ["00000000"] * offset_words  # Padding iniziale

                for i in range(0, len(section_data), 4):
                    word = section_data[i:i+4]
                    hex_word = ''.join(f'{b:02x}' for b in reversed(word))
                    words.append(hex_word)

                coe_content = "memory_initialization_radix=16;\n"
                coe_content += "memory_initialization_vector=\n"
                for i, w in enumerate(words):
                    end = ";" if i == len(words) - 1 else ","
                    coe_content += f"{w}{end}\n"
                return coe_content

            # ---- Scrive il file COE per la memoria istruzioni (.text) ----
            if text_data and text_addr is not None:
                instr_coe = build_coe_section(text_data, text_addr, instr_base)
                with open(instr_output, 'w') as out_instr:
                    out_instr.write(instr_coe)
                print(f"File COE istruzioni scritto: {instr_output}")
            else:
                print("Nessuna sezione .text trovata per le istruzioni.")

            # ---- Combina e ordina .const e .data per il file dati ----
            data_sections = []
            if const_data and const_addr is not None:
                data_sections.append((const_addr, const_data))
            if data_data and data_addr is not None:
                data_sections.append((data_addr, data_data))

            data_sections.sort(key=lambda x: x[0])

            full_data = b''
            current_addr = data_base
            for addr, data in data_sections:
                if addr > current_addr:
                    gap = addr - current_addr
                    full_data += b'\x00' * gap  # Padding tra sezioni
                full_data += data
                current_addr = addr + len(data)

            # ---- Scrive il file COE per la memoria dati ----
            if full_data:
                data_coe = build_coe_section(full_data, data_base, data_base)
                with open(data_output, 'w') as out_data:
                    out_data.write(data_coe)
                print(f"File COE dati scritto: {data_output}")
            else:
                print("Nessuna sezione .data o .const trovata per i dati.")

    except Exception as e:
        print(f"Errore durante la generazione dei file COE duali: {e}")

def main():
    parser = argparse.ArgumentParser(description="Estrai le sezioni .text, .const, .data e .bss da un file ELF e convertilo in un array per C, SystemVerilog o COE.")
    parser.add_argument("file", help="Percorso del file ELF da elaborare")
    parser.add_argument("output", help="Percorso del file di output (se --format coe, usato per le istruzioni)")
    parser.add_argument("program", help="Nome della variabile (se --format coe, usato per la memoria dati)")
    parser.add_argument("--format", choices=["c", "sv", "coe"], default="c", help="Formato di output: c (default), sv (SystemVerilog), coe (Xilinx)")
    parser.add_argument("--memory_conf", nargs=2, metavar=('instr_base', 'data_base'),
                        help="Configurazione memorie per formato COE: base_istruzioni base_dati")

    args = parser.parse_args()

    if args.format == "c":
        extract_text_section_to_c(args.file, args.output, args.program)
    elif args.format == "sv":
        extract_text_section_to_sv(args.file, args.output, args.program)
    elif args.format == "coe":
        if args.memory_conf:
            instr_base = int(args.memory_conf[0], 16)
            data_base = int(args.memory_conf[1], 16)
        else:
            instr_base = 0x40000000
            data_base  = 0x40010000

        extract_text_section_to_coe_dual(args.file, args.output, args.program, instr_base, data_base)

if __name__ == "__main__":
    main()
