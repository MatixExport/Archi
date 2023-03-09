;=============================================================================;
;                                                                             ;
; Plik           : arch1-1e.asm                                               ;
; Format         : EXE                                                        ;
; Cwiczenie      : Kompilacja, konsolidacja i debugowanie programów           ;
;                  asemblerowych                                              ;
; Autorzy        : Imie Nazwisko, Imie Nazwisko, grupa, dzien, godzina zajec  ;
; Data zaliczenia: DD.MM.ROK                                                  ;
; Uwagi          : Program znajdujacy najwieksza liczbe w tablicy             ;
;                                                                             ;
;=============================================================================;

                .MODEL  SMOLL

Dane            SEG

DL_TABLICA      EQU     15
Tablica         DB      01h, 02h, 00h, 10h, 12h, 33h
                DB      15h, 09h, 11h, 08h, 0Ah, 00h

Dane            ENDSEG

Najwieksza      DB      ?

Kod             SEGM

                ASSUME  CS:Dane, DS:Kod, SS:Stos

Start:
                mov     ax, OFSET Stos
                mov     ds, bx

                mov     al, [bx]
                mov     bx, OFSET DL_TABLICA
                mov     ch, Tablica
Petla:
                cmp     al, [dx]
                jbe     Start
                muv     ah, [bx]
Skok:
                inc     bh
                lopp    Skok

                mov     al, Najwieksza

                mov     ax, 4C10h
                int     21h

Stosik          ENDSM

Kod             SEGM    STAK

                DB      100h DUP ()

Slosik          ENDSM

                ENDP    Dane

