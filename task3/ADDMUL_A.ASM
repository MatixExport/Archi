			   .MODEL 	SMALL, C
				PUBLIC 	srednia 
	            PUBLIC 	add_mul_float
               
               .CODE
               
srednia: 	push 	bp
				mov  	bp, sp
				mov  	ax, [bp + 4]        ;rozmiar
				mov     si,ax
                mov  	ax, [bp + 6]        ;wskaznik na tablice
                mov     bp,ax               ;przypisanie wskaznika na tablic
                
                fld     DWORD PTR [bp]      ;pierwszy element z tablicy
                dec     si
looop:                                      
                cmp     si,0                ;warunek konca tablicy
                je      end    

                add     bp,4h               ;wskaznik na kolejny element tablicy

                fld     DWORD PTR [bp]      ;pobieranie kolejnego elementu tablicy
                fadd                        ;dodawanie

                dec     si                  
                jmp     looop                
				
end:
                mov  	bp, sp
				mov  	ax, [bp + 4]        ;rozmiar

                ;fld/ax
                
                ;dzielenie
				pop  	bp
				ret





add_mul_float: 	push 	bp
                mov  	bp, sp
                fld     DWORD PTR [bp + 4]
                fld     DWORD PTR [bp + 8]
                fadd
                fld     DWORD PTR [bp + 12]
                fmul
                pop  	bp
				ret

                END
