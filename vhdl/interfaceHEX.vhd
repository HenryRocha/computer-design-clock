-- Henry Rocha
-- Vitor Eller
-- São Paulo, 11 de Outubro de 2020

LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY interfaceHEX IS
    GENERIC (
        DATA_WIDTH : NATURAL := 8;
        ADDR_WIDTH : NATURAL := 8;
        HEX_WIDTH  : NATURAL := 7
    );
    PORT (
        -- Input ports
        clk      : IN std_logic;
        endereco : IN std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0);
        habilita : IN std_logic := '0';
        dados    : IN std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);

        -- Output ports
        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : OUT std_logic_vector(6 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE main OF interfaceHEX IS
    -- Declarando todos os sinais intermedi�rios.
    SIGNAL interHEX0 : std_logic_vector(HEX_WIDTH - 1 DOWNTO 0) := "1111111";
    SIGNAL interHEX1 : std_logic_vector(HEX_WIDTH - 1 DOWNTO 0) := "1111111";
    SIGNAL interHEX2 : std_logic_vector(HEX_WIDTH - 1 DOWNTO 0) := "1111111";
    SIGNAL interHEX3 : std_logic_vector(HEX_WIDTH - 1 DOWNTO 0) := "1111111";
    SIGNAL interHEX4 : std_logic_vector(HEX_WIDTH - 1 DOWNTO 0) := "1111111";
    SIGNAL interHEX5 : std_logic_vector(HEX_WIDTH - 1 DOWNTO 0) := "1111111";

    -- Declarando o habilita de cada um dos HEX.
    SIGNAL habHEX0 : std_logic;
    SIGNAL habHEX1 : std_logic;
    SIGNAL habHEX2 : std_logic;
    SIGNAL habHEX3 : std_logic;
    SIGNAL habHEX4 : std_logic;
    SIGNAL habHEX5 : std_logic;
BEGIN
    -- Declarando todos os conversores de 7 segmentos.
    conversorHex0 : ENTITY work.hexToDecimalDisplay
        PORT MAP(
            dadoHex   => dados,
            apaga     => '0',
            negativo  => '0',
            overFlow  => '0',
            saida7seg1 => interHEX1,
            saida7seg2 => interHEX0
        );
    
    conversorHex1 : ENTITY work.hexToDecimalDisplay
        PORT MAP(
            dadoHex   => dados,
            apaga     => '0',
            negativo  => '0',
            overFlow  => '0',
            saida7seg1 => interHEX3,
            saida7seg2 => interHEX2
        );

    conversorHex2 : ENTITY work.hexToDecimalDisplay
        PORT MAP(
            dadoHex   => dados,
            apaga     => '0',
            negativo  => '0',
            overFlow  => '0',
            saida7seg1 => interHEX5,
            saida7seg2 => interHEX4
        );

    -- Cada display s� ser� escrito caso o endere�o seja o referente aquela
    -- dupla de display.
    habHEX0 <= '1' WHEN (endereco = "100000000000" AND habilita = '1') ELSE
        '0';
    habHEX1 <= '1' WHEN (endereco = "100000000000" AND habilita = '1') ELSE
        '0';
    habHEX2 <= '1' WHEN (endereco = "100000000001" AND habilita = '1') ELSE
        '0';
    habHEX3 <= '1' WHEN (endereco = "100000000001" AND habilita = '1') ELSE
        '0';
    habHEX4 <= '1' WHEN (endereco = "100000000010" AND habilita = '1') ELSE
        '0';
    habHEX5 <= '1' WHEN (endereco = "100000000010" AND habilita = '1') ELSE
        '0';

    -- Declarando os registradores de cada HEX, para guardar o valor de cada um.
    register_hex0 : ENTITY work.registradorGenerico
        GENERIC MAP(
            larguraDados => HEX_WIDTH
        )
        PORT MAP(
            DIN    => interHEX0,
            DOUT   => HEX0,
            ENABLE => habHEX0,
            CLK    => clk,
            RST    => '0'
        );

    register_hex1 : ENTITY work.registradorGenerico
        GENERIC MAP(
            larguraDados => HEX_WIDTH
        )
        PORT MAP(
            DIN    => interHEX1,
            DOUT   => HEX1,
            ENABLE => habHEX1,
            CLK    => clk,
            RST    => '0'
        );

    register_hex2 : ENTITY work.registradorGenerico
        GENERIC MAP(
            larguraDados => HEX_WIDTH
        )
        PORT MAP(
            DIN    => interHEX2,
            DOUT   => HEX2,
            ENABLE => habHEX2,
            CLK    => clk,
            RST    => '0'
        );

    register_hex3 : ENTITY work.registradorGenerico
        GENERIC MAP(
            larguraDados => HEX_WIDTH
        )
        PORT MAP(
            DIN    => interHEX3,
            DOUT   => HEX3,
            ENABLE => habHEX3,
            CLK    => clk,
            RST    => '0'
        );

    register_hex4 : ENTITY work.registradorGenerico
        GENERIC MAP(
            larguraDados => HEX_WIDTH
        )
        PORT MAP(
            DIN    => interHEX4,
            DOUT   => HEX4,
            ENABLE => habHEX4,
            CLK    => clk,
            RST    => '0'
        );

    register_hex5 : ENTITY work.registradorGenerico
        GENERIC MAP(
            larguraDados => HEX_WIDTH
        )
        PORT MAP(
            DIN    => interHEX5,
            DOUT   => HEX5,
            ENABLE => habHEX5,
            CLK    => clk,
            RST    => '0'
        );
END ARCHITECTURE;