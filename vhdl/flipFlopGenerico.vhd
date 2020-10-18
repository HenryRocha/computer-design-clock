LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY flipFlopGenerico IS
    PORT (
        -- Input ports
        DIN    : IN std_logic;
        ENABLE : IN std_logic;
        RST    : IN std_logic;
        CLK    : IN std_logic;

        -- Output ports
        DOUT : OUT std_logic
    );

END ENTITY;

ARCHITECTURE main OF flipFlopGenerico IS
BEGIN
    PROCESS (RST, CLK)
    BEGIN
        IF (RST = '1') THEN
            DOUT <= '0';
        ELSE
            IF (rising_edge(CLK)) THEN
                IF (ENABLE = '1') THEN
                    DOUT <= DIN;
                END IF;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;