.nolist
.include "m88def.inc"
.list
.listmac

.equ LCDDATA=PORTB
.equ LCDCTL=PORTC
.EQU ENABLE=0
.EQU RS=1
.EQU RW=2
.def    lcdinput    =   r19
	rjmp RESET
;*************************************************************************************
lcd_busy:
; test the busy state
sbi portc,RW        ; RW high to read
cbi portc,RS        ; RS low to read

ldi r16,00          ; make port input
out ddrb,r16
out portb,r16

loop:
sbi portc,ENABLE    ; begin read sequence
in r16,pinb         ; read it
cbi portc,ENABLE    ; set enable back to low
;cbi portc,RW    ; clear the RW back to write mode
sbrc r16,7          ; test bit 7, skip if clear
rjmp loop       ; jump if set

ldi r16,0xff        ; make port output
out ddrb,r16
ret

;****************************************************************************************
lcd_cmd:

; lcd_cmd writes the LCD command in r19 to the LCD
cbi portc,RS    ; RS low for command mode
cbi portc,RW    ; RW low to write
sbi portc,ENABLE    ; Enable HIGH
out portb,lcdinput  ; output
cbi portc,ENABLE    ; Enable LOW to execute

ret
;*****************************************************************************************************
lcd_write:

; lcd_write writes the value in r19 to the LCD
sbi portc,RS    ; RS high
cbi portc,RW    ; RW low to write
sbi portc,ENABLE    ; Enable HIGH
out portb,lcdinput  ; output
cbi portc,ENABLE    ; Enable LOW to execute

ret
;*****************************************************************
writemsg:
    lpm lcdinput,z+      ; load r0 with the character to display          ; increment the string counter
    cpi lcdinput, 0
	breq writedone
    rcall lcd_write
    rcall lcd_busy
    rjmp writemsg
writedone:
 	ret
;*****************************************************************************************************
lcdinit: 			;initialize LCD
	ldi r16,0xff
	out ddrb,r16 	;portb is the LCD data port, 8 bit mode set for output
	out ddrc,r16	;portc is the LCD control pins set for output
	ldi lcdinput,56  ; init the LCD. 8 bit mode, 2*16
	rcall lcd_cmd    ; execute the command
	rcall lcd_busy   ; test busy
	ldi lcdinput,1		; clear screen
	rcall lcd_cmd
	rcall lcd_busy
	;ldi lcdinput,15 	; show cursor and blink it
	;rcall lcd_cmd
	;rcall lcd_busy
	ldi lcdinput,2      ; cursor home command
    rcall lcd_cmd        ; execute command
    rcall lcd_busy
	ret
;*****************************************************************************************************

msg:    .db      "Welcome to HAPSIM!",0
msg2:   .db      "MC404 2",$df," Sem 2009",0
msg3:   .db      "IC-UNICAMP",0
msg4:   .db      "Eng de Computacao",0
;***************************************************************************
RESET:
    rcall lcdinit		; initialize LCD
	ldi zl,low(msg*2)   ;point to message for 1st line
    ldi zh,high(msg*2)
    rcall writemsg		; display it
	ldi   lcdinput, $c0	; go to the beginning of 2nd line
	rcall lcd_cmd		; do it
	rcall lcd_busy
	ldi zl,low(msg2*2)   ;point to message for 2nd line
    ldi zh,high(msg2*2)
    rcall writemsg		; display it
	ldi   lcdinput, $94	; go to the beginning of 3rd line
	rcall lcd_cmd		; do it
	rcall lcd_busy
	ldi zl,low(msg3*2)   ;point to message for 3rd line
    ldi zh,high(msg3*2)
    rcall writemsg		; display it
	ldi   lcdinput, $d4	; go to the beginning of 4th line
	rcall lcd_cmd		; do it
	rcall lcd_busy
	ldi zl,low(msg4*2)   ;point to message for 4th line
    ldi zh,high(msg4*2)
    rcall writemsg		; display it
	
done: rjmp PC
