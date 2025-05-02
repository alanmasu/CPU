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
                h_next[k] += 1

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

if __name__ == "__main__":
    get_popcount_levels(3)
    get_popcount_levels(6)
    get_popcount_levels(7)
    get_popcount_levels(18)
    get_popcount_levels(19)
    get_popcount_levels(36)
    get_popcount_levels(37)  # Sostituisci con il valore che vuoi testare
    get_popcount_levels(128)