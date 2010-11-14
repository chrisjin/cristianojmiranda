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
.def 			rBin1H 		= r24
.def 			rBin1L 		= r23
.def 			rmp			= r16
.def			rBin2H		= r20
.def			rBin2L		= r21

.equ			OPSR1		= 0x128				; Operando 1
.equ			OPSR2		= 0x12C				; Operando 2
.equ			OPSR		= 0x130				; Tipo de Operacao [1 = Soma, 2 = Multiplicacao, 3 = Divisao]


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

				; Test

				clr rBin1H
				ldi rBin1L, 0b00001010
				rcall Bin2ToDigit
				; ----------------
				;ldi r, 0b10000001 ; 81
				;ori r, 0x30
				;ldi Xh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
        		;ldi Xl, low(SRAM_START)     	; Seta Xl como o inicio da SRAM

				;st X+, r
				;clr r
				;st X, r

    			;rcall writemsg					; Exibe a mensagem 
				;rcall clenPortB

				; ----------------

				rcall key1
				rcall key2
				rcall key3
				rcall key3
				rcall key0
				rcall key1
				rcall keyAdd
				rcall key1
				rcall keyEnter					; Era esperado o resultado 302 no lcd

				ldi Zh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
        		ldi Zl, low(SRAM_START)     	; Seta Xl como o inicio da SRAM
				rcall Bcd5ToBin2

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
				


; Converte os digitos da calculadora para binario
; -----------------------------------------------------------------------------
convertToBin:	


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



; -----------------------------------------------------------------------------
; ### BCD FUNCTIONS ###
; -----------------------------------------------------------------------------
; Bcd5ToBin2
; ==========
; converts a 5-bit-BCD to a 16-bit-binary
; In: Z points to the most signifant digit of the BCD
; Out: T-flag shows general result:
;   T=0: Binary in rBin1H:L is valid, Z points to the
;     first digit of the BCD converted
;   T=1: Error during conversion. Either the BCD was too
;     big (must be 0..65535, Z points to BCD where the
;     overflow occurred) or an illegal BCD was detected
;     (Z points to the first non-BCD digit).
; Used registers: rBin1H:L (result), R0 (restored after
;   use), rBin2H:L (restored after use), rmp
; Called subroutines: Bin1Mul10
;
Bcd5ToBin2:
	push R0 ; Save register
	clr rBin1H ; Empty result
	clr rBin1L
	ldi rmp,5 ; Set counter to 5
	mov R0,rmp
	clt ; Clear error flag
Bcd5ToBin2a:
	ld rmp,Z+ ; Read BCD digit
	cpi rmp,10 ; is it valid?
	brcc Bcd5ToBin2c ; invalid BCD
	rcall Bin1Mul10 ; Multiply result by 10
	brts Bcd5ToBin2c ; Overflow occurred
	add rBin1L,rmp ; add digit
	brcc Bcd5ToBin2b ; No overflow to MSB
	inc rBin1H ; Overflow to MSB
	breq Bcd5ToBin2c ; Overflow of MSB
Bcd5ToBin2b:
	dec R0 ; another digit?
	brne Bcd5ToBin2a ; Yes
	pop R0 ; Restore register
	sbiw ZL,5 ; Set to first BCD digit
	ret ; Return
Bcd5ToBin2c:
	sbiw ZL,1 ; back one digit
	pop R0 ; Restore register
	set ; Set T-flag, error
	ret ; and return
;

; Bin1Mul10
; =========
; multiplies a 16-bit-binary by 10
; Sub used by: AscToBin2, Asc5ToBin2, Bcd5ToBin2
; In: 16-bit-binary in rBin1H:L
; Out: T-flag shows general result:
;   T=0: Valid result, 16-bit-binary in rBin1H:L ok
;   T=1: Overflow occurred, number too big
;
Bin1Mul10:
	push rBin2H ; Save the register of 16-bit-binary 2
	push rBin2L
	mov rBin2H,rBin1H ; Copy the number
	mov rBin2L,rBin1L
	add rBin1L,rBin1L ; Multiply by 2
	adc rBin1H,rBin1H
	brcs Bin1Mul10b ; overflow, get out of here
Bin1Mul10a:
	add rBin1L,rbin1L ; again multiply by 2 (4*number reached)
	adc rBin1H,rBin1H
	brcs Bin1Mul10b ; overflow, get out of here
	add rBin1L,rBin2L ; add the copied number (5*number reached)
	adc rBin1H,rBin2H
	brcs Bin1Mul10b ;overflow, get out of here
	add rBin1L,rBin1L ; again multiply by 2 (10*number reached)
	adc rBin1H,rBin1H
	brcc Bin1Mul10c ; no overflow occurred, don't set T-flag
Bin1Mul10b:
	set ; an overflow occurred during multplication
Bin1Mul10c:
	pop rBin2L ; Restore the registers of 16-bit-binary 2
	pop rBin2H
	ret


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


; Final de execucao da aplicacao
; -----------------------------------------------------------------------------
end:			
				rjmp loop						; Final do programa


; -----------------------------------------------------------------------------
; ### BCD FUNCTIONS ###
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
