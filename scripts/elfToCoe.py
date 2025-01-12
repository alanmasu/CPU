import argparse
from elftools.elf.elffile import ELFFile

def extract_text_section_to_coe(file_path, output_path):
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
            
            # Genera il contenuto del file .coe
            coe_content = "memory_initialization_radix=16;\n"
            coe_content += "memory_initialization_vector=\n"
            coe_content += ',\n'.join(instructions)
            coe_content += ";\n"
            
            # Salva il file .coe
            with open(output_path, 'w') as out_file:
                out_file.write(coe_content)
            
            print(f"Sezione .text estratta con successo e salvata in '{output_path}'.")

    except Exception as e:
        print(f"Errore durante l'estrazione della sezione .text: {e}")

def main():
    parser = argparse.ArgumentParser(description="Estrai la sezione .text da un file ELF e generala come file .coe.")
    parser.add_argument("file", help="Percorso del file ELF da elaborare")
    parser.add_argument("output", help="Percorso del file .coe di output")
    args = parser.parse_args()
    
    # Chiama la funzione con i file specificati dall'utente
    extract_text_section_to_coe(args.file, args.output)

if __name__ == "__main__":
    main()
