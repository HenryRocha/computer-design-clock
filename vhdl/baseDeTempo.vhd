LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY baseDeTempo IS
    GENERIC (
        DATA_WIDTH : NATURAL := 8
    );
    PORT (
        -- Input ports
        clk             : IN std_logic;
        habilitaLeitura : IN std_logic;
        limpaLeitura    : IN std_logic;

        -- Output ports
        leituraUmSegundo : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE interface OF baseDeTempo IS
    -- Sinal que indica se passou um segundo.
    SIGNAL passouUmSegundo : std_logic := '0';

    -- Contador de clocks, usado para verificar se passou o tempo certo.
    SIGNAL contador : INTEGER RANGE 0 TO 100000000 := 0;

    -- Quantos clocks devemos esperar.
    SIGNAL num_clocks : NATURAL := 50000000;
BEGIN
    -- Responsável por fazer a leitura de um clock, aumentar o contador e quando
    -- o contador chegar ao num_clocks, passou o tempo correto.
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF (limpaLeitura = '1') THEN
                contador        <= 0;
                passouUmSegundo <= '0';
            ELSIF contador >= num_clocks THEN
                passouUmSegundo <= '1';
            ELSE
                contador        <= contador + 1;
                passouUmSegundo <= '0';
            END IF;
        END IF;
    END PROCESS;

    -- Mudamos apenas o primeiro bit da saída, retirando a necessidade de um
    -- extensor de sinal no fluxo de dados.
    leituraUmSegundo <= ("0000000" & passouUmSegundo) WHEN habilitaLeitura = '1' ELSE
        (OTHERS => 'Z');
END ARCHITECTURE interface;