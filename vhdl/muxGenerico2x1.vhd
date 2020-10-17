LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY muxGenerico2x1 IS
    GENERIC (
        larguraDados : NATURAL := 8
    );
    PORT (
        -- Input ports 
        entradaA_MUX : IN std_logic_vector((larguraDados - 1) DOWNTO 0);
        entradaB_MUX : IN std_logic_vector((larguraDados - 1) DOWNTO 0);
        seletor_MUX  : IN std_logic;

        -- Output ports
        saida_MUX : OUT std_logic_vector((larguraDados - 1) DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE comportamento OF muxGenerico2x1 IS
BEGIN
    -- A saída é determinada pelo valor do "seletor_MUX".
    saida_MUX <= entradaB_MUX WHEN (seletor_MUX = '1') ELSE
        entradaA_MUX;
END ARCHITECTURE;