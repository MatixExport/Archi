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

                .MODEL TINY 

a               EQU      20 ;DB
b               EQU      10 ;DW
c               EQU     100
d               EQU       5 ;=

Kod             SEGMENT

                ORG    100h
                ASSUME    CS:Kod, DS:Kod, SS:Kod

Start:          mov     al, a
                mov     bl, b
                sub     al,bl           ;ax = al - bl
                mov     bl, c           ;bl = c
                mul     bl

                mov     bl,d
                div     bl
                
                
                ; mov     bx, WORD PTR Wynik

Koniec:         mov     ax, 4C00h
                int     21h


Kod             ENDS

                END     start