; Carrega 0 nos registradores.
LEA $1, 0x0;
LEA $2, 0x0;
LEA $3, 0x0;
; Carrega os registradores nos displays HEX.
MOVR 0x800, $1;
MOVR 0x801, $2;
MOVR 0x802, $3;
; Limpa base de tempo.
MOVM $8, 0x401;

LOOP_GERAL:
; Carrega os registradores nos displays HEX.
MOVR 0x800, $1;
MOVR 0x801, $2;
MOVR 0x802, $3;
; Le a base de tempo.
MOVM $8, 0x400;
; Verifica se passou um segundo.
CMP $8, 0x1;
JE PASSOU_UM_SEG;
JMP LOOP_GERAL;

PASSOU_UM_SEG:
; Limpa a base de tempo.
MOVM $8, 0x401;

; Ve se a chave 1 está ligada.
MOVM $5, 0x1;
CMP $5, 0x1;
JE CHAVE_SETUP;

; Soma um no registrador de segundo.
ADDI $1, 0x1;
; Verifica se passou é 60.
CMP $1, 0x3C;
JE PASSOU_UM_MIN;
JMP LOOP_GERAL;

PASSOU_UM_MIN:
; Reset registrador de segundo.
LEA $1, 0x0;
; Soma um no registrador de minuto.
ADDI $2, 0x1;
; Verifica se passou é 60.
CMP $2, 0x3C;
JE PASSOU_UMA_HR;
JMP LOOP_GERAL;

PASSOU_UMA_HR:
; Reset registrador de minuto.
LEA $2, 0x0;
; Soma um no registrador de hora.
ADDI $3, 0x1;
; Verifica se passou é 24.
CMP $3, 0x18;
JE PASSOU_UM_DIA;
JMP LOOP_GERAL;

PASSOU_UM_DIA:
; Reset todos os registradores.
LEA $1, 0x0;
LEA $2, 0x0;
LEA $3, 0x0;
; Carrega os registradores nos displays HEX.
MOVR 0x800, $1;
MOVR 0x801, $2;
MOVR 0x802, $3;
JMP LOOP_GERAL;

CHAVE_SETUP:
; Verifica se o botao 0 foi apertado.
MOVM $4, 0xA;
CMP $4, 0x0;
JE APERTOU_K0;
; Verifica se o botao 1 foi apertado.
MOVM $5, 0xB;
CMP $5, 0x0;
JE APERTOU_K1;
; Verifica se o botao 2 foi apertado.
MOVM $6, 0xC;
CMP $6, 0x0;
JE APERTOU_K2;
; Se nenhum botao foi apertado, volta ao loop geral.
JMP LOOP_GERAL;

APERTOU_K0:
; Soma 1 no registrador de segundo e verifica é 60,
; caso seja, zera o registrador de segundo.
ADDI $1, 0x1;
CMP $1, 0x3C;
JE ZERA_SEG;
JMP LOOP_GERAL;

APERTOU_K1:
; Soma 1 no registrador de minuto e verifica é 60,
; caso seja, zera o registrador de minuto.
ADDI $2, 0x1;
CMP $2, 0x3C;
JE ZERA_MIN;
JMP LOOP_GERAL;

APERTOU_K2:
; Soma 1 no registrador de hora e verifica é 24,
; caso seja, zera o registrador de hora.
ADDI $3, 0x1;
CMP $3, 0x18;
JE ZERA_HR;
JMP LOOP_GERAL;

ZERA_SEG:
; Zera o registrador de segundo.
LEA $1, 0x0;
JMP LOOP_GERAL;

ZERA_MIN:
; Zera o registrador de minuto.
LEA $2, 0x0;
JMP LOOP_GERAL;

ZERA_HR:
; Zera o registrador de hora.
LEA $3, 0x0;
JMP LOOP_GERAL;
