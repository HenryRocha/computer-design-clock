LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

ENTITY bancoRegistradores_tb IS
    GENERIC (
        runner_cfg : STRING := runner_cfg_default
    );
END ENTITY;

ARCHITECTURE tb OF bancoRegistradores_tb IS
    -- Inputs and ouputs
    SIGNAL enderecoReg   : std_logic_vector(2 DOWNTO 0);
    SIGNAL dadoEscrita   : std_logic_vector(7 DOWNTO 0);
    SIGNAL habEscritaReg : std_logic;
    SIGNAL bancoReg_out  : std_logic_vector(7 DOWNTO 0);

    SIGNAL expBancoReg_out : std_logic_vector(7 DOWNTO 0);

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

    bancoRegs : ENTITY work.bancoRegistradores
        GENERIC MAP(
            larguraDados        => 8,
            larguraEndBancoRegs => 3
        )
        PORT MAP(
            clk             => clk,
            endereco        => enderecoReg,
            dadoEscrita     => dadoEscrita,
            habilitaEscrita => habEscritaReg,
            saida           => bancoReg_out
        );

    main : PROCESS
    BEGIN
        test_runner_setup(runner, runner_cfg);

        WHILE test_suite LOOP
            IF run("coloca1_r1") THEN
                enderecoReg     <= "001";
                dadoEscrita     <= "00000001";
                habEscritaReg   <= '1';
                expBancoReg_out <= "00000001";
                WAIT UNTIL clk = '1';
                WAIT UNTIL clk = '1';
                check_equal(bancoReg_out, expBancoReg_out);
                REPORT("Saida bancoRegs: " & to_string(bancoReg_out));
            ELSIF run("coloca1_r0") THEN
                enderecoReg     <= "000";
                dadoEscrita     <= "00000111";
                habEscritaReg   <= '1';
                expBancoReg_out <= "00000111";
                WAIT UNTIL clk = '1';
                WAIT UNTIL clk = '1';
                check_equal(bancoReg_out, expBancoReg_out);
                REPORT("Saida bancoRegs: " & to_string(bancoReg_out));
            END IF;
        END LOOP;

        test_runner_cleanup(runner);
    END PROCESS;
END ARCHITECTURE;