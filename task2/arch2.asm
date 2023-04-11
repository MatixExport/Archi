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


                jmp startt
wynik           DW      0h

a               DB       "17" 
b               DB      "-11"
an              DW      0
znak            DB      0


startt:
        mov     si,OFFSET a   
        cmp     [si] , '-'      
        je      minus1

looop:  cmp     si,OFFSET b
        je      next
        mov     bl,10
        mul     bl
        mov     bl,[si]
        sub     bl , 48
        add     al,bl
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
        mov     bl,10
        mul     bl
        mov     bl,[si]
        sub     bl , 48
        add     al,bl
        inc     si
        jmp     looop2
minus2:
        mov     znak,1
        inc     si
        jmp     looop2

;koniec zamiany liczb

dodaj:
        ;kod na dodawanie trzeba by dodać
        ;an + ax

Koniec:        
                mov     ax, 4C00h               ;4C mowi systemowi ze konczy dzialanie programu i zwraca wartosc ah jako kod bledu 00 w tym przypadku
                int     21h                     ;przerwanie systemowe konczace program



Kod             ENDS

                END     start