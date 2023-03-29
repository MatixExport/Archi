;Napisać program, który konwertować będzie dwie liczby całkowite 
;z przedziału [-32768..32767] z postaci ASCII do postaci 
;obliczeniowej w kodzie U2, dodawać je do siebie, a otrzymany 
;wynik wyświetlać na ekranie.


				.386p
				.MODEL  SMALL

Dane			SEGMENT USE16
l1 				DB           "0000000000001010" 
l2 				DB           "1111111111110101"
;10  + -11^^^

;DD jako 4 bajty

;poprzez zanegowanie wszystkich bitów modułu liczby i do otrzymanego wyniku dodanie 1.
;tak robimy

Dane			ENDS

Kod				SEGMENT USE16
				ASSUME  CS:Kod, DS:Dane, SS:Stosik

Start:			mov     ax, SEG Dane
                mov     ds, ax 					;czytanie segmentu danych
				
                ;if ujemna:
					;odejmij 1
					;negacja bitowa    ;jest w 2 tylko jeszcze na -
				;if dodatnia:
					;jest w 2
				
				mov si,0
				mov ax,0
				mov bh,30h
looop:
				
				cmp si,15
				jnb skok
				cmp [si],bh
				je zero			;jump equal
				jmp jeden
zero:
	shl ax,1
	inc si
	jmp looop
jeden:
	inc ax
	shl ax,1		;shift left
	inc si
	jmp looop
skok:
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
				