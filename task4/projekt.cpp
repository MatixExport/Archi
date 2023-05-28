//======================================================================================//
//                                                                            			//
// Plik           : Archi4                                    							//
// Format         : EXE                                                        			//
// Cwiczenie      : Tryb graficzny                                          			//
// Autorzy        : Gabriela Szkiłondź, Paulina Papiernik, gr 3, poniedzialek, 14:15	//
// Data zaliczenia: DD.MM.ROK						   									//
//                                                                             			//
//======================================================================================//

#include <dos.h>
#include <iostream.h>
#include <stdio.h>
#include <conio. h>

	typedef unsigned char BYTE;
	typedef unsigned int WORD;
	typedef unsigned int UINT;
	typedef unsigned long DWORD;
	typedef unsigned long LONG; 
 
	struct BITMAPFILEHEADER
	{
		UINT bfType; //Opis formatu pliku. Musi być ‘BM’.
		DWORD bfSize; //Rozmiar pliku BMP w bajtach.
		UINT bfReserved1; //Zarezerwowane. Musi być równe 0.
		UINT bfReserved2; //Zarezerwowane. Musi być równe 0.
		DWORD bfOffBits; //Przesunięcie w bajtach początku danych
	}; 
	
	struct BITMAPINFOHEADER
	 {
		 DWORD biSize; //Rozmiar struktury BITMAPINFOHEADER.
		 LONG biWidth; //Szerokość bitmapy w pikselach.
		 LONG biHeight; //Wysokość bitmapy w pikselach.
		 WORD biPlanes; //Ilość płaszczyzn. Musi być 1.
		 WORD biBitCount; //Głębia kolorów w bitach na piksel.
		 DWORD biCompression; //Rodzaj kompresji (0 – brak).
		 DWORD biSizeImage; //Rozmiar obrazu w bajtach. Uwaga może być 0.
		 LONG biXPelsPerMeter;//Rozdzielczość pozioma w pikselach na metr.
		 LONG biYPelsPerMeter;//Rozdzielczość pionowa w pikselach na metr.
		 DWORD biClrUsed; //Ilość używanych kolorów z palety.
		 DWORD biClrImportant; //Ilość kolorów z palety niezbędnych do
	 }; //wyświetlenia obrazu. 

 struct RGBQUAD 
 { 
 BYTE rgbBlue; 
 BYTE rgbGreen; 
 BYTE rgbRed; 
 BYTE rgbReserved; 
 }; 

	

    

	unsigned char far* video_memory = (BYTE *)0xA0000000L;			//Ogolnie to musi byc far, far away, ale kto by sie tym przejmowal...
																	//Patrz: Dalekie wskazniki
	
	//Uczcie i czerpcie z tego wszyscy...
	int main(){


        //here tryb graficzny:
		REGPACK regs;					
		regs.r_ax = 0x13;
		intr(0x10, &regs);


		//here czytanie danych o pliku:
		FILE * file = fopen("IMAGES/BABOON.bmp", "rb");
		
        BITMAPFILEHEADER BM_fileHeader; //nagłówek nr 1 bitmapy
	    BITMAPINFOHEADER BM_infoHeader; //nagłówek nr 2 bitmapy

		fread(&BM_fileHeader, sizeof(BITMAPFILEHEADER), 1, file);
		fread(&BM_infoHeader, sizeof(BITMAPINFOHEADER), 1, file); 
		

        //here ustawianie kolorków na czarno białe:
		outportb(0x03C8, 0); 				//rozpocznij ustawianie palety od koloru nr 0
		for (int i = 0; i < 256; i++) 		//ilość kolorów w palecie 8-bitowej
		{
            
			 outp(0x03C9,   i * 63 / 255); 	//skalowana składowa R
			 outp(0x03C9,   i * 63 / 255); 	//skalowana składowa G
			 outp(0x03C9,   i * 63 / 255); 	//skalowana składowa B
		}

       
        //here wyswietlanie obrazu:
		fseek(file,BM_fileHeader.bfOffBits,SEEK_SET);  				// Od poczatku pliku przesuwa o ten offset dzieki czemu jesteśmy w miejscu gdzie zaczynaja sie konkretne piksele obrazu
		
		for(int k=199; k>=0; k--){											//Wczytywanie jest "od dolu", stad dekrementacja 
			for(int j=0; j<320; j++){
				 video_memory[320*k + j] = fgetc(file); 		//Ogolnie to dzialamy na calym obrazku jako na jednowymiarowej tablicy...
			}																//Kazda linijka jest wczytywana co 320 znak
		}																	//Stad to kazdego pojedynczego piksela zaczytujemy piksel obrazka
		fclose(file);

getch();



//here zaczynaja sie robic kolorki bo mi sie nudziło

		file = fopen("IMAGES/BABOON.bmp", "rb");
		
		fread(&BM_fileHeader, sizeof(BITMAPFILEHEADER), 1, file);
		fread(&BM_infoHeader, sizeof(BITMAPINFOHEADER), 1, file); 

        RGBQUAD paleta; //nagłówek nr 2 bitmapy

        
		
		outportb(0x03C8, 0); 				//rozpocznij ustawianie palety od koloru nr 0
		for (k = 0; k < 256; k++) 		//ilość kolorów w palecie 8-bitowej
		{
            fread(&paleta, sizeof(RGBQUAD),1,file);
			outp(0x03C9,   (int)paleta.rgbRed * 63 / 255); 	//skalowana składowa R
			outp(0x03C9,   (int)paleta.rgbGreen * 63 / 255); 	//skalowana składowa G
			outp(0x03C9,   (int)paleta.rgbBlue * 63 / 255); 	//skalowana składowa B
		}

fclose(file);
//here koniec kolorkow


getch();

return 0;
	}//int main