			   .MODEL 	SMALL, C
				PUBLIC 	srednia 
                PUBLIC  countAsciiOccurrence
               
               .CODE

srednia:    push 	bp
            push    ax
            push    si
            push    dx
;trzeba inne rejestry które są zmieniane
				mov  	bp, sp
				mov  	ax, [bp + 10]        ;rozmiar
                sub     sp ,2               ;rezerwacja 2 bajtow na zmienna lokalna
                mov     [bp - 2], ax        ;przenoszenie rozmiaru do zmiennej lokalnej
				mov     si,ax               ;rozmiar do si potrzebne do petli
                mov  	ax, [bp + 12]        ;wskaznik na tablice
                mov     dx,bp               ;zapisanie wierzcholka stosu 
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
                mov     bp,dx               ;przywrocenie stosu

                fidiv WORD ptr [bp - 2]     ;dzielenie przez rozmiar (zmienna lokalna)
                mov     sp,bp               ;zwolnienie pamieci zmiennych lokalnych
                
                pop     dx
                pop     si
                pop     ax
				pop  	bp
				ret
;zachowanie i przywrócenie bx,si podobnie jak bp
ascii = word ptr -2
countAsciiOccurrence:
                push si
                push bx
                push bp             ; zachowujemy obecną wartość bp na stosie
                mov  bp,sp          ; bp i sp będą wskazywać na początek stosu
                sub sp,2            ; rezerwujemy 2 bajty na zmienne lokalne
                mov  ax, [bp + 8]   ;przenosimy do ax szukany znak ascii
                mov [bp + ascii],ax
                mov  ax, [bp + 10]   ; przenosimy do ax wskaźnik na tablicę znaków
                mov si,ax           ; przenosimy do si wskaźnik na tablicę znaków
                xor bx,bx           ; czyścimy bx
                
countAsciiOccurrenceLoop:
                cmp word ptr [si], 0                    ; sprawdzamy czy to koniec tablicy znaków
                je countAsciiOccurrenceEnd              ;jeżeli to koniec tablicy przejdź do countAsciiOccurrenceEnd
                mov dh,byte ptr [bp + ascii]            ;przenosimy do dh szukany znak z zminnej lokalnej
                cmp byte ptr [si],dh                    ; sprawdzamy czy obecnie iterowany znak jest szukanym znakiem
                jne countAsciiOccurrenceLoopIncrement   ;jeżeli nie to przechodzimy do inkrementacji
                inc bx                                  ;jeżeli tak to zwiększamy bx o 1 
                jmp countAsciiOccurrenceLoopIncrement   ;i przechodzimy do inkrementacji
                
countAsciiOccurrenceLoopIncrement:
                inc si                                   ; inkrementujemy "index" tablicy znakóww
                jmp countAsciiOccurrenceLoop             ; przechodzimy do pętli
countAsciiOccurrenceEnd:
                mov sp,bp                                ; zdjęcie ze stosu zmiennych lokalnych
                mov ax,bx         
                pop si    
                pop bx                   ; przenosimy ilość wystąpień szukanego znaku do ax
                pop bp                                   ; odtworzenie starej wartości bp
                ret                                      ; powrót z procedury

                
                END
