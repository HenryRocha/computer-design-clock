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
    SIGNAL saidaTemp : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
BEGIN
    -- Apenas o bit 0 da saída será usado. Foi feito desse modo para não ser necessário
    -- o uso do estendeSinalGenerico.
    -- O sinal de saída será o valor lido de cada chave, mas o valor de saída só será
    -- substituido caso o endereço seja o correto e a interface esteja habilitada.
    WITH endereco SELECT
        saidaTemp(0) <= entrada(0) WHEN "000000000000",
        entrada(1) WHEN "000000000001",
        entrada(2) WHEN "000000000010",
        entrada(3) WHEN "000000000011",
        entrada(4) WHEN "000000000100",
        entrada(5) WHEN "000000000101",
        entrada(6) WHEN "000000000110",
        entrada(7) WHEN "000000000111",
        entrada(8) WHEN "000000001000",
        entrada(9) WHEN "000000001010",
        '0' WHEN OTHERS;

    saida <= saidaTemp WHEN (habilita = '1') ELSE
        (OTHERS => 'Z');
END ARCHITECTURE;