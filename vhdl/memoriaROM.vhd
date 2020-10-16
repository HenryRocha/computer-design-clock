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
        -- Funfa
        -- tmp(0) := "1010" & "000" & "000000000001"; -- Jump 1
        -- tmp(0) := "0000" & "000" & "000000000000"; -- Jump 1
        tmp(0) := "0110" & "000" & "000000000111"; -- Lea 7 > R0
        tmp(1) := "0101" & "000" & "100000000000"; -- Movr r0, 2048
        tmp(2) := "1010" & "000" & "000000000000"; -- Jump 0
        RETURN tmp;
    END initMemory;

    SIGNAL memROM : blocoMemoria := initMemory;
BEGIN
    Dado <= memROM (to_integer(unsigned(Endereco)));
END ARCHITECTURE;