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



                .MODEL TINY         ; dane i kod sa w jednym segmencie o max wielkosci 64kb
 
Kod             SEGMENT
                ORG       100h
                ASSUME    CS:Kod, DS:Kod, SS:Kod
Start:


                jmp st
wynik           DW      0h

a               DB       "17" 
b               DB      "-11"
an              DB      0


st:

        mov     si,OFFSET a         
looop:  cmp     si,OFFSET b
        je      Koniec
        mov     bx,10
        mul     bx
        mov     bx,[si]
        sub     bx , 48
        add     al,bl
        inc     si
        jmp     looop

Koniec:        
                mov     wynik, ax        ; w wyniku 11h = 17d czyli działa tlumaczenie stringa a na inta  
                mov     ax, 4C00h               ;4C mowi systemowi ze konczy dzialanie programu i zwraca wartosc ah jako kod bledu 00 w tym przypadku
                int     21h                     ;przerwanie systemowe konczace program



Kod             ENDS

                END     start