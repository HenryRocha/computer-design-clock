LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY divisorGenerico_e_Interface IS
    GENERIC (
        DATA_WIDTH : NATURAL := 8
    );
    PORT (
        clk              : IN std_logic;
        habilitaLeitura  : IN std_logic;
        limpaLeitura     : IN std_logic;
        leituraUmSegundo : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE interface OF divisorGenerico_e_Interface IS
    SIGNAL sinalUmSegundo   : std_logic;
    SIGNAL saidaclk_reg1seg : std_logic;
    SIGNAL temp             : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
BEGIN
    baseTempo : ENTITY work.divisorGenerico
        GENERIC MAP(
            divisor => 5
        ) -- divide por 10.
        PORT MAP(
            clk       => clk,
            saida_clk => saidaclk_reg1seg
        );

    registraUmSegundo : ENTITY work.registradorGenerico
        PORT MAP(
            DIN    => '1',
            DOUT   => sinalUmSegundo,
            ENABLE => '1',
            CLK    => saidaclk_reg1seg,
            RST    => limpaLeitura
        );

    temp(0) <= sinalUmSegundo;
    -- Faz o tristate de saida:
    leituraUmSegundo <= temp WHEN habilitaLeitura = '1' ELSE
        'Z';
END ARCHITECTURE interface;