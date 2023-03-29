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
a               EQU      20 ;DB
b               EQU      10 ;DW
c               EQU      100
d               EQU      5 
                .MODEL TINY         ; dane i kod sa w jednym segmencie o max wielkosci 64kb
 


Kod             SEGMENT
                ORG       100h
                ASSUME    CS:Kod, DS:Kod, SS:Kod
Start:

; dlaczego to się wykonuje mimo że skok jest
Poczatek:
                mov     al, a           ;al = a
                mov     bl, b           ;bl = b
                sub     al,bl           ;ax = al - bl
                mov     bl, c           ;bl = c
                mul     bl              ;ax = al * bl

                mov     bl,d            ;bl = d
                div     bl              ;ax = ax/bl
                
                
                mov     wynik,ax        ;wynik=ax

Koniec:         mov     ax, 4C00h               ;4C mowi systemowi ze konczy dzialanie programu i zwraca wartosc ah jako kod bledu 00 w tym przypadku
                int     21h                     ;przerwanie systemowe konczace program

wynik           DW      0h


Kod             ENDS

                END     start