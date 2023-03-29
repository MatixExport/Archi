;=============================================================================;
;                                                                             ;
; Plik           : arch1-1e.asm                                               ;
; Format         : EXE                                                        ;
; Cwiczenie      : Kompilacja, konsolidacja i debugowanie program�w          ;
;                  asemblerowych                                              ;
; Autorzy        : Mateusz Giełczyński, Jakub Kubiś, 1.1, śr, 12:00           ;
; Data zaliczenia: DD.MM.ROK                                                  ;
; Uwagi          : Program znajdujacy najwieksza liczbe w tablicy             ;
;                                                                             ;
;=============================================================================;

.MODEL  SMALL           ; dane i kod w osobnych segmentach o wielkości maksymalnie 64 kb każdy

;Segment Danych
Dane            SEGMENT
    DL_TABLICA      EQU     12                              ;definicja stalej
    Tablica         DB      01h, 02h, 00h, 10h, 12h, 33h
                    DB      15h, 09h, 11h, 08h, 0Ah, 00h
    Najwieksza      DB      ?                               ;definicja zmiennej
Dane            ENDS        ;Koniec Segmentu Danych

ASSUME  CS:Kod, DS:Dane ;,SS:Stosik

;Segment Kodu
Kod             SEGMENT
Start:          mov     ax, SEG Dane            ;ładowanie segmentu danych
                mov     ds, ax                  ;ustawienie wskaznika ds na segment danych
                mov     si,OFFSET TABLICA       ;si zaczyna sie tam gdie tablica
                
                mov     cx,DL_TABLICA           ;zapisanie dlugosci tablicy
                mov     bh,[si]                 ;przypisanie pierwszego elementu jako najwiekszy
Looop:                
                inc     si                      ;increment si
                cmp     si,cx                   ;sprawdza czy warunek konca jest spelniony
                jnb     Koniec                  ;jezeli si nie jest mniejsze niz cx to skok do konca programu
                cmp     bh,[si]                 ;porownanie elementu iterowanego do zapisanego najwiekszego
                jna     Zmien                   ;jezeli bh nie jest wieksze niz kolejny element tablicy to zmien
                jmp     Looop                   ;inaczej kontuujemy petle

Zmien:          mov     bh,[si]                 ;zmiana zapisanego najwiekszego
                jmp     Looop                   ;powrot do petli

Koniec: 
                mov     Najwieksza,bh           ;zapis wyniku
                mov     ax, 4C00h               ;4C mowi systemowi ze konczy dzialanie programu i zwraca wartosc ah jako kod bledu 00 w tym przypadku
                int     21h                     ;przerwanie systemowe konczace program

;Stosik             SEGMENT    STACK            
;                DB      100h DUP ()
;Stosik          ENDS


Kod             ENDS                            ;koniec segmentu kodu
END             start