;=========================================================================
; clock.asm - MS-DOS Clock driver 
;-------------------------------------------------------------------------
;
; Compiles with NASM 2.13.02, might work with other versions
;
; Copyright (C) 2024 - Sergey Kiselev.
; Provided for hobbyist use with the RTC8088 boards.
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
;=========================================================================

	cpu	8086

;-------------------------------------------------------------------------
; RTC default I/O port
default_io_port	equ	240h

;-------------------------------------------------------------------------
; locations in RTC and NVRAM
cmos_seconds	equ	00h	; seconds location in RTC
cmos_alarm_secs	equ	01h	; alarm seconds location in RTC
cmos_minutes	equ	02h	; minutes location in RTC
cmos_alarm_mins	equ	03h	; alarm minutes location in RTC
cmos_hours	equ	04h	; hours locaiton in RTC
cmos_alarm_hrs	equ	05h	; alarm hours location in RTC
cmos_day	equ	06h	; day location in RTC
cmos_date	equ	07h	; date location in RTC
cmos_month	equ	08h	; month location in RTC
cmos_year	equ	09h	; year location in RTC
cmos_floppy	equ	10h	; floppy type byte
cmos_equip	equ	14h	; equipment byte
cmos_config_a	equ	2Dh	; BIOS configuration byte A
cmos_sum_hi	equ	2Eh	; checksum of bytes 10h - 20h - high byte
cmos_sum_lo	equ	2Fh	; checksum of bytes 10h - 20h - low byte 
cmos_century	equ	32h	; centry location in RTC (DS12C887 only)

;-------------------------------------------------------------------------
; RTC control register and their bits
cmos_control_a	equ	0Ah	; RTC control A register
cmos_uip	equ	80h	; RTC update in progress bit
cmos_control_b	equ	0Bh	; RTC control B register
cmos_dse	equ	01h	; RTC daylight savings enable bit
cmos_24hours	equ	02h	; RTC 24 hours format (1 = 24 hours, 0 = 12)
cmos_uie	equ	10h	; RTC update ended interrupt enable bit
cmos_aie	equ	20h	; RTC alarm interrupt enable bit
cmos_pie	equ	40h	; RTC periodic interrupt enable bit
cmos_set	equ	80h	; RTC set bit (0 = normal operation, 1 = set)
cmos_control_c	equ	0Ch	; RTC control C register
cmos_uf		equ	20h	; RTC update ended interrupt flag
cmos_af		equ	40h	; RTC alarm interrupt flag
cmos_pf		equ	80h	; RTC periodic interrupt flag
cmos_control_d	equ	0Dh	; RTC control D register
cmos_vrt	equ	80h	; RTC vrt bit (1 = battery is OK)

;-------------------------------------------------------------------------
; Device driver - Request header - common fields (13 bytes)
cmdlen		equ	0	; Length of this command (1 byte)
unit		equ	1	; Subunit Specified (1 byte)
cmd		equ	2	; Command Code (1 byte)
status		equ	3	; Status (2 bytes / 1 word)
reserved	equ 	5	; Reserved (8 bytes)
; Device driver - Request header - Init function
num_units	equ	13	; Number of units (1 byte)
end_addr	equ	14	; End address of the driver (dword/4 bytes)
cmd_addr	equ	18	; Pointer to command line arguments + CR/LF
; Device driver - Request header - Read/Write functions
transfer_addr	equ	14	; Transfer address (dword/4 bytes)

;-------------------------------------------------------------------------
; Device driver - Commands and status
cmd_init	equ	0h	; "Init" command
cmd_read	equ	4h	; "Read" command
cmd_write	equ	8h	; "Write" command
status_done	equ	0100h	; "Done" status, bit 8 set
status_fail	equ	800Ch	; "Error" - bit 15 set + "General Failure" - 0Ch

;-------------------------------------------------------------------------
; MS-DOS reads or writes the following 6-byte sequence to clock device:
clk_days	equ	0h	; days since 01/01/1980 - word
clk_minutes	equ	2h	; minutes - byte
clk_hours	equ	3h	; hours - byte
clk_cseconds	equ	4h	; centiseconds - byte
clk_seconds	equ	5h	; seconds - byte 

	org	0h		; device drivers start at the offset 0h

;=========================================================================
; Device driver header
;-------------------------------------------------------------------------
device_header	dw	0FFFFh, 0FFFFh	; next device pointer - last device
		dw	1000000000001000b ; driver attributes
;			|           `--- clock device
;			`--------------- character device
		dw	strategy	; strategy entry point
		dw	entry		; device driver entry point
		db	'CLOCK$  '	; device name

;=========================================================================
; Clock driver data
;-------------------------------------------------------------------------
request_ptr	dd	0		; pointer to the request header
rtc_io_port	dw	0240h		; use I/O port 240h by default
dse		db	0		; DSE flag: 0 - disable; 1 - enable
seconds		db	cmos_seconds,0	; last seconds value read or written
minutes		db	cmos_minutes,0	; last minutes value read or written
hours		db	cmos_hours,0	; last hours value read or written
day		db	cmos_day,0	; last day value read or written
date		db	cmos_date,0	; last date value read or written
month		db	cmos_month,0	; last month value read or written
year		db	cmos_year,0	; last year value read or written
century		db	cmos_century,0	; last century value read or written
num_rtc_regs	equ	($-seconds)/2	; number of RTC registers
ticks		dw	0		; initial ticks value for read time
days_in_month	db	31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31

;=========================================================================
; strategy - MS-DOS calls this function first, passing the request header
;            address. This function stores that address in request_ptr
; Input:
;	ES:BX = request header address
; Output:
;	none
;-------------------------------------------------------------------------
strategy:
	mov	cs:[request_ptr],bx	; save request header address
	mov	cs:[request_ptr+2],es
	retf

;=========================================================================
; entry - MS-DOS calls this function to perform the operation
; Input:
;	none; strategy subroutine is called first with the request header
; Output:
;	[request_ptr] is populated for init, read, and write functions
;	[transfer_addr] is populated for the read function
;-------------------------------------------------------------------------
entry:
	pushf				; save the registers on the stack
	push	es
	push	ds
	push	ax
	push	bx
	push	cx
	push	dx
	push	si
	push	di
	cld
	lds	bx,cs:[request_ptr]	; load request header pointer to DS:BX
	mov	word [bx+status],status_done	; set return status to "done"
	mov	al,[bx+cmd]		; load command code to AL
	cmp	al,cmd_init		; "Init" command?
	je	init			; jump to init subroutine
	mov	si,[bx+transfer_addr]	; SI = clock data sequence
	cmp	al,cmd_read		; "Read" command?
	je	read			; jump to read subroutine
	cmp	al,cmd_write		; "Write" command?
	je	write			; jump to write subroutine
error:
	mov	word [bx+status],status_fail	; invalid function number
exit:
	pop	di
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	pop	ds
	pop	es
	popf
	retf

;=========================================================================
; read - Read (get) time
; Input:
;	[SI] = 6-byte sequence with the values for the clock
; Output:
;	[SI] = 6-byte sequence populated with the current clock date and time
;-------------------------------------------------------------------------
read:
	call	rtc_get			; get current time and date
	pushf				; save time changed flag
	mov	al,cs:[hours+1]		; AL = BSD hours
	call	bcd_to_binary		; convert to binary
	mov	[si+clk_hours],al
	mov	al,cs:[minutes+1]	; AL = BCD minutes
	call	bcd_to_binary		; convert to binary
	mov	[si+clk_minutes],al
	mov	al,cs:[seconds+1]	; AL = BCD seconds
	call	bcd_to_binary		; convert to binary
	mov	[si+clk_seconds],al

; DS12885 RTC provides time only down to 1 second
; DOS wants centisecond accuracy
; do our best to get that using system interval timer (~55 ms intervals)

	push	cx
	push	dx
	mov	ah,00h			; read system clock counter
	int	1Ah			; System Clock BIOS Services
	mov	ax,dx			; AX = low word of tick count
	pop	dx
	pop	cx
	popf				; ZF = time changed flag
	jnz	.reset_ticks		; time changed since last call

; Still the same time (up to seconds)
; calculate the centisecond based on ticks difference

	sub	ax,cs:[ticks]		; find the difference between the
					; current and the previous ticks count
					; we should't care for roll-over
					; because the difference should not be
					; more than 18 ticks...
	
	mov	dl,11			; 11 2-centisecond intervals per tick
	mul	dl			; AX = centiseconds * 2
	mov	dl,al			; DL = centiseconds * 2
	shr	dl,1			; DL = centiseconds
	jmp	.return_cseconds

.reset_ticks:
	mov	cs:[ticks],ax		; store ticks value
	mov	dl,0			; centiseconds = 0

.return_cseconds:
	mov	[si+clk_cseconds],dl

; calculate days since 1/1/1980

	mov	al,cs:[century+1]	; AL = BCD century
	call	bcd_to_binary
	mov	ch,al			; CH = binary century
	mov	al,cs:[year+1]		; AL = BCD year
	call	bcd_to_binary
	mov	cl,al			; CL = binary year
	mov	al,cs:[month+1]		; AL = BCD month
	call	bcd_to_binary
	mov	dh,al			; DH = binary month
	mov	al,cs:[date+1]		; AL = BCD date
	call	bcd_to_binary
	mov	dl,al			; DL = binary date

	push	bx
	xor	bx,bx			; result - days since 1/1/1980

	cmp	ch,20			; is it 21st century (year 20xx)?
	je	.twentyfirst
	sub	cl,80			; 20th century, subtract 80 from year
	jmp	.add_leap_years
.twentyfirst:
	add	cl,20			; 21th century, add 20 to the year
.add_leap_years:
	mov	bl,cl			; years since 1980
	shr	bx,1			; BX /= 4 - number of leap years
	shr	bx,1

	mov	ch,0
	mov	ax,365			; days in a year
	push	dx			; DX gets modified by multiplication
	mul	cx			; DX:AX = days in the years so far
	pop	dx
	add	bx,ax			; add the days in the past years

	test	cl,3			; is it a leap year?
	je	.leap_year
	inc	bx			; add a day for the previous leap year
	jmp	.add_months

.leap_year:
	cmp	dh,2			; leap year, before March?
	jna	.add_months
	inc	bx			; add an extra day for Feburary

.add_months:
	lea	di,[days_in_month]	; table with number of days per month
	mov	cl,dh			; CL - current month (1-12)
	jmp	.add_months_next	; first decrement month, then add

.add_months_loop:
	add	bl,byte cs:[di]		; add number of days in the month
	adc	bh,0			; add the carry
	inc	di			; move to the next month

.add_months_next:
	loop	.add_months_loop

	dec	dl			; date is 1 based, make it 0 based
	add	bl,dl			; add the current day of the month
	adc	bh,0			; add the carry
	
	mov	[si+clk_days],bx	; return the result to DOS
	pop	bx

	jmp	exit

;=========================================================================
; write - Write (set) time
; Input:
;	[SI] = 6-byte sequence with the values for the clock
; Output:
;	none
;-------------------------------------------------------------------------
write:
	mov	al,byte [si+clk_hours]
	call	binary_to_bcd		; convert to BCD
	mov	cs:[hours+1],al		; save BCD hours
	mov	al,byte [si+clk_minutes]
	call	binary_to_bcd		; convert to BCD
	mov	cs:[minutes+1],al	; save BCD minutes
	mov	al,byte [si+clk_seconds]
	call	binary_to_bcd		; convert to BCD
	mov	cs:[seconds+1],al	; save BCD seconds

	push	bx

	mov	ax,word [si+clk_days]	; days since 1/1/1980

; calculate the day of the week

	push	ax
	add	ax,2			; January 1st 1980 is a Tuesday
	xor	dx,dx			; DX:AX - days since 1/1/1980
	mov	bx,7			; 7 days a week
	div	bx			; DL - remainer day of the week
	inc	dl			; days of the week are 1-based
	mov	cs:[day+1],dl		; save day of the week
	pop	ax

; calculate the date

	mov	cx,1461			; 1461 in a 4 year cycle (365*3+366)
	xor	dx,dx			; DX:AX = days since 1/1/1980
	div	cx			; AX = number of 4 year cycles
	add	ax,ax			; AX = AX * 4 - number of years
	add	ax,ax			; since 1/1/1980 modulo 4
	mov	cl,al			; CL = years modulo 4
	add	cl,80			; the starting year is 1980
	mov	ch,19			; CH = century, assume 20th century
	cmp	cl,100
	jb	.twentieth_century	; the year is below 100?
	sub	cl,100			; subtract 100 from the year
	inc	ch			; increment the century

.twentieth_century:
	mov	ax,dx			; AX - remainder = the day in the
					; current 4 year cycle

	cmp	ax,59			; February 29 of a leap year?
	jb	.calculate_year
	ja	.past_february		
	mov	dh,2			; February
	mov	dl,29			; 29
	jmp	.set_date

.past_february:
	dec	ax			; decrement a day for the leap year

.calculate_year:
	mov	bx,365			; 365 days in a year
	xor	dx,dx			; DX:AX = the day in the current
					; 4 year cycle
	div	bx			; AX = year in the 4 year cycle
					; DX = day in the current year
	add	cl,al			; CL = year

	xor	bx,bx			; BH = month, BL = date
	mov	ah,0
	lea	di,[days_in_month]

.add_months_loop:
	mov	al,cs:[di]		; AL - number of days in the month
	cmp	dx,ax			; the current day is below the number
	jb	.add_months_done	; of days in the current month?
	sub	dx,ax			; subtract the days in the month
	inc	di			; move to the next month
	inc	bh			; increment month count
	jmp	.add_months_loop

.add_months_done:
	mov	dh,bh			; BH = month
	inc	dh			; months are 1 based
	inc	dl			; dates are 1 based

.set_date:
	mov	al,ch
	call	binary_to_bcd
	mov	cs:[century+1],al	; save BCD century
	mov	al,cl
	call	binary_to_bcd
	mov	cs:[year+1],al		; save BCD year
	mov	al,dh
	call	binary_to_bcd
	mov	cs:[month+1],al		; save BCD month
	mov	al,dl
	call	binary_to_bcd
	mov	cs:[date+1],al		; save BCD date

	call	rtc_set

	pop	bx

	jmp	exit

;=========================================================================
; rtc_set - Set real time clock
; Input:
;	cs:[dse] - DSE flag
;	cs:[seconds] - pairs of the RTC register number + RTC value
; Output:
;	None
;-------------------------------------------------------------------------
rtc_set:
	push	ax
	push	cx
	push	si
	push	ds
	mov	ax,cs
	mov	ds,ax			; DS = CS
	mov	al,cmos_control_b
	call	rtc_read		; read control B register
	mov	ah,al
	or	ah,cmos_set		; set the RTC set bit
	mov	al,cmos_control_b
	call	rtc_write		; write control B register

	or	ah,[dse]		; set DSE flag from the data area
	mov	al,cmos_control_b
	call	rtc_write		; write control B register

	mov	cx,num_rtc_regs		; number of iterations
	mov	si,seconds		; the address of the first RTC value
	cld

rtc_set_loop:
	lodsw				; AX = DS:[SI], SI += 2
					; AL - RTC register number
					; AH - value to write to the RTC
	call	rtc_write		; write it to the RTC
	loop	rtc_set_loop

	mov	al,cmos_control_b
	call	rtc_read		; read control B register
	mov	ah,al
	and	ah,~cmos_set		; clear the RTC set bit
	mov	al,cmos_control_b
	call	rtc_write		; write control B register
	pop	ds
	pop	si
	pop	cx
	pop	ax
	ret

;=========================================================================
; rtc_get - Get real time clock
; Input:
;	cs:[seconds] - pairs of the RTC register number + previous RTC value
; Output:
;	ZF - time changed from the previous call flag
;	     ZF = 0 - time not changed
;	     ZF = 1 - time changed
;	cs:[dse] - DST flag
;	cs:[seconds] - pairs of the RTC register number + current RTC value
;-------------------------------------------------------------------------
rtc_get:
	push	ax
	push	cx
	push	dx
	push	si
	push	ds
	mov	ax,cs
	mov	ds,ax			; DS = CS
	xor	dx,dx			; reset time changed flag

.wait_for_update:
	mov	al,cmos_control_a
	call	rtc_read		; read control A register
	test	al,cmos_uip
	loopnz	.wait_for_update	; wait for the update to complete
	jnz	.exit			; timeout waiting for the update

	and	al,cmos_dse		; isolate DSE bit
	mov	[dse],al		; set DSE flag in the data area

	mov	cx,num_rtc_regs		; number of iterations
	mov	si,seconds		; the address of the first RTC value
	cld

.rtc_get_loop:
	lodsw				; AX = DS:[SI], SI += 2
					; AL - RTC register number
					; AH = previous value
	call	rtc_read
	cmp	al,ah			; compare previous and current values
	je	.rtc_get_loop_continue
	inc 	dx			; set time changed flag

.rtc_get_loop_continue:
	mov	[si-1],al		; save the new value
	loop	.rtc_get_loop

.exit:
	or	dx,dx			; ZF = time changed flag
	pop	ds
	pop	si
	pop	dx
	pop	cx
	pop	ax
	ret

;=========================================================================
; rtc_read - Read byte from RTC or CMOS memory
; Input:
;	AL - address of byte to read
; Output:
;	AL - byte from RTC
;-------------------------------------------------------------------------
rtc_read:
	push	dx
	mov	dx,cs:[rtc_io_port]
	cli
	out	dx,al
	jmp	$+2			; I/O delay
	jmp	$+2
	jmp	$+2
	jmp	$+2
	inc	dx			; DX = RTC data register
	in	al,dx
	sti
	pop	dx
	ret

;=========================================================================
; rtc_write - Write byte to RTC or CMOS memory
; Input:
;	AL - address of byte to write
;	AH - byte to write to RTC
; Output:
;	none
;-------------------------------------------------------------------------
rtc_write:
	push	dx
	mov	dx,cs:[rtc_io_port]
	cli
	out	dx,al
	jmp	$+2			; I/O delay
	jmp	$+2
	jmp	$+2
	jmp	$+2
	xchg	ah,al
	inc	dx			; DX = RTC data register
	out	dx,al
	xchg	ah,al
	sti
	pop	dx
	ret

;=========================================================================
; bcd_to_binary - convert 8-bit BCD number to binary
; Input:
;	AL - BCD number
; Output:
;	AL - binary number
;	AH = 0
;-------------------------------------------------------------------------
bcd_to_binary:
	mov	ah,al			; calculate tens
	and	al,0Fh			; AL = ones
	shr	ah,1
	shr	ah,1
	shr	ah,1
	shr	ah,1			; AH = tens
	aad				; AL = AH * 10 + AL ; AH = 0
	ret

;=========================================================================
; binary_to_bcd - convert 8-bit binary number to BCD
; Input:
;	AL - binary number
; Output:
;	AL - BCD number
;	AH - trashed
;-------------------------------------------------------------------------
binary_to_bcd:
	aam				; AH = AL / 10 ; AL = AL % 10
	shl	ah,1			; shift tens to 4 higher bits
	shl	ah,1
	shl	ah,1
	shl	ah,1
	add	al,ah			; add tens to ones
	ret

;=========================================================================
; init - Initialize the device driver
; Input:
;	[bx+cmd_addr] - address of the command line arguments (dword)
; Output:
;	[bx+num_units] = 1 - number of units (byte)
;	[bx+end_addr] - address of the end of the resident part (dword)
;-------------------------------------------------------------------------
init:

; Print the sign-in message

	mov	dx,msg_signin
	call	print_string

;-------------------------------------------------------------------------
; Parse the command line - look for a hexadecimal number - I/O port number
; Implementation:
; - Skip all non-space characters
; - Skip all space and tab characters
; - Parse the number either in decimal or hexadecimal format
;   hexadecimal format uses 'x' as identifier, which might have one or
;   more zeros before it

	xor	dx,dx			; DX = 0 - port number goes here
	mov	cl,0			; CL = 0 - hex indicator (0 = decimal)
	push	ds
	lds	si,[bx+cmd_addr]	; DS:SI - command line
	cld

skip_drv_name_loop:
	lodsb
	cmp	al,' '			; space
	je	skip_space
	cmp	al,09h			; TAB
	je	skip_space
	jmp	skip_drv_name_loop

skip_space_loop:
	lodsb

skip_space:
	cmp	al,' '			; space
	je	skip_space_loop
	cmp	al,09h			; TAB
	je	skip_space_loop
	jmp	parse_port

parse_port_loop:
	lodsb

parse_port:
	cmp	al,0Dh			; CR - end of cmdline, stop parsing
	je	port_check
	cmp	al,0Ah			; LF - end of cmdline, stop parsing
	je	port_check
	or	al,20h			; convert letters to lower case
	cmp	al,'x'			; hexadecimal identifier?
	je	use_hex
	cmp	al,'0'
	jb	invalid_argument
	cmp	al,'9'
	ja	above_nine
	sub	al,'0'			; convert to binary
	jmp	add_digit

use_hex:
	cmp	cl,0			; already seen a hexdecimal identifier?
	jne	invalid_argument
	cmp	dx,0			; hex flag after a non-zero number?
	jne	invalid_argument
	inc	cl			; set hexadecimal flag
	jmp	parse_port_loop

above_nine:
	cmp	cl,0			; hex flag not set, but not a decimal?
	je	invalid_argument
	cmp	al,'a'
	jb	invalid_argument
	cmp	al,'f'
	ja	invalid_argument
	sub	al,'a'-10		; convert to binary

add_hex_digit:
	shl	dx,1			; DX = DX << 4
	shl	dx,1
	shl	dx,1
	shl	dx,1
	add	dl,al			; add the digit
	jmp	parse_port_loop

add_digit:
	cmp	cl,0			; hex flag is set?
	jne	add_hex_digit		; then add a hex digit
	push	ax
	mov	ax,10
	mul	dx			; DX:AX = DX * 10
	mov	dx,ax
	pop	ax
	mov	ah,0
	add	dx,ax			; add the digit
	jmp	parse_port_loop

port_check:
	cmp	dx,0
	jnz	port_check_range
	mov	dx,default_io_port	; DX==0, load the default address

port_check_range:
	cmp	dx,3FEh			; I/O port shouldn't be above 3FEh
	ja	invalid_port
	cmp	dx,200h			; I/O port shouldn't be below 200h
	jb	invalid_port
	pop	ds
	mov	cs:[rtc_io_port],dx	; store the port address

;-------------------------------------------------------------------------
; Check if we have a DS12885 RTC at the specified address

	mov	al,cmos_control_a	; select control A register
	mov	ah,26h			; turn on oscillator and time keeping
					; set SQW frequency to 1.024 KHz
	call	rtc_write		; write control register A

	call	rtc_read		; read back control A register
	cmp	al,26h
	jne	no_rtc

; Continue with the RTC initialization

	mov	al,cmos_control_b
	call	rtc_read
	mov	ah,al
	and	ah,cmos_dse		; clear all bits except of DSE
	or	ah,cmos_24hours		; set 24 hours bit, keep BCD format and
					; interrupts disabled
	mov	al,cmos_control_b
	call	rtc_write		; write control register B

	mov	al,cmos_control_c
	call	rtc_read		; read control register C - reset
					; interrupt flags

	mov	al,cmos_control_d
	call	rtc_read		; read control register D
	test	al,cmos_vrt
	jnz	battery_good		; RTC battery is good

; Battery is bad

	mov	dx,msg_rtc_batt
	call	print_string

; Set initial time and date - Monday, January 1st, 2024

	mov	byte cs:[day+1],2	; Monday
	mov	byte cs:[date+1],1	; 1st
	mov	byte cs:[month+1],1	; January
	mov	byte cs:[year+1],24h	; 24h
	mov	byte cs:[century+1],20h	; 20h
	call	rtc_set

battery_good:

;-------------------------------------------------------------------------
; Set BIOS timer variables to RTC time

	push	bx

	call	rtc_get

; convert time to ticks * 2^11

; ticks = seconds * 37287
	mov	al,cs:[seconds+1]
	call	bcd_to_binary		; convert seconds to binary

	mov	dx,37287
	mul	dx			; DX:AX = seconds * 37287

	mov	si,ax
	mov	di,dx

; ticks += minutes * 2237216 = minutes * 8992 + minutes * 34 * 2^16
	mov	al,cs:[minutes+1]
	call	bcd_to_binary		; convert minutes to binary

	mov	bx,ax
	mov	dx,8992
	mul	dx			; DX:AX = minutes * 8992

	add	si,ax
	adc	di,dx

	mov	ax,bx
	mov	dx,34
	mul	dx

	add	di,ax

; ticks += hours * 134232938 = hours * 15210 + hours * 2048 * 2^16
	mov	al,cs:[hours+1]
	call	bcd_to_binary		; convert hours to binary

	mov	bx,ax
	mov	dx,15210
	mul	dx			; DX:AX = hours * 15210

	add	si,ax
	adc	di,dx

	mov	ax,bx
	mov	dx,2048
	mul	dx			; AX = hours * 2048

	add	di,ax

; CX:DX = DI:SI / 2048
	mov	cl,11
	shr	si,cl
	mov	dx,di
	mov	cl,5
	shl	dx,cl
	or	dx,si

	mov	cl,11
	shr	di,cl
	mov	cx,di

					; CX = high word of tick count
					; DX = low word of tick count
	
	mov	ah,01h			; int 1Ah, function 01h - set time
	int	1Ah
	pop	bx

;-------------------------------------------------------------------------
; Print the RTC I/O port number

	mov	dx,msg_rtc_port
	call	print_string
	mov	ax,cs:[rtc_io_port]
	call	print_hex

; Print current date and time

	mov	dx,msg_rtc_time
	call	print_string

	mov	ah,cs:[century+1]
	mov	al,cs:[year+1]
	call	print_hex		; print 4-digit year

	mov	al,'-'			; print a dash (-)
	call	print_char

	mov	al,cs:[month+1]
	call	print_byte		; print 2-digit month

	mov	al,'-'			; print a dash (-)
	call	print_char

	mov	al,cs:[date+1]
	call	print_byte		; print 2-digit date

	mov	al,' '			; print a space
	call	print_char

	mov	al,cs:[hours+1]
	call	print_byte		; print 2-digit hours
	
	mov	al,':'			; print a colon (:)
	call	print_char

	mov	al,cs:[minutes+1]
	call	print_byte		; print 2-digit minutes
	
	mov	al,':'			; print a colon (:)
	call	print_char

	mov	al,cs:[seconds+1]
	call	print_byte		; print 2-digit seconds

	mov	dx,msg_cr_lf
	call	print_string

	mov	word [bx+end_addr],init	; resident part ends at "init"
	mov	[bx+end_addr+2],cs
	mov	byte [bx+num_units],1	; 1 unit, keeps DOS happy?!

	jmp	exit
	
no_rtc:
	push	dx
	mov	dx,msg_no_rtc
	call	print_string
	pop	dx
	mov	ax,dx
	call	print_hex
	mov	dx,msg_cr_lf
	call	print_string
	jmp	init_error
	
invalid_argument:
	pop	ds
	mov	dx,msg_inv_arg
	call	print_string
	jmp	init_error

invalid_port:
	pop	ds
	mov	ax,dx
	mov	dx,msg_inv_port
	call	print_string
	call	print_hex
	mov	dx,msg_usage
	call	print_string

init_error:

	mov	word [bx+end_addr],0	; not staying in memory
	mov	[bx+end_addr+2],cs
	mov	byte [bx+num_units],1	; 1 unit, keeps DOS happy?!

	jmp	error

;=========================================================================
; print_string - print '$' terminated string
; Input:
;	CS:DX - string to print
; Output:
;	none, string printed
;-------------------------------------------------------------------------
print_string:
	push	ax
	push	ds
	mov	ax,cs
	mov	ds,ax
	mov	ah,09h
	int	21h			; DOS function 09h - print string
	pop	ds
	pop	ax
	ret

;=========================================================================
; print_char - print character
; Input:
;	AL - character to print
; Output:
;	none, character printed
;	AH - trashed
;-------------------------------------------------------------------------
print_char:
	push	dx
	mov	ah,02h
	mov	dl,al			; character to print
	int	21h			; DOS function 02h - print character
	pop	dx
	ret

;=========================================================================
; print_hex - print 16-bit number in hexadecimal format
; Input:
;	AX - number to print
; Output:
;	none
;-------------------------------------------------------------------------
print_hex:
	xchg	al,ah
	call	print_byte		; print the upper byte
	xchg	al,ah
	call	print_byte		; print the lower byte
	ret

;=========================================================================
; print_byte - print a byte in hexadecimal
; Input:
;	AL - byte to print
; Output:
;	none
;-------------------------------------------------------------------------
print_byte:
	rol	al,1
	rol	al,1
	rol	al,1
	rol	al,1
	call	print_digit
	rol	al,1
	rol	al,1
	rol	al,1
	rol	al,1
	call	print_digit
	ret	

;=========================================================================
; print_digit - print hexadecimal digit
; Input:
;	AL - bits 3...0 - digit to print (0...F)
; Output:
;	none
;-------------------------------------------------------------------------
print_digit:
	push	ax
	and	al,0Fh
	add	al,'0'			; convert to ASCII
	cmp	al,'9'			; less or equal 9?
	jna	.1
	add	al,'A'-'9'-1		; a hex digit
.1:
	call	print_char
	pop	ax
	ret

;=========================================================================
; Messages for the initialization routine

msg_signin	db	'DS12885 RTC Driver, Version 1.0. '
		db	'Copyright (C) 2024 Sergey Kiselev'
		db	0Dh, 0Ah, '$'
msg_rtc_port	db	'Using RTC at the I/O port 0x$'
msg_rtc_time	db	'. Date and time: $'
msg_rtc_batt	db	07h, 'Warning: The RTC battery is bad', 0Dh, 0Ah, '$'
msg_no_rtc	db	07h, 'Error: No RTC detected at the I/O port 0x$'
msg_inv_port	db	07h, 'Error: Invalid port number 0x$'
msg_inv_arg	db	07h, 'Error: Invalid command line argument'
msg_usage	db	0Dh, 0Ah, 'Usage: DSCLOCK.SYS [port]', 0Dh, 0Ah
		db	'  port - decimal or hexadecimal RTC I/O port number.'
		db	0Dh, 0Ah, '  Supported port range is 0x200 - 0x3FF'
		db	0Dh, 0Ah, 'Example: DSCLOCK.SYS 0x240'
msg_cr_lf	db	0Dh, 0AH, '$'
