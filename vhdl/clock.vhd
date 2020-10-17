LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY clock IS
    GENERIC (
        DATA_WIDTH : NATURAL := 8;
        ADDR_WIDTH : NATURAL := 12
    );
    PORT (
        -- Input ports
        CLOCK_50     : IN std_logic;
        SW           : IN std_logic_vector(9 DOWNTO 0);
        KEY          : IN std_logic_vector(3 DOWNTO 0);
        FPGA_RESET_N : IN std_logic;

        -- Output ports
        LEDR                               : OUT std_logic_vector(9 DOWNTO 0);
        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : OUT std_logic_vector(6 DOWNTO 0);

        -- Saidas para debugging
        saidaBancoRegs       : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        saidaULA             : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        saidaMuxImedDados    : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        opULA                : OUT std_logic_vector(2 DOWNTO 0);
        opCode               : OUT std_logic_vector(3 DOWNTO 0);
        palavraControle      : OUT std_logic_vector(7 DOWNTO 0);
        programCounter       : OUT std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0);
        enderecoRAMROM_DEBUG : OUT std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0);
        flagZero_DEBUG       : OUT std_logic
    );
END ENTITY;

ARCHITECTURE main OF clock IS
    SIGNAL clk : std_logic;
BEGIN
    detectorSub0 : ENTITY work.edgeDetector(bordaSubida)
        PORT MAP(
            clk     => CLOCK_50,
            entrada => (NOT FPGA_RESET_N),
            saida   => clk
        );

    CPU : ENTITY work.CPU
        GENERIC MAP(
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH
        )
        PORT MAP(
            -- Inputs
            clk => clk,
            sw  => SW,
            key => KEY,

            -- Outputs
            HEX0 => HEX0,
            HEX1 => HEX1,
            HEX2 => HEX2,
            HEX3 => HEX3,
            HEX4 => HEX4,
            HEX5 => HEX5,

            -- Saidas para debugging
            saidaBancoRegs_DEBUG    => saidaBancoRegs,
            saidaULA_DEBUG          => saidaULA,
            saidaMuxImedDados_DEBUG => saidaMuxImedDados,
            opULA_DEBUG             => opULA,
            opCode_DEBUG            => opCode,
            palavraControle_DEBUG   => palavraControle,
            programCounter_DEBUG    => programCounter,
            enderecoRAMROM_DEBUG    => enderecoRAMROM_DEBUG,
            flagZero_DEBUG          => flagZero_DEBUG
        );

    LEDR(5 DOWNTO 0) <= SW(5 DOWNTO 0);
    LEDR(9 DOWNTO 6) <= NOT KEY(3 DOWNTO 0);
END ARCHITECTURE;