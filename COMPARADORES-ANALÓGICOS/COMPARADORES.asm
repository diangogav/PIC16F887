	List p=16f887
	#include <p16f887.inc>
	__CONFIG H'2007', H'3FFC' & H'3FF7' & H'3FFF' & H'3FFF' & H'3FFF' & H'3FFF' & H'3CFF' & H'3BFF' & H'37FF' & H'2FFF' & H'3FFF'
	__CONFIG H'2008', H'3EFF' & H'3FFF'	

;===============================================================================
BANK0	MACRO
	BCF STATUS,6
	BCF STATUS,5
	ENDM
BANK1	MACRO
	BCF STATUS,6
	BSF STATUS,5
	ENDM
BANK2	MACRO
	BSF STATUS,6
	BCF STATUS,5
	ENDM
BANK3	MACRO
	BSF STATUS,6
	BSF STATUS,5
	ENDM
PRECARGA    MACRO   T1H,T1L
	BCF TMR1,0
	MOVLW T1H
	MOVWF TMR1H
	MOVLW T1L
	MOVWF TMR1L
	BSF T1CON,0
	ENDM
;===============================================================================
	ORG 0x00
	GOTO INICIO
	ORG 0x04
	GOTO INTERRUPCION
	ORG 0x05

INTERRUPCION
	
	CLRF PORTB
	BCF PIR2,5
	RETFIE

INICIO
	;CLRF INTCON ;DESHABILITO LAS INTERRUPCIONES
	CLRF PORTA 
	CLRF PORTB
	;MOVLW B'00110000'
	;MOVWF T1CON ; PRESCALADOR ASIGNADO A TMR1 A 8 DIV
	BANK1
	MOVLW B'00001001'
	MOVWF TRISA ;BIT 0 Y 3 COMO ENTRADAS PARA EL COMPARADOR C1 // 
		    ;RESULTADO SE LE CON EL BIT 6 EN PORTA4
	CLRF TRISB
	BANK2
	MOVLW B'10100000' ;COMPARADOR1 ON//C1OUT PORTA6//SALIDA SIN INVERTIR
			  ;ENTRADA POSITIVA AL PIN C1IN+
			  ;ENTRADA NEGATIVA AL PIN C12IN1
	MOVWF CM1CON0
	BANK0
	;MOVLW B'11111000' ;// HABILITADAS TODAS LAS INTERRUPCIONES
	;MOVWF INTCON
	BANK1
CONTROL	;BSF PIE2,5 ;// HABILITADA LA INTERRUPCION POR EL COMPARADOR1
	BANK2
	BTFSS CM1CON0,6
	GOTO LED1
	GOTO LED2
	
LED1
	BANK0
	BSF PORTB,0
	GOTO CONTROL
LED2
	BANK0
	BSF PORTB,1
	GOTO CONTROL
	
	;BANK0
	;BCF PIR2,5
	;BTFSS PIR2,5
	;GOTO $-1
	END
	
	
	