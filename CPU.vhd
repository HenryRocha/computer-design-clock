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
        clk : IN std_logic;
        sw  : IN std_logic_vector(9 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE main OF CPU IS
    SIGNAL programCounter  : std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0);
    SIGNAL palavraControle : std_logic_vector(7 DOWNTO 0);
    SIGNAL opCode          : std_logic_vector(3 DOWNTO 0);
    SIGNAL flagZero        : std_logic;
BEGIN
    FD : ENTITY work.fluxoDados
        GENERIC MAP(
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH
        )
        PORT MAP(
            clk             => clk,
            sw              => sw,
            palavraControle => palavraControle,
            opCode          => opCode,
            programCounter  => programCounter
        );

    UC : ENTITY work.unidadeControle
        PORT MAP(
            palavraControle => palavraControle,
            flagZero        => flagZero,
            opCode          => opCode,
            clk             => clk
        );
END ARCHITECTURE;