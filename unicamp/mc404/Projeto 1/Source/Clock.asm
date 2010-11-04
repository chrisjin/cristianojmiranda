; -----------------------------------------------------------------------------
;  MC404-E
;
;  Atividade Obrigatoria 1 - cronômetro/relógio de parede
;
;
;                                               Cristiano J. Miranda Ra: 083382
; -----------------------------------------------------------------------------



.nolist
.include "m88def.inc"
.list

; Registradores utilzados: r16, r17, r19, r21, r22, r23, r24, r25, r26,
; -----------------------------------------------------------------------------

; Constantes e variaveis
; -----------------------------------------------------------------------------
.equ 			LCDDATA		=	PORTB
.equ 			LCDCTL		=	PORTC
.equ 			ENABLE		=	0
.equ 			RS			= 	1
.equ 			RW			= 	2
.def    		lcdinput    =   r19

.def    		secCount  	= 	r21				; Contador global de seguncos
.def			r			= 	r16
.def 			btnStart	= 	r17


start:	rjmp	RESET							; Funcao de Reset


.org 	0x003
				;clr btnStart					; Limpa contador para btnStart
				rjmp startPressed 						; Trata interrupcao para o pino 0 da porta B (Start/Stop)


.org	0x10
    			rjmp count1s					; Salta para a rotina de contagem de segundo ao ocorrer uma interrupção Timer/Counter0
				rjmp loop


; -----------------------------------------------------------------------------
RESET:
			    ldi r, low(RAMEND)
				out	SPL,r						;initialize Stack Pointer to last RAM address		
				ldi	r,high(RAMEND)
				out SPH,r
				clr secCount					; clear software seconds counter 
				clr Yl							; will use X as an interrupt counter
				clr Yh
				clr btnStart					; Limpa contador para btnStart

				ldi r, 1
				sts PCICR, r  					; set bit 0 of B port to activate PCINT0 interruption
				sts PCMSK0, r  					; activate PCINT0 interruption

				;ldi r,1						; era out TIMSK0,r no Atmega88 este registrador está fora do espaço de E/S!
				sts TIMSK0,r					; enable timer0 overflow interrupt (p.102 datasheet)
				;ldi r,1							; set prescalong: 1= no prescaling 5=  CK/1024 pre-scaling (p 102-103 datasheet)
				out TCCR0B,r					; also starts timer0 counting
				

				rcall cronoIni					; Inicializ o cronometro na SRAM

				rcall lcdinit					; inicializa o LCD

				clr r25							; Marca como leitura Progam Memory
				ldi Zl,low(msg_hhmmss*2)   		; Seta a mensagem inicial no LDCD
    			ldi Zh,high(msg_hhmmss*2)
    			rcall writemsg					; Exibe a mensagem 
				rcall clenPortB
				
				sei								; Habilita interrupção global
				rjmp loop


; Inicializa o Cronometro
; -----------------------------------------------------------------------------
cronoIni:										; Monta o display do cronometro na SRAM
				ldi Xh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
        		ldi Xl, low(SRAM_START)     	; Seta Xl como o inicio da SRAM

				ldi r23, 0x30					; Seta '0' em r23
				ldi r24, 0x3A					; Seta ':' em r24

				;ldi r23, 0x32					; TODO: remover
				st X+, r23						; Monta display em memoria
				;ldi r23, 0x33					; TODO: remover
				st X+, r23						; HORA

				st X+, r24						; MINUTO
				;ldi r23, 0x35					; TODO: remover
				st X+, r23
				;ldi r23, 0x39					; TODO: remover
				st X+, r23

				st X+, r24
				;ldi r23, 0x35					; TODO: remover
				st X+, r23						; SEGUNDOS
				st X+, r23

				ldi r23, 0						; Seta final da leitura
				st X+, r23
				ret

; Loop principal da aplicação
; -----------------------------------------------------------------------------
loop:			ldi r, low(RAMEND)				; Remove lixo da pilha para evitar overflow
				out	SPL,r		
				;clr btnStart					; Limpa contador para btnStart
				sei								; Habilita interrupção
				sleep							; Entra em loop aguardando uma interrupção
				rjmp loop


; Trata o acionamento dos botoes da aplicacao
; -----------------------------------------------------------------------------
startPressed: 	inc btnStart
				cpi btnStart, 0x2
				breq startPressed1
				ret
startPressed1:	clr btnStart
				brts startPressed2
				set
				ret
startPressed2:	clt
				ret


; Funcao para ontabilizar 1s no microcontrolador
; -----------------------------------------------------------------------------
												; Funcao de interrupcao acada 1s
count1s:		brtc loop
			    push r							; save into stack
			    in r,SREG						; get SREG
				push r							; and save it in stack			
			    adiw Y,1
				cpi  Yh,0x02					; assume 0x200 interrupts make 1 second ; TODO: decomentar
				;cpi  Yh,0x1						; assume 0x100 interrupts make 1 second
				brne exitCount1

												; -------------------------------
				clr Yl							; got 1 sec, clear 16 bit counter in X
				clr Yh
				inc secCount					; Incrementa contador de segund

				rcall atualizarLcd				; Atualiza o cronometro

				bst secCount, 0
				brtc onLed
				brts offLed
				rjmp exitCount1

; -----------------------------------------------------------------------------
onLed: 			sbi PORTD,0						; liga led conectado no pino 2
				rjmp exitCount1					; retorna com interrupções habilitadas


; -----------------------------------------------------------------------------
offLed:			cbi PORTD,0						; liga led conectado no pino 2
		
; -----------------------------------------------------------------------------
exitCount1:
				pop r							; get SREG from stack
				out SREG, r						; restore it
				pop r							; now restore r
			    reti
				

; Atualiz LCD com o cronometro
; -----------------------------------------------------------------------------
atualizarLcd:	ldi   lcdinput,1				; Apaga o LCD
				rcall lcd_cmd		
				rcall lcd_busy

				ldi r25, 0x1					; Habilita a leitura LCD para SRAM

				rcall cron						; Atualiza os digitos do cronometro

				ldi Xh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
        		ldi Xl, low(SRAM_START)     	; Seta Xl como o inicio da SRAM

    			rcall writemsg					; Exibe a mensagem 
				rcall clenPortB

				rcall chk24h
				ret	



; Atualiza o segundo
; -----------------------------------------------------------------------------
cron:			ldi Xh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
        		ldi Xl, low(SRAM_START)     	; Seta Xl como o inicio da SRAM
				
				ldi r24, 0x7					; Obtem o byte do segundo
				add Xl, r24
				ld r24, X
				inc r24

				cpi r24, 0x3A					; Verifica overflow unidade segundos
				breq cronAddSec

				st X, r24
				ret

; Adiciona uma dezena de segundo
; -----------------------------------------------------------------------------
cronAddSec:		ldi Xh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
        		ldi Xl, low(SRAM_START)     	; Seta Xl como o inicio da SRAM
				
				ldi r24, 0x6					; Obtem o byte do segundo
				add Xl, r24
				ld r24, X
				inc r24							; Adiciona um a dezena

				cpi r24, 0x36					; Verifica overflow das dezenas segundos
				breq cronAddUnMin				; Adiciona minuto

				
				st X+, r24

				ldi r24, 0x30					; Atualiza unidade segundo
				st X, r24
				ret


; Link para funcao que inicializa o cronometro
; -----------------------------------------------------------------------------
cronoIniLink:	
				rjmp cronoIni
				ret


; Atualiza a unidade do minuto
; -----------------------------------------------------------------------------
cronAddUnMin:	ldi Xh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
        		ldi Xl, low(SRAM_START)     	; Seta Xl como o inicio da SRAM
				
				ldi r24, 0x4					; Obtem o byte do minuto
				add Xl, r24
				ld r24, X
				inc r24

				cpi r24, 0x3A					; Verifica overflow unidade dos minutos
				breq cronAddDzMin


				st X+, r24						; Incrementa o minuto na memoria

				ldi r24, 0x3A					; Refaz a parte dos segundos
				st X+, r24
				ldi r24, 0x30
				st X+, r24
				st X+, r24

				ret

; Atualiza a dezena do minuto
; -----------------------------------------------------------------------------
cronAddDzMin:	ldi Xh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
        		ldi Xl, low(SRAM_START)     	; Seta Xl como o inicio da SRAM
				
				ldi r24, 0x3					; Obtem o byte do minuto
				add Xl, r24
				ld r24, X
				inc r24

				cpi r24, 0x36					; Verifica overflow para completar hora
				breq cronAddUnHora


				st X+, r24						; Incrementa o minuto na memoria

				ldi r24, 0x30					; Refaz a parte dos segundos
				st X+, r24
				ldi r24, 0x3A
				st X+, r24
				ldi r24, 0x30
				st X+, r24
				st X+, r24

				ret

; Atualiza a unidade hora
; -----------------------------------------------------------------------------
cronAddUnHora:	ldi Xh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
        		ldi Xl, low(SRAM_START)     	; Seta Xl como o inicio da SRAM
				
				ldi r24, 0x1					; Obtem o byte do minuto
				add Xl, r24
				ld r24, X
				inc r24

				cpi r24, 0x3A					; Verifica overflow para completar hora
				breq cronAddDzHora

				st X+, r24						; Incrementa o minuto na memoria

				ldi r24, 0x3A
				st X+, r24
				ldi r24, 0x30					; Refaz a parte dos minutos e segundos
				st X+, r24
				st X+, r24
				ldi r24, 0x3A
				st X+, r24
				ldi r24, 0x30
				st X+, r24
				st X+, r24

				ret

; Atualiza a dezena hora
; -----------------------------------------------------------------------------
cronAddDzHora:	ldi Xh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
        		ldi Xl, low(SRAM_START)     	; Seta Xl como o inicio da SRAM
				
				ldi r24, 0x0					; Obtem o byte do minuto
				add Xl, r24
				ld r24, X
				inc r24

				st X+, r24						; Incrementa o minuto na memoria

				ldi r24, 0x30					; Refaz a parte dos minutos e segundos
				st X+, r24
				ldi r24, 0x3A					
				st X+, r24
				ldi r24, 0x30					
				st X+, r24
				st X+, r24
				ldi r24, 0x3A
				st X+, r24
				ldi r24, 0x30
				st X+, r24
				st X+, r24

				ret


; Verifica a ocorrencia de 24h
; -----------------------------------------------------------------------------
chk24h:			ldi Xh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
        		ldi Xl, low(SRAM_START)     	; Seta Xl como o inicio da SRAM
				
				ld r24, X+
				ld r23, X

				cpi r24, 0x32
				breq chk24hA
				ret

chk24hA:		cpi r23, 0x34
				breq chk24hB
				ret

chk24hB:		rcall cronoIniLink
				ldi Xh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
        		ldi Xl, low(SRAM_START)     	; Seta Xl como o inicio da SRAM
				ldi   lcdinput,1				; Apaga o LCD
				rcall lcd_cmd		
				rcall lcd_busy
				rcall writemsg					; Exibe a mensagem 
				rcall clenPortB
				ret


; -----------------------------------------------------------------------------
; ### LCD FUNCTIONS ###
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
clenPortB:		clr r22
				out ddrb, r22
				out pinb, r22
				ret

; -----------------------------------------------------------------------------
lcd_busy:										; test the busy state
				sbi portc,RW        			; RW high to read
				cbi portc,RS        			; RS low to read

				ldi r22,00          			; make port input
				out ddrb,r22
				out portb,r22

; -----------------------------------------------------------------------------
looplcd:
				sbi portc,ENABLE    			; begin read sequence
				in r22,pinb         			; read it
				cbi portc,ENABLE    			; set enable back to low
				sbrc r22,7          			; test bit 7, skip if clear
				rjmp looplcd       				; jump if set

				ldi r22,0xff        			; make port output
				out ddrb,r22
				ret


; -----------------------------------------------------------------------------
lcd_cmd:

				cbi portc,RS    				; RS low for command mode
				cbi portc,RW    				; RW low to write
				sbi portc,ENABLE    			; Enable HIGH
				out portb,lcdinput  			; output
				cbi portc,ENABLE    			; Enable LOW to execute

				ret

; -----------------------------------------------------------------------------
lcd_write:

				sbi portc,RS    				; RS high
				cbi portc,RW    				; RW low to write
				sbi portc,ENABLE    			; Enable HIGH
				out portb,lcdinput  			; output
				cbi portc,ENABLE    			; Enable LOW to execute

				ret

; -----------------------------------------------------------------------------
writemsg:		cpi r25, 0x0
				breq writemsgmp
				rjmp writemsgsram

; -----------------------------------------------------------------------------
writemsgmp:		lpm lcdinput,Z+      			; load r0 with the character to display, increment the string counter
				rjmp writemsgbd

; -----------------------------------------------------------------------------
writemsgsram:	ld lcdinput, X+

; -----------------------------------------------------------------------------
writemsgbd: 	cpi lcdinput, 0
				breq writedone
    			rcall lcd_write
    			rcall lcd_busy
    			rjmp writemsg

; -----------------------------------------------------------------------------
writedone:
 				ret

; -----------------------------------------------------------------------------
lcdinit: 										;initialize LCD
				ldi r22,0xFF
				out ddrb,r22 					;portb is the LCD data port, 8 bit mode set for output
				out ddrc,r22					;portc is the LCD control pins set for output
				ldi lcdinput,56  				; init the LCD. 8 bit mode, 2*16
				rcall lcd_cmd    				; execute the command
				rcall lcd_busy   				; test busy
				ldi lcdinput,1					; clear screen
				rcall lcd_cmd
				rcall lcd_busy
				ldi lcdinput,2      			; cursor home command
    			rcall lcd_cmd        			; execute command
    			rcall lcd_busy
				ret
; -----------------------------------------------------------------------------



end:			
				rjmp loop						; Final do programa

; Mensagens
; -----------------------------------------------------------------------------
msg_hhmmss:  	.db      "HH:MM:SS",0
msg_n1:  	.db      "RA: 083382 MC404",0
