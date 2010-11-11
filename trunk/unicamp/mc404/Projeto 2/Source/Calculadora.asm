; -----------------------------------------------------------------------------
;  MC404-E
;
;  Atividade Obrigatoria 2 - calculadora
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
.def 			r			= 	r16				; Registrador de uso geral


; Inicializa a aplicacao
; -----------------------------------------------------------------------------
start:	rjmp	RESET							; Funcao de Reset



; Inicia a aplicacao
; -----------------------------------------------------------------------------
RESET:
			    ldi r, low(RAMEND)
				out	SPL,r						;initialize Stack Pointer to last RAM address		
				ldi	r,high(RAMEND)
				out SPH,r
				clr Yl							; will use X as an interrupt counter
				clr Yh

				;ldi r, 1
				;sts PCICR, r  					; set B port to activate PCINT0 and PCINT1 interruption
				;ldi r, 0b11111111
				;sts PCMSK0, r  					; activate PCINT0 and PCINT1 interruption

				;ldi    temp,      0b00000001    //CLK/1, normal mode, internal signal
    			;out    TCCR1B,    temp
    			;ldi    temp,      0b00000100    //overflow interupt
    			;out    TIMSK,     temp 

				; ----------
				ldi r,0b00000100
				sts TIMSK0,r
				ldi r,0b00000001
				out TCCR0B,r
				out SMCR,r

				;rcall lcdinit					; inicializa o LCD

				;clr r25							; Marca como leitura Progam Memory
				;ldi Zl,low(msg_hhmmss*2)   		; Seta a mensagem inicial no LDCD
    			;ldi Zh,high(msg_hhmmss*2)
    			;rcall writemsg					; Exibe a mensagem 
				;rcall clenPortB
				clt
				
				sei								; Habilita interrupção global
				rjmp loop


KeyScan: 	rjmp loop


; Loop principal da aplicação
; -----------------------------------------------------------------------------
loop:			ldi r, low(RAMEND)				; Remove lixo da pilha para evitar overflow
				out	SPL,r		
				clr r22
				out pinb, r22

				sei								; Habilita interrupção
				sleep							; Entra em loop aguardando uma interrupção
				rjmp loop


; Trata o acionamento dos botoes da aplicacao
; -----------------------------------------------------------------------------
btnPressed: 	in r22, pinb
				cpi r22, 0x9
				breq startPressed
				ret

; Acionamento do botao Start
; -----------------------------------------------------------------------------
startPressed:	clr r22                         
				out portb, r22
				brts startPressed1
				set
				ret

; Acionamento do botao Stop
; -----------------------------------------------------------------------------
startPressed1:	clr r22
				out pinb, r22
				clt
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
msg_n1:  		.db      "RA: 083382 MC404",0
