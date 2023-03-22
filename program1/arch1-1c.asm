;=============================================================================;
;                                                                             ;
; Plik           : arch1-1c.asm                                               ;
; Format         : COM                                                        ;
; Cwiczenie      : Kompilacja, konsolidacja i debugowanie program�w           ;
;                  asemblerowych                                              ;
; Autorzy        : Imie Nazwisko, Imie Nazwisko, grupa, dzien, godzina zajec  ;
; Data zaliczenia: DD.MM.ROK                                                  ;
; Uwagi          : Program obliczajacy wzor: (a-b)*c/d                        ;
;                                                                             ;
;=============================================================================;

                .MODEL TINY         ; dane i kod sa w jednym segmencie o max wielkosci 64kb



Kod             SEGMENT

                ORG    100h
                ASSUME    CS:Kod, DS:Kod, SS:Kod

Start:          jmp      Poczatek   ;skok do poczatku
a               EQU      20 ;DB
b               EQU      10 ;DW
c               EQU      100
d               EQU      5 
Wynik           DB      0
; dlaczego to się wykonuje mimo że skok jest
Poczatek:
                mov     al, a
                mov     bl, b
                sub     al,bl           ;ax = al - bl
                mov     bl, c           ;bl = c
                mul     bl              ;ax = al * bl

                mov     bl,d            ;bl = d
                div     bl              ;ax = ax/bl
                
                
                mov     ax, WORD PTR Wynik

Koniec:         mov     ax, 4C00h       ;zakonczenie
                int     21h


Kod             ENDS

                END     start