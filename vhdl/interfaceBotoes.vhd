LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY interfaceBotoes IS
    GENERIC (
        DATA_WIDTH : NATURAL := 8;
        ADDR_WIDTH : NATURAL := 12
    );
    PORT (
        entrada  : IN std_logic_vector(3 DOWNTO 0);
        endereco : IN std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0);
        habilita : IN std_logic;
        saida    : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE main OF interfaceBotoes IS
    SIGNAL temp : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
BEGIN
    WITH endereco SELECT
        temp(0) <= entrada(0) WHEN "000000001010",
        entrada(1) WHEN "000000001011",
        entrada(2) WHEN "000000001100",
        entrada(3) WHEN "000000001101",
        '0' WHEN OTHERS;

    saida <= temp WHEN (habilita = '1') ELSE
        (OTHERS => 'Z');
END ARCHITECTURE;