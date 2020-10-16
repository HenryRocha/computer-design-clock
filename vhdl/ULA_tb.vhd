LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

ENTITY ULA_tb IS
    GENERIC (
        runner_cfg : STRING := runner_cfg_default
    );
END ENTITY;

ARCHITECTURE tb OF ULA_tb IS
    CONSTANT DATA_WIDTH : NATURAL := 8;
    -- Inputs and ouputs
    SIGNAL muxImedDados_out, bancoReg_out, ULA_out, expectedResult : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL operacao                                                : std_logic_vector(2 DOWNTO 0);
    SIGNAL flagZero                                                : std_logic;

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
            entradaA => muxImedDados_out,
            entradaB => bancoReg_out,
            seletor  => operacao,
            saida    => ULA_out,
            flagZero => flagZero
        );

    main : PROCESS
    BEGIN
        test_runner_setup(runner, runner_cfg);

        WHILE test_suite LOOP
            IF run("test_ADD") THEN
                muxImedDados_out <= "00000000";
                bancoReg_out     <= "00000000";
                operacao         <= "011";
                expectedResult   <= "01100110";
                WAIT UNTIL clk = '1';
                ASSERT(ULA_out = expectedResult)
                REPORT (
                    "ULA_out mismatch. Expected: "
                    & to_string(expectedResult)
                    & ". Got: "
                    & to_string(ULA_out))
                    SEVERITY error;
            END IF;
        END LOOP;

        test_runner_cleanup(runner);
    END PROCESS;
END ARCHITECTURE;