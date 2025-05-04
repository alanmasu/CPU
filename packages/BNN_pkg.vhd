----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2025 09:19:00
-- Design Name: 
-- Module Name: BNN_pkg - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.utilities_pkg.all;


package BNN_pkg is
    constant X_MAX : integer := 31;
    
    function get_popcount_levels(x : integer) return integer;

    type integer_array_t is array (0 to X_MAX) of integer;
    type layer_info_t is array (0 to 1, 0 to X_MAX) of integer;

    --! @brief Funzione per calcolare le altezze ed il numero di compressori per il livellp
    --! @param X: Bit del popcounter
    --! @param level: Livello interessato
    --! @returns layer_info_t: Una matrice che contiene due array [0:clog2[X]] contenente le altezze (0) ed il numero di compressori (1)
    function get_layer_info(X : integer; level : integer) return layer_info_t;

    --! @brief Funzione per convertire la lista in integer_array_t
    function get_info(matrix : layer_info_t; row_index : natural) return integer_array_t;

    --! @brief Funzione per calcolare il numero di bit in uscita
    function get_layer_outputs(X : integer; level : integer) return integer;

    --! @brief Funzione per calcolare il numero di bit in ingresso
    function get_layer_inputs(X : integer; level : integer) return integer;
    
    --! @brief Funzione per calcolare il numero di compressori
    function get_layer_compressors(X : integer; level : integer) return integer;

    --! @brief Funzione per calcolare l'altezza del peso
    function get_layer_weight_size(X : integer; level : integer; weight : integer ) return integer;
    
    --! @brief Funzione per calcolare il numero di compressori per il peso
    function get_layer_compressors_n(X : integer; level : integer; weight : integer) return integer;

    --! @brief Funzione per calcolare il numero di compressori accumulati al peso 'weight'
    function acc_layers_compressors(X : integer; level : integer; weight : integer) return integer;

    --! @brief Funzione per calcolare il peso massimo di un livello
    function get_layer_weights(X : integer; level : integer) return integer;

    --! @brief Funzione per calcolare l'altezza massima di un livello
    function get_h_max(X : integer; level : integer) return integer;

    --! @brief Funzione per calcolare la posizione del primo bit in ingresso relativo al perso 'weight'
    function acc_in_position(X : integer; level : integer; weight : integer) return integer;

    --! @brief Funzione per calcolare il numero di ingressi relativi al peso 'weight'
    function get_weight_input_n(X : integer; level : integer; weight : integer) return integer;
end package ;

package body BNN_pkg is
    function get_popcount_levels(X : integer) return integer is
        type int_array is array (0 to clog2(X) + 4) of integer;
        variable h_curr : int_array := (others => 0);  -- Altezze per peso alla fase corrente
        variable h_next : int_array := (others => 0);  -- Altezze per peso alla fase successiva
        variable level  : integer := 0;
        variable max_k  : integer := 0;
        variable groups : integer;
        variable still_running : boolean;
    begin
        -- Inizializza: tutti i bit in peso 0
        h_curr(0) := X;
        max_k := 0;
        
        -- report " ";
        -- report "get_popcount_levels called with X: " & integer'image(X);

        while true loop
            -- Verifica se tutte le colonne sono ≤ 3
            still_running := false;
            for k in 0 to max_k loop --k è il peso
                if h_curr(k) > 3 then
                    still_running := true;
                    exit;
                end if;
            end loop;
    
            if not still_running then
                exit;
            end if;
    
            -- Incrementa solo se serve davvero compressione
            level := level + 1;
    
            -- Reset buffer per la prossima fase
            h_next := (others => 0);
    
            -- Applica compressori 6:3 o passa direttamente i bit
            for k in 0 to max_k loop
                if h_curr(k) > 3 then
                    groups := (h_curr(k) + 5) / 6;  -- ceil division
                    h_next(k)     := h_next(k)     + groups;  -- peso 2^k
                    h_next(k + 1) := h_next(k + 1) + groups;  -- peso 2^(k+1)
                    h_next(k + 2) := h_next(k + 2) + groups;  -- peso 2^(k+2)
                else
                    h_next(k) := h_next(k) + h_curr(k);  -- trasporto diretto
                end if;
            end loop;
    
            -- Aggiorna stato per il prossimo ciclo
            h_curr := h_next;
    
            -- Aggiorna max_k (limite superiore dei pesi presenti)
            for i in max_k + 2 downto 0 loop
                if h_curr(i) > 0 then
                    max_k := i;
                    exit;
                end if;
            end loop;
        end loop;
        return level;
    end function;

    function get_layer_info(X : integer; level : integer) return layer_info_t is
        constant max_k_guess : integer := clog2(X);
    
        variable h_curr : integer_array_t := (others => 0);
        variable h_next : integer_array_t := (others => 0);
        variable temp   : integer_array_t := (others => 0);
        variable groups : integer_array_t := (others => 0);
    
        variable current_level : integer := 0;
        variable max_k  : integer := 0;
        variable result : layer_info_t := (others => (others => 0));
    begin
        h_curr(0) := X;
        max_k := 0;
    
        while current_level <= level loop
            if current_level = level then
                -- Costruisci risultato e restituisci solo il vettore attuale
                for k in 0 to max_k loop
                    result(0, k) := h_curr(k);
                    result(1, k) := groups(k);
                end loop;
                exit;
            end if;
    
            h_next := (others => 0);
            groups := (others => 0);
    
            for k in 0 to max_k loop
                if h_curr(k) > 3 then
                    groups(k) := (h_curr(k) + 5) / 6;
                    h_next(k)     := h_next(k)     + groups(k);
                    h_next(k + 1) := h_next(k + 1) + groups(k);
                    h_next(k + 2) := h_next(k + 2) + groups(k);
                else
                    h_next(k) := h_next(k) + h_curr(k);  -- trasporto diretto
                end if;
            end loop;
    
            h_curr := h_next;
    
            for i in max_k + 2 downto 0 loop
                if h_curr(i) > 0 then
                    max_k := i;
                    exit;
                end if;
            end loop;
    
            current_level := current_level + 1;
        end loop;
    
        return result;  -- taglia il risultato solo fino all’ultimo peso usato
    end function;

    function get_info(matrix : layer_info_t; row_index : natural) return integer_array_t is
        variable row : integer_array_t;
    begin
        for j in matrix'range(2) loop
            row(j) := matrix(row_index, j);
        end loop;
        return row;
    end function;
    
    function get_layer_outputs(X : integer; level : integer) return integer is
        variable length : integer := 0;
        variable layer_info : layer_info_t := (others => (others => 0));
    begin
        layer_info := get_layer_info(X, level);
        length := 0;
        for i in layer_info'range(2) loop
            length := length + layer_info(0, i);
        end loop;
        return length;  -- ritorna solo la parte usata
    end function;

    function get_layer_inputs(X : integer; level : integer) return integer is
    begin
        return get_layer_outputs(X, level - 1);
    end function;

    function get_layer_compressors(X : integer; level : integer) return integer is
        variable length : integer := 0;
        variable layer_info : layer_info_t := (others => (others => 0));
    begin
        layer_info := get_layer_info(X, level);
        length := 0;
        for i in layer_info'range(2) loop
            length := length + layer_info(1, i);
        end loop;
        return length;  -- ritorna solo la parte usata
    end function;

    function get_layer_weight_size(X : integer; level : integer; weight : integer) return integer is
        variable layer_info : layer_info_t := (others => (others => 0));
    begin 
        layer_info := get_layer_info(X, level);
        if weight < layer_info'length(2) then
            return layer_info(0, weight);
        else
            return 0;
        end if;
    end function;

    function get_layer_compressors_n(X : integer; level : integer; weight : integer) return integer is
        variable layer_info : layer_info_t := (others => (others => 0));
    begin 
        layer_info := get_layer_info(X, level);
        if weight < 0 then
            return 0;
        end if;
        if weight < layer_info'length(2) then
            return layer_info(1, weight);
        else
            return 0;
        end if;
    end function;

    function acc_layers_compressors(X : integer; level : integer; weight : integer) return integer is
        variable layer_info : layer_info_t := (others => (others => 0));
        variable length : integer := 0;
    begin
        layer_info := get_layer_info(X, level);
        length := 0;
        for i in 0 to layer_info'length(2) loop
            if(i = weight) then
                exit;
            end if;
            length := length + layer_info(1, i);
        end loop;

        return length;  -- ritorna solo la parte usata
    end function;   

    function get_layer_weights(X : integer; level : integer) return integer is
        variable layer_info : layer_info_t := (others => (others => 0));
        variable length : integer := 0;
    begin
        layer_info := get_layer_info(X, level);
        length := 0;
        for i in layer_info'range(2) loop
            if layer_info(0, i) > 0 then
                length := i;
            end if;
        end loop;
        return length;  -- ritorna solo la parte usata
    end function;

    function get_h_max(X : integer; level : integer) return integer is
        variable layer_info : layer_info_t := (others => (others => 0));
        variable max_h : integer := 0;
    begin
        layer_info := get_layer_info(X, level);
        for i in layer_info'range(2) loop
            if layer_info(0, i) > max_h then
                max_h := layer_info(0, i);
            end if;
        end loop;
        return max_h;
    end function;

    function acc_in_position(X : integer; level : integer; weight : integer) return integer is
        variable layer_info : layer_info_t := (others => (others => 0));
        variable length : integer := 0;
    begin
        layer_info := get_layer_info(X, level - 1);
        length := 0;
        for i in 0 to layer_info'length(2) loop
            if(i = weight) then
                exit;
            end if;
            length := length + layer_info(0, i);
        end loop;
        return length;  -- ritorna solo la parte usata
    end function;

    function get_weight_input_n(X : integer; level : integer; weight : integer) return integer is
        variable layer_info : layer_info_t := (others => (others => 0));
        variable length : integer := 0;
    begin
        layer_info := get_layer_info(X, level - 1);
        return layer_info(0, weight);
    end function;
        

end package body;
            