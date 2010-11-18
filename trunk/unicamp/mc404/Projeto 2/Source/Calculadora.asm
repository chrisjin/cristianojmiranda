; -----------------------------------------------------------------------------
;  MC404-E
;
;  Atividade Obrigatoria 2 - calculadora
;
;
;												Grupo:
;                                               Cristiano J. Miranda Ra: 083382
;						Teodoro	O. Wey	     Ra: 072448
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
.def 			m1L = R16						; Operador 1 da multiplicacao
.def 			m1M = R17
.def 			m2L = R18						; Operador 2 da multiplicacao
.def 			m2M = R19
.def 			tmp = R20						; Registrador temporario da operacao


												; Contantes de conversao de binario para Ascii
.def			rmp 		= r20
.def			rBin1H		= r16
.def			rBin1L		= r17
.def			rBin2H		= r18
.def			rBin2L		= r19


												; Constantes para keypad
.def aux = r16
.def coluna = r17
.def retorno = r18								; O codigo da tecla sera retornado aqui.


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

; Macro para subtrair 2 numeros de 16 bits, guarda o resultado no primeiro parametro
; -----------------------------------------------------------------------------
.macro sub16 ;(@0@1 - @2@3)
		sub @0,@2
		sbc @1,@3
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
				
												; Limpa operadores 1 e 2 na SRAM
				ldi	Zh, high(OPSR1)			
				ldi	Zl, low(OPSR1)
				st Z+, r
				st Z, r

				ldi	Zh, high(OPSR2)			
				ldi	Zl, low(OPSR2)
				st Z+, r
				st Z, r
				

				; Test I ----------------------------------------------------------------------------
				; Soma
				;rcall key1
				;rcall key2
				;rcall key3
				;rcall key3
				;rcall key0
				;rcall key1
				;rcall keyAdd					; Entrada 301 no operando 1, aciona o operador soma
				;rcall key2
				;rcall key2
				;rcall key2
				;rcall key6
				;rcall key1						; Entrada 61 no operando 2
				;rcall keyEnter					; Era esperado o resultado 362 no lcd

				; Test II ----------------------------------------------------------------------------
				; Subtracao
				;rcall key1
				;rcall key9
				;rcall key0
				;rcall keySub				; Entrada 190, aciona operador de subtracao
				;rcall key9
				;rcall key8
				;rcall keyEnter				; Entrada 98 no operador 2, esperado resultado 92

				; Test III ---------------------------------------------------------------------------
				; Multiplicacao
				;rcall key5
				;rcall key3
				;rcall keyMult				; Entrada 53 no operador 1, aciona operador de multiplicacao
				;rcall key6
				;rcall key1
				;rcall key0
				;rcall keyEnter				; Entrada 610 no operador 2, esperado resultado 32330

				ldi aux, 0x0F
				out DDRB, aux					; Diracao dos dados

				ldi coluna, 0xFE				; coluna eh uma mascara

				ldi aux, 0xFF
				out PINB, aux					; Pull-up inicial para evitar problemas de inicializacao

				and aux, coluna
				out PORTB, aux					; Ainda para evitar problemas de inicializacao

				rjmp loop


; Loop principal da aplicação
; -----------------------------------------------------------------------------
loop:			ldi r, low(RAMEND)				; Remove lixo da pilha para evitar overflow
				out	SPL, r
				ldi	r, high(RAMEND)
				out SPH,r
				rcall clenPortB

				ldi aux, 0xFF
				out PINB, aux				; Pull-up

				and aux, coluna
				out PORTB, aux				; Strobe apenas na coluna em que ha o zero.

				in aux, PINB				; Le linhas.

				swap aux
				andi aux, 0x0F				; Seleciona apenas botoes de entrada.
				cpi aux, 0x0F				; Detecta se houve botao pressionado.
				brne encerra				; Unica forma de sair do loop.

				sec
				rol coluna					; Proxima coluna.
				cpi coluna, 0xEF			; Detecta se acabaram as 4 colunas.
				brne loop

				ldi coluna, 0xFE			; Retorna para primeira coluna.
				rjmp loop
			
				rjmp loop


encerra:									; Apos ser detectado o botao, verifica a qual coluna ele pertence.
				cpi coluna, 0xF7
				breq coluna1
				cpi coluna, 0xFB
				breq coluna2
				cpi coluna, 0xFD
				breq coluna3
				cpi coluna, 0xFE
				breq coluna4
				rjmp loop					; Se chegou aqui, houve erro na contagem das colunas, e volta para o loop de espera.

coluna1:									; Detecta botao a partir da sua linha, considerando coluna 1.
				cpi aux, 0xE
				breq key1Link
				cpi aux, 0xD
				breq key4Link
				cpi aux, 0xB
				breq key7Link
				cpi aux, 0x7
				breq keyClearLink
				rjmp loop					; Se chegou aqui, houve erro no momento da leitura, e volta ao loop.

coluna2:									; Detecta botao a partir da sua linha, considerando coluna 2.
				cpi aux, 0xE
				breq key2Link
				cpi aux, 0xD
				breq key5Link
				cpi aux, 0xB
				breq key8Link
				cpi aux, 0x7
				breq key0
				rjmp loop					; Se chegou aqui, houve erro no momento da leitura, e volta ao loop.

coluna3:									; Detecta botao a partir da sua linha, considerando coluna 3.
				cpi aux, 0xE
				breq key3Link
				cpi aux, 0xD
				breq key6Link
				cpi aux, 0xB
				breq key9Link
				cpi aux, 0x7
				breq keyEnterLink
				rjmp loop					; Se chegou aqui, houve erro no momento da leitura, e volta ao loop.

coluna4:						; Detecta botao a partir da sua linha, considerando coluna 4.
				cpi aux, 0xE
				breq keyAddLink
				cpi aux, 0xD
				breq keySubLink
				cpi aux, 0xB
				breq keyMultLink
				cpi aux, 0x7
				breq keyDivLink
				rjmp loop					; Se chegou aqui, houve erro no momento da leitura, e volta ao loop.

loopLink:		rjmp loop

; Links para rotinas
; -----------------------------------------------------------------------------
keyAddLink:		rjmp keyAdd
keySubLink:		rjmp keySub
keyMultLink:	rjmp keyMult
keyDivLink:		rjmp keyDiv
keyEnterLink:	rjmp keyEnter
keyClearLink:	rjmp keyClear
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
				rcall convertToBin
				ret

; Btn Um
; -----------------------------------------------------------------------------
key1:			rcall verificaErro
				ldi rr, 0x31						; Seta o valor 1 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x1
				mov r9, r
				rcall convertToBin
				rjmp loop

; Btn Dois
; -----------------------------------------------------------------------------
key2:			rcall verificaErro
				ldi rr, 0x32						; Seta o valor 2 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x2
				mov r9, r
				rcall convertToBin
				rjmp loop

; Btn Tres
; -----------------------------------------------------------------------------
key3:			rcall verificaErro
				ldi rr, 0x33						; Seta o valor 3 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x3
				mov r9, r
				rcall convertToBin
				rjmp loop

; Btn Quatro
; -----------------------------------------------------------------------------
key4:			rcall verificaErro
				ldi rr, 0x34						; Seta o valor 4 a ser exibido no lcd
				rcall indexInLcd
				rcall convertToBin
				clr r8
				ldi r, 0x4
				mov r9, r
				rcall convertToBin
				rjmp loop

; Btn Cinco
; -----------------------------------------------------------------------------
key5:			rcall verificaErro
				ldi rr, 0x35						; Seta o valor 5 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x5
				mov r9, r
				rcall convertToBin
				rjmp loop

; Btn Seis
; -----------------------------------------------------------------------------
key6:			rcall verificaErro
				ldi rr, 0x36						; Seta o valor 6 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x6
				mov r9, r
				rcall convertToBin
				rjmp loop

; Btn Sete
; -----------------------------------------------------------------------------
key7:			rcall verificaErro
				ldi rr, 0x37						; Seta o valor 7 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x7
				mov r9, r
				rcall convertToBin
				rjmp loop

; Btn Oito
; -----------------------------------------------------------------------------
key8:			rcall verificaErro
				ldi rr, 0x38						; Seta o valor 8 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x8
				mov r9, r
				rcall convertToBin
				rjmp loop

; Btn Nove
; -----------------------------------------------------------------------------
key9:			rcall verificaErro
				ldi rr, 0x39						; Seta o valor 9 a ser exibido no lcd
				rcall indexInLcd
				clr r8
				ldi r, 0x9
				mov r9, r
				rcall convertToBin
				rjmp loop

; Btn Clear
; -----------------------------------------------------------------------------
keyClear:	
				rjmp start						; Volta para o inicio da aplicação (RESET)

; Btn Add
; -----------------------------------------------------------------------------
keyAdd:			
				clr dgCount						; Limpa a contagem de digitos do lcd
				ldi   lcdinput,	1				; Apaga o LCD
				rcall lcd_cmd

				clr r
				rcall setLcdIoFlag				; Marca como leitura Progam Memory
				ldi Zl,low(lb_add*2)   			; Exibe o operador de soma no lcd
    			ldi Zh,high(lb_add*2)				
    			rcall writemsg					; Escreve no lcd
				rcall clenPortB					

				ldi r, OPADICAO					; Seta a operacao como soma
				rcall setOperacao
				
				ldi r, 0x1						; Prepara para primeira escrita
				rcall setLcdIoFlag				; Habilita escrita no lcd a partir da SRAM
				rjmp loop

; Btn Sub
; -----------------------------------------------------------------------------
keySub:			
				clr dgCount						; Limpa a contagem de digitos do lcd
				ldi   lcdinput,	1				; Apaga o LCD
				rcall lcd_cmd

				clr r
				rcall setLcdIoFlag				; Marca como leitura Progam Memory
				ldi Zl,low(lb_sub*2)   			; Exibe o operador de SUBTRACAO no lcd
    			ldi Zh,high(lb_sub*2)				
    			rcall writemsg					; Escreve no lcd
				rcall clenPortB					

				ldi r, OPSUBTRACAO				; Seta a operacao como SUBTRACAO
				rcall setOperacao
				
				ldi r, 0x1						; Prepara para primeira escrita
				rcall setLcdIoFlag				; Habilita escrita no lcd a partir da SRAM
				rjmp loop

; Btn Multiplicacao
; -----------------------------------------------------------------------------
keyMult:			
				clr dgCount						; Limpa a contagem de digitos do lcd
				ldi   lcdinput,	1				; Apaga o LCD
				rcall lcd_cmd

				clr r
				rcall setLcdIoFlag				; Marca como leitura Progam Memory
				ldi Zl,low(lb_mult*2)  			; Exibe o operador de multiplicacao no lcd
    			ldi Zh,high(lb_mult*2)		
    			rcall writemsg					; Escreve no lcd
				rcall clenPortB					

				ldi r, OPMULTIPLIC				; Seta a operacao como MULTIPLICACAO
				rcall setOperacao
				
				ldi r, 0x1						; Prepara para primeira escrita
				rcall setLcdIoFlag				; Habilita escrita no lcd a partir da SRAM
				rjmp loop

; Btn Divisao
; -----------------------------------------------------------------------------
keyDiv:			
				clr dgCount						; Limpa a contagem de digitos do lcd
				ldi   lcdinput,	1				; Apaga o LCD
				rcall lcd_cmd

				clr r
				rcall setLcdIoFlag				; Marca como leitura Progam Memory
				ldi Zl,low(lb_div*2)  			; Exibe o operador de divisao no lcd
    			ldi Zh,high(lb_div*2)		
    			rcall writemsg					; Escreve no lcd
				rcall clenPortB					

				ldi r, OPDIVISAO				; Seta a operacao como DIVISAO
				rcall setOperacao
				
				ldi r, 0x1						; Prepara para primeira escrita
				rcall setLcdIoFlag				; Habilita escrita no lcd a partir da SRAM
				rjmp loop


; Aciona a opcao enter no keypad
; -----------------------------------------------------------------------------
keyEnter:		rcall getOperacao				; Obtem operacao
				cpi r, 0x0						; Caso nao haja operacao
				breq erroOperador				; Notifica falta de operador

												; Obtem os operadores da SRAM
				ldi	Zh, high(OPSR1)			
				ldi	Zl, low(OPSR1)
				ld r25, Z+						; Operador1 em r25 e r26
				ld r26, Z

				ldi	Zh, high(OPSR2)			
				ldi	Zl, low(OPSR2)
				ld r27, Z+						; Operador2 em r27 e r28
				ld r28, Z

												; Verifica qual operador foi acionado
				cpi r, OPADICAO					; Caso seja operador de soma
				breq opSoma

				cpi r, OPMULTIPLIC				; Caso seja operador de multiplicacao
				breq opMult

				cpi r, OPDIVISAO				; Caso seja operador de divisao
				breq opDiv

				cpi r, OPSUBTRACAO				; Caso seja operador de subtracao
				breq opSub

				rjmp loop


; Soma
; -----------------------------------------------------------------------------
opSoma:			add16 r25, r26, r27, r28		; Executa a soma
				rcall showLcdResult				; Exibe o resultado da operacao no LCD
				ret

; Multiplicacao
; -----------------------------------------------------------------------------
opMult:											; Executa a multiplicacao
				mov m1M, r25					; Seta o operando 1 
				mov m1L, r26
				mov m2M, r27
				mov m2L, r28					; Seta o segundo operando
				rcall multiply					; Executa a multiplicacao

				mov r25, res2					; Seta o resultado da multiplicacao nos registradores de exibicao
				mov r26, res1

				rcall showLcdResult				; Exibe o resultado da operacao no LCD
				ret

; Divisao
; -----------------------------------------------------------------------------
opDiv:											; Executa divisao
				rcall showLcdResult				; Exibe o resultado da operacao no LCD
				ret

; Subtracao
; -----------------------------------------------------------------------------
opSub:			sub16 r25, r26, r27, r28		; Executa a subtracao
				rcall showLcdResult				; Exibe o resultado da operacao no LCD
				ret


; Exibe os valores dos registradores r25 e r26 no lcd
; -----------------------------------------------------------------------------
showLcdResult:	ldi   lcdinput,	1				; Apaga o LCD
				rcall lcd_cmd		

				mov rBin1H, r25					; Move o resultado para o registrador de conversao ascii
				mov rBin1L, r26

				ldi Zh, high(SRAM_START)    	; Seta Zh como o inicio da SRAM para iniciar escrita do resultado em ascii
        		ldi Zl, low(SRAM_START) 

				rcall Bin2ToAsc					; Converte o resultado em ascii

				clr r							; Delimita o display numerico no sexto digito
				;ldi Zh, high(0x105)				
				;ldi Zl, low(0x105)
				ldi Zh, high(0x106)				
				ldi Zl, low(0x106)
				st Z, r

												; Exibe o resultado convertido
				ldi r, 0x1						; Habilita a leitura do LCD a partir da SRAM
				rcall setLcdIoFlag

				ldi Xh, high(SRAM_START)    	; Seta Xh como o inicio da SRAM
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
				

; -----------------------------------------------------------------------------
; ### LCD FUNCTIONS ###
; -----------------------------------------------------------------------------

; Limpa a porta B, pois a mesma pode ser utilizada para funcoes lcd e keyboard
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

; Le os valores de Memory program para exibir no LCD
; -----------------------------------------------------------------------------
writemsgmp:		lpm lcdinput,Z+      			; load lcdinput with the character to display, increment the string counter
				rjmp writemsgbd

; Le os valores da SRAM para exibir no LCD
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
; ### FUNCOES DE CONVERSOES BINARIO, ASCII, BCD ###
; -----------------------------------------------------------------------------

; Bin2ToAsc
; =========
; converts a 16-bit-binary to a 5-digit ASCII coded decimal,
;   the pointer points to the first significant digit of the
;   decimal, returns the number of digits
; In: 16-bit-binary in rBin1H:L, Z points to first digit of
;   the ASCII decimal (requires 5 digits buffer space, even
;   if the number is smaller!)
; Out: Z points to the first significant digit of the ASCII
;   decimal, rBin2L has the number of characters (1..6)
; Used registers: rBin1H:L (unchanged), rBin2H (changed),
;   rBin2L (result, length of number), rmp
; Called subroutines: Bin2ToBcd5, Bin2ToAsc5
;
; -----------------------------------------------------------------------------
Bin2ToAsc:
				rcall Bin2ToAsc6 				; Convert binary to ASCII
				ldi rmp, 5 						; Counter is 6
				mov rBin2L,rmp

; -----------------------------------------------------------------------------
Bin2ToAsca:
				dec rBin2L 						; decrement counter
				ld rmp,z+ 						; read char and inc pointer
				cpi rmp, ' ' 					; was a blank?
				breq Bin2ToAsca 				; Yes, was a blank
				sbiw ZL,1 						; one char backwards
				ret ; done

; Bin2ToAsc6
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
; -----------------------------------------------------------------------------
Bin2ToAsc6:
				rcall Bin2ToBcd6 				; convert binary to BCD
				ldi rmp, 5						; Counter is 5 leading digits
				mov rBin2L,rmp

; -----------------------------------------------------------------------------
Bin2ToAsc6a:
				ld rmp,z 						; read a BCD digit
				tst rmp 						; check if leading zero
				brne Bin2ToAsc6b 				; No, found digit >0
				ldi rmp,' ' 					; overwrite with blank
				st z+,rmp 						; store and set to next position
				dec rBin2L 						; decrement counter
				brne Bin2ToAsc6a 				; further leading blanks
				ld rmp,z 						; Read the last BCD

; -----------------------------------------------------------------------------
Bin2ToAsc6b:
				inc rBin2L ; one more char

; -----------------------------------------------------------------------------
Bin2ToAsc6c:
				subi rmp, -'0' 					; Add ASCII-0
				st z+,rmp 						; store and inc pointer
				ld rmp,z 						; read next char
				dec rBin2L 						; more chars?
				brne Bin2ToAsc6c 				; yes, go on
				sbiw ZL, 4 						; Pointer to beginning of the BCD
				ret 							; done
;

; Bin2ToBcd6
; ==========
; converts a 16-bit-binary to a 5-digit-BCD
; In: 16-bit-binary in rBin1H:L, Z points to first digit
;   where the result goes to
; Out: 5-digit-BCD, Z points to first BCD-digit
; Used registers: rBin1H:L (unchanged), rBin2H:L (changed),
;   rmp
; Called subroutines: Bin2ToDigit
;
; -----------------------------------------------------------------------------
Bin2ToBcd6:
				push rBin1H 					; Save number
				push rBin1L
				
				ldi rmp,HIGH(100000) 			; Start with tenthousands
				mov rBin2H,rmp
				ldi rmp,LOW(100000)
				mov rBin2L,rmp
				rcall Bin2ToDigit

				ldi rmp,HIGH(10000) 			; Start with tenthousands
				mov rBin2H,rmp
				ldi rmp,LOW(10000)
				mov rBin2L,rmp
				rcall Bin2ToDigit 				; Calculate digit

				ldi rmp,HIGH(1000) 				; Next with thousands
				mov rBin2H,rmp
				ldi rmp,LOW(1000)
				mov rBin2L,rmp
				rcall Bin2ToDigit 				; Calculate digit

				ldi rmp,HIGH(100) 				; Next with hundreds
				mov rBin2H,rmp
				ldi rmp,LOW(100)
				mov rBin2L,rmp
				rcall Bin2ToDigit 				; Calculate digit

				ldi rmp,HIGH(10) 				; Next with tens
				mov rBin2H,rmp
				ldi rmp,LOW(10)
				mov rBin2L,rmp
				rcall Bin2ToDigit 				; Calculate digit

				st z,rBin1L 					; Remainder are ones
				sbiw ZL, 5 						; Put pointer to first BCD
				pop rBin1L 						; Restore original binary
				pop rBin1H

				ret 							; and return
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
; -----------------------------------------------------------------------------
Bin2ToDigit:
				clr rmp 						; digit count is zero

; -----------------------------------------------------------------------------
Bin2ToDigita:
				cp rBin1H,rBin2H 				; Number bigger than decimal?
				brcs Bin2ToDigitc 				; MSB smaller than decimal
				brne Bin2ToDigitb 				; MSB bigger than decimal
				cp rBin1L,rBin2L 				; LSB bigger or equal decimal
				brcs Bin2ToDigitc 				; LSB smaller than decimal
; -----------------------------------------------------------------------------
Bin2ToDigitb:
				sub rBin1L,rBin2L 				; Subtract LSB decimal
				sbc rBin1H,rBin2H 				; Subtract MSB decimal
				inc rmp 						; Increment digit count
				rjmp Bin2ToDigita 				; Next loop
; -----------------------------------------------------------------------------
Bin2ToDigitc:
				st z+,rmp 						; Save digit and increment
				ret 							; done
;
; **************************************************
;
; Package III: From binary to Hex-ASCII
;

; Final de execucao da aplicacao
; -----------------------------------------------------------------------------
end:			
				rjmp loop						; Final do programa

null: 			ret

; Mensagens e labels
; -----------------------------------------------------------------------------
lb_clear:  		.db      "0", 0					; Label inicial da calculadora, com operador clean
lb_add:			.db		 "+", 0					; Label de adicao
lb_sub:			.db		 "-", 0					; Label de subtracao
lb_mult:		.db		 "*", 0					; Label de multiplicacao
lb_div:			.db		 "/", 0					; Label de divisao
err_div_zero:	.db  	"E = div por 0", 0		; Erro ao dividir por zero
err_precision: 	.db		"E = precisao", 0		; Erro de precissao
err_operator:	.db		"E = operando?", 0		; Erro de falta de operador
