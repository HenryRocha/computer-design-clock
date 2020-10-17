LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY fluxoDados IS
    GENERIC (
        DATA_WIDTH : NATURAL := 8;
        INST_WIDTH : NATURAL := 19;
        ADDR_WIDTH : NATURAL := 12
    );
    PORT (
        -- Input ports
        clk             : IN std_logic;
        palavraControle : IN std_logic_vector(7 DOWNTO 0);
        sw              : IN std_logic_vector(9 DOWNTO 0);
        key             : IN std_logic_vector(3 DOWNTO 0);

        -- Output ports
        flagZero                           : OUT std_logic;
        opCode                             : OUT std_logic_vector(3 DOWNTO 0);
        programCounter                     : OUT std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0);
        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : OUT std_logic_vector(6 DOWNTO 0) := (OTHERS => '-');

        -- Saidas para debugging
        saidaBancoRegs_DEBUG    : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        saidaULA_DEBUG          : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        saidaMuxImedDados_DEBUG : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        opULA_DEBUG             : OUT std_logic_vector(2 DOWNTO 0);
        enderecoRAMROM_DEBUG    : OUT std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE main OF fluxoDados IS
    -- Sinais intermediarios
    SIGNAL instrucao             : std_logic_vector(INST_WIDTH - 1 DOWNTO 0);
    SIGNAL pc_out                : std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0) := "000000000000";
    SIGNAL muxProxPC_out         : std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0) := "000000000000";
    SIGNAL somaUm_out            : std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0);
    SIGNAL muxImedDados_out      : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL ULA_out               : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL ULA_flagZero_out      : std_logic;
    SIGNAL bancoReg_out          : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL RAM_out               : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL controleDecodificador : std_logic_vector(5 DOWNTO 0);

    -- Barramentos
    SIGNAL barramentoEntradaDados : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);

    -- Partes da instrucao
    ALIAS valorImediato  : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0) IS instrucao(DATA_WIDTH - 1 DOWNTO 0);
    ALIAS enderecoRAMROM : std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0) IS instrucao(ADDR_WIDTH - 1 DOWNTO 0);
    ALIAS enderecoReg    : std_logic_vector(2 DOWNTO 0) IS instrucao(14 DOWNTO 12);
    ALIAS instOpCode     : std_logic_vector(3 DOWNTO 0) IS instrucao(18 DOWNTO 15);

    -- Partes da palavra de controle
    ALIAS selMuxProxPC    : std_logic IS palavraControle(7);
    ALIAS selMuxImedDados : std_logic IS palavraControle(6);
    ALIAS habEscritaReg   : std_logic IS palavraControle(5);
    ALIAS operacao        : std_logic_vector(2 DOWNTO 0) IS palavraControle(4 DOWNTO 2);
    ALIAS habLeituraRAM   : std_logic IS palavraControle(1);
    ALIAS habEscritaRAM   : std_logic IS palavraControle(0);

    -- Partes do decodificador
    ALIAS habBarramentoLimpaBaseTempo : std_logic IS controleDecodificador(5);
    ALIAS habBarramentoEscritaChaves  : std_logic IS controleDecodificador(4);
    ALIAS habBarramentoEscritaBtn     : std_logic IS controleDecodificador(3);
    ALIAS habBarramentoBaseTempo      : std_logic IS controleDecodificador(2);
    ALIAS habBarramentoHex            : std_logic IS controleDecodificador(1);
    ALIAS habBarramentoEscritaRAM     : std_logic IS controleDecodificador(0);

    -- Constantes
    CONSTANT INCREMENTO : NATURAL := 1;
BEGIN
    PC : ENTITY work.registradorGenerico
        GENERIC MAP(
            larguraDados => ADDR_WIDTH
        )
        PORT MAP(
            DIN    => muxProxPC_out,
            DOUT   => pc_out,
            ENABLE => '1',
            CLK    => clk,
            RST    => '0'
        );

    MuxProxPC : ENTITY work.muxGenerico2x1
        GENERIC MAP(
            larguraDados => ADDR_WIDTH
        )
        PORT MAP(
            entradaA_MUX => somaUm_out,
            entradaB_MUX => enderecoRAMROM,
            seletor_MUX  => selMuxProxPC,
            saida_MUX    => muxProxPC_out
        );

    somaUm : ENTITY work.somaConstante
        GENERIC MAP(
            larguraDados => ADDR_WIDTH,
            constante    => INCREMENTO
        )
        PORT MAP(
            entrada => pc_out,
            saida   => somaUm_out
        );

    ROM : ENTITY work.memoriaROM
        GENERIC MAP(
            dataWidth => INST_WIDTH,
            addrWidth => ADDR_WIDTH
        )
        PORT MAP(
            Endereco => pc_out,
            Dado     => instrucao
        );

    decodificador : ENTITY work.decodificador
        GENERIC MAP(
            DATA_WIDTH => ADDR_WIDTH
        )
        PORT MAP(
            seletor  => enderecoRAMROM,
            habilita => controleDecodificador
        );

    MuxImedDados_ints : ENTITY work.muxGenerico2x1
        GENERIC MAP(
            larguraDados => DATA_WIDTH
        )
        PORT MAP(
            entradaB_MUX => barramentoEntradaDados,
            entradaA_MUX => valorImediato,
            seletor_MUX  => selMuxImedDados,
            saida_MUX    => muxImedDados_out
        );

    bancoRegs : ENTITY work.bancoRegistradores
        GENERIC MAP(
            larguraDados        => DATA_WIDTH,
            larguraEndBancoRegs => 3
        )
        PORT MAP(
            clk             => clk,
            endereco        => enderecoReg,
            dadoEscrita     => ULA_out,
            habilitaEscrita => habEscritaReg,
            saida           => bancoReg_out
        );

    ULA : ENTITY work.ULA
        GENERIC MAP(
            larguraDados => DATA_WIDTH
        )
        PORT MAP(
            entradaB => muxImedDados_out,
            entradaA => bancoReg_out,
            seletor  => operacao,
            saida    => ULA_out,
            flagZero => ULA_flagZero_out
        );

    registerFlagZero : ENTITY work.flipFlopGenerico
        PORT MAP(
            DIN    => ULA_flagZero_out,
            DOUT   => flagZero,
            ENABLE => '1',
            CLK    => clk,
            RST    => '0'
        );

    RAM : ENTITY work.memoriaRAM
        GENERIC MAP(
            dataWidth => DATA_WIDTH,
            addrWidth => ADDR_WIDTH
        )
        PORT MAP(
            addr     => enderecoRAMROM,
            we       => habEscritaRAM,
            re       => habLeituraRAM,
            habilita => habBarramentoEscritaRAM,
            clk      => clk,
            dado_in  => bancoReg_out,
            dado_out => barramentoEntradaDados
        );

    intChaves : ENTITY work.interfaceChaves
        GENERIC MAP(
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH
        )
        PORT MAP(
            entrada  => sw,
            endereco => enderecoRAMROM,
            habilita => habBarramentoEscritaChaves,
            saida    => barramentoEntradaDados
        );

    intBtn : ENTITY work.interfaceBotoes
        GENERIC MAP(
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH
        )
        PORT MAP(
            entrada  => key,
            endereco => enderecoRAMROM,
            habilita => habBarramentoEscritaBtn,
            saida    => barramentoEntradaDados
        );

    intHEX : ENTITY work.interfaceHEX
        GENERIC MAP(
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH
        )
        PORT MAP(
            clk      => clk,
            endereco => enderecoRAMROM,
            habilita => habBarramentoHex,
            dados    => bancoReg_out,
            HEX0     => HEX0,
            HEX1     => HEX1,
            HEX2     => HEX2,
            HEX3     => HEX3,
            HEX4     => HEX4,
            HEX5     => HEX5
        );

    interfaceBaseTempo : ENTITY work.divisorGenerico_e_Interface
        GENERIC MAP(
            DATA_WIDTH => DATA_WIDTH
        )
        PORT MAP(
            clk              => clk,
            habilitaLeitura  => habBarramentoBaseTempo,
            limpaLeitura     => habBarramentoLimpaBaseTempo,
            leituraUmSegundo => barramentoEntradaDados
        );

    programCounter <= pc_out;
    opCode         <= instOpCode;

    -- Saidas para debugging
    saidaBancoRegs_DEBUG    <= bancoReg_out;
    saidaULA_DEBUG          <= ULA_out;
    saidaMuxImedDados_DEBUG <= muxImedDados_out;
    opULA_DEBUG             <= operacao;
    enderecoRAMROM_DEBUG    <= enderecoRAMROM;
END ARCHITECTURE;