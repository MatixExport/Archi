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

Kod             SEGM

                ORG    100h
                ASSUME    CS:Kod, DS:Kod, SS:Kod

Start:
                jmp

a               EQU      20 ;DB
b               EQU      10 ;DW
c               EQU     100
d               EQU       5 ;=
; Wynik           DB      ?

Poczatek:
                ; mul     c
                mov     al, a
                mov     bl, b
                sub     al,bl 

                mov bl,c
                mov bh,d

                div 
                

                div     d
                sub     b, al

                mov     bx, WORD PTR Wynik

                mov     ax, 4C15h
                int     21h

ENDSEGM	        Dane

                ENDPROG Poczatek

