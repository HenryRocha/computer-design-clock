LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY interfaceChaves IS
    GENERIC (
        DATA_WIDTH : NATURAL := 8;
        ADDR_WIDTH : NATURAL := 12
    );
    PORT (
        entrada  : IN std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        endereco : IN std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0);
        habilita : IN std_logic;
        saida    : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE main OF interfaceChaves IS
    SIGNAL temp : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
BEGIN
    WITH endereco SELECT
        temp(0) <= entrada(0) WHEN "000000000000",
        entrada(1) WHEN "000000000001",
        entrada(2) WHEN "000000000010",
        entrada(3) WHEN "000000000011",
        entrada(4) WHEN "000000000100",
        entrada(5) WHEN "000000000101",
        entrada(6) WHEN "000000000110",
        entrada(7) WHEN "000000000111",
        entrada(8) WHEN "000000001000",
        '0' WHEN OTHERS;

    saida <= temp WHEN (habilita = '1') ELSE
        (OTHERS => 'Z');
END ARCHITECTURE;