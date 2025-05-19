import os
import argparse
import math

def generate_sv_block_matrix(matrix_name: str, matrix_bits: int, block_bits: int, starting_point: int = 0) -> str:
    import math

    # Calcola dimensioni effettive in parole
    total_bits = matrix_bits * matrix_bits
    total_words = math.ceil(total_bits / 32)

    matrix_words_per_row = math.ceil(matrix_bits / 32)
    padded_matrix_bits = matrix_words_per_row * 32  # numero di bit reali per riga, con padding

    total_rows = matrix_bits
    num_blocks_per_side = matrix_bits // block_bits
    words_per_block_row = math.ceil(block_bits / 32)

    # Crea matrice 2D di parole da 32 bit con padding
    matrix = []
    counter = 0
    value = starting_point
    for row in range(matrix_bits):
        current_row = []
        for col in range(matrix_words_per_row):
            if counter * 32 < total_bits:
                current_row.append(value)
            else:
                current_row.append(0)  # padding
            counter += 1
            value += 1
        matrix.append(current_row)

    flattened_words = []

    # Estrai i blocchi in ordine row-major
    for block_row in range(num_blocks_per_side):
        for block_col in range(num_blocks_per_side):
            for row_in_block in range(block_bits):
                row_idx = block_row * block_bits + row_in_block
                if row_idx >= total_rows:
                    flattened_words.extend([0] * words_per_block_row)
                else:
                    word_start = block_col * words_per_block_row
                    word_end = word_start + words_per_block_row
                    row_slice = matrix[row_idx][word_start:word_end]
                    # padding se la slice è corta
                    row_slice += [0] * (words_per_block_row - len(row_slice))
                    flattened_words.extend(row_slice)

    # Genera SystemVerilog array: una parola per riga
    sv_array = f"logic [31:0] {matrix_name} [0:{len(flattened_words)-1}] = '{{\n"

    # sv_array += ",\n".join(f"    32'd{val}" for val in flattened_words)
    sv_array += ",\n".join(f"    32'h{val:08x}" for val in flattened_words)
    sv_array += "\n};"

    return sv_array


    
    
if __name__ == "__main__":
    # aggiungi i parametri: (con default values)
    # - nome matrice
    # - nome file
    # - dimensione matrice
    # - dimensione blocco
    # - è una matrice trasposta?
    parser = argparse.ArgumentParser(description="Genera un array di SystemVerilog a partire da una matrice.")
    parser.add_argument("-m", "--matrix_name", type=str, help="Nome della matrice", default="matrix")
    parser.add_argument("-f", "--file_name", type=str, help="Nome del file di output", default="matrix.sv")
    parser.add_argument("-sp", "--starting_point", type=int, help="Inizio della matrice ", default=0)
    parser.add_argument("-ms", "--matrix_size", type=int, help="Dimensione della matrice ", default=64)
    parser.add_argument("-bs", "--block_size", type=int, help="Dimensione del blocco ", default=32)
    parser.add_argument("-t", "--transpose", action="store_true", help="Genera una matrice trasposta", default=False)
    parser.add_argument("-a", "--append", action="store_true", help="Aggiungi alla matrice esistente", default=False)
    
    # Lettura degli argomenti
    args = parser.parse_args()
    matrix_name = args.matrix_name
    file_name = args.file_name
    matrix_size = args.matrix_size
    block_size = args.block_size
    transpose = args.transpose
    starting_point = args.starting_point
    
    arr = generate_sv_block_matrix(matrix_name, matrix_size, block_size, starting_point)
    
    # Scrittura dell'array su file
    if args.append:
        if os.path.exists(file_name):
            with open(file_name, "a") as f:
                f.write("\n\n")
                f.write(arr)
        else:
            print(f"Il file {file_name} non esiste. Creazione di un nuovo file.")
            with open(file_name, "w") as f:
                f.write("// File generato automaticamente\n")
                f.write("// Non modificare a mano\n")
                f.write(arr)
    else:
        with open(file_name, "w") as f:
            f.write("// File generato automaticamente\n")
            f.write("// Non modificare a mano\n")
            f.write(arr)
        
    print(f"Array {matrix_name} generato e scritto su {file_name}")
