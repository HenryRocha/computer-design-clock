LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

ENTITY fluxoDados_tb IS
    GENERIC (
        runner_cfg : STRING := runner_cfg_default
    );
END ENTITY;

ARCHITECTURE tb OF fluxoDados_tb IS
    -- Inputs and ouputs
    SIGNAL palavraControle : std_logic_vector(7 DOWNTO 0);
    SIGNAL sw              : std_logic_vector(9 DOWNTO 0);
    SIGNAL key             : std_logic_vector(3 DOWNTO 0);

    SIGNAL programCounter                     : std_logic_vector(11 DOWNTO 0);
    SIGNAL opCode                             : std_logic_vector(3 DOWNTO 0);
    SIGNAL flagZero                           : std_logic;
    SIGNAL selMuxProxPC_aaa                   : std_logic_vector(11 DOWNTO 0);
    SIGNAL HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : std_logic_vector(6 DOWNTO 0) := (OTHERS => '-');

    SIGNAL expProgramCounter : std_logic_vector(11 DOWNTO 0);
    SIGNAL bancoReg_out_aaaa : std_logic_vector(7 DOWNTO 0);
    SIGNAL expOpCode         : std_logic_vector(3 DOWNTO 0);

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

    FD : ENTITY work.fluxoDados
        GENERIC MAP(
            DATA_WIDTH => 8,
            ADDR_WIDTH => 12
        )
        PORT MAP(
            clk               => clk,
            sw                => sw,
            key               => key,
            palavraControle   => palavraControle,
            flagZero          => flagZero,
            opCode            => opCode,
            programCounter    => programCounter,
            -- bancoReg_out_aaaa => bancoReg_out_aaaa,
            HEX0              => HEX0,
            HEX1              => HEX1,
            HEX2              => HEX2,
            HEX3              => HEX3,
            HEX4              => HEX4,
            HEX5              => HEX5
        );

    main : PROCESS
    BEGIN
        test_runner_setup(runner, runner_cfg);

        WHILE test_suite LOOP
            IF run("opcode_PROGRAM_JMP") THEN
                palavraControle <= "10000100";
                WAIT UNTIL clk = '1';
                REPORT("Saida bancoRegs: " & to_string(bancoReg_out_aaaa));
                -- Executa a primeira inst
                expOpCode <= "0110";
                WAIT UNTIL clk = '0';
                -- Terminou de executar a primeira inst
                check_equal(opCode, expOpCode);
                REPORT("Saida bancoRegs: " & to_string(bancoReg_out_aaaa));
                
                palavraControle <= "00101100";
                WAIT UNTIL clk = '1';
                REPORT("Saida bancoRegs: " & to_string(bancoReg_out_aaaa));
                expOpCode <= "0101";
                WAIT UNTIL clk = '0';
                check_equal(opCode, expOpCode);
                REPORT("Saida bancoRegs: " & to_string(bancoReg_out_aaaa));
                
                palavraControle <= "00010001";
                WAIT UNTIL clk = '1';
                REPORT("Saida bancoRegs: " & to_string(bancoReg_out_aaaa));
                expOpCode <= "1010";
                WAIT UNTIL clk = '0';
                check_equal(opCode, expOpCode);
                REPORT("Saida bancoRegs: " & to_string(bancoReg_out_aaaa));
                
                palavraControle <= "10000100";
                WAIT UNTIL clk = '1';
                REPORT("Saida bancoRegs: " & to_string(bancoReg_out_aaaa));
                expOpCode <= "1010";
                WAIT UNTIL clk = '0';
                check_equal(opCode, expOpCode);
                REPORT("Saida bancoRegs: " & to_string(bancoReg_out_aaaa));

                -- palavraControle <= "10000000";
                -- expOpCode       <= "0101";
                -- WAIT UNTIL clk = '0';
                -- -- 7pc 8somaum
                -- palavraControle <= "00000000";
                -- WAIT UNTIL clk = '0';
                -- -- 8pc 9somaum
                -- ASSERT(opCode = expOpCode)
                -- REPORT (
                --     "opCode mismatch. VarX: "
                --     & to_string(selMuxProxPC_aaa)
                --     & ". Opcode recebido: "
                --     & to_string(programCounter))
                --     SEVERITY error;
            END IF;
        END LOOP;

        test_runner_cleanup(runner);
    END PROCESS;
END ARCHITECTURE;