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


startt:
        ;xor eax,eax
        ;xor ebx,ebx
        ;mov ebx,10
        ;mov eax,6
        ;div ebx
        ;tutaj to działa dzieli przez 10 a tam w konwersji na asci
        ;jakieś rzeczy się dzieją niestworzone

        mov     si,OFFSET a   
        cmp     byte ptr [si] , '-'      
        je      minus1

looop:  cmp     si,OFFSET b
        je      next
        mov     bx,10
        mul     bx
        mov     bl,[si]
        sub     bl , 48
        add     ax,bx
        inc     si
        jmp     looop
minus1:
        mov     znak,1
        inc     si
        jmp     looop

next:
        cmp     znak,1
        je      ujemna
        jne     nexxt
ujemna: 
        not     ax
        inc     ax
        jmp     nexxt

nexxt:
        cmp     an,0          ;obie liczby powinny być zmienione
        jne     dodaj
        mov     an, ax        ; w an 11h = 17d czyli działa tlumaczenie stringa a na inta  
        mov     ax, 0
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

dodaj:

        mov bx, an
        
        add eax,ebx
        xor eax,10000000000000000b
        mov wynik,eax ; TODO: przetestować dla dużych liczb
        ;dobra z jakiegoś powodu wychodzi dobrze tylko że
        ;trzeba dać not na 17 bit i wtedy wszystko śmiga lata super jest
convertoToAsciiDecision:
        xor ebx, ebx  ; czyścimy ebx
        mov  si,OFFSET napis 
        cmp eax,10000000000000000b
        jb convertToAsciiPrestart
convertToAsciiIfNegative:
        ;mov ax,1111h
        mov [si],'-' ; to jest bezsensu bo będziemy obracać cyfry więc to tylko przeszkadza
        inc si       ; lepiej zrobić flagę i wypisać to na końcu przed obrotem  ale na razie niech se bedzie
        ;rozkład eax
        xor ebx,ebx
        mov ebx,eax
        xor ebx,10000000000000000b ; wartość eax bez 17 bitu
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
mov dx,ax
mov ah,02h
int 21h

        ;zapisać cyfrę 
        mov [si],ax ; chyba ax wystarczy bo to pojedyńcza cyfra a nie jakies tam araraty
        inc si
        xor eax, eax
        mov eax,ebx ; przywracamy konwertowaną liczbę do eax
        JMP convertToAscii
print:
                ;trzeba to wypisać odwrotnie
                mov     ah, 09h
                mov     dx, OFFSET napis
 ;wylączone bo wcześniej wypisane (128-130)               int     21h
Koniec:        
                mov     ax, 4C00h               ;4C mowi systemowi ze konczy dzialanie programu i zwraca wartosc ah jako kod bledu 00 w tym przypadku
                int     21h                     ;przerwanie systemowe konczace program

wynik           DD     0h
a               DB       "-32768" 
b               DB      "32767"
an              DW      0
znak            DB      0
napis db 16 dup (0)

Kod             ENDS

                END     start