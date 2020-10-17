LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY interfaceBotoes IS
    GENERIC (
        DATA_WIDTH : NATURAL := 8;
        ADDR_WIDTH : NATURAL := 12;
        BTNS_WIDTH : NATURAL := 4
    );
    PORT (
        -- Input ports
        entrada  : IN std_logic_vector(BTNS_WIDTH - 1 DOWNTO 0);
        endereco : IN std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0);
        habilita : IN std_logic;

        -- Output ports
        saida : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE main OF interfaceBotoes IS
    SIGNAL saidaTemp : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
BEGIN
    -- Apenas o bit 0 da saída será usado. Foi feito desse modo para não ser necessário
    -- o uso do estendeSinalGenerico.
    -- O sinal de saída será o valor lido de cada chave, mas o valor de saída só será
    -- substituido caso o endereço seja o correto e a interface esteja habilitada.
    WITH endereco SELECT
        saidaTemp(0) <= entrada(0) WHEN "000000001010",
        entrada(1) WHEN "000000001011",
        entrada(2) WHEN "000000001100",
        entrada(3) WHEN "000000001101",
        '0' WHEN OTHERS;

    saida <= saidaTemp WHEN (habilita = '1') ELSE
        (OTHERS => 'Z');
END ARCHITECTURE;