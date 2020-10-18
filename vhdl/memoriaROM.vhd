LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY memoriaROM IS
    GENERIC (
        dataWidth : NATURAL := 8;
        addrWidth : NATURAL := 3
    );
    PORT (
        Endereco : IN std_logic_vector (addrWidth - 1 DOWNTO 0);
        Dado     : OUT std_logic_vector (dataWidth - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE assincrona OF memoriaROM IS
    TYPE blocoMemoria IS ARRAY(0 TO 2 ** addrWidth - 1) OF std_logic_vector(dataWidth - 1 DOWNTO 0);

    FUNCTION initMemory
        RETURN blocoMemoria IS VARIABLE tmp : blocoMemoria := (OTHERS => (OTHERS => '0'));
    BEGIN
        -- Acende os 3 displays HEX. Funfa
        -- tmp(0) := "0110" & "000" & "000000000001";
        -- tmp(1) := "0110" & "001" & "000000000001";
        -- tmp(2) := "0110" & "010" & "000000000001";
        -- tmp(3) := "0101" & "000" & "100000000000";
        -- tmp(4) := "0101" & "001" & "100000000001";
        -- tmp(5) := "0101" & "010" & "100000000010";

        -- Loop somando no R1 e HEX0. Funfa
        -- tmp(0) := "0110" & "000" & "000000000001";
        -- tmp(1) := "0101" & "000" & "100000000000";
        -- tmp(2) := "0001" & "000" & "000000000001";
        -- tmp(3) := "0101" & "000" & "100000000000";
        -- tmp(4) := "1010" & "000" & "000000000001";

        -- Funfa
        -- tmp(0) := "0110" & "000" & "000000000000";
        -- tmp(1) := "0101" & "000" & "100000000000";
        -- tmp(2) := "0001" & "000" & "000000000001";
        -- tmp(3) := "0111" & "000" & "000000000001";
        -- tmp(4) := "1000" & "000" & "000000000110";
        -- tmp(5) := "1010" & "000" & "000000000000";
        -- tmp(6) := "0110" & "001" & "000000000010";
        -- tmp(7) := "0101" & "001" & "100000000010";

        tmp(0)  := "0110" & "010" & "000000000000";
        tmp(1)  := "0101" & "010" & "100000000000";
        tmp(2)  := "0100" & "000" & "010000000000";
        tmp(3)  := "0111" & "000" & "000000000001";
        tmp(4)  := "1000" & "000" & "000000000110";
        tmp(5)  := "1010" & "000" & "000000000010";
        tmp(6)  := "0110" & "001" & "000000000001";
        tmp(7)  := "0101" & "001" & "010000000001";
        tmp(8)  := "0001" & "010" & "000000000001";
        tmp(9)  := "0101" & "010" & "100000000000";
        tmp(10) := "1010" & "000" & "000000000010";

        RETURN tmp;
    END initMemory;

    SIGNAL memROM : blocoMemoria := initMemory;
BEGIN
    Dado <= memROM (to_integer(unsigned(Endereco)));
END ARCHITECTURE;