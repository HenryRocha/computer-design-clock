LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

ENTITY ULA_tb IS
    GENERIC (
        runner_cfg : STRING  := runner_cfg_default;
        DATA_WIDTH : NATURAL := 8;
        SEL_WIDTH  : NATURAL := 3
    );
END ENTITY;

ARCHITECTURE tb OF ULA_tb IS
    -- Input ports 
    SIGNAL entradaA : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL entradaB : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL operacao : std_logic_vector(SEL_WIDTH - 1 DOWNTO 0);

    -- Output ports
    SIGNAL saida    : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL flagZero : std_logic;

    -- Sinais usado para verificar as saída.
    SIGNAL expectedSaida    : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL expectedFlagZero : std_logic;

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

    ULA : ENTITY work.ULA
        GENERIC MAP(
            larguraDados => DATA_WIDTH
        )
        PORT MAP(
            entradaA => entradaA,
            entradaB => entradaB,
            seletor  => operacao,
            saida    => saida,
            flagZero => flagZero
        );

    main : PROCESS
    BEGIN
        test_runner_setup(runner, runner_cfg);

        WHILE test_suite LOOP
            IF run("soma_zero") THEN
                entradaA      <= "10000001";
                entradaB      <= "10000001";
                operacao      <= "000";
                expectedSaida <= "00000000";

                WAIT UNTIL clk = '1';
                check_equal(saida, expectedSaida);

            ELSIF run("soma") THEN
                entradaA      <= "00000101";
                entradaB      <= "00000101";
                operacao      <= "001";
                expectedSaida <= "00001010";

                WAIT UNTIL clk = '1';
                check_equal(saida, expectedSaida);

            ELSIF run("soma_b_zero") THEN
                entradaA      <= "10000100";
                entradaB      <= "10000001";
                operacao      <= "011";
                expectedSaida <= "10000001";

                WAIT UNTIL clk = '1';
                check_equal(saida, expectedSaida);

            ELSIF run("soma_a_zero") THEN
                entradaA      <= "10000001";
                entradaB      <= "10000100";
                operacao      <= "100";
                expectedSaida <= "10000001";

                WAIT UNTIL clk = '1';
                check_equal(saida, expectedSaida);

            ELSIF run("sub") THEN
                entradaA      <= "10000011";
                entradaB      <= "10000000";
                operacao      <= "010";
                expectedSaida <= "00000011";

                WAIT UNTIL clk = '1';
                check_equal(saida, expectedSaida);

            ELSIF run("and") THEN
                entradaA      <= "10000011";
                entradaB      <= "10000011";
                operacao      <= "110";
                expectedSaida <= "10000011";

                WAIT UNTIL clk = '1';
                check_equal(saida, expectedSaida);

            ELSIF run("or") THEN
                entradaA      <= "10000001";
                entradaB      <= "00000010";
                operacao      <= "101";
                expectedSaida <= "10000011";

                WAIT UNTIL clk = '1';
                check_equal(saida, expectedSaida);
            END IF;
        END LOOP;

        test_runner_cleanup(runner);
    END PROCESS;
END ARCHITECTURE;