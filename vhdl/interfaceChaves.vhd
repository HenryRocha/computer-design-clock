LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY interfaceChaves IS
    GENERIC (
        DATA_WIDTH : NATURAL := 8;
        ADDR_WIDTH : NATURAL := 12
    );
    PORT (
        -- Input ports
        entrada  : IN std_logic_vector(9 DOWNTO 0);
        endereco : IN std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0);
        habilita : IN std_logic;

        -- Output ports
        saida : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE main OF interfaceChaves IS
BEGIN
    -- Apenas o bit 0 da saída será usado. Foi feito desse modo para não ser necessário
    -- o uso do estendeSinalGenerico.
    -- O sinal de saída será o valor lido de cada chave, mas o valor de saída só será
    -- substituido caso o endereço seja o correto e a interface esteja habilitada.
    saida(0) <= entrada(0) WHEN (endereco = "000000000000" AND habilita = '1') ELSE
    entrada(1) WHEN (endereco = "000000000001" AND habilita = '1') ELSE
    entrada(2) WHEN (endereco = "000000000010" AND habilita = '1') ELSE
    entrada(3) WHEN (endereco = "000000000011" AND habilita = '1') ELSE
    entrada(4) WHEN (endereco = "000000000100" AND habilita = '1') ELSE
    entrada(5) WHEN (endereco = "000000000101" AND habilita = '1') ELSE
    entrada(6) WHEN (endereco = "000000000110" AND habilita = '1') ELSE
    entrada(7) WHEN (endereco = "000000000111" AND habilita = '1') ELSE
    entrada(8) WHEN (endereco = "000000001000" AND habilita = '1') ELSE
    entrada(9) WHEN (endereco = "000000001010" AND habilita = '1') ELSE
    '0';
END ARCHITECTURE;