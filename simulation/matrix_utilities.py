import os
import argparse
import math

def generate_sv_block_matrix(matrix_name: str, blocks_x: int, blocks_y: int, block_bits: int, starting_point: int = 0) -> str:
    matrix_bits_x = blocks_x * block_bits
    matrix_bits_y = blocks_y * block_bits

    total_bits = matrix_bits_x * matrix_bits_y
    total_words = math.ceil(total_bits / 32)

    words_per_row = math.ceil(matrix_bits_x / 32)
    padded_matrix_bits = words_per_row * 32

    total_rows = matrix_bits_y
    words_per_block_row = math.ceil(block_bits / 32)

    matrix = []
    counter = 0
    value = starting_point
    for row in range(total_rows):
        current_row = []
        for col in range(words_per_row):
            if counter * 32 < total_bits:
                current_row.append(value)
            else:
                current_row.append(0)
            counter += 1
            value += 1
        matrix.append(current_row)

    flattened_words = []

    for block_row in range(blocks_y):
        for block_col in range(blocks_x):
            for row_in_block in range(block_bits):
                row_idx = block_row * block_bits + row_in_block
                if row_idx >= total_rows:
                    flattened_words.extend([0] * words_per_block_row)
                else:
                    word_start = block_col * words_per_block_row
                    word_end = word_start + words_per_block_row
                    row_slice = matrix[row_idx][word_start:word_end]
                    row_slice += [0] * (words_per_block_row - len(row_slice))
                    flattened_words.extend(row_slice)

    sv_array = f"logic [31:0] {matrix_name} [0:{len(flattened_words)-1}] = '{{\n"
    sv_array += ",\n".join(f"    32'h{val:08x}" for val in flattened_words)
    sv_array += "\n};"

    return sv_array


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Genera un array di SystemVerilog a partire da una matrice.")
    parser.add_argument("-m", "--matrix_name", type=str, default="matrix")
    parser.add_argument("-f", "--file_name", type=str, default="matrix.sv")
    parser.add_argument("-sp", "--starting_point", type=int, default=0)
    parser.add_argument("-bx", "--blocks_x", type=int, default=2)
    parser.add_argument("-by", "--blocks_y", type=int, default=2)
    parser.add_argument("-bs", "--block_size", type=int, default=32)
    parser.add_argument("-a", "--append", action="store_true", default=False)

    args = parser.parse_args()
    matrix_name = args.matrix_name
    file_name = args.file_name
    starting_point = args.starting_point
    blocks_x = args.blocks_x
    blocks_y = args.blocks_y
    block_size = args.block_size

    arr = generate_sv_block_matrix(matrix_name, blocks_x, blocks_y, block_size, starting_point)

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
