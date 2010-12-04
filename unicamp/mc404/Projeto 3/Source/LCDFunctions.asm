; -----------------------------------------------------------------------------
; ### LCD FUNCTIONS ###
; -----------------------------------------------------------------------------

; Limpa a porta B, pois a mesma pode ser utilizada para funcoes lcd e keyboard
; -----------------------------------------------------------------------------
clenPortB:		clr r
				out ddrb, r
				out portb, r
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

												; done
