import argparse
from elftools.elf.elffile import ELFFile

def extract_section_data(elf, section_name):
    """Restituisce i dati della sezione, il suo indirizzo e la sua dimensione."""
    section = elf.get_section_by_name(section_name)
    if section:
        return section.data(), section['sh_addr'], section['sh_size']
    else:
        return None, None, None

def extract_text_section_to_svh(file_path, output_path, programName):
    try:
        with open(file_path, 'rb') as f:
            elf = ELFFile(f)
            
            # Estrazione dei dati delle sezioni
            text_data, text_address, text_size = extract_section_data(elf, '.text')
            const_data, const_address, const_size = extract_section_data(elf, '.const')
            data_data, data_address, data_size = extract_section_data(elf, '.data')
            _, bss_address, bss_size = extract_section_data(elf, '.bss')
            
            # Converte i byte delle sezioni in formato esadecimale
            def convert_to_hex_array(data):
                return ["32'h" + ''.join(f'{byte:02x}' for byte in reversed(data[i:i+4])) for i in range(0, len(data), 4)] if data else []
            
            text_instructions = convert_to_hex_array(text_data)
            const_instructions = convert_to_hex_array(const_data)
            data_instructions = convert_to_hex_array(data_data)
            
            # Genera il contenuto del file .svh
            svh_content = f"// SystemVerilog Header per {programName}\n\n"
            svh_content += f"`define {programName}_TEXT_ADDR 32'h{text_address:08x}\n"
            svh_content += f"`define {programName}_TEXT_SIZE {text_size}\n"
            if const_address is not None:
                svh_content += f"`define {programName}_CONST_ADDR 32'h{const_address:08x}\n"
                svh_content += f"`define {programName}_CONST_SIZE {const_size}\n"
            if bss_address is not None:
                svh_content += f"`define {programName}_BSS_ADDR 32'h{bss_address:08x}\n"
                svh_content += f"`define {programName}_BSS_SIZE {bss_size}\n"
            if data_address is not None:
                svh_content += f"`define {programName}_DATA_ADDR 32'h{data_address:08x}\n"
                svh_content += f"`define {programName}_DATA_SIZE {data_size}\n"
            
            # Aggiunge gli array per le sezioni estratte
            svh_content += "\n// Sezione .text\n"
            svh_content += f"logic [31:0] {programName}_text[] = '{{\n    " + ',\n    '.join(text_instructions) + ",\n    0\n};\n\n"
            
            if const_instructions:
                svh_content += "// Sezione .const (.rodata)\n"
                svh_content += f"logic [31:0] {programName}_const[] = '{{\n    " + ',\n    '.join(const_instructions) + ",\n    0\n};\n\n"
            
            if data_instructions:
                svh_content += "// Sezione .data\n"
                svh_content += f"logic [31:0] {programName}_data[] = '{{\n    " + ',\n    '.join(data_instructions) + ",\n    0\n};\n\n"
            
            # Salva il file .svh
            with open(output_path, 'w') as out_file:
                out_file.write(svh_content)
            
            print(f"File .svh generato con successo: '{output_path}'.")
    except Exception as e:
        print(f"Errore durante l'estrazione delle sezioni: {e}")

def main():
    parser = argparse.ArgumentParser(description="Estrai le sezioni .text, .const e .bss da un file ELF e generala come file .svh.")
    parser.add_argument("file", help="Percorso del file ELF da elaborare")
    parser.add_argument("output", help="Percorso del file .svh di output")
    parser.add_argument("program", help="Nome della variabile creata nel file .svh")
    args = parser.parse_args()
    
    extract_text_section_to_svh(args.file, args.output, args.program)

if __name__ == "__main__":
    main()
