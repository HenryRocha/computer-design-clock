LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY interfaceHEX IS
    GENERIC (
        DATA_WIDTH : NATURAL := 8;
        ADDR_WIDTH : NATURAL := 8
    );
    PORT (
        -- Input ports
        endereco : IN std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0);
        habilita : IN std_logic := '0';
        dados    : IN std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        -- Output ports
        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : OUT std_logic_vector(6 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE main OF interfaceHEX IS
    SIGNAL interHEX0 : std_logic_vector(6 DOWNTO 0);
    SIGNAL interHEX1 : std_logic_vector(6 DOWNTO 0);
    SIGNAL interHEX2 : std_logic_vector(6 DOWNTO 0);
    SIGNAL interHEX3 : std_logic_vector(6 DOWNTO 0);
    SIGNAL interHEX4 : std_logic_vector(6 DOWNTO 0);
    SIGNAL interHEX5 : std_logic_vector(6 DOWNTO 0);
BEGIN
    conversorHex0 : ENTITY work.conversorHex7Seg
        PORT MAP(
            dadoHex   => dados(3 DOWNTO 0),
            apaga     => '0',
            negativo  => '0',
            overFlow  => '0',
            saida7seg => interHEX0
        );

    conversorHex1 : ENTITY work.conversorHex7Seg
        PORT MAP(
            dadoHex   => dados(7 DOWNTO 4),
            apaga     => '0',
            negativo  => '0',
            overFlow  => '0',
            saida7seg => interHEX1
        );

    conversorHex2 : ENTITY work.conversorHex7Seg
        PORT MAP(
            dadoHex   => dados(3 DOWNTO 0),
            apaga     => '0',
            negativo  => '0',
            overFlow  => '0',
            saida7seg => interHEX2
        );

    conversorHex3 : ENTITY work.conversorHex7Seg
        PORT MAP(
            dadoHex   => dados(7 DOWNTO 4),
            apaga     => '0',
            negativo  => '0',
            overFlow  => '0',
            saida7seg => interHEX3
        );

    conversorHex4 : ENTITY work.conversorHex7Seg
        PORT MAP(
            dadoHex   => dados(3 DOWNTO 0),
            apaga     => '0',
            negativo  => '0',
            overFlow  => '0',
            saida7seg => interHEX4);

    conversorHex5 : ENTITY work.conversorHex7Seg
        PORT MAP(
            dadoHex   => dados(7 DOWNTO 4),
            apaga     => '0',
            negativo  => '0',
            overFlow  => '0',
            saida7seg => interHEX5
        );

    HEX0 <= interHEX0 WHEN (endereco = "100000000000" AND habilita = '1') ELSE
        (OTHERS => 'Z');

    HEX1 <= interHEX1 WHEN (endereco = "100000000000" AND habilita = '1') ELSE
        (OTHERS => 'Z');

    HEX2 <= interHEX2 WHEN (endereco = "100000000001" AND habilita = '1') ELSE
        (OTHERS => 'Z');

    HEX3 <= interHEX3 WHEN (endereco = "100000000001" AND habilita = '1') ELSE
        (OTHERS => 'Z');

    HEX4 <= interHEX4 WHEN (endereco = "100000000010" AND habilita = '1') ELSE
        (OTHERS => 'Z');

    HEX5 <= interHEX5 WHEN (endereco = "100000000010" AND habilita = '1') ELSE
        (OTHERS => 'Z');
END ARCHITECTURE;