;=============================================================================;
;                                                                             ;
; Plik           : arch1-1e.asm                                               ;
; Format         : EXE                                                        ;
; Cwiczenie      : Kompilacja, konsolidacja i debugowanie program�w           ;
;                  asemblerowych                                              ;
; Autorzy        : Imie Nazwisko, Imie Nazwisko, grupa, dzien, godzina zajec  ;
; Data zaliczenia: DD.MM.ROK                                                  ;
; Uwagi          : Program znajdujacy najwieksza liczbe w tablicy             ;
;                                                                             ;
;=============================================================================;

                .MODEL  SMALL

;Segment Danych
Dane            SEGMENT

DL_TABLICA      EQU     15
Tablica         DB      01h, 02h, 00h, 10h, 12h, 33h
                DB      15h, 09h, 11h, 08h, 0Ah, 00h
Najwieksza      DB      ?
Dane            ENDS
;Koniec Segmentu Danych


;Segment Kodu
Kod             SEGMENT

                ASSUME  CS:Kod, DS:Dane, SS:Stosik

Start:
                mov     ax, OFFSET Stosik
                mov     ds, bx

                mov     al, [bx]
                mov     bx, OFFSET DL_TABLICA
                mov     ch, Tablica
Petla:
                cmp     al, [dx] 
                jbe     Start
                muv     ah, [bx]
Skok:
                inc     bh
                loop    Skok

                mov     al, Najwieksza

                mov     ax, 4C10h
                int     21h

Kod         ENDS

; Segement stosu
Stosik             SEGMENT    STACK
                DB      100h DUP ()
Stosik          ENDS


                ; ENDP    Dane
                END     start

