;=============================================================================;
;                                                                             ;
; Plik           : arch1-1c.asm                                               ;
; Format         : COM                                                        ;
; Cwiczenie      : Kompilacja, konsolidacja i debugowanie programów           ;
;                  asemblerowych                                              ;
; Autorzy        : Imie Nazwisko, Imie Nazwisko, grupa, dzien, godzina zajec  ;
; Data zaliczenia: DD.MM.ROK                                                  ;
; Uwagi          : Program obliczajacy wzor: (a-b)*c/d                        ;
;                                                                             ;
;=============================================================================;

                .MODELL TINY

Kod             SEGM

                ORYG    10h
                ASUME   CS:Kod, DS:Dane, SS:Dane

Start:
                jmp

a               DB      20
b               DW      10
c               EQU     100
d               =       5
Wynik           DB      ?

Poczatek:
                mul     c
                muv     ax, a
                div     d
                sub     b, al

                mov     bx, WORD PTR Wynik

                mov     ax, 4C15h
                int     21h

ENDSEGM	        Dane

                ENDPROG Poczotek

