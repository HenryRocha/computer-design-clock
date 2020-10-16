LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY decodificador IS
    GENERIC (
        DATA_WIDTH : NATURAL := 8
    );
    PORT (
        seletor  : IN std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        habilita : OUT std_logic_vector(5 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE comportamento OF decodificador IS
    SIGNAL numSeletor : unsigned(DATA_WIDTH - 1 DOWNTO 0);
BEGIN
    numSeletor(DATA_WIDTH - 1 DOWNTO 0) <= unsigned(seletor);

    habilita(0) <= '1' WHEN numSeletor >= 3072 ELSE
    '0';

    habilita(1) <= '1' WHEN numSeletor >= 2048 AND numSeletor <= 2053 ELSE
    '0';

    habilita(2) <= '1' WHEN numSeletor = 1024 ELSE
    '0';

    habilita(3) <= '1' WHEN numSeletor >= 10 and numSeletor <= 13 ELSE
    '0';

    habilita(4) <= '1' WHEN numSeletor >= 0 and numSeletor <= 9 ELSE
    '0';

    habilita(5) <= '1' WHEN numSeletor = 1025 ELSE
    '0';
END ARCHITECTURE;