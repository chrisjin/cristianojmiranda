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

.def    		secsct  	= r21				;seconds counter
.def			r			= r16

start:
				rjmp	RESET					;reset handle

.org	0x10

    			rjmp count1s					; go to timer0 overflow counter interrupt routine

RESET:
			    ldi r, low(RAMEND)
				out	SPL,r						;initialize Stack Pointer to last RAM address		
				ldi	r,high(RAMEND)
				out SPH,r
				clr secsct						; clear software seconds counter 
				clr xl							; will use X as an interrupt counter
				clr xh
				ldi r,1							; era out TIMSK0,r no Atmega88 este registrador está fora do espaço de E/S!
				sts TIMSK0,r					; enable timer0 overflow interrupt (p.102 datasheet)
				ldi r,1							; set prescalong: 1= no prescaling 5=  CK/1024 pre-scaling (p 102-103 datasheet)
				out TCCR0B,r					; also starts timer0 counting
				out SMCR,r						; SMCR=1 selects idle mode sleep and enables sleep (p 37-38 datasheet)
				sei								; Global Interrupt enable

loop:			sleep							; enter idle mode sleep: wait for interrupt
				rjmp loop						

done: 											
    			clr r17
    			out TCCR0B,r17					; stop timer0 counter: no more interrupts 
				rjmp PC

;**************************************************************
												; timer0 overflow interrupt routine
count1s:	
			    push r							; save into stack
			    in r,SREG						; get SREG
				push r							; and save it in stack			
			    adiw x,1
				cpi  xh,0x02					; assume 0x200 interrupts make 1 second
				brne n0
				clr xl							; got 1 sec, clear 16 bit counter in X
				clr xh
				inc secsct						; and increment secon counter
				bst secsct, 0
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
;**************************************************************

