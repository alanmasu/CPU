import math

def clog2(x):
    return math.ceil(math.log2(x)) if x > 0 else 0

def get_popcount_levels(X):
    # Array per rappresentare le altezze per ogni peso
    max_cols = clog2(X) + 5  # buffer extra
    h_curr = [0] * max_cols
    h_next = [0] * max_cols
    h_curr[0] = X

    level = 0
    max_k = 0

    print(f"\nget_popcount_levels called with X: {X}")

    while True:
        # Verifica se serve un altro livello
        still_running = any(h_curr[k] > 3 for k in range(max_k + 1))
        if not still_running:
            break

        level += 1
        # print(f"\n  Level {level}:")

        # Reset buffer
        h_next = [0] * max_cols

        for k in range(max_k + 1):
            if h_curr[k] > 3:
                groups = (h_curr[k] + 5) // 6  # ceil division
                # print(f"    Applico compressione a k={k} con h_curr[k]={h_curr[k]} → {groups} gruppi")
                h_next[k]     += groups
                h_next[k + 1] += groups
                h_next[k + 2] += groups
                # print(f"      h_next[{k}] = {h_next[k]}")
                # print(f"      h_next[{k+1}] = {h_next[k+1]}")
                # print(f"      h_next[{k+2}] = {h_next[k+2]}")
            else:
                h_next[k] += h_curr[k]  

        h_curr = h_next.copy()

        # aggiorna max_k
        for i in reversed(range(max_cols)):
            if h_curr[i] > 0:
                max_k = i
                break

        # print(f"    max_k dopo il livello: {max_k}")
        # for i in range(max_k + 1):
        #     print(f"    h_curr[{i}] = {h_curr[i]}")

    # print("\nRisultato finale:")
    # for i in range(max_k + 1):
    #     print(f"  h_curr[{i}] = {h_curr[i]}")
    print(f"Livelli richiesti: {level}")
    return level

def get_weights(X: int, target_level: int) -> list[int]:
    from math import ceil, log2

    max_cols = int(log2(X)) + 5
    h_curr = [0] * max_cols
    h_next = [0] * max_cols
    h_curr[0] = X
    max_k = 0
    level = 0

    while True:
        still_running = any(h_curr[k] > 3 for k in range(max_k + 1))

        if not still_running or level == target_level:
            break

        level += 1
        h_next = [0] * max_cols

        for k in range(max_k + 1):
            if h_curr[k] > 3:
                groups = (h_curr[k] + 5) // 6
                h_next[k] += groups
                h_next[k + 1] += groups
                h_next[k + 2] += groups
            else:
                h_next[k] += h_curr[k]  # Trasferisce un singolo bit residuo

        h_curr = h_next[:]
        for i in reversed(range(max_k + 3)):
            if h_curr[i] > 0:
                max_k = i
                break

    return h_curr[:max_k + 1]

# Funzione per calcolare la massima altezza di un livello
## @param H: lista delle altezze di tutti i livelli
## @return max_h: massima altezza
def maxHeight(H: list[list[int]], j:int ) -> int:
    max_h = 0
    for i in range(len(H[j])):
        if H[j][i] > max_h:
            max_h = H[j][i]
    return max_h

def myAlgorithm(X: int, target_level: int):
    # Funzione che calcola 
    H = [[X]]

    
    # inputList = [0] * clog2(X)
    # ouputList = [0] * clog2(X)
    n_compressors = [[0]]
    i = 0
    j = 0
    # print(maxHeight(H, j))
    while maxHeight(H, j) > 3:
        H.append([0] * clog2(X))
        n_compressors.append([0] * clog2(X))
        for k in range(len(H[j])):
            if H[j][k] > 3:
                n_compressors[j + 1][k] = (H[j][k] + 5) // 6
                H[j + 1][k] += n_compressors[j + 1][k]
                H[j + 1][k + 1] += n_compressors[j + 1][k]
                H[j + 1][k + 2] += n_compressors[j + 1][k]
            else:
                H[j + 1][k] += H[j][k]
        j += 1
        
    return H[target_level], n_compressors[target_level]
    


if __name__ == "__main__":
    # get_popcount_levels(3)
    # get_popcount_levels(6)
    # get_popcount_levels(7)
    # get_popcount_levels(18)
    # get_popcount_levels(19)
    # get_popcount_levels(36)
    # get_popcount_levels(37)  # Sostituisci con il valore che vuoi testare
    # get_popcount_levels(128)
    X = 72
    for i in range(0, get_popcount_levels(X) + 1):
        print(f"Livello {i}: {myAlgorithm(X, i)}")

    # print("\n")

    # X = 73
    # for i in range(1, get_popcount_levels(X) + 1):
    #     print(f"Livello {i}: {myAlgorithm(X, i)}")