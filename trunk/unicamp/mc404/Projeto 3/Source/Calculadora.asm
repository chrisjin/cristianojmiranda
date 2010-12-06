; -----------------------------------------------------------------------------
;  MC404-E
;
;  Atividade Obrigatoria 3 - Calculadora de Pilha utilizando RPN (Reverse Polish Notation)
;
;
;												Grupo:
;                                               Cristiano J. Miranda Ra: 083382
;												Teodoro	O. Wey	     Ra: 072448
; -----------------------------------------------------------------------------
.nolist
.include "m88def.inc"
.list

; Mapa de registradores utilzados: 
; -----------------------------------------------------------------------------
; r1 - *
; r2 - Resultado da multiplicacao1
; r3 - Resultado da multiplicacao2
; r4 - Resultado da multiplicacao3
; r5 - Resultado da multiplicacao4
; r6 - *
; r7 - *
; r8 - Utilizado temporariamente para converter ASCII para binario na memoria (utilizado como registrador zerado)
; r9 - Utilizado temporariamente para converter ASCII para binario na memoria
; r10 - Utilizado para exibir o resultado da operacao no lcd junto com r25 e r26
; r11 - registrador de operador 1
; r12 - *
; r13 - *
; r14 - Utilizado para armazenar o resto da divisao
; r15 - Utilizado para armazenar o resto da divisao
; r16 - Operador 1 da multiplicacao/divisao, Operador 1 para conversao binario to ascii
; r17 - Operador 1 da multiplicacao/divisao, Operador 1 para conversao binario to ascii
; r18 - Operador 2 da multiplicacao, Operador 2 para conversao binario to ascii, variavel auxiliar do keypad ********
; r19 - Operador 2 da multiplicacao, Operador 2 para conversao binario to ascii, variavel coluna do keypad  ********
; r20 - LcdInput, registrador tmp de multiplicacao, constante de conversao bin to asc, 
; r21 - r, 
; r22 - rr,
; r23 - dcnt16u (contador de iteracoes divisao)
; r24 - dgCount (contador de digitos do lcd)
; r25 - registrador de operador 1
; r26 - registrador de operador 1
; r27 - registrador de operador 2
; r28 - registrador de operador 2
; r29 - registrador de operador 2
; r30 - Zh
; r31 - Zl
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

.equ			FLNEGATIVO  =  0X15C			; Flag para sinal negativo (Caso 0: positivo, Caso contrario negativo)

.equ			OPSR1		= 0x12A				; Operando 1
.equ			OPSR		= 0x14A				; Tipo de Operacao [1 = Soma, 2 = Multiplicacao, 3 = Divisao, 4 = Subtracao]

												; Constantes para os operadores matematicos da calculadora
.equ 			OPADICAO	= 0x1				; Operador de soma
.equ 			OPMULTIPLIC	= 0x2				; Operador de multiplicacao
.equ 			OPDIVISAO	= 0x3				; Operador de divisao
.equ 			OPSUBTRACAO	= 0x4				; Operador de subtracao


												; Contantes de multiplicacao (16bits por 16 bits)
.def 			Res1 = R2						; Primeiros 8bits do resultado da multiplicacao
.def 			Res2 = R3						; Segundos 8bits do resultado da multiplicacao
.def 			Res3 = R4						; Terceiros 8bits do resultado da multiplicacao
.def 			Res4 = R5						; 8bits finais do resultado da multiplicacao
.def 			m1L = R16						; Operador 1 da multiplicacao/divisao
.def 			m1M = R17
.def 			m2L = R18						; Operador 2 da multiplicacao/divisao
.def 			m2M = R19
.def 			tmp = R20						; Registrador temporario da operacao



.def 			drem16uL=r14					;resto da divisao
.def 			drem16uH=r15
.def 			dres16uL=r16					;resultado da divisao
.def 			dres16uH=r17
.def 			dcnt16u = r23					;contador de iteracoes da divisao



												; Contantes de conversao de binario para Ascii
.def			rmp 		= r20
.def			rBin1T		= r6
.def			rBin1H		= r16
.def			rBin1L		= r17
.def			rBin2T		= r7
.def			rBin2H		= r18
.def			rBin2L		= r19


												; Constantes para keypad
.def aux = r27
.def coluna = r28


rcall null										; Hapsim

; -----------------------------------------------------------------------------
; ### MACRO SECTION ###
; -----------------------------------------------------------------------------

; Macro para somar 2 numeros de 16bits, guarda o resultado no primeiro parametro
; -----------------------------------------------------------------------------
.macro add16
        add @0, @2
		adc @1, @3
.endmacro

; Macro para somar 2 numeros de 24bits, guarda o resultado no primeiro parametro
; -----------------------------------------------------------------------------
.macro add24 ; (@0, @1, @2, | @3, @4, @5)
        add @0, @3
		adc @1, @4
		adc @2, @5
.endmacro


; Macro para subtrair 2 numeros de 16 bits, guarda o resultado no primeiro parametro
; -----------------------------------------------------------------------------
.macro sub16 ;(@1@0 - @3@2)
		sub @0,@2
		sbc @1,@3
.endmacro

; Macro para subtrair 2 numeros de 24 bits, guarda o resultado no primeiro parametro
; -----------------------------------------------------------------------------
.macro sub24 ;(@2@1@0 - @5@4@3)
		sub @0,@3
		sbc @1,@4
		sbc @2,@5
.endmacro

; Macro para dividir 2 numeros de 16 bits, guarda o resultado no primeiro parametro
; -----------------------------------------------------------------------------


; Inicializa a aplicacao
; -----------------------------------------------------------------------------
start:			
				rjmp	RESET					; Funcao de Reset


; Inicia a aplicacao
; -----------------------------------------------------------------------------
RESET:			

				ldi r, low(RAMEND)				; Inicializar Stack Pointer para o fim RAM 
				out	SPL,r						
				ldi	r,high(RAMEND)
				out SPH,r

				ldi dgCount, 0					; Zera o contador de digitos
				clr r
				rcall setErroFlag				; Limpa o flag de erro

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

				rcall setFlNegativo				; Seta o resultado como positivo
				
												; Limpa operadores 1 e 2 na SRAM
				ldi	Zh, high(OPSR1)			
				ldi	Zl, low(OPSR1)
				st Z+, r
				st Z+, r
				st Z, r

				rcall configKeypad
				rjmp loop


configKeypad:	ldi aux, 0x0F
				out DDRB, aux

				clr aux
				out DDRD, aux

				ldi coluna, 0xFE

				ldi aux, 0xFF
				out PIND, aux

				out PORTB, coluna
				ret

null: 			ret


; Loop principal da aplicação
; -----------------------------------------------------------------------------
loop:			ldi aux, 0xFF
				out PIND, aux

				out PORTB, coluna

				in aux, PIND

				swap aux
				andi aux, 0x0F
				cpi aux, 0x0F
				brne encerra

				sec
				rol coluna
				cpi coluna, 0xEF
				brne loop

				ldi coluna, 0xFE
				rjmp loop


encerra:
				cpi coluna, 0xFE
				breq coluna1
				cpi coluna, 0xFD
				breq coluna2
				cpi coluna, 0xFB
				breq coluna3
				cpi coluna, 0xF7
				breq coluna4
				rjmp loop

coluna1:
				cpi aux, 0xE
				breq key1Link
				cpi aux, 0xD
				breq key4Link
				cpi aux, 0xB
				breq key7Link
				cpi aux, 0x7
				breq keyClearLink
				rcall configKeypad
				rjmp loop

coluna2:
				cpi aux, 0xE
				breq key2Link
				cpi aux, 0xD
				breq key5Link
				cpi aux, 0xB
				breq key8Link
				cpi aux, 0x7
				breq key0Link
				rcall configKeypad
				rjmp loop

coluna3:
				cpi aux, 0xE
				breq key3Link
				cpi aux, 0xD
				breq key6Link
				cpi aux, 0xB
				breq key9Link
				cpi aux, 0x7
				breq keyEnterLink
				rcall configKeypad
				rjmp loop

coluna4:
				cpi aux, 0xE
				breq keyAddLink
				cpi aux, 0xD
				breq keySubLink
				cpi aux, 0xB
				breq keyMultLink
				cpi aux, 0x7
				breq keyDivLink
				rcall configKeypad
				rjmp loop

loopLink:		rcall configKeypad
				rjmp loop

; Links para rotinas
; -----------------------------------------------------------------------------
keyAddLink:		rjmp keyAdd
keySubLink:		rjmp keySub
keyMultLink:	rjmp keyMult
keyDivLink:		rjmp keyDiv
keyEnterLink:	rjmp keyEnter
keyClearLink:	rjmp keyClear
key0Link:		rjmp key0
key1Link:		rjmp key1
key2Link:		rjmp key2
key3Link:		rjmp key3
key4Link:		rjmp key4
key5Link:		rjmp key5
key7Link:		rjmp key7
key8Link:		rjmp key8
key6Link:		rjmp key6
key9Link:		rjmp key9


; Seta o tipo de operacao a ser executada na SRAM, apontada por OPSR, cujo valor esta em r
; Os valores devem ser setados em antes de executar essa rotina
; -----------------------------------------------------------------------------
setOperacao:
				ldi Zh, high(OPSR)
				ldi Zl, low(OPSR)
				st Z, r

				ret

; Obtem o tipo de operacao a ser executada na SRAM, apontada por OPSR, cujo valor sera armazenado em r
; O valor da SRAM eh armazenado em r
; -----------------------------------------------------------------------------
getOperacao:	ldi Zh, high(OPSR)
				ldi Zl, low(OPSR)
				ld r, Z

				ret

; Seta o sinal do resultado
; -----------------------------------------------------------------------------
setFlNegativo:
				ldi Zh, high(FLNEGATIVO)
				ldi Zl, low(FLNEGATIVO)
				st Z, r

				ret

; Obtem o sinal do resultado (positivo ou negativo)
; O valor da SRAM eh armazenado em r
; -----------------------------------------------------------------------------
getFlNegativo:	ldi Zh, high(FLNEGATIVO)
				ldi Zl, low(FLNEGATIVO)
				ld r, Z


				ret

; Seta o local de onde sera obtido os valores para escrever no LCD: 
;  - caso 0: Program Memory apontado por Z,
;  - caso contrario: SRAM
; Os valores devem ser setados em antes de executar essa rotina
; -----------------------------------------------------------------------------
setLcdIoFlag:
				ldi Yh, high(lcdIoFlag)
				ldi Yl, low(lcdIoFlag)
				st Y, r
				ret

; Obtem o local de onde sera obtido os valores para escrever no LCD: 
;  - caso 0: Program Memory apontado por Z,
;  - caso contrario: SRAM
; O valor da SRAM eh armazenado em r
; -----------------------------------------------------------------------------
getLcdIoFlag:	ldi Yh, high(lcdIoFlag)
				ldi Yl, low(lcdIoFlag)
				ld r, Y
				ret

; Seta a ocorrencia de erro na operacao
; Os valores devem ser setados em antes de executar essa rotina
; -----------------------------------------------------------------------------
setErroFlag:
				ldi Yh, high(ERROFLAG)
				ldi Yl, low(ERROFLAG)
				st Y, r
				ret

; Obtem a flag de ocorrencia de erro na operacao
; O valor da SRAM eh armazenado em r
; -----------------------------------------------------------------------------
getErroFlag:	ldi Yh, high(ERROFLAG)
				ldi Yl, low(ERROFLAG)
				ld r, Y
				ret

; Verifica se ocorreu erro de execucao
; -----------------------------------------------------------------------------
verificaErro:	rcall getErroFlag
				cpi r, 0x0
				brne loopLink
				ret

; Trata o acionamento dos botoes da aplicacao
; -----------------------------------------------------------------------------


; Btn Zero
; -----------------------------------------------------------------------------
key0:			rcall verificaErro
				ldi rr, 0x30						; Seta o valor 0 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x0
				mov r9, r

				clr r
				rcall setOperacao

				rcall convertToBin
				rcall configKeypad
				rjmp loop

; Btn Um
; -----------------------------------------------------------------------------
key1:			rcall verificaErro
				ldi rr, 0x31						; Seta o valor 1 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x1
				mov r9, r

				clr r
				rcall setOperacao

				rcall convertToBin
				rcall configKeypad
				rjmp loop

; Btn Dois
; -----------------------------------------------------------------------------
key2:			rcall verificaErro
				ldi rr, 0x32						; Seta o valor 2 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x2
				mov r9, r

				clr r
				rcall setOperacao

				rcall convertToBin
				rcall configKeypad
				rjmp loop

; Btn Tres
; -----------------------------------------------------------------------------
key3:			rcall verificaErro
				ldi rr, 0x33						; Seta o valor 3 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x3
				mov r9, r

				clr r
				rcall setOperacao

				rcall convertToBin
				rcall configKeypad
				rjmp loop

; Btn Quatro
; -----------------------------------------------------------------------------
key4:			rcall verificaErro
				ldi rr, 0x34						; Seta o valor 4 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x4
				mov r9, r

				clr r
				rcall setOperacao

				rcall convertToBin
				rcall configKeypad
				rjmp loop

; Btn Cinco
; -----------------------------------------------------------------------------
key5:			rcall verificaErro
				ldi rr, 0x35						; Seta o valor 5 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x5
				mov r9, r

				clr r
				rcall setOperacao

				rcall convertToBin
				rcall configKeypad
				rjmp loop

; Btn Seis
; -----------------------------------------------------------------------------
key6:			rcall verificaErro
				ldi rr, 0x36						; Seta o valor 6 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x6
				mov r9, r

				clr r
				rcall setOperacao

				rcall convertToBin
				rcall configKeypad
				rjmp loop

; Btn Sete
; -----------------------------------------------------------------------------
key7:			rcall verificaErro
				ldi rr, 0x37						; Seta o valor 7 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x7
				mov r9, r

				clr r
				rcall setOperacao

				rcall convertToBin
				rcall configKeypad
				rjmp loop

; Btn Oito
; -----------------------------------------------------------------------------
key8:			rcall verificaErro
				ldi rr, 0x38						; Seta o valor 8 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x8
				mov r9, r

				clr r
				rcall setOperacao

				rcall convertToBin
				rcall configKeypad
				rjmp loop

; Btn Nove
; -----------------------------------------------------------------------------
key9:			rcall verificaErro
				ldi rr, 0x39						; Seta o valor 9 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x9
				mov r9, r

				clr r
				rcall setOperacao

				rcall convertToBin
				rcall configKeypad
				rjmp loop

; Btn Clear
; -----------------------------------------------------------------------------
keyClear:	
				rjmp start						; Volta para o inicio da aplicação (RESET)

; Verifica se esta prestes a ocorrer overflow com a pilha
; -----------------------------------------------------------------------------
verPilha:		mov r, Yh
				cpi r, high(0x0500)
				breq verPilhac
				cpi r, high(0x04FC)
				breq verPilhaa 
				ret

verPilhaa:		mov r, Yl
				cpi r, low(0x04FC)
				breq verPilhab 
				ret 

verPilhab: 		out SPh, Yh
				out SPl, Yl
				rcall configKeypad
				rjmp loop

verPilhac: 		ldi r, high(RAMEND)
				out SPh, r
				ldi r, low(RAMEND)
				out SPl, r
				rcall configKeypad
				rjmp loop


; Btn Add
; -----------------------------------------------------------------------------
keyAdd:			rcall verificaErro
				clr dgCount						; Limpa a contagem de digitos do lcd

				in Yh, SPh
				in Yl, SPl
				rcall verPilha					; Verifica se existem 2 operadores na pilha

				ldi   lcdinput,	1				; Apaga o LCD
				rcall lcd_cmd

				pop r10
				pop r25
				pop r26

				pop r27
				pop r28
				pop r29

				rjmp opSoma						; Executa a soma

; Btn Sub
; -----------------------------------------------------------------------------
keySub:			rcall verificaErro
				clr dgCount						; Limpa a contagem de digitos do lcd

				in Yh, SPh
				in Yl, SPl
				rcall verPilha					; Verifica se existem 2 operadores na pilha

				ldi   lcdinput,	1				; Apaga o LCD
				rcall lcd_cmd		
				
				pop r27							; Obtem os parametros da operação
				pop r28	
				pop r29
				
				pop r11
				pop r25
				pop r26		

				rjmp opSub						; Executa a subtracao

; Link para erroOperador
; -----------------------------------------------------------------------------
erroOperadorLink: rjmp erroOperador

; Btn Multiplicacao
; -----------------------------------------------------------------------------
keyMult:		rcall verificaErro	
				clr dgCount						; Limpa a contagem de digitos do lcd

				in Yh, SPh
				in Yl, SPl
				rcall verPilha					; Verifica se existem 2 operadores na pilha
				
				ldi   lcdinput,	1				; Apaga o LCD
				rcall lcd_cmd

				pop r27							; Obtem os parametros da operação
				pop r28
				pop r29
				
				pop r11
				pop r25
				pop r26		

				rjmp opMult						; Executa a multiplicacao

; Btn Divisao
; -----------------------------------------------------------------------------
keyDiv:			rcall verificaErro
				clr dgCount						; Limpa a contagem de digitos do lcd
				
				in Yh, SPh
				in Yl, SPl
				rcall verPilha					; Verifica se existem 2 operadores na pilha
				
				ldi   lcdinput,	1				; Apaga o LCD
				rcall lcd_cmd
				
				pop r27							; Obtem os parametros da operação
				pop r28
				pop r29
				
				pop r11
				pop r25
				pop r26		
				
				rjmp opDiv					 	; Processa a divisao


; Aciona a opcao enter no keypad
; -----------------------------------------------------------------------------
keyEnter:										; Obtem os operadores da SRAM
				ldi	Zh, high(OPSR1)			
				ldi	Zl, low(OPSR1)
				ld r11, Z+
				ld r25, Z+						; Operador1 em r25 e r26
				ld r26, Z

				ldi dgCount, 0x3				; Limpa o contador de digitos para ocorrer overflow

				push r26						; Adiciona o operador a pilha
				push r25
				push r11

				rcall configKeypad

				rjmp loop


; Soma
; -----------------------------------------------------------------------------
opSoma:									 		; Executa a soma

				mov r, r10
				cpi r, 0x0						; Verifica overflow dos operandos
				brne opSomaa
				rjmp opSomac

opSomaa:		cpi r27, 0x0
				brne erroPrecisao

opSomac:		add r10, r27
				adc r25, r28
				adc r26, r29

				;ldi	Zh, high(OPSR1)			
				;ldi	Zl, low(OPSR1)
				;st Z+, r10
				;st Z+, r25
				;st Z, r26

				push r26						; Empilha o resultado
				push r25
				push r10

				rjmp showLcdResult				; Exibe o resultado da operacao no LCD


; Notifica falta de precisao na operacao a ser executada
; -----------------------------------------------------------------------------
erroPrecisao:	clr r							; Marca como leitura Progam Memory
				rcall setLcdIoFlag

				ldi r, 0x1
				rcall setErroFlag				; Seta o flag de erro

				ldi Zl,low(err_precision*2)   	; Seta o status inicial no LCD
    			ldi Zh,high(err_precision*2)
    			rcall writemsg					; Exibe a mensagem 
				rcall clenPortB
												; Prepara para primeira escrita
												; Habilita escrita no lcd a partir da SRAM
				ldi r, 0x1
				rcall setLcdIoFlag

				rcall configKeypad
				rjmp loop
			

; Multiplicacao
; -----------------------------------------------------------------------------
opMult:											; Executa a multiplicacao

				mov r, r11
				cpi r, 0x0
				brne erroPrecisao				; Verifica overflow dos registradores

				cpi r27, 0x0
				brne erroPrecisao
				
				mov m1M, r25					; Seta o operando 1 
				mov m1L, r26
				mov m2M, r28
				mov m2L, r29					; Seta o segundo operando
				rcall multiply					; Executa a multiplicacao

				mov r10, res3
				mov r25, res2					; Seta o resultado da multiplicacao nos registradores de exibicao
				mov r26, res1

				;ldi	Zh, high(OPSR1)			
				;ldi	Zl, low(OPSR1)
				;st Z+, r10
				;st Z+, r25
				;st Z, r26

				push r26						; Empilha o resultado
				push r25
				push r10

				rjmp showLcdResult				; Exibe o resultado da operacao no LCD
				


; Link para opSub
; -----------------------------------------------------------------------------
opSubLink:		rjmp opSub

; Divisao
; -----------------------------------------------------------------------------
opDiv:											

				cpi r28, 0x0					; Verifica se o operador 2 eh zero
				breq opDivZeroH
				rjmp opDivExecute				; Executa a divisao

; Verifica se o segundo operandoH eh zero, para caracterizar divisao por zero
; -----------------------------------------------------------------------------
opDivZeroH:		cpi r29, 0x0
				breq opDivZeroL
				rjmp opDivExecute				; Caso nao seja zero executa a divisao


; Verifica se o segundo operandoL eh zero, para caracterizar divisao por zero
; Notifica divisao por zero
; -----------------------------------------------------------------------------
opDivZeroL:		clr r
				rcall setLcdIoFlag				; Marca como leitura Progam Memory
				ldi   lcdinput,	1				; Apaga o LCD
				ldi r, 0x1
				rcall setErroFlag				; Seta o flag de erro
				rcall lcd_cmd		
				ldi Zl,low(err_div_zero*2)   	; Seta mensagem de divisao por zero
    			ldi Zh,high(err_div_zero*2)
    			rcall writemsg					; Exibe a mensagem 
				rcall clenPortB
						
				ldi r, 0x1						; Habilita escrita a partir da SRAM
				rcall setLcdIoFlag
				rcall configKeypad
				rjmp loop

; Executa a divisao
; -----------------------------------------------------------------------------
opDivExecute:									; Executa divisao
				mov m1M, r25					; Seta o operando 1 
				mov m1L, r26
				mov m2M, r28
				mov m2L, r29	
				rcall divide

				mov r25,dres16uH				;Seta o resultado da divisao nos registradores de exibicao
				mov r26,dres16uL
				
				rjmp showLcdDiv				; Exibe o resultado da operacao no LCD(caso especial com decimais)

; Subtracao
; -----------------------------------------------------------------------------
opSub:			cp r11, r27						; Verifica se OP1 < OP2
				brlo invertOp

				cp r25, r28						; Verifica se OP1 < OP2
				brlo invertOp

				cp r26, r29						; Verifica se OP1 < OP2
				brlo invertOp

				rjmp opSubExec
				
; Subtracao - Inverte os operadores da subtracao
; -----------------------------------------------------------------------------
invertOp:		ldi r, 0x1						; Seta o flag de operacao negativa
				rcall setFlNegativo
				push r11
				push r25						; Inverte os registradores de subtracao
				push r26
				mov r11, r27					; Para que o operador maior fique sempre em OP1
				mov r25, r28
				mov r26, r29
				pop r29
				pop r28
				pop r27


; Subtracao - Executa a subtracao
; -----------------------------------------------------------------------------
opSubExec:										; Executa a subtracao
				sub24 r26, r25, r11, r29, r28, r27 	

				;ldi	Zh, high(OPSR1)			
				;ldi	Zl, low(OPSR1)
				;st Z+, r11
				;st Z+, r25
				;st Z, r26

				push r26						; Empilha o resultado
				push r25
				push r11

				mov r10, r11					; Move o registrador para exibir os valores corretamente

				rjmp showLcdResult				; Exibe o resultado da operacao no LCD


; Exibe os valores dos registradores r10, r25 e r26 no lcd
; -----------------------------------------------------------------------------
showLcdResult:	ldi   lcdinput,	1				; Apaga o LCD
				rcall lcd_cmd		

				mov rBin1T, r10
				mov rBin1H, r25					; Move o resultado para o registrador de conversao ascii
				mov rBin1L, r26

				ldi Zh, high(SRAM_START)    	; Seta Zh como o inicio da SRAM para iniciar escrita do resultado em ascii
        		ldi Zl, low(SRAM_START) 

				rcall Bin2ToAsc					; Converte o resultado em ascii
			
				
				clr r							; Delimita o display numerico no sexto digito
				ldi Zh, high(0x106)				
				ldi Zl, low(0x106)
				st Z, r
				
												; Exibe o resultado convertido
				ldi r, 0x1						; Habilita a leitura do LCD a partir da SRAM
				rcall setLcdIoFlag

				ldi Xh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
        		ldi Xl, low(SRAM_START) 

				rcall getFlNegativo				; Verifica se o resultado eh negativo
				cpi r, 0x0						; Caso seja negativo
				brne showResultNeg

				clr r
				rcall setFlNegativo				; Limpa resultado negativo

    			rcall writemsg					; Exibe a mensagem 
				rcall clenPortB
				
				rcall configKeypad
				rjmp loop

showResultNeg:	ldi r, '-'						; Carrega o sinal a ser exibido
				ldi Zh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
        		ldi Zl, low(SRAM_START) 
				st Z, r

				clr r
				rcall setFlNegativo				; Limpa resultado negativo

    			rcall writemsg					; Exibe a mensagem 
				rcall clenPortB

				rcall configKeypad
				rjmp loop

; Exibe o resultado da divisao
; -----------------------------------------------------------------------------
showLcdDiv:		ldi   lcdinput,	1				; Apaga o LCD
				rcall lcd_cmd		

				mov rBin1H, r25					; Move o resultado para o registrador de conversao ascii
				mov rBin1L, r26

				ldi Zh, high(SRAM_START)    	; Seta Zh como o inicio da SRAM para iniciar escrita do resultado em ascii
        		ldi Zl, low(SRAM_START) 

				rcall Bin2ToAsc					; Converte o resultado em ascii
			
							
				ldi r,','
				ldi Zh,high(0x106)
				ldi Zl,low(0x106)
				st Z+,r

				ldi r,100
				mov r26,r14				
				mov	r25,r15
				;mul r25,r
				mul r26,r

				mov m1M, r0			
				mov m1L, r1
				mov m2M, r27
				mov m2L, r28
								
				rcall divide
			
				clr rBin1H						;Seta o resultado da divisao nos registradores de exibicao
				mov rBin1L,dres16uH	
							
				rcall Bin2ToAsc 				; Converte o resultado em ascii 
												; Move os digitos para os locais corretos ;0000120				
				ldi Zh, high(0x10B)
				ldi Zl, low(0x10B) 
				ld r, Z
				
				ldi Zh, high(0x107)
				ldi Zl, low(0x107)
				cpi r,0x20  
				breq showLcdDivA
				st Z,r
				rjmp showLcdDivB
				
showLcdDivA:
				ldi r,0x30
				st Z,r
					
showLcdDivB:	
				ldi Zh, high(0x10C)
				ldi Zl, low(0x10C) 
				ld r, Z
				
				ldi Zh, high(0x108)
				ldi Zl, low(0x108) 
				st Z, r

				clr r
				ldi Zh,high(0x109)
				ldi Zl,low(0x109)	
				st Z,r
				
				ldi r, 0x1						; Habilita a leitura do LCD a partir da SRAM
				rcall setLcdIoFlag

				ldi Xh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
        		ldi Xl, low(SRAM_START) 

				rcall getFlNegativo				; Verifica se o resultado eh negativo
				cpi r, 0x0						; Caso seja negativo
				brne showResultNeg

				clr r
				rcall setFlNegativo				; Limpa resultado negativo

    			rcall writemsg					; Exibe a mensagem 
				rcall clenPortB
				
				rcall configKeypad
				rjmp loop

			
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
				rcall configKeypad
				rjmp loop						


; Converte os digitos da calculadora para binario, para fazer as operacoes matematicas
; -----------------------------------------------------------------------------
convertToBin:	ldi	Zh, high(OPSR1)			
				ldi	Zl, low(OPSR1)
				ld r11, Z+
				ld r, Z+
				ld rr, Z

				cpi dgCount, 0x1				; Caso seja o primeiro operando
				breq convertToBin1
				rjmp convertToBin2
				
				ret

convertToBin1:	add16 r, rr, r8, r9
				ldi	Zh, high(OPSR1)			
				ldi	Zl, low(OPSR1)
				clr r11
				st Z+, r11
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
				clr r11
				st Z+, r11
				st Z+, r
				st Z, rr

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

lcdInOverflowA:	ldi	Zh, high(OPSR1)			
				ldi	Zl, low(OPSR1)
				clr r
				st Z+, r
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


; Rotina de multiplicacao de 16bits por 16bits
; Os operadores dessa rotina devem ser setados em operador1: m1M e m1L, 
; operador2: m2M e m2L. O resultado eh armazendo em Res4,Res3,Res2 e Res1.
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
		
		
; Divisao 16 por 16 bits
; -----------------------------------------------------------------------------
divide:
				clr drem16uL			;clear no LOW do resto
				sub drem16uH,drem16uH	;clear no HIGH do resto
				ldi dcnt16u,17			;contador regressivo de iteracao
d16ua:
				rol m1L 				;shift left no dividendo
				rol m1M
				dec dcnt16u 			;contador decrementa e pula pra d16ub,
				brne d16ub 				;mas caso tenha atingido 0 sai da rotina
				ret  					
d16ub: 
				rol drem16uL			;shift dividend into remainder
				rol drem16uH
				sub drem16uL,m2L		;resto = resto - divisor
				sbc drem16uH,m2M;
				brcc d16uc 				;se resto < negativo, pula pra d16uc
				add drem16uL,m2L		;caso contratio resto volta ao valor anterior
				adc drem16uH,m2M
				clc  					;zera carry para usar no rol
				rjmp d16ua 			;else
d16uc: 
				sec						;seta carry para usar no rol
				rjmp d16ua



; Include das funcoes para manipular LCD
; -----------------------------------------------------------------------------
.include "LCDFunctions.asm"

; Include das funcoes para manipular conversao de digitos
; -----------------------------------------------------------------------------
.include "BCDFunctions.asm"


; Final de execucao da aplicacao
; -----------------------------------------------------------------------------
end:			
				rcall configKeypad
				rjmp loop						; Final do programa

; Mensagens e labels
; -----------------------------------------------------------------------------
lb_clear:  		.db     "0", 0					; Label inicial da calculadora, com operador clean
err_div_zero:	.db  	"E = div por 0", 0		; Erro ao dividir por zero
err_precision: 	.db		"E = precisao", 0		; Erro de precissao
err_operator:	.db		"E = operando?", 0		; Erro de falta de operador
