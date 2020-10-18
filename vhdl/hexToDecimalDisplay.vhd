-- Henry Rocha
-- Vitor Eller
-- São Paulo, 11 de Outubro de 2020

-- Código responsável por traduzir o valor hexadecimal para decimal no display de 7 segmentos da placa

-- Esse código foi criado baseado em um código usado pelos alunos na disciplina de Elementos de Sistema
-- Por sua vez, o código da disiciplina de Elementos foi criado baseado em um código encontrado no Stack Overflow
-- Link para o código da disciplina: https://github.com/andrekwr/Z01.1-Fury/blob/master/Projetos/C-LogicaCombinacional/src/Decimal.vhd
-- Link para o código do StackOverflow: https://stackoverflow.com/questions/20866747/decimal-number-on-7-segment-display

LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY hexToDecimalDisplay IS
    PORT (
        -- Input ports
        dadoHex  : IN std_logic_vector(7 DOWNTO 0);
        apaga    : IN std_logic := '0';
        negativo : IN std_logic := '0';
        overFlow : IN std_logic := '0';
        -- Output ports
        saida7seg1 : OUT std_logic_vector(6 DOWNTO 0); -- := (others => '1')
        saida7seg2 : OUT std_logic_vector(6 DOWNTO 0) -- := (others => '1')
    );
END ENTITY;

ARCHITECTURE comportamento OF hexToDecimalDisplay is
    SIGNAL hex           : std_logic_vector(13 DOWNTO 0);
    SIGNAL unsignedInput : unsigned(7 DOWNTO 0);
    
    FUNCTION convertTo7Segment(
        digit : std_logic_vector(3 DOWNTO 0)
    ) RETURN std_logic_vector
    IS BEGIN
        CASE digit is
            WHEN x"0" => RETURN "1000000";
            WHEN x"1" => RETURN "1111001";
            WHEN x"2" => RETURN "0100100";
            WHEN x"3" => RETURN "0110000";
            WHEN x"4" => RETURN "0011001";
            WHEN x"5" => RETURN "0010010";
            WHEN x"6" => RETURN "0000010";
            WHEN x"7" => RETURN "1111000";
            WHEN x"8" => RETURN "0000000";
            WHEN x"9" => RETURN "0010000";
                WHEN others => RETURN "1111111";
        END CASE;
    END;

    FUNCTION decimalTo7Segment(
        value: unsigned;
        digits: integer
    ) RETURN std_logic_vector
    IS 
        VARIABLE displays : std_logic_vector(digits*7-1 downto 0);
        VARIABLE quotient : unsigned(7 DOWNTO 0);
        VARIABLE remainder: unsigned(3 DOWNTO 0);
    BEGIN
        quotient := value;
        FOR i IN 0 TO digits-1 LOOP
            remainder := resize(quotient MOD 10, 4);
            quotient  := quotient/10;
            displays(i*7+6 DOWNTO i*7) := convertTo7Segment(
                std_logic_vector(remainder)
            );
        END LOOP;
        RETURN displays;
    END;


BEGIN
    unsignedInput <= unsigned(dadoHex);
    hex <= decimalTo7Segment(
        unsignedInput,
        2
    );

    saida7seg1 <= "1100010" WHEN (overFlow = '1') ELSE
        "1111111" WHEN (apaga = '1' AND negativo = '0') ELSE
        "0111111" WHEN (apaga = '0' AND negativo = '1') ELSE
        hex(13 DOWNTO 7);

    
    saida7seg2 <= "1100010" WHEN (overFlow = '1') ELSE
        "1111111" WHEN (apaga = '1' AND negativo = '0') ELSE
        "0111111" WHEN (apaga = '0' AND negativo = '1') ELSE
        hex(6 DOWNTO 0);
END ARCHITECTURE;