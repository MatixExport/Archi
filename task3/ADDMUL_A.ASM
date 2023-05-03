			   .MODEL 	SMALL, C
				PUBLIC 	srednia 
	            PUBLIC 	add_mul_float
               
               .CODE
               
srednia: 	push 	bp
				mov  	bp, sp
				mov  	ax, [bp + 4]        ;rozmiar
				mov     si,ax
                mov  	ax, [bp + 6]        ;pointer na tablice
                mov     bp,ax
                mov     ax,si
                
                fld     DWORD PTR [bp]
                dec     si
looop:                                      ;teoretycznie powinno czytać wszystkie liczby z tablicy float i oddać ich sumę ale nie działa
                cmp     si,0
                je      end    

                sub     ax,si
                mov     bx,4h
                mul     bx

                add     ax,bp
                mov     bp,ax

                fld     DWORD PTR [bp]
                fadd

                dec     si
                jmp     looop                
				
end:
                
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
