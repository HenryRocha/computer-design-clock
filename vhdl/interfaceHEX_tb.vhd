LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

ENTITY interfaceHEX_tb IS
    GENERIC (
        runner_cfg : STRING := runner_cfg_default
    );
END ENTITY;

ARCHITECTURE tb OF interfaceHEX_tb IS
    -- Inputs and ouputs
    SIGNAL enderecoRAMROM                                       : std_logic_vector(11 DOWNTO 0);
    SIGNAL habBarramentoEscritaChaves                           : std_logic;
    SIGNAL dados                                                : std_logic_vector(7 DOWNTO 0);
    SIGNAL HEX0, HEX1, HEX2, HEX3, HEX4, HEX5                   : std_logic_vector(6 DOWNTO 0);
    SIGNAL expHEX0, expHEX1, expHEX2, expHEX3, expHEX4, expHEX5 : std_logic_vector(6 DOWNTO 0);

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

    intHEX : ENTITY work.interfaceHEX
        GENERIC MAP(
            DATA_WIDTH => 8,
            ADDR_WIDTH => 12
        )
        PORT MAP(
            endereco => enderecoRAMROM,
            habilita => habBarramentoEscritaChaves,
            dados    => dados,
            HEX0     => HEX0,
            HEX1     => HEX1,
            HEX2     => HEX2,
            HEX3     => HEX3,
            HEX4     => HEX4,
            HEX5     => HEX5
        );

    main : PROCESS
    BEGIN
        test_runner_setup(runner, runner_cfg);

        WHILE test_suite LOOP
            IF run("w1_hex0_hex1") THEN
                enderecoRAMROM             <= "100000000000";
                habBarramentoEscritaChaves <= '1';
                dados                      <= "00000001";
                expHEX0                    <= "1111001";
                expHEX1                    <= "1000000";
                expHEX2                    <= "ZZZZZZZ";
                expHEX3                    <= "ZZZZZZZ";
                expHEX4                    <= "ZZZZZZZ";
                expHEX5                    <= "ZZZZZZZ";
                WAIT UNTIL clk = '1';
                check_equal(HEX0, expHEX0);
                check_equal(HEX1, expHEX1);
                check_equal(HEX2, expHEX2);
                check_equal(HEX3, expHEX3);
                check_equal(HEX4, expHEX4);
                check_equal(HEX5, expHEX5);
            ELSIF run("w1_hex0_hex1_semHab") THEN
                enderecoRAMROM             <= "100000000000";
                habBarramentoEscritaChaves <= '0';
                dados                      <= "00000001";
                expHEX0                    <= "ZZZZZZZ";
                expHEX1                    <= "ZZZZZZZ";
                expHEX2                    <= "ZZZZZZZ";
                expHEX3                    <= "ZZZZZZZ";
                expHEX4                    <= "ZZZZZZZ";
                expHEX5                    <= "ZZZZZZZ";
                WAIT UNTIL clk = '1';
                check_equal(HEX0, expHEX0);
                check_equal(HEX1, expHEX1);
                check_equal(HEX2, expHEX2);
                check_equal(HEX3, expHEX3);
                check_equal(HEX4, expHEX4);
                check_equal(HEX5, expHEX5);

            ELSIF run("w1_hex2_hex3") THEN
                enderecoRAMROM             <= "100000000001";
                habBarramentoEscritaChaves <= '1';
                dados                      <= "00000001";
                expHEX0                    <= "ZZZZZZZ";
                expHEX1                    <= "ZZZZZZZ";
                expHEX2                    <= "1111001";
                expHEX3                    <= "1000000";
                expHEX4                    <= "ZZZZZZZ";
                expHEX5                    <= "ZZZZZZZ";
                WAIT UNTIL clk = '1';
                check_equal(HEX0, expHEX0);
                check_equal(HEX1, expHEX1);
                check_equal(HEX2, expHEX2);
                check_equal(HEX3, expHEX3);
                check_equal(HEX4, expHEX4);
                check_equal(HEX5, expHEX5);
            ELSIF run("w1_hex2_hex3_semHab") THEN
                enderecoRAMROM             <= "100000000001";
                habBarramentoEscritaChaves <= '0';
                dados                      <= "00000001";
                expHEX0                    <= "ZZZZZZZ";
                expHEX1                    <= "ZZZZZZZ";
                expHEX2                    <= "ZZZZZZZ";
                expHEX3                    <= "ZZZZZZZ";
                expHEX4                    <= "ZZZZZZZ";
                expHEX5                    <= "ZZZZZZZ";
                WAIT UNTIL clk = '1';
                check_equal(HEX0, expHEX0);
                check_equal(HEX1, expHEX1);
                check_equal(HEX2, expHEX2);
                check_equal(HEX3, expHEX3);
                check_equal(HEX4, expHEX4);
                check_equal(HEX5, expHEX5);

            ELSIF run("w1_hex4_hex5") THEN
                enderecoRAMROM             <= "100000000010";
                habBarramentoEscritaChaves <= '1';
                dados                      <= "00000001";
                expHEX0                    <= "ZZZZZZZ";
                expHEX1                    <= "ZZZZZZZ";
                expHEX2                    <= "ZZZZZZZ";
                expHEX3                    <= "ZZZZZZZ";
                expHEX4                    <= "1111001";
                expHEX5                    <= "1000000";
                WAIT UNTIL clk = '1';
                check_equal(HEX0, expHEX0);
                check_equal(HEX1, expHEX1);
                check_equal(HEX2, expHEX2);
                check_equal(HEX3, expHEX3);
                check_equal(HEX4, expHEX4);
                check_equal(HEX5, expHEX5);
            ELSIF run("w1_hex4_hex5_semHab") THEN
                enderecoRAMROM             <= "100000000010";
                habBarramentoEscritaChaves <= '0';
                dados                      <= "00000001";
                expHEX0                    <= "ZZZZZZZ";
                expHEX1                    <= "ZZZZZZZ";
                expHEX2                    <= "ZZZZZZZ";
                expHEX3                    <= "ZZZZZZZ";
                expHEX4                    <= "ZZZZZZZ";
                expHEX5                    <= "ZZZZZZZ";
                WAIT UNTIL clk = '1';
                check_equal(HEX0, expHEX0);
                check_equal(HEX1, expHEX1);
                check_equal(HEX2, expHEX2);
                check_equal(HEX3, expHEX3);
                check_equal(HEX4, expHEX4);
                check_equal(HEX5, expHEX5);

            END IF;
        END LOOP;

        test_runner_cleanup(runner);
    END PROCESS;
END ARCHITECTURE;