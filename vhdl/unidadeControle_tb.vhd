LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

ENTITY unidadeControle_tb IS
    GENERIC (
        runner_cfg : STRING := runner_cfg_default
    );
END ENTITY;

ARCHITECTURE tb OF unidadeControle_tb IS
    -- Inputs and ouputs
    SIGNAL palavraControle, expectedPalavraControle : std_logic_vector(7 DOWNTO 0);
    SIGNAL opCode                                   : std_logic_vector(3 DOWNTO 0);
    SIGNAL flagZero                                 : std_logic;

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

    UC : ENTITY work.unidadeControle
        PORT MAP(
            palavraControle => palavraControle,
            flagZero        => flagZero,
            opCode          => opCode,
            clk             => clk
        );

    main : PROCESS
    BEGIN
        test_runner_setup(runner, runner_cfg);

        WHILE test_suite LOOP
            IF run("test_ADD") THEN
                opCode                  <= "0000";
                flagZero                <= '0';
                expectedPalavraControle <= "01100110";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);
            ELSIF run("test_ADD_FZ") THEN
                opCode                  <= "0000";
                flagZero                <= '1';
                expectedPalavraControle <= "01100110";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);

            ELSIF run("test_ADDI") THEN
                opCode                  <= "0001";
                flagZero                <= '0';
                expectedPalavraControle <= "00100100";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);
            ELSIF run("test_ADDI_FZ") THEN
                opCode                  <= "0001";
                flagZero                <= '1';
                expectedPalavraControle <= "00100100";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);

            ELSIF run("test_SUB") THEN
                opCode                  <= "0010";
                flagZero                <= '0';
                expectedPalavraControle <= "01101010";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);
            ELSIF run("test_SUB_FZ") THEN
                opCode                  <= "0010";
                flagZero                <= '1';
                expectedPalavraControle <= "01101010";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);

            ELSIF run("test_SUBI") THEN
                opCode                  <= "0011";
                flagZero                <= '0';
                expectedPalavraControle <= "00101000";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);
            ELSIF run("test_SUBI_FZ") THEN
                opCode                  <= "0011";
                flagZero                <= '1';
                expectedPalavraControle <= "00101000";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);

            ELSIF run("test_MOVM") THEN
                opCode                  <= "0100";
                flagZero                <= '0';
                expectedPalavraControle <= "01101110";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);

            ELSIF run("test_MOVM_FZ") THEN
                opCode                  <= "0100";
                flagZero                <= '1';
                expectedPalavraControle <= "01101110";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);

            ELSIF run("test_MOVR") THEN
                opCode                  <= "0101";
                flagZero                <= '0';
                expectedPalavraControle <= "00010001";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);
            ELSIF run("test_MOVR_FZ") THEN
                opCode                  <= "0101";
                flagZero                <= '1';
                expectedPalavraControle <= "00010001";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);

            ELSIF run("test_LEA") THEN
                opCode                  <= "0110";
                flagZero                <= '0';
                expectedPalavraControle <= "00101100";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);
            ELSIF run("test_LEA_FZ") THEN
                opCode                  <= "0110";
                flagZero                <= '1';
                expectedPalavraControle <= "00101100";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);

            ELSIF run("test_CMP") THEN
                opCode                  <= "0111";
                flagZero                <= '0';
                expectedPalavraControle <= "00101000";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);
            ELSIF run("test_CMP_FZ") THEN
                opCode                  <= "0111";
                flagZero                <= '1';
                expectedPalavraControle <= "00101000";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);

            ELSIF run("test_JE") THEN
                opCode                  <= "1000";
                flagZero                <= '0';
                expectedPalavraControle <= "00000100";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);
            ELSIF run("test_JE_FZ") THEN
                opCode                  <= "1000";
                flagZero                <= '1';
                expectedPalavraControle <= "10000100";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);

            ELSIF run("test_JNE") THEN
                opCode                  <= "1001";
                flagZero                <= '0';
                expectedPalavraControle <= "10000100";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);
            ELSIF run("test_JNE_FZ") THEN
                opCode                  <= "1001";
                flagZero                <= '1';
                expectedPalavraControle <= "00000100";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);

            ELSIF run("test_JMP") THEN
                opCode                  <= "1010";
                flagZero                <= '0';
                expectedPalavraControle <= "10000100";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);
            ELSIF run("test_JMP_FZ") THEN
                opCode                  <= "1010";
                flagZero                <= '1';
                expectedPalavraControle <= "10000100";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);

            ELSIF run("test_OR") THEN
                opCode                  <= "1011";
                flagZero                <= '0';
                expectedPalavraControle <= "01110110";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);
            ELSIF run("test_OR_FZ") THEN
                opCode                  <= "1011";
                flagZero                <= '1';
                expectedPalavraControle <= "01110110";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);

            ELSIF run("test_AND") THEN
                opCode                  <= "1100";
                flagZero                <= '0';
                expectedPalavraControle <= "01111010";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);
            ELSIF run("test_AND_FZ") THEN
                opCode                  <= "1100";
                flagZero                <= '1';
                expectedPalavraControle <= "01111010";
                WAIT UNTIL clk = '1';
                check_equal(palavraControle, expectedPalavraControle);

            END IF;
        END LOOP;

        test_runner_cleanup(runner);
    END PROCESS;
END ARCHITECTURE;