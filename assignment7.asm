TITLE  Assignment 7: Use procedures and macros to convert decimal to binary byte
		

; Name:  Yunlin Xie

;;; Question 1. (3pts) Write a printString macro to print a text string of 8 characters,
;;; where each output character is separated by a space. 
;;; The macro receives the address of the string.
;;; Hint: don't use writeString since it won't let you insert a space between characters

;;; Question 2. (4pts) Write a procedure readInput that uses THE STACK for parameter passing.
;;; The procedure accepts an address of a prompt string as input argument, then it reads in a user input number
;;; and returns it on the stack. 
;;; Keep re-prompting if you don't get a positive value that's within a byte.

;;; Question 3. (5pts) Write a procedure toBinary that uses REGISTERS for parameter passing.
;;; The procedure accepts the user input number and the address of the binaryStr in 2 registers.
;;; Then it converts the user input number into the appropriate binary characters and stores it in binaryStr
;;; The procedure should not modify the input register

;;; Question 4. (3pts) Complete the main procedure below by calling the readInput and toBinary procedures,
;;; and then invoke the printString macro to print the result

COMMENT !
Sample output:
Enter an 8-bit positive number: -2
Enter an 8-bit positive number: 7
0 0 0 0 0 1 1 1
Enter an 8-bit positive number: 128
1 0 0 0 0 0 0 0
Enter an 8-bit positive number: 250
1 1 1 1 1 0 1 0
!

INCLUDE Irvine32.inc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printString MACRO strAddr
	push eax
	push ecx
	push edx
	
	mov edx, strAddr
	mov ecx, 8
	L1:
	mov al, BYTE PTR [edx]
	call writeChar
	mov al, ' '
	call writeChar
	inc edx
	LOOP L1
	
	pop edx
	pop ecx
	pop eax
ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.data
binaryStr BYTE 8 DUP (0)
promptS BYTE "Enter an 8-bit positive number: ", 0

.code
main PROC
	loopTop:
	; call readInput
	sub esp, 4
	push OFFSET promptS
	call readInput
	pop eax

	cmp eax, 0
	jl loopTop
	
	; call toBinary
	mov esi, OFFSET binaryStr
	call toBinary
	
	; invoke printString
	printString OFFSET binaryStr
	call crlf
	jmp loopTop			; this creates an infinite loop for testing. 
						; Use control-c or close the output window to end the program.
	exit	
main ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; answer for Question2
; readInput returns an input number
; input: address of a string prompt
; output: on stack
;;; stack frame:
; ret value     ebp+12
; string addr   ebp+8
; ret addr      ebp+4
; ebp
; saved regs

readInput PROC
	push ebp
	mov ebp, esp
	push eax
	push edx

	mov edx, [ebp+8]
	call writeString
	call readInt
	mov [ebp+12], eax

	pop edx
	pop eax
	pop ebp
	ret 4
readInput ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; answer for Question3
; toBinary converts an input number to binary
; input: eax(number)
; input: esi(address of binaryStr)
; output: in binaryStr

toBinary PROC
	pushad

	mov ecx, 8
	L2:
	shl al, 1
	mov BYTE PTR [esi], '0'
	jnc L3
	mov BYTE PTR [esi], '1'
	L3:
	inc esi
	LOOP L2

	popad
	ret
toBinary ENDP


END main
