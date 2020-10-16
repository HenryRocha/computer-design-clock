LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

ENTITY decodificador_tb_hex IS
    GENERIC (
        runner_cfg : STRING := runner_cfg_default
    );
END ENTITY;

ARCHITECTURE tb OF decodificador_tb_hex IS
    -- Inputs and ouputs
    SIGNAL enderecoRAMROM           : std_logic_vector(11 DOWNTO 0);
    SIGNAL controleDecodificador    : std_logic_vector(5 DOWNTO 0);
    SIGNAL expControleDecodificador : std_logic_vector(5 DOWNTO 0);

    -- Clock
    CONSTANT CLK_PERIOD : TIME      := 1 ns;
    SIGNAL clk          : STD_LOGIC := '0';
BEGIN
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    decodificador : ENTITY work.decodificador
        GENERIC MAP(
            DATA_WIDTH => 12
        )
        PORT MAP(
            seletor  => enderecoRAMROM,
            habilita => controleDecodificador
        );

    main : PROCESS
    BEGIN
        test_runner_setup(runner, runner_cfg);

        WHILE test_suite LOOP
            IF run("habEscrita_hex0_hex1") THEN
                enderecoRAMROM           <= std_logic_vector(to_unsigned(2048, 12));
                expControleDecodificador <= "000010";
                WAIT UNTIL clk = '1';
                check_equal(controleDecodificador, expControleDecodificador);
            ELSIF run("habEscrita_hex2_hex3") THEN
                enderecoRAMROM           <= std_logic_vector(to_unsigned(2049, 12));
                expControleDecodificador <= "000010";
                WAIT UNTIL clk = '1';
                check_equal(controleDecodificador, expControleDecodificador);
            ELSIF run("habEscrita_hex4_hex5") THEN
                enderecoRAMROM           <= std_logic_vector(to_unsigned(2050, 12));
                expControleDecodificador <= "000010";
                WAIT UNTIL clk = '1';
                check_equal(controleDecodificador, expControleDecodificador);
            END IF;
        END LOOP;

        test_runner_cleanup(runner);
    END PROCESS;
END ARCHITECTURE;