;=============================================================================;
;                                                                             ;
; Plik           : arch1-1c.asm                                               ;
; Format         : COM                                                        ;
; Cwiczenie      : Kompilacja, konsolidacja i debugowanie program�w          ;
;                  asemblerowych                                              ;
; Autorzy        : Mateusz Giełczyński, Jakub Kubiś, 1.1, śr, 12:00           ;
; Data zaliczenia: DD.MM.ROK                                                  ;
; Uwagi          : Program obliczajacy wzor: (a-b)*c/d                        ;
;                                                                             ;
;=============================================================================;


                .386p
                .MODEL TINY         ; dane i kod sa w jednym segmencie o max wielkosci 64kb
 
Kod             SEGMENT USE16
                ORG       100h
                ASSUME    CS:Kod, DS:Kod, SS:Kod
Start:
        mov     si,OFFSET a                     ;zaczynamy na pierwszej liczbie z a
        cmp     byte ptr [si] , '-'             ;sprawdzamy czy ujemna
        je      minus1                          ;wywolujemy kod ujemnej

looop:  cmp     si,OFFSET b                     ;sprawdzamy czy to koniec liczby
        je      next                            ;jezeli koniec idziemy do nastepnej
        mov     cx,10                           ;10 do cx zeby mnozyc 
        mul     cx
        mov     bl,[si]                         ;pobieranie nastepnego znaku
        sub     bl , 48                         ;zmiana znaku z asci na int
        add     ax,bx                           ;dodajemy znak do obliczanej liczby
        inc     si                              
        jmp     looop
minus1:
        mov     znak,1                          ;zapisujemy ze liczba jest ujemna
        inc     si
        jmp     looop                           ;powrot

next:
        cmp     znak,1                          ;jezeli ujemna
        je      ujemna
        jne     nexxt
ujemna:                 
        not     ax                              ;negacja ax
        inc     ax                              ;+1 do ax
        jmp     nexxt                           ;liczba juz zmieniona do kodu u2

nexxt:
        cmp     an,0          ;sprawdzamy czy obie liczby sa zmienione
        jne     dodaj
        mov     an, ax        ; wynik pierwszej liczby do an  
        mov     ax, 0         ;poczatek konwersji drugiej liczby
        mov     znak,0

        mov     si,OFFSET b   
        cmp     byte ptr [si] , '-'     ;byte ptr zeby porównać 8 bitów nie 16 
        je      minus2
looop2:
        cmp     si,OFFSET an
        je      next
        mov     bx,10
        mul     bx
        mov     bl,[si]
        sub     bl , 48
        add     ax,bx
        inc     si
        jmp     looop2
minus2:
        mov     znak,1
        inc     si
        jmp     looop2
;koniec zamiany liczb

hexTo32BitConvert:
        or eax,11111111111111110000000000000000b
        jmp xd
hexTo32BitConvert2:
        or ebx,11111111111111110000000000000000b
        jmp xd2

dodaj:

        cmp eax,1000000000000000b
        jnb  hexTo32BitConvert
xd:
        mov bx, an
        cmp ebx,1000000000000000b
        jnb  hexTo32BitConvert2
xd2:
        
;       xor eax,10000000000000000b

        add eax,ebx
convertoToAsciiDecision:
        xor ebx, ebx  ; czyścimy ebx
        mov  si,OFFSET napis 
        cmp eax,100000000000000000b
        jb convertToAsciiPrestart
convertToAsciiIfNegative:
        xor ebx,ebx
        mov ebx,eax

        mov dx , '-'
        mov ah,02h
        int 21h
        mov eax,ebx

        inc si       ; lepiej zrobić flagę i wypisać to na końcu przed obrotem  ale na razie niech se bedzie
        ;rozkład eax
        xor ebx,ebx
        mov ebx,eax
        and ebx,00000000000000001111111111111111b ; wartość eax bez 17 bitu
        xor eax,eax
        mov eax, 10000h ; wartośc 17 bitu do której będziemy dodawać wartości kolejnych bitów
        sub eax,ebx
convertToAsciiPrestart:
        ;dla dodatnich działa trzeba jeszcze zrobić rozkład dla ujemnych
        xor ebx,ebx
        xor ecx,ecx
        mov ecx, 10 ; tu jest 10 bo będziem dzielić przez 10 (naprawdę)
convertToAscii:
        ;mov eax,0h
        cmp eax,0d
        JNE convertToAsciiLoop
        JMP print
convertToAsciiLoop:
        xor edx, edx  ; czyścimy edx
        div ecx
        xor ebx, ebx
        mov ebx,eax ; czyścimy ebx i zapisujemy tam eax
        xor eax, eax
        mov eax,edx ; przenosimy resztę z dzielnie do eax żeby dodać 48

        ;add eax,48d; w eax mamy kod asci danej cyfry
        add eax,'0'

        ;zapisać cyfrę 
        mov [si],ax ; chyba ax wystarczy bo to pojedyńcza cyfra a nie jakies tam araraty
        inc si
        xor eax, eax
        mov eax,ebx ; przywracamy konwertowaną liczbę do eax
        JMP convertToAscii
print:
                mov  ah, 02h
                mov dx,[si]
                int     21h
                dec si
                cmp si,OFFSET napis
                jnb print
Koniec:        
                mov     ax, 4C00h               ;4C mowi systemowi ze konczy dzialanie programu i zwraca wartosc ah jako kod bledu 00 w tym przypadku
                int     21h                     ;przerwanie systemowe konczace program

wynik           DD     0h
a               DB      "8000" 
b               DB      "4000"
an              DW      0
znak            DB      0
napisStart      DB     0
napis db 16 dup (0)

Kod             ENDS

                END     start