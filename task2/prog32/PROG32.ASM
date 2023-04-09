;Napisać program, który konwertować będzie dwie liczby całkowite 
;z przedziału [-32768..32767] z postaci ASCII do postaci 
;obliczeniowej w kodzie U2, dodawać je do siebie, a otrzymany 
;wynik wyświetlać na ekranie.


				.386p
				.MODEL  SMALL			;zmienic na exe

Dane			SEGMENT USE16
l1 				DB           "0000000000001010b" 
l2 				DB           "1111111111110101b"

li1             DB    ?
li2             DB    ?

;10  + -11^^^

;DD jako 4 bajty

;poprzez zanegowanie wszystkich bitów modułu liczby i do otrzymanego wyniku dodanie 1.
;tak robimy

Dane			ENDS

Kod				SEGMENT USE16
	ASSUME  CS:Kod, DS:Dane, SS:Stosik

Start:
	mov     ax, SEG Dane
	mov     ds, ax 					;czytanie segmentu danych
	
	;if ujemna:
		;odejmij 1
		;negacja bitowa    ;jest w 2 tylko jeszcze na -
	;if dodatnia:
		;jest w 2

	mov si,16
	mov ax,0
	mov bh,30h
	cmp[si],bh
	jne looop0
looop1:
	cmp si,15
	jnb skok
	cmp [si],bh
	je zero1		;jump equal
	jmp jeden1
zero1:
	shl ax,1
	inc si
	jmp looop1
jeden1:
	inc ax
	shl ax,1		;shift left
	inc si
	jmp looop1

looop0:
	cmp si,31
	jnb skok1
	cmp [si],bh
	je zero0		;jump equal
	jmp jeden0

zero0:
	inc ax
	shl ax,1
	inc si
	jmp looop0
jeden0:
	shl ax,1		;shift left
	inc si
	jmp looop0


ujemna:
	;liczba -1 
	;jmp looop
skok1:
	inc ax
	mov li2,al
	jmp skok

skok:
	mov li1,al

	mov bl,li1
	mov al,li2
	sub al,bl

	mov     ah, 4Ch				;al wynikiem tłumaczenia l1 ze stringa (binarny naturalny) na inta 
    int     21h
	;mov		eax, 165536
	;mov		ebx, 2
	;add 		eax, ebx
			

	mov     ah, 09h         			;poczatek wypisywania
    mov     dx, OFFSET l1
    int     21h							;koniec wypisywania

				

Kod				ENDS

Stosik			SEGMENT stack USE16
				DB 100h DUP(0)
Stosik			ENDS
				
				END Start
				