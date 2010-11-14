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
.def    		lcdinput    =   r20
.def 			r			= 	r21				; Registrador de uso geral
.def 			rr			= 	r22				; Registrador de uso geral 2
.def			dgCount		= 	r24				; Contador de digitos no lcd
.def			lcdIoFlag	= 	r25				; Flag para verificar de onde será lido os dados para 
												; atualizar o lcd, caso 0: Program Memory apontado por Z,
												; caso contrario: SRAM

.equ			OPSR1		= 0x12A				; Operando 1
.equ			OPSR2		= 0x13A				; Operando 2
.equ			OPSR		= 0x14A				; Tipo de Operacao [1 = Soma, 2 = Multiplicacao, 3 = Divisao]


												; Contantes de multiplicacao
.def 			Res1 = R2
.def 			Res2 = R3
.def 			Res3 = R4
.def 			Res4 = R5
.def 			m1L = R16
.def 			m1M = R17
.def 			m2L = R18
.def 			m2M = R19
.def 			tmp = R20


; -----------------------------------------------------------------------------
; ### MACRO SECTION ###
; -----------------------------------------------------------------------------


; Macro para somar 2 numeros imediatos de 16bits, guarda o resultado no primeiro parametro
; -----------------------------------------------------------------------------
.macro addi16
		subi @0, low(-@2)
        sbci @1, high(-@2)
.endmacro


; Macro para somar 2 numeros de 16bits, guarda o resultado no primeiro parametro
; -----------------------------------------------------------------------------
.macro add16
        add @0, @2
		adc @1, @3
.endmacro


; Inicializa a aplicacao
; -----------------------------------------------------------------------------
start:			
				rjmp	RESET					; Funcao de Reset


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

				clr r							; Limpa a operacao a ser executada
				rcall setOperacao									
				
												; Limpa operadores 1 e 2 na SRAM
				ldi	Zh, high(OPSR1)			
				ldi	Zl, low(OPSR1)
				st Z+, r
				st Z, r

				ldi	Zh, high(OPSR2)			
				ldi	Zl, low(OPSR2)
				st Z+, r
				st Z, r
				

				; Test
				rcall key1
				rcall key2
				rcall key3
				rcall key3
				rcall key0
				rcall key1
				rcall keyAdd
				rcall key1
				rcall keyEnter					; Era esperado o resultado 302 no lcd

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



; Seta o tipo de operacao a ser executada na SRAM, apontada por OPSR, cujo valor esta em r
; -----------------------------------------------------------------------------
setOperacao:
				ldi Zh, high(OPSR)
				ldi Zl, low(OPSR)
				st Z, r
				ret

; Obtem o tipo de operacao a ser executada na SRAM, apontada por OPSR, cujo valor sera armazenado em r
; -----------------------------------------------------------------------------
getOperacao:	ldi Zh, high(OPSR)
				ldi Zl, low(OPSR)
				ld r, Z
				ret


; Trata o acionamento dos botoes da aplicacao
; -----------------------------------------------------------------------------
keyPress: 		in r, pinb
				cpi r, 0x1
				breq key1
				ret

key0:			ldi r, 0x30						; Seta o valor 0 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x0
				mov r9, r
				rcall convertToBin
				ret

key1:			ldi r, 0x31						; Seta o valor 1 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x1
				mov r9, r
				rcall convertToBin
				ret

key2:			ldi r, 0x32						; Seta o valor 2 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x2
				mov r9, r
				rcall convertToBin
				ret

key3:			ldi r, 0x33						; Seta o valor 3 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x3
				mov r9, r
				rcall convertToBin
				ret

key4:			ldi r, 0x34						; Seta o valor 4 a ser exibido no lcd
				rcall indexInLcd
				rcall convertToBin
				clr r8
				ldi r, 0x4
				mov r9, r
				rcall convertToBin
				ret

key5:			ldi r, 0x35						; Seta o valor 5 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x5
				mov r9, r
				rcall convertToBin
				ret

key6:			ldi r, 0x36						; Seta o valor 6 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x6
				mov r9, r
				rcall convertToBin
				ret

key7:			ldi r, 0x37						; Seta o valor 7 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x7
				mov r9, r
				rcall convertToBin
				ret

key8:			ldi r, 0x38						; Seta o valor 8 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x8
				mov r9, r
				rcall convertToBin
				ret

key9:			ldi r, 0x39						; Seta o valor 9 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x9
				mov r9, r
				rcall convertToBin
				ret

; Acionamento do multiplicador add
; -----------------------------------------------------------------------------
keyClear:	
				rjmp start						; Volta para o inicio da aplicação

; Acionamento do multiplicador add
; -----------------------------------------------------------------------------
keyAdd:			clr lcdIoFlag					; Marca como leitura Progam Memory
				clr dgCount						; Limpa a contagem
				ldi   lcdinput,	1				; Apaga o LCD
				rcall lcd_cmd
				ldi Zl,low(lb_add*2)   			; Exibe o operador de soma no lcd
    			ldi Zh,high(lb_add*2)
    			rcall writemsg					; Exibe a mensagem 
				rcall clenPortB
												; Prepara para primeira escrita
				inc lcdIoFlag					; Habilita escrita no lcd a partir da SRAM
				ret

; Aciona a opcao enter no keypad
; -----------------------------------------------------------------------------
keyEnter:
				ret
				


; Converte os digitos da calculadora para binario, para fazer as operacoes matematicas
; -----------------------------------------------------------------------------
convertToBin:	rcall getOperacao				; Obtem o operador
				cpi r, 0x0						; Verifica se algum operador foi setado
				brne convertToBinA

				ldi	Zh, high(OPSR1)			
				ldi	Zl, low(OPSR1)
				ld r, Z+
				ld rr, Z

				cpi dgCount, 0x2				; Caso seja o primeiro operando
				brlo convertToBin1				
				breq convertToBin2

				mov m1M, r
				mov m1L, rr
				ldi m2M, 0x0
				ldi m2L, 0xA					; Multiplica o valor em memoria por 100
				rcall multiply
				mov r, res2
				mov rr, res1
				add16 r, rr, r8, r9
				ldi	Zh, high(OPSR1)			
				ldi	Zl, low(OPSR1)
				st Z+, r
				st Z, rr
				
				ret

convertToBin1:	add16 r, rr, r8, r9
				ldi	Zh, high(OPSR1)			
				ldi	Zl, low(OPSR1)
				st Z+, r
				st Z, rr
				
				ret


convertToBin2:	mov m1M, r
				mov m1L, rr
				ldi m2M, 0x0
				ldi m2L, 0xA					; Multiplica o valor em memoria por 10
				rcall multiply
				mov r, res2
				mov rr, res1
				add16 r, rr, r8, r9
				ldi	Zh, high(OPSR1)			
				ldi	Zl, low(OPSR1)
				st Z+, r
				st Z, rr


convertToBinA:									; Caso seja o segundo operando

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
; ### Operations FUNCTIONS ###
; -----------------------------------------------------------------------------
;
; Multiply
;
multiply:		clr R20 						; clear for carry operations
				mul m1M,m2M 					; Multiply MSBs
				mov Res3,R0 					; copy to MSW Result
				mov Res4,R1
				mul m1L,m2L 					; Multiply LSBs
				mov Res1,R0 					; copy to LSW Result
				mov Res2,R1
				mul m1M,m2L 					; Multiply 1M with 2L
				add Res2,R0 					; Add to Result
				adc Res3,R1
				adc Res4,tmp 					; add carry
				mul m1L,m2M 					; Multiply 1L with 2M
				add Res2,R0 					; Add to Result
				adc Res3,R1
				adc Res4,tmp
				ret
;
; Multiplication done
;
				

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




; Mensagens e labels
; -----------------------------------------------------------------------------
lb_clear:  		.db      "0", 0
lb_add:			.db		 "+", 0
lb_sub:			.db		 "-", 0
lb_mult:		.db		 "*", 0
lb_div:			.db		 "/", 0
err_div_zero:	.db  	"E = div por 0", 0
err_precision: 	.db		"E = precisao", 0
err_operator:	.db		"E = operando?", 0
