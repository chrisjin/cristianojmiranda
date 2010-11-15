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

; Registradores utilzados: r2, r3, r16, r17, r19, r20, r21, r22, r24, r25, r27, r29
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
.equ			LCDIOFLAG	= 	0x15A			; Flag para verificar de onde será lido os dados para 
												; atualizar o lcd, caso 0: Program Memory apontado por Z,
												; caso contrario: SRAM
.equ			ERROFLAG	= 	0x15B			; Flag para registrar erro de operacao, 1 = Erro

.equ			OPSR1		= 0x12A				; Operando 1
.equ			OPSR2		= 0x13A				; Operando 2
.equ			OPSR		= 0x14A				; Tipo de Operacao [1 = Soma, 2 = Multiplicacao, 3 = Divisao, 4 = Subtracao]


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


												; Contantes de conversao
.def			rmp 		= r20
.def			rBin1H		= r16
.def			rBin1L		= r17
.def			rBin2H		= r18
.def			rBin2L		= r19


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
				clr r
				rcall setErroFlag					; Limpa o flag de erro

				rcall lcdinit					; inicializa o LCD

				
				clr r							; Marca como leitura Progam Memory
				rcall setLcdIoFlag
				ldi Zl,low(lb_clear*2)   		; Seta o status inicial no LCD
    			ldi Zh,high(lb_clear*2)
    			rcall writemsg					; Exibe a mensagem 
				rcall clenPortB
												; Prepara para primeira escrita
												; Habilita escrita no lcd a partir da SRAM
				ldi r, 0x1
				rcall setLcdIoFlag
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
				rcall keyAdd					; Entrada 301 no operando 1, aciona o operador soma
				rcall key2
				rcall key2
				rcall key2
				rcall key2
				rcall key1						; Entrada 21 no operando 2
				rcall keyEnter					; Era esperado o resultado 322 no lcd

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

; Seta o tipo de operacao a ser executada na SRAM, apontada por OPSR, cujo valor esta em r
; -----------------------------------------------------------------------------
setLcdIoFlag:
				ldi Yh, high(lcdIoFlag)
				ldi Yl, low(lcdIoFlag)
				st Y, r
				ret

; Obtem o tipo de operacao a ser executada na SRAM, apontada por OPSR, cujo valor sera armazenado em r
; -----------------------------------------------------------------------------
getLcdIoFlag:	ldi Yh, high(lcdIoFlag)
				ldi Yl, low(lcdIoFlag)
				ld r, Y
				ret

; Seta o tipo de operacao a ser executada na SRAM, apontada por OPSR, cujo valor esta em r
; -----------------------------------------------------------------------------
setErroFlag:
				ldi Yh, high(ERROFLAG)
				ldi Yl, low(ERROFLAG)
				st Y, r
				ret

; Obtem o tipo de operacao a ser executada na SRAM, apontada por OPSR, cujo valor sera armazenado em r
; -----------------------------------------------------------------------------
getErroFlag:	ldi Yh, high(ERROFLAG)
				ldi Yl, low(ERROFLAG)
				ld r, Y
				ret

; Verifica se ocorreu erro de execucao
; -----------------------------------------------------------------------------
verificaErro:	rcall getErroFlag
				cpi r, 0x0
				brne loop
				ret

; Trata o acionamento dos botoes da aplicacao
; -----------------------------------------------------------------------------
keyPress: 		in r, pinb
				cpi r, 0x1
				breq key1
				ret

key0:			rcall verificaErro
				ldi rr, 0x30						; Seta o valor 0 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x0
				mov r9, r
				rcall convertToBin
				ret

key1:			rcall verificaErro
				ldi rr, 0x31						; Seta o valor 1 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x1
				mov r9, r
				rcall convertToBin
				ret

key2:			rcall verificaErro
				ldi rr, 0x32						; Seta o valor 2 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x2
				mov r9, r
				rcall convertToBin
				ret

key3:			rcall verificaErro
				ldi rr, 0x33						; Seta o valor 3 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x3
				mov r9, r
				rcall convertToBin
				ret

key4:			rcall verificaErro
				ldi rr, 0x34						; Seta o valor 4 a ser exibido no lcd
				rcall indexInLcd
				rcall convertToBin
				clr r8
				ldi r, 0x4
				mov r9, r
				rcall convertToBin
				ret

key5:			rcall verificaErro
				ldi rr, 0x35						; Seta o valor 5 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x5
				mov r9, r
				rcall convertToBin
				ret

key6:			rcall verificaErro
				ldi rr, 0x36						; Seta o valor 6 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x6
				mov r9, r
				rcall convertToBin
				ret

key7:			rcall verificaErro
				ldi rr, 0x37						; Seta o valor 7 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x7
				mov r9, r
				rcall convertToBin
				ret

key8:			rcall verificaErro
				ldi rr, 0x38						; Seta o valor 8 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x8
				mov r9, r
				rcall convertToBin
				ret

key9:			rcall verificaErro
				ldi rr, 0x39						; Seta o valor 9 a ser exibido no lcd
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
keyAdd:			
				clr dgCount						; Limpa a contagem
				ldi   lcdinput,	1				; Apaga o LCD
				rcall lcd_cmd

				clr r
				rcall setLcdIoFlag				; Marca como leitura Progam Memory
				ldi Zl,low(lb_add*2)   			; Exibe o operador de soma no lcd
    			ldi Zh,high(lb_add*2)				
    			rcall writemsg					; Exibe a mensagem 
				rcall clenPortB

				ldi r, 0x1						; Seta a operacao como soma
				rcall setOperacao
				
				ldi r, 0x1						; Prepara para primeira escrita
				rcall setLcdIoFlag				; Habilita escrita no lcd a partir da SRAM
				ret

; Aciona a opcao enter no keypad
; -----------------------------------------------------------------------------
keyEnter:		rcall getOperacao				; Obtem operacao
				cpi r, 0x0						; Caso nao haja operacao
				breq erroOperador

												; Obtem os operadores da SRAM
				ldi	Zh, high(OPSR1)			
				ldi	Zl, low(OPSR1)
				ld r25, Z+						; Operador1 em r25 e r26
				ld r26, Z

				ldi	Zh, high(OPSR2)			
				ldi	Zl, low(OPSR2)
				ld r27, Z+						; Operador2 em r27 e r28
				ld r28, Z

				cpi r, 0x1						; Caso seja operador de soma
				breq opSoma

				cpi r, 0x2						; Caso seja operador de multiplicacao
				breq opMult

				cpi r, 0x3						; Caso seja operador de divisao
				breq opDiv

				cpi r, 0x4						; Caso seja operador de subtracao
				breq opSub

				ret


; Soma
; -----------------------------------------------------------------------------
opSoma:			add16 r25, r26, r27, r28		; Executa a soma
				rcall showLcdResult
				ret

; Multiplicacao
; -----------------------------------------------------------------------------
opMult:											; Executa a multiplicacao
				ret

; Divisao
; -----------------------------------------------------------------------------
opDiv:											; Executa divisao

				ret

; Subtracao
; -----------------------------------------------------------------------------
opSub:											; Executa a subtracao

				ret


; Exibe os valores dos registradores r25 e r26 no lcd
; -----------------------------------------------------------------------------
showLcdResult:	ldi   lcdinput,	1				; Apaga o LCD
				rcall lcd_cmd		
				mov rBin1H, r25
				mov rBin1L, r26
				ldi Zh, high(SRAM_START)    	; Seta Zh como o inicio da SRAM
        		ldi Zl, low(SRAM_START) 
				rcall Bin2ToAsc

				clr r							; Delimita o display numerico
				ldi Zh, high(0x105)				
				ldi Zl, low(0x105)
				st Z, r

				ldi r, 0x1
				rcall setLcdIoFlag
				ldi Xh, high(SRAM_START)    	; Seta Zh como o inicio da SRAM
        		ldi Xl, low(SRAM_START) 
    			rcall writemsg					; Exibe a mensagem 
				rcall clenPortB
				ret
				
; Exibe mensagem de falta de operador
; -----------------------------------------------------------------------------
erroOperador:	clr r
				rcall setLcdIoFlag				; Marca como leitura Progam Memory
				ldi   lcdinput,	1				; Apaga o LCD
				ldi r, 0x1
				rcall setErroFlag				; Seta o flag de erro
				rcall lcd_cmd		
				ldi Zl,low(err_operator*2)   	; Seta mensagem de falta de operador
    			ldi Zh,high(err_operator*2)
    			rcall writemsg					; Exibe a mensagem 
				rcall clenPortB
						
				ldi r, 0x1						; Habilita escrita a partir da SRAM
				rcall setLcdIoFlag
				rjmp loop						


; Converte os digitos da calculadora para binario, para fazer as operacoes matematicas
; -----------------------------------------------------------------------------
convertToBin:	rcall getOperacao				; Obtem o operador
				cpi r, 0x0						; Verifica se algum operador foi setado
				brne convertToBinA

				ldi	Zh, high(OPSR1)			
				ldi	Zl, low(OPSR1)
				ld r, Z+
				ld rr, Z

				cpi dgCount, 0x1				; Caso seja o primeiro operando
				breq convertToBin1
				rjmp convertToBin2
				
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
				ret


convertToBinA:									; Caso seja o segundo operando
				ldi	Zh, high(OPSR2)			
				ldi	Zl, low(OPSR2)
				ld r, Z+
				ld rr, Z

				cpi dgCount, 0x1				; Caso seja o primeiro operando
				breq convertToBinA1
				rjmp convertToBinA2
				
				ret

convertToBinA1:	add16 r, rr, r8, r9
				ldi	Zh, high(OPSR2)			
				ldi	Zl, low(OPSR2)
				st Z+, r
				st Z, rr
				
				ret


convertToBinA2:	mov m1M, r
				mov m1L, rr
				ldi m2M, 0x0
				ldi m2L, 0xA					; Multiplica o valor em memoria por 10
				rcall multiply
				mov r, res2
				mov rr, res1
				add16 r, rr, r8, r9
				ldi	Zh, high(OPSR2)			
				ldi	Zl, low(OPSR2)
				st Z+, r
				st Z, rr
				ret

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

				st X+, rr
				clr rr
				st X, rr

				rjmp indexInLcd1

lcdInOverflow:	ldi dgCount, 0x1				; Limpa a contagem
				ldi Xh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
        		ldi Xl, low(SRAM_START)     	; Seta Xl como o inicio da SRAM
				clr r							; Finaliza a escrita do lcd
				st X+, rr
				st X+, r
				rcall getOperacao				; Obtem operacao
				cpi r, 0x0
				breq lcdInOverflowA
				rjmp lcdInOverflowB
				ret

lcdInOverflowA:	ldi	Zh, high(OPSR1)			
				ldi	Zl, low(OPSR1)
				clr r
				st Z+, r
				st Z, r
				rjmp indexInLcd1

lcdInOverflowB:	ldi	Zh, high(OPSR2)			
				ldi	Zl, low(OPSR2)
				clr r
				st Z+, r
				st Z, r
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


; Multiply
; -----------------------------------------------------------------------------
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
writemsg:		rcall getLcdIoFlag
				cpi r, 0x0
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



; Bin2ToAsc
; =========
; converts a 16-bit-binary to a 5-digit ASCII coded decimal,
;   the pointer points to the first significant digit of the
;   decimal, returns the number of digits
; In: 16-bit-binary in rBin1H:L, Z points to first digit of
;   the ASCII decimal (requires 5 digits buffer space, even
;   if the number is smaller!)
; Out: Z points to the first significant digit of the ASCII
;   decimal, rBin2L has the number of characters (1..5)
; Used registers: rBin1H:L (unchanged), rBin2H (changed),
;   rBin2L (result, length of number), rmp
; Called subroutines: Bin2ToBcd5, Bin2ToAsc5
;
Bin2ToAsc:
	rcall Bin2ToAsc5 ; Convert binary to ASCII
	ldi rmp,6 ; Counter is 6
	mov rBin2L,rmp
Bin2ToAsca:
	dec rBin2L ; decrement counter
	ld rmp,z+ ; read char and inc pointer
	cpi rmp,' ' ; was a blank?
	breq Bin2ToAsca ; Yes, was a blank
	sbiw ZL,1 ; one char backwards
	ret ; done

; Bin2ToAsc5
; ==========
; converts a 16-bit-binary to a 5 digit ASCII-coded decimal
; In: 16-bit-binary in rBin1H:L, Z points to the highest
;   of 5 ASCII digits, where the result goes to
; Out: Z points to the beginning of the ASCII string, lea-
;   ding zeros are filled with blanks
; Used registers: rBin1H:L (content is not changed),
;   rBin2H:L (content is changed), rmp
; Called subroutines: Bin2ToBcd5
;
Bin2ToAsc5:
	rcall Bin2ToBcd5 ; convert binary to BCD
	ldi rmp,4 ; Counter is 4 leading digits
	mov rBin2L,rmp
Bin2ToAsc5a:
	ld rmp,z ; read a BCD digit
	tst rmp ; check if leading zero
	brne Bin2ToAsc5b ; No, found digit >0
	ldi rmp,' ' ; overwrite with blank
	st z+,rmp ; store and set to next position
	dec rBin2L ; decrement counter
	brne Bin2ToAsc5a ; further leading blanks
	ld rmp,z ; Read the last BCD
Bin2ToAsc5b:
	inc rBin2L ; one more char
Bin2ToAsc5c:
	subi rmp,-'0' ; Add ASCII-0
	st z+,rmp ; store and inc pointer
	ld rmp,z ; read next char
	dec rBin2L ; more chars?
	brne Bin2ToAsc5c ; yes, go on
	sbiw ZL,5 ; Pointer to beginning of the BCD
	ret ; done
;

; Bin2ToBcd5
; ==========
; converts a 16-bit-binary to a 5-digit-BCD
; In: 16-bit-binary in rBin1H:L, Z points to first digit
;   where the result goes to
; Out: 5-digit-BCD, Z points to first BCD-digit
; Used registers: rBin1H:L (unchanged), rBin2H:L (changed),
;   rmp
; Called subroutines: Bin2ToDigit
;
Bin2ToBcd5:
	push rBin1H ; Save number
	push rBin1L
	ldi rmp,HIGH(10000) ; Start with tenthousands
	mov rBin2H,rmp
	ldi rmp,LOW(10000)
	mov rBin2L,rmp
	rcall Bin2ToDigit ; Calculate digit
	ldi rmp,HIGH(1000) ; Next with thousands
	mov rBin2H,rmp
	ldi rmp,LOW(1000)
	mov rBin2L,rmp
	rcall Bin2ToDigit ; Calculate digit
	ldi rmp,HIGH(100) ; Next with hundreds
	mov rBin2H,rmp
	ldi rmp,LOW(100)
	mov rBin2L,rmp
	rcall Bin2ToDigit ; Calculate digit
	ldi rmp,HIGH(10) ; Next with tens
	mov rBin2H,rmp
	ldi rmp,LOW(10)
	mov rBin2L,rmp
	rcall Bin2ToDigit ; Calculate digit
	st z,rBin1L ; Remainder are ones
	sbiw ZL,4 ; Put pointer to first BCD
	pop rBin1L ; Restore original binary
	pop rBin1H
	ret ; and return
;
; Bin2ToDigit
; ===========
; converts one decimal digit by continued subraction of a
;   binary coded decimal
; Used by: Bin2ToBcd5, Bin2ToAsc5, Bin2ToAsc
; In: 16-bit-binary in rBin1H:L, binary coded decimal in
;   rBin2H:L, Z points to current BCD digit
; Out: Result in Z, Z incremented
; Used registers: rBin1H:L (holds remainder of the binary),
;   rBin2H:L (unchanged), rmp
; Called subroutines: -
;
Bin2ToDigit:
	clr rmp ; digit count is zero
Bin2ToDigita:
	cp rBin1H,rBin2H ; Number bigger than decimal?
	brcs Bin2ToDigitc ; MSB smaller than decimal
	brne Bin2ToDigitb ; MSB bigger than decimal
	cp rBin1L,rBin2L ; LSB bigger or equal decimal
	brcs Bin2ToDigitc ; LSB smaller than decimal
Bin2ToDigitb:
	sub rBin1L,rBin2L ; Subtract LSB decimal
	sbc rBin1H,rBin2H ; Subtract MSB decimal
	inc rmp ; Increment digit count
	rjmp Bin2ToDigita ; Next loop
Bin2ToDigitc:
	st z+,rmp ; Save digit and increment
	ret ; done
;
; **************************************************
;
; Package III: From binary to Hex-ASCII
;


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
