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


; Mensagens
; -----------------------------------------------------------------------------
msg_hhmmss:    .db      "  HH:MM:SS",0
msg_1:    		.db      "one!",0




start:
				rjmp	RESET					; Funcao de Reset

.org	0x10

    			rjmp count1s					; Salta para a rotina de contagem de segundo ao ocorrer uma interrupção Timer/Counter0


; -----------------------------------------------------------------------------
RESET:
			    ldi r, low(RAMEND)
				out	SPL,r						;initialize Stack Pointer to last RAM address		
				ldi	r,high(RAMEND)
				out SPH,r
				clr secCount					; clear software seconds counter 
				clr xl							; will use X as an interrupt counter
				clr xh
				ldi r,1							; era out TIMSK0,r no Atmega88 este registrador está fora do espaço de E/S!
				sts TIMSK0,r					; enable timer0 overflow interrupt (p.102 datasheet)
				ldi r,1							; set prescalong: 1= no prescaling 5=  CK/1024 pre-scaling (p 102-103 datasheet)
				out TCCR0B,r					; also starts timer0 counting
				out SMCR,r						; SMCR=1 selects idle mode sleep and enables sleep (p 37-38 datasheet)

				rcall lcdinit					; inicializa o LCD

				ldi zl,low(msg_hhmmss*2)   		; Seta a mensagem inicial no LDCD
    			ldi zh,high(msg_hhmmss*2)
    			rcall writemsg					; Exibe a mensagem 


				sei								; Habilita interrupção global


; -----------------------------------------------------------------------------
loop:			sleep							; Entra em loop aguardando uma interrupção
				rjmp loop						



; -----------------------------------------------------------------------------
done: 											
    			clr r17
    			out TCCR0B,r17					; stop timer0 counter: no more interrupts 
				rjmp PC




; -----------------------------------------------------------------------------
												; Funcao de interrupcao acada 1s
count1s:	
			    push r							; save into stack
			    in r,SREG						; get SREG
				push r							; and save it in stack			
			    adiw x,1
				cpi  xh,0x02					; assume 0x200 interrupts make 1 second
				brne n0
				clr xl							; got 1 sec, clear 16 bit counter in X
				clr xh
				inc secCount					; and increment secon counter
				bst secCount, 0
				brtc acende
				brts apaga
				rjmp n0

acende: 		sbi PORTD,0						; liga led conectado no pino 2
				rjmp n0							; retorna com interrupções habilitadas


apaga:			cbi PORTD,0						; liga led conectado no pino 2
				
n0:
				pop r							; get SREG from stack
				out SREG, r						; restore it
				pop r							; now restore r
			    reti	


; -----------------------------------------------------------------------------
; ### LCD FUNCTIONS ###
; -----------------------------------------------------------------------------

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
writemsg:
    			lpm lcdinput,z+      			; load r0 with the character to display, increment the string counter
    			cpi lcdinput, 0
				breq writedone
    			rcall lcd_write
    			rcall lcd_busy
    			rjmp writemsg

; -----------------------------------------------------------------------------
writedone:
 	ret

; -----------------------------------------------------------------------------
lcdinit: 										;initialize LCD
				ldi r22,0xff
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



end:											; Final do programa
