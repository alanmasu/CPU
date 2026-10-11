import argparse
from elftools.elf.elffile import ELFFile

def extract_text_section_to_c(file_path, output_path, programName):
    try:
        with open(file_path, 'rb') as f:
            elf = ELFFile(f)
            
            # Trova la sezione .text
            text_section = elf.get_section_by_name('.text')
            if not text_section:
                print("Sezione .text non trovata.")
                return
            
            # Leggi il contenuto della sezione .text
            text_data = text_section.data()
            instructions = []
            
            # Converte i byte in formato esadecimale con lettere minuscole
            for i in range(0, len(text_data), 4):  # Assume istruzioni a 4 byte
                word = text_data[i:i+4]
                hex_word = ''.join(f'{byte:02x}' for byte in reversed(word))  # Little endian e minuscolo
                instructions.append(hex_word)
            
            # Genera il contenuto del file .c
            c_content = "#include <stdint.h>\n\n"
            c_content += "const uint32_t "
            c_content += programName +"[] = {\n"
            c_content += ',\n'.join(f"    0x{instr}" for instr in instructions)
            c_content += ",\n    0\n};\n"
            
            # Salva il file .c
            with open(output_path, 'w') as out_file:
                out_file.write(c_content)
            
            print(f"Sezione .text estratta con successo e salvata in '{output_path}'.")

    except Exception as e:
        print(f"Errore durante l'estrazione della sezione .text: {e}")

def main():
    parser = argparse.ArgumentParser(description="Estrai la sezione .text da un file ELF e generala come file .c.")
    parser.add_argument("file", help="Percorso del file ELF da elaborare")
    parser.add_argument("output", help="Percorso del file .c di output")
    parser.add_argument("program", help="Nome della variabile creata nel file .c")
    args = parser.parse_args()
    
    # Chiama la funzione con i file specificati dall'utente
    extract_text_section_to_c(args.file, args.output, args.program) 

if __name__ == "__main__":
    main()

# tilde ~ 