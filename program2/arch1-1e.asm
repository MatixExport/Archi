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

DL_TABLICA      EQU     12

Tablica         DB      08h, 02h, 00h, 10h, 12h, 50h
                DB      15h, 09h, 11h, 08h, 0Ah, 08h
 Najwieksza      DB      ?
Dane            ENDS        ;Koniec Segmentu Danych


;Segment Kodu
Kod             SEGMENT

                ASSUME  CS:Kod, DS:Dane, SS:Stosik

Start:          mov     ax, SEG Dane            ;ładowanie segmentu danych
                mov     ds, ax                  ;ustawienie wskaznika ds na segment danych
                mov     si,OFFSET TABLICA       ;si zaczyna sie tam gdie tablica
                
                mov     cx,DL_TABLICA           ;zapisanie dlugosci tablicy
                mov     bh,[si]                 ;przypisanie pierwszego elementu jako najwiekszy
Looop:                
                inc     si                      ;increment c
                cmp     si,cx                   ;sprawdza czy warunek konca jest spelniony
                jnb     Koniec                  ;skok do konca programu
                cmp     bh,[si]                 ;porownanie elementu iterowanego do zapisanego najwiekszego
                jna     Zmien                   ;jezeli wieksyzy to zmieniamy
                jmp     Looop                   ;inaczej kontuujemy petle

Zmien:          mov     bh,[si]                 ;zmiana zapisanego najwiekszego
                jmp     Looop                   ;powrot do petli

Skok:   

Koniec: 
                mov     Najwieksza,bh           ;zapis wyniku
                mov     ax, 4C10h               ;?
                int     21h                     ;? 

Kod         ENDS                                ;koniec segmentu kodu

; Segement stosu
Stosik             SEGMENT    STACK             ;VVVpo co? nie wiemVVV
                DB      100h DUP ()
Stosik          ENDS


                ; ENDP    Dane
                END     start

