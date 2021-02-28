;Archivo:	7segmentos.s
;Dispositivo:	    PIC16F887
;Autor:	    Juan Diego Villafuerte
;Compilador: pic-as (v2.30), MPLABX V5.40
;
;Programa:	Timer0 con 500ms y contador hex con 7 segmentos
;Hardware:	LEDs en puestos C, 7 segmentos en puerto D, botones en puerto B
;
;Creado;	16 febrero 2021
;Ultima modificación:	    16 febrero 2021

PROCESSOR 16F887
#include <xc.inc>
    ;configuration word 1

    CONFIG FOSC=INTRC_NOCLKOUT // Osilador interno sin salida
    CONFIG WDTE=OFF // WDT disabled (reinicio repetitivo del pic)
    CONFIG PWRTE=ON // PWRT eneable (espeera de 72ms al inicial)
    CONFIG MCLRE=OFF // El pin de MCLR se utiliza como I/O 
    CONFIG CP=OFF // Sin proteccion de código
    CONFIG CPD=OFF // Sin proteccion de datos
    
    CONFIG BOREN=OFF //Sin reinicio cuando el voltaje de alimentación baja de 4V
    CONFIG IESO=OFF // Reinicio sin cambio de reloj de interno a externo
    CONFIG FCMEN=OFF // Cambio de reloj externo a interno en caso de fallo
    CONFIG LVP=ON // Programación en bajo voltaje permitida
    
    ;configuration word 2
    
    CONFIG WRT=OFF // Proteccion de autoescritura por el programa desactivada
    CONFIG BOR4V=BOR40V // Reinicio abajo de 4V1 (BOR21V=2.1V)
    
    PSECT udata_bank0 ;common memory
	W_TEMP: DS 8 ;1 byte
	STATUS_TEM: DS 8;var: DS 5
;_____________________________Para el vector reset______________________________   
    PSECT resVect, class=CODE, abs, delta=2
    OrG 00h	;posicion 0000h para el reset

resetVec:
	PAGESEL Lab03
	goto Lab03
    
    PSECT code, delta=2, abs
    ORG 100h

push:
    movwf  W_TEMP
    swapf STATUS,w
    movwf STATUS_TEMP
    
    
    
isr:
    btfsc RBIF
    call boton
    
    
    
pop:
    swapf STATUS_TEMP,w
    movwf STATUS
    movwf W_TEMP,w
    
    retfie
boton:
    banksel PORTA
    btfss PORTB,0
    incf PORTA
    btfss PORTB,1
    decf PORTA
    
    bcf RBIF
    return
    
    
interpush:
    call config_io
    call config_inter_eneable
    
config_io:
    banksel ANSEL
    clrf ANSEL
    clrf ANSELH
    
    banksel TRISA
    bsf TRISB,0
    bsf TRISB,1
    
    clrf TRISA
    bsf TRISA,4
    bsf TRISA,5
    bsf TRISA,6
    bsf TRISA,7
    
    bcf OPTION_REG,7
    bsf WPUB,0
    bsf WPUB,1
    
    bsf IOCB,0
    bsf IOCB,1

    banksel PORTA
    clrf PORTA
    clrf PORTB
    movf PORTB,w
    bcf RBIF
    
    
return    
    
config_inter_eneable:
    
    bsf GIE
    bsf RBIE
    bcf RBIF
    
    return
Loop:
    
    
    goto Loop
    
    
end