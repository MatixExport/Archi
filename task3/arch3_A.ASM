			   .MODEL 	SMALL, C
				PUBLIC 	srednia 
                PUBLIC  countAsciiOccurrence
               
               .CODE

srednia: 	push 	bp
				mov  	bp, sp
				mov  	ax, [bp + 4]        ;rozmiar
                sub     sp ,2 
                mov     [bp - 2], ax
				mov     si,ax
                mov  	ax, [bp + 6]        ;wskaznik na tablice
                mov     dx,bp
                mov     bp,ax               ;przypisanie wskaznika na tablic
                
                fld     DWORD PTR [bp]      ;pierwszy element z tablicy
                dec     si
looop:                                      
                cmp     si,0                ;warunek konca tablicy
                je      end    

                add     bp,4h               ;wskaznik na kolejny element tablicy

                fld     DWORD PTR [bp]      ;pobieranie kolejnego elementu tablicy
                fadd                        ;dodawanie

                dec     si                  
                jmp     looop                
				
end:
                mov     bp,dx
                ;mov  	bp, sp

                fidiv WORD ptr [bp - 2]     ;dzielenie przez rozmiar
                mov     sp,bp
                
				pop  	bp
				ret

ascii = word ptr -4
countAsciiOccurrence:
                push bp ; zachowujemy obecną wartość bp na stosie
                mov  bp,sp ; bp i sp będą wskazywać na początek stosu
                sub sp,4
                xor ax,ax
                mov [bp + ascii],ax
                mov  ax, [bp + 4]  ;przenosimy do ax szukany znak ascii
                mov [bp + ascii],ax
                mov  ax, [bp + 6]  ; przenosimy do ax wskaźnik na tablicę znaków
                mov si,ax
                xor bx,bx
                
countAsciiOccurrenceLoop:
                cmp word ptr [si], 0
                je countAsciiOccurrenceEnd
                mov dh,byte ptr [bp + ascii]
                cmp byte ptr [si],dh
                jne countAsciiOccurrenceLoopIncrement
                inc bx
                jmp countAsciiOccurrenceLoopIncrement
                
countAsciiOccurrenceLoopIncrement:
                inc si
                jmp countAsciiOccurrenceLoop
countAsciiOccurrenceEnd:
                mov sp,bp
                mov ax,bx
                pop bp
                ret

                
                END
