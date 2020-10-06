LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY unidadeControle IS
    PORT (
        -- Input ports
        clk      : IN std_logic;
        opcode   : IN std_logic_vector(3 DOWNTO 0);
        flagZero : IN std_logic;

        -- Output ports
        palavraControle : OUT std_logic_vector(7 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE main OF unidadeControle IS
    ALIAS muxProxPC     : std_logic IS palavraControle(7);
    ALIAS muxImedDados  : std_logic IS palavraControle(6);
    ALIAS habEscritaReg : std_logic IS palavraControle(5);
    ALIAS operacao      : std_logic_vector(2 DOWNTO 0) IS palavraControle(4 DOWNTO 2);
    ALIAS habLeituraRAM : std_logic IS palavraControle(1);
    ALIAS habEscritaRAM : std_logic IS palavraControle(0);

    SIGNAL instrucao    : std_logic_vector(12 DOWNTO 0);
    CONSTANT opcodeAdd  : std_logic_vector(3 DOWNTO 0) := "0000";
    CONSTANT opcodeAddi : std_logic_vector(3 DOWNTO 0) := "0001";
    CONSTANT opcodeSub  : std_logic_vector(3 DOWNTO 0) := "0010";
    CONSTANT opcodeSubi : std_logic_vector(3 DOWNTO 0) := "0011";
    CONSTANT opcodeMovm : std_logic_vector(3 DOWNTO 0) := "0100";
    CONSTANT opcodeMovr : std_logic_vector(3 DOWNTO 0) := "0101";
    CONSTANT opcodeLea  : std_logic_vector(3 DOWNTO 0) := "0110";
    CONSTANT opcodeCmp  : std_logic_vector(3 DOWNTO 0) := "0111";
    CONSTANT opcodeJE   : std_logic_vector(3 DOWNTO 0) := "1000";
    CONSTANT opcodeJNE  : std_logic_vector(3 DOWNTO 0) := "1001";
    CONSTANT opcodeJMP  : std_logic_vector(3 DOWNTO 0) := "1010";
    CONSTANT opcodeOr   : std_logic_vector(3 DOWNTO 0) := "1011";
    CONSTANT opcodeAnd  : std_logic_vector(3 DOWNTO 0) := "1100";

    ALIAS add     : std_logic IS instrucao(0);
    ALIAS addi    : std_logic IS instrucao(1);
    ALIAS sub     : std_logic IS instrucao(2);
    ALIAS subi    : std_logic IS instrucao(3);
    ALIAS movm    : std_logic IS instrucao(4);
    ALIAS movr    : std_logic IS instrucao(5);
    ALIAS lea     : std_logic IS instrucao(6);
    ALIAS cmp     : std_logic IS instrucao(7);
    ALIAS je      : std_logic IS instrucao(8);
    ALIAS jne     : std_logic IS instrucao(9);
    ALIAS jmp     : std_logic IS instrucao(10);
    ALIAS instOR  : std_logic IS instrucao(11);
    ALIAS instAND : std_logic IS instrucao(12);
BEGIN
    WITH opcode SELECT
        instrucao <= "0000000000001" WHEN opcodeAdd,
        "0000000000010" WHEN opcodeAddi,
        "0000000000100" WHEN opcodeSub,
        "0000000001000" WHEN opcodeSubi,
        "0000000010000" WHEN opcodeMovm,
        "0000000100000" WHEN opcodeMovr,
        "0000001000000" WHEN opcodeLea,
        "0000010000000" WHEN opcodeCmp,
        "0000100000000" WHEN opcodeJE,
        "0001000000000" WHEN opcodeJNE,
        "0010000000000" WHEN opcodeJMP,
        "0100000000000" WHEN opcodeOr,
        "1000000000000" WHEN opcodeAnd,
        "0000000000000" WHEN OTHERS;

    muxProxPC <= jmp OR (je AND flagZero) OR (jne AND (NOT flagZero));

    muxImedDados <= add OR sub OR movm OR instOR OR instAND;

    habEscritaReg <= add OR addi OR sub OR subi OR movm OR lea OR cmp OR instOR OR instAND;

    WITH opcode SELECT
        operacao <= "000" WHEN opcodeLea,
        "000" WHEN opcodeMovm,
        "001" WHEN opcodeAdd,
        "001" WHEN opcodeAddi,
        "001" WHEN opcodeJMP,
        "001" WHEN opcodeJE,
        "001" WHEN opcodeJNE,
        "010" WHEN opcodeCmp,
        "010" WHEN opcodeSub,
        "010" WHEN opcodeSubi,
        "100" WHEN opcodeMovr,
        "101" WHEN opcodeOr,
        "110" WHEN opcodeAnd,
        "000" WHEN OTHERS;

    habLeituraRAM <= add OR sub OR movm OR instOR OR instAND;

    habEscritaRAM <= movr;
END ARCHITECTURE;