;Napisać program, który konwertować będzie dwie liczby całkowite 
;z przedziału [-32768..32767] z postaci ASCII do postaci 
;obliczeniowej w kodzie U2, dodawać je do siebie, a otrzymany 
;wynik wyświetlać na ekranie.


				.386p
				.MODEL  SMALL

Dane			SEGMENT USE16
l1 				DB           "12345"
l2 				DB           "345"

;DD jako 4 bajty

Dane			ENDS

Kod				SEGMENT USE16
				ASSUME  CS:Kod, DS:Dane, SS:Stosik

Start:			mov     ax, SEG Dane
                mov     ds, ax 
				
                mov     ah, 09h         
                mov     dx, OFFSET Napis
                int     21h
				
				mov		eax, 165536
				mov		ebx, 2
				add 	eax, ebx
				



				mov     ax, 4C00h
                int     21h

Kod				ENDS

Stosik			SEGMENT stack USE16
				DB 100h DUP(0)
Stosik			ENDS
				
				END Start
				