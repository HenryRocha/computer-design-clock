LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY CPU IS
    GENERIC (
        DATA_WIDTH : NATURAL := 8;
        ADDR_WIDTH : NATURAL := 12
    );
    PORT (
        -- Input ports
        clk : IN std_logic;
        sw  : IN std_logic_vector(9 DOWNTO 0);
        key : IN std_logic_vector(3 DOWNTO 0);

        -- Output ports
        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : OUT std_logic_vector(6 DOWNTO 0) := (OTHERS => '-');

        -- Saidas para debugging
        saidaBancoRegs_DEBUG    : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0) := (OTHERS => '-');
        saidaULA_DEBUG          : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0) := (OTHERS => '-');
        saidaMuxImedDados_DEBUG : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0) := (OTHERS => '-');
        opULA_DEBUG             : OUT std_logic_vector(2 DOWNTO 0)              := (OTHERS => '-');
        opCode_DEBUG            : OUT std_logic_vector(3 DOWNTO 0)              := (OTHERS => '-');
        palavraControle_DEBUG   : OUT std_logic_vector(7 DOWNTO 0)              := (OTHERS => '-');
        programCounter_DEBUG    : OUT std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0) := (OTHERS => '-');
        enderecoRAMROM_DEBUG    : OUT std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0) := (OTHERS => '-');
        flagZero_DEBUG          : OUT std_logic
    );
END ENTITY;

ARCHITECTURE main OF CPU IS
    SIGNAL programCounter  : std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0);
    SIGNAL palavraControle : std_logic_vector(7 DOWNTO 0);
    SIGNAL opCode          : std_logic_vector(3 DOWNTO 0);
    SIGNAL flagZero        : std_logic;

    SIGNAL saidaBancoRegs : std_logic_vector(7 DOWNTO 0);
BEGIN
    FD : ENTITY work.fluxoDados
        GENERIC MAP(
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH
        )
        PORT MAP(
            -- Inputs
            clk             => clk,
            sw              => sw,
            key             => key,
            palavraControle => palavraControle,

            -- Outputs
            flagZero       => flagZero,
            opCode         => opCode,
            programCounter => programCounter,
            HEX0           => HEX0,
            HEX1           => HEX1,
            HEX2           => HEX2,
            HEX3           => HEX3,
            HEX4           => HEX4,
            HEX5           => HEX5,

            -- Saidas para debugging
            saidaBancoRegs_DEBUG    => saidaBancoRegs_DEBUG,
            saidaULA_DEBUG          => saidaULA_DEBUG,
            saidaMuxImedDados_DEBUG => saidaMuxImedDados_DEBUG,
            opULA_DEBUG             => opULA_DEBUG,
            enderecoRAMROM_DEBUG    => enderecoRAMROM_DEBUG
        );

    UC : ENTITY work.unidadeControle
        PORT MAP(
            -- Inputs
            clk      => clk,
            opCode   => opCode,
            flagZero => flagZero,

            -- Outputs
            palavraControle => palavraControle
        );

    -- Saidas para debugging
    palavraControle_DEBUG <= palavraControle;
    programCounter_DEBUG  <= programCounter;
    opCode_DEBUG          <= opCode;
    flagZero_DEBUG        <= flagZero;
END ARCHITECTURE;