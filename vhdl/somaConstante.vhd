LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY somaConstante IS
    GENERIC (
        larguraDados : NATURAL := 32;
        constante    : NATURAL := 4
    );
    PORT (
        -- Input ports
        entrada : IN STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0);

        -- Output ports
        saida : OUT STD_LOGIC_VECTOR((larguraDados - 1) DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE comportamento OF somaConstante IS
BEGIN
    -- A saída é a soma da entrada com a constante.
    saida <= std_logic_vector(unsigned(entrada) + constante);
END ARCHITECTURE;