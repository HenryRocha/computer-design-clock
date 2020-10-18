LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY decodificador IS
    GENERIC (
        DATA_WIDTH   : NATURAL := 8;
        OPCODE_WIDTH : NATURAL := 4;
        NUM_BLOCOS   : NATURAL := 6
    );
    PORT (
        -- Input ports
        seletor : IN std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        opCode  : IN std_logic_vector(OPCODE_WIDTH - 1 DOWNTO 0);

        -- Output ports
        habilita : OUT std_logic_vector(5 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE comportamento OF decodificador IS
    -- Sinal usado para guardar o valor do seletor em decimal.
    SIGNAL numSeletor : unsigned(DATA_WIDTH - 1 DOWNTO 0);

    -- Variável que indica se deve habilitar as interfaces ou não.
    SIGNAL deveHabilitar : std_logic;

    -- Declarando todas as intruções da CPU e seus OpCodes.
    CONSTANT opcodeAdd  : std_logic_vector(OPCODE_WIDTH - 1 DOWNTO 0) := "0000";
    CONSTANT opcodeAddi : std_logic_vector(OPCODE_WIDTH - 1 DOWNTO 0) := "0001";
    CONSTANT opcodeSub  : std_logic_vector(OPCODE_WIDTH - 1 DOWNTO 0) := "0010";
    CONSTANT opcodeSubi : std_logic_vector(OPCODE_WIDTH - 1 DOWNTO 0) := "0011";
    CONSTANT opcodeMovm : std_logic_vector(OPCODE_WIDTH - 1 DOWNTO 0) := "0100";
    CONSTANT opcodeMovr : std_logic_vector(OPCODE_WIDTH - 1 DOWNTO 0) := "0101";
    CONSTANT opcodeLea  : std_logic_vector(OPCODE_WIDTH - 1 DOWNTO 0) := "0110";
    CONSTANT opcodeCmp  : std_logic_vector(OPCODE_WIDTH - 1 DOWNTO 0) := "0111";
    CONSTANT opcodeJE   : std_logic_vector(OPCODE_WIDTH - 1 DOWNTO 0) := "1000";
    CONSTANT opcodeJNE  : std_logic_vector(OPCODE_WIDTH - 1 DOWNTO 0) := "1001";
    CONSTANT opcodeJMP  : std_logic_vector(OPCODE_WIDTH - 1 DOWNTO 0) := "1010";
    CONSTANT opcodeOr   : std_logic_vector(OPCODE_WIDTH - 1 DOWNTO 0) := "1011";
    CONSTANT opcodeAnd  : std_logic_vector(OPCODE_WIDTH - 1 DOWNTO 0) := "1100";
BEGIN
    -- Tranformando o seletor recebido em decimal.
    numSeletor(DATA_WIDTH - 1 DOWNTO 0) <= unsigned(seletor);

    -- Decide se habilita o decodificador baseado na instrução sendo executada.
    deveHabilitar <= '1' WHEN (opCode = opcodeMovm);

    -- Verificando qual instrução deve ser executada. Dependendo de qual for
    -- não devemos habilitar nenhuma interface.
    habilita(0) <= '1' WHEN (numSeletor >= 3072) ELSE
    '0';

    habilita(1) <= '1' WHEN numSeletor >= 2048 AND numSeletor <= 2050 ELSE
    '0';

    habilita(2) <= '1' WHEN numSeletor = 1024 ELSE
    '0';

    habilita(3) <= '1' WHEN numSeletor >= 10 AND numSeletor <= 13 ELSE
    '0';

    habilita(4) <= '1' WHEN numSeletor >= 0 AND numSeletor <= 9 ELSE
    '0';

    habilita(5) <= '1' WHEN numSeletor = 1025 ELSE
    '0';
END ARCHITECTURE;