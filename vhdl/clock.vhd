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
        programCounter                     : OUT std_logic_vector(11 DOWNTO 0);
        opCode                             : OUT std_logic_vector(3 DOWNTO 0);
        saidaBancoRegs                     : OUT std_logic_vector(7 DOWNTO 0);
        palavraControleOUT                 : OUT std_logic_vector(7 DOWNTO 0);
        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : OUT std_logic_vector(6 DOWNTO 0)
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
            clk                => clk,
            sw                 => SW,
            key                => KEY,
            HEX0               => HEX0,
            HEX1               => HEX1,
            HEX2               => HEX2,
            HEX3               => HEX3,
            HEX4               => HEX4,
            HEX5               => HEX5,
            programCounterOUT  => programCounter,
            opCodeOUT          => opCode,
            saidaBancoRegsOUT  => saidaBancoRegs,
            palavraControleOUT => palavraControleOUT
        );

    LEDR(5 DOWNTO 0) <= SW(5 DOWNTO 0);
    LEDR(9 DOWNTO 6) <= NOT KEY(3 DOWNTO 0);
END ARCHITECTURE;