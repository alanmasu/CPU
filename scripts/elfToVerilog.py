import argparse
from elftools.elf.elffile import ELFFile

def extract_text_section(file_path, programName):
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
            
            # Genera l'array in formato SystemVerilog
            systemverilog_array = "logic [31:0] " + programName + " [] = '{\n"
            systemverilog_array += ',\n'.join(f"    32'h{instr}" for instr in instructions)
            systemverilog_array += "\n};"
            
            print("Sezione .text estratta con successo:")
            print(systemverilog_array)
            return systemverilog_array

    except Exception as e:
        print(f"Errore durante l'estrazione della sezione .text: {e}")

def main():
    parser = argparse.ArgumentParser(description="Estrai la sezione .text da un file ELF e generala come array SystemVerilog.")
    parser.add_argument("file", help="Percorso del file ELF da elaborare")
    parser.add_argument("program", help="Nome della variabile creata nel file .c")
    args = parser.parse_args()
    
    # Chiama la funzione con il file specificato dall'utente
    extract_text_section(args.file, args.program)

if __name__ == "__main__":
    main()
