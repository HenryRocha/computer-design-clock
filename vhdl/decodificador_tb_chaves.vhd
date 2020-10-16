LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

ENTITY decodificador_tb_chaves IS
    GENERIC (
        runner_cfg : STRING := runner_cfg_default
    );
END ENTITY;

ARCHITECTURE tb OF decodificador_tb_chaves IS
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
            IF run("habLeitura_sw0") THEN
                enderecoRAMROM           <= "000000000000";
                expControleDecodificador <= "010000";
                WAIT UNTIL clk = '1';
                check_equal(controleDecodificador, expControleDecodificador);
            ELSIF run("habLeitura_sw1") THEN
                enderecoRAMROM           <= "000000000001";
                expControleDecodificador <= "010000";
                WAIT UNTIL clk = '1';
                check_equal(controleDecodificador, expControleDecodificador);
            ELSIF run("habLeitura_sw2") THEN
                enderecoRAMROM           <= "000000000010";
                expControleDecodificador <= "010000";
                WAIT UNTIL clk = '1';
                check_equal(controleDecodificador, expControleDecodificador);
            ELSIF run("habLeitura_sw3") THEN
                enderecoRAMROM           <= "000000000011";
                expControleDecodificador <= "010000";
                WAIT UNTIL clk = '1';
                check_equal(controleDecodificador, expControleDecodificador);
            ELSIF run("habLeitura_sw4") THEN
                enderecoRAMROM           <= "000000000100";
                expControleDecodificador <= "010000";
                WAIT UNTIL clk = '1';
                check_equal(controleDecodificador, expControleDecodificador);
            ELSIF run("habLeitura_sw5") THEN
                enderecoRAMROM           <= "000000000101";
                expControleDecodificador <= "010000";
                WAIT UNTIL clk = '1';
                check_equal(controleDecodificador, expControleDecodificador);
            ELSIF run("habLeitura_sw6") THEN
                enderecoRAMROM           <= "000000000110";
                expControleDecodificador <= "010000";
                WAIT UNTIL clk = '1';
                check_equal(controleDecodificador, expControleDecodificador);
            ELSIF run("habLeitura_sw7") THEN
                enderecoRAMROM           <= "000000000111";
                expControleDecodificador <= "010000";
                WAIT UNTIL clk = '1';
                check_equal(controleDecodificador, expControleDecodificador);
            ELSIF run("habLeitura_sw8") THEN
                enderecoRAMROM           <= "000000001000";
                expControleDecodificador <= "010000";
                WAIT UNTIL clk = '1';
                check_equal(controleDecodificador, expControleDecodificador);
            ELSIF run("habLeitura_sw9") THEN
                enderecoRAMROM           <= "000000001001";
                expControleDecodificador <= "010000";
                WAIT UNTIL clk = '1';
                check_equal(controleDecodificador, expControleDecodificador);
            END IF;
        END LOOP;

        test_runner_cleanup(runner);
    END PROCESS;
END ARCHITECTURE;