import argparse
from elftools.elf.elffile import ELFFile
from elftools.elf.sections import SymbolTableSection

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
            if const_address is not None:
                c_content += f"#define {programName}_CONST_ADDR 0x{const_address:08x}\n"
                c_content += f"#define {programName}_CONST_SIZE {const_size}\n"
            else:
                c_content += "// .const section non trovata\n"
                
            if bss_address is not None:
                c_content += f"#define {programName}_BSS_ADDR 0x{bss_address:08x}\n"
                c_content += f"#define {programName}_BSS_SIZE {bss_size}\n"
            else:
                c_content += "// .bss section non trovata\n"
                
            if data_address is not None:
                c_content += f"#define {programName}_DATA_ADDR 0x{data_address:08x}\n"
                c_content += f"#define {programName}_DATA_SIZE {data_size}\n"
            else:
                c_content += "// .data section non trovata\n"
            
            # Aggiunta della define per __global_pointer
            if global_pointer_val is not None:
                c_content += f"\n#define GLOBAL_POINTER_VAL 0x{global_pointer_val:08x}\n"
                        
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

def main():
    parser = argparse.ArgumentParser(description="Estrai le sezioni .text, .const e .bss da un file ELF e generala come file .c.")
    parser.add_argument("file", help="Percorso del file ELF da elaborare")
    parser.add_argument("output", help="Percorso del file .c di output")
    parser.add_argument("program", help="Nome della variabile creata nel file .c")
    args = parser.parse_args()
    
    # Chiama la funzione con i file specificati dall'utente
    extract_text_section_to_c(args.file, args.output, args.program)
    

if __name__ == "__main__":
    main()
