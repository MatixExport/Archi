				.386p
				.MODEL  SMALL

Dane			SEGMENT USE16
Napis           DB      "Witaj swiecie!",13,10,"$"
Dane			ENDS

Kod				SEGMENT USE16
				ASSUME  CS:Kod, DS:Dane, SS:Stosik

Start:			mov     ax, SEG Dane
                mov     ds, ax 
				
                mov     ah, 09h         
                mov     dx, OFFSET Napis
                int     21h
				
				mov		eax, 1
				mov		ebx, 2
				add 	eax, ebx
				
				mov     ax, 4C00h
                int     21h

Kod				ENDS

Stosik			SEGMENT stack USE16
				DB 100h DUP(0)
Stosik			ENDS
				
				END Start
				