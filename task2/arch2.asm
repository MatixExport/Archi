;=============================================================================;
;                                                                             ;
; Plik           : arch2.asm                                                  ;
; Format         : COM                                                        ;
; Cwiczenie      : Kompilacja, konsolidacja i debugowanie program�w          ;
;                  asemblerowych                                              ;
; Autorzy        : Mateusz Giełczyński, Jakub Kubiś, 1.1, śr, 12:00           ;
; Data zaliczenia: DD.MM.ROK                                                  ;
; Uwagi          : Program zmieniajacy liczyby z lancucha znakow na liczby    ;
;               w zapisie u2 i wypisujacy wynik oddawania tych liczb na ekran ;
;                                                                             ;
;=============================================================================;

                .386p
                .MODEL TINY                     ; dane i kod sa w jednym segmencie o max wielkosci 64kb
 
Kod             SEGMENT USE16
        ORG       100h
        ASSUME    CS:Kod, DS:Kod, SS:Kod
Start:
        mov     si,OFFSET a                     ;zaczynamy na pierwszej liczbie z a
        cmp     byte ptr [si] , '-'             ;sprawdzamy czy ujemna ; byte ptr zeby porównać 8 bitów nie 16
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
        cmp     flaga,0                            ;sprawdzamy czy obie liczby sa zmienione
        jne     dodaj                   ;przejscie do czesci dodajacej
        mov     flaga,1
        mov     an, ax                          ; wynik pierwszej liczby do an  
        mov     ax, 0                           ;poczatek konwersji drugiej liczby
        mov     znak,0

        mov     si,OFFSET b   
        cmp     byte ptr [si] , '-'             ;byte ptr zeby porównać 8 bitów nie 16 
        je      minus2
looop2:
        cmp     si,OFFSET an
        je      next
        mul     cx                              ;*10
        mov     bl,[si]                         ;wczytanie kolejnej cyfry
        sub     bl , 48                         ;zmiana z asci na int
        add     ax,bx                           
        inc     si
        jmp     looop2
minus2:
        mov     znak,1
        inc     si
        jmp     looop2
;koniec zamiany liczb

hexTo32BitConvert:                 ;konwersja 16 bitowej ujemnej na 32 bitowa, poprzez wpisanie jedynek do wszyskich bitow przed 16
        or      eax,11111111111111110000000000000000b
        jmp     back1
hexTo32BitConvert2:
        or      ebx,11111111111111110000000000000000b
        jmp     back2

dodaj:
        cmp     eax,1000000000000000b
        jnb     hexTo32BitConvert
back1:
        mov     bx, an                              ;wczytanie przekonwertowanej liczby z pamieci
        cmp     ebx,1000000000000000b
        jnb     hexTo32BitConvert2
back2:
        add     eax,ebx                             ;dodawanie
convertoToAsciiDecision:
        mov     si,OFFSET napis                     ;ustawienie wskaznika na poczatek napisu wynikowego
        cmp     eax,100000000000000000b             ;sprawdzamy czy suma jest ujemna 18 bit sprawdzamy
        jb      convertToAsciiPrestart              ;jezeli nie to pomijamy nastepna czesc
convertToAsciiIfNegative:
        mov     ebx,eax             
        mov     dx , '-'                            ;wypisanie '-' dla liczb ujemnych
        mov     ah,02h
        int     21h

        mov     eax,ebx                                     
        dec     eax                             ;zmiana liczby ujemnej w kodzie u2 na wartosc bezwzgledna
        not     eax
convertToAsciiPrestart:
        mov     ecx, 10                         ;ecx = 10 , zeby pozniej dzielic
convertToAsciiLoop:
        xor     edx, edx                        ; czyścimy edx zeby zapisac tam reszte z dzielenia
        div     ecx                             ;eax=eax/10
        add     edx,'0'                         ;zmiana z inta na asci
        mov     [si],dx                         ;zapis cyfry do tablicy
        inc     si  
        cmp     eax,0d                          ;jezeli eax==0 to koniec petli
        JNE     convertToAsciiLoop
print:
        mov     ah, 02h                         ;si jest na koncu tablicy wiec dekrementujemy w petli i wypisujemy kazdy znak
        mov     dx,[si]
        int     21h
        dec     si
        cmp     si,OFFSET napis
        jnb     print
Koniec:        
        mov     ax, 4C00h                       ;4C mowi systemowi ze konczy dzialanie programu i zwraca wartosc ah jako kod bledu 00 w tym przypadku
        int     21h                             ;przerwanie systemowe konczace program


a               DB      "-32768"                  ;input 1
b               DB      "-32767"                  ;input 2
an              DW      0                        ;zmienna 
znak            DB      0                        ;flaga czy liczba jest ujemna
flaga           DB      0                        ;flaga zapisu liczby

napis           db      16 dup (0)

Kod             ENDS

                END     Start