LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY CPU IS
    GENERIC (
        DATA_WIDTH : NATURAL := 16;
        ADDR_WIDTH : NATURAL := 12
    );
    PORT (
        -- Input ports
        clk : IN std_logic
    );
END ENTITY;

ARCHITECTURE main OF CPU IS
    SIGNAL palavraControle : std_logic_vector(7 DOWNTO 0);
    SIGNAL opCode          : std_logic_vector(3 DOWNTO 0);
    SIGNAL flagZero        : std_logic;
BEGIN
    UC : ENTITY work.unidadeControle
        PORT MAP(
            palavraControle => palavraControle,
            flagZero        => flagZero,
            opCode          => opCode,
            clk             => clk
        );
END ARCHITECTURE;