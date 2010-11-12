; -----------------------------------------------------------------------------
;  MC404-E
;
;  Atividade Obrigatoria 2 - calculadora
;
;
;												Grupo:
;                                               Cristiano J. Miranda Ra: 083382
;												Teodoro				 Ra: 
; -----------------------------------------------------------------------------
.nolist
.include "m88def.inc"
.list

; Registradores utilzados: r16, r17, r19, r25
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
.def 			rr			= 	r18				; Registrador de uso geral 2
.def			dgCount		= 	r17				; Contador de digitos no lcd
.def			lcdIoFlag	= 	r25				; Flag para verificar de onde será lido os dados para 
												; atualizar o lcd, caso 0: Program Memory apontado por Z,
												; caso contrario: SRAM


; Inicializa a aplicacao
; -----------------------------------------------------------------------------
start:			
				rjmp	RESET							; Funcao de Reset


; Inicia a aplicacao
; -----------------------------------------------------------------------------
RESET:			ldi r, low(RAMEND)				; Inicializar Stack Pointer para o fim RAM 
				out	SPL,r						
				ldi	r,high(RAMEND)
				out SPH,r

				ldi dgCount, 0					; Zera o contador de digitos

				rcall lcdinit					; inicializa o LCD

				clr lcdIoFlag					; Marca como leitura Progam Memory
				ldi Zl,low(lb_clear*2)   		; Seta o status inicial no LCD
    			ldi Zh,high(lb_clear*2)
    			rcall writemsg					; Exibe a mensagem 
				rcall clenPortB
												; Prepara para primeira escrita
				inc lcdIoFlag					; Habilita escrita no lcd a partir da SRAM
				ldi Xh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
        		ldi Xl, low(SRAM_START)     	; Seta Xl como o inicio da SRAM

				; Test
				rcall key1
				rcall key2
				rcall key3
				rcall key3
				rcall key0
				rcall key1

				rjmp loop


; Loop principal da aplicação
; -----------------------------------------------------------------------------
loop:			ldi r, low(RAMEND)				; Remove lixo da pilha para evitar overflow
				out	SPL, r
				ldi	r, high(RAMEND)
				out SPH,r

				sei								; Habilita interrupção
				sleep							; Entra em loop aguardando uma interrupção
				rjmp loop


; Trata o acionamento dos botoes da aplicacao
; -----------------------------------------------------------------------------
keyPress: 		in r, pinb
				cpi r, 0x1
				breq key1
				ret

key1:			ldi r, 0x31						; Seta o valor 1 a ser exibido no lcd
				rcall indexInLcd
				ret

key2:			ldi r, 0x32						; Seta o valor 2 a ser exibido no lcd
				rcall indexInLcd
				ret

key3:			ldi r, 0x33						; Seta o valor 3 a ser exibido no lcd
				rcall indexInLcd
				ret

key4:			ldi r, 0x34						; Seta o valor 4 a ser exibido no lcd
				rcall indexInLcd
				ret

key5:			ldi r, 0x35						; Seta o valor 5 a ser exibido no lcd
				rcall indexInLcd
				ret

key6:			ldi r, 0x36						; Seta o valor 6 a ser exibido no lcd
				rcall indexInLcd
				ret

key7:			ldi r, 0x37						; Seta o valor 7 a ser exibido no lcd
				rcall indexInLcd
				ret

key8:			ldi r, 0x38						; Seta o valor 8 a ser exibido no lcd
				rcall indexInLcd
				ret

key9:			ldi r, 0x39						; Seta o valor 9 a ser exibido no lcd
				rcall indexInLcd
				ret

key0:			ldi r, 0x30						; Seta o valor 0 a ser exibido no lcd
				rcall indexInLcd
				ret





; Posiciona SRAM para escrever lcd input
; -----------------------------------------------------------------------------
indexInLcd:		inc dgCount						; Incrementa o contador de digitos
				cpi dgCount, 0x4				; Verifica se ocorreu overflow
				breq lcdInOverflow				; Ocorreu overflow

				ldi Xh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
        		ldi Xl, low(SRAM_START)     	; Seta Xl como o inicio da SRAM
				add Xl, dgCount
				subi Xl, 0x1

				st X+, r
				clr r
				st X, r

				rjmp indexInLcd1

lcdInOverflow:	ldi dgCount, 0x1				; Limpa a contagem
				ldi Xh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
        		ldi Xl, low(SRAM_START)     	; Seta Xl como o inicio da SRAM
				clr rr							; Finaliza a escrita do lcd
				st X+, r
				st X+, rr

												; Posiciona o cursor em X no inicio da SRAM
indexInLcd1:	ldi Xh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
        		ldi Xl, low(SRAM_START)     	; Seta Xl como o inicio da SRAM
				ldi   lcdinput,	1				; Apaga o LCD
				rcall lcd_cmd		
				rcall lcd_busy
    			rcall writemsg					; Exibe a mensagem 
				rcall clenPortB
				ret
				
				





; -----------------------------------------------------------------------------
; ### LCD FUNCTIONS ###
; -----------------------------------------------------------------------------

; Limpa a porta B, pois a mesma pode ser utilizada para funcoes lcd
; -----------------------------------------------------------------------------
clenPortB:		clr r
				out ddrb, r
				out pinb, r
				ret

; -----------------------------------------------------------------------------
lcd_busy:										; test the busy state
				sbi portc,RW        			; RW high to read
				cbi portc,RS        			; RS low to read

				ldi r, 00          				; make port input
				out ddrb, r
				out portb, r

; -----------------------------------------------------------------------------
looplcd:
				sbi portc,ENABLE    			; begin read sequence
				in r, pinb       	  			; read it
				cbi portc,ENABLE    			; set enable back to low
				sbrc r, 7          				; test bit 7, skip if clear
				rjmp looplcd       				; jump if set

				ldi r, 0xFF        				; make port output
				out ddrb, r
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
writemsg:		cpi lcdIoFlag, 0x0
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
lcdinit: 										; initialize LCD
				ldi r,0xFF
				out ddrb, r						; portb is the LCD data port, 8 bit mode set for output
				out ddrc,r						; portc is the LCD control pins set for output
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



; Final de execucao da aplicacao
; -----------------------------------------------------------------------------
end:			
				rjmp loop						; Final do programa

; Mensagens
; -----------------------------------------------------------------------------
lb_clear:  	.db      "0", 0
