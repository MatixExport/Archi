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


	FILE *file; //Plik bitmapy
	BITMAPFILEHEADER bmfh; //nagłówek nr 1 bitmapy
	BITMAPINFOHEADER bmih; //nagłówek nr 2 bitmapy
	unsigned char far* video_memory = (BYTE *)0xA0000000L;			//Ogolnie to musi byc far, far away, ale kto by sie tym przejmowal...
																	//Patrz: Dalekie wskazniki
	
	//Uczcie i czerpcie z tego wszyscy...
	int main(){

		REGPACK regs;					
		regs.r_ax = 0x13;
		intr(0x10, &regs);

		clrscr();
		
		outportb(0x03C8, 0); 				//rozpocznij ustawianie palety od koloru nr 0
		for (int i = 0; i < 256; i++) 		//ilość kolorów w palecie 8-bitowej
		{
			 outp(0x03C9, i * 63 / 255); 	//skalowana składowa R
			 outp(0x03C9, i * 63 / 255); 	//skalowana składowa G
			 outp(0x03C9, i * 63 / 255); 	//skalowana składowa B
		}
		
		file = fopen("IMAGES/LENA.bmp", "rb");
		
		fread(&bmfh, sizeof(BITMAPFILEHEADER), 1, file);
		fread(&bmih, sizeof(BITMAPINFOHEADER), 1, file); 
		
		fseek(file,bmfh.bfOffBits,SEEK_SET);  				//Tego to w sumie nie dali w instrukcji, ale to ustawienie kursora na poczatek
		
		for(int k=199; k>=0; k--){											//Wczytywanie jest "od dolu", stad dekrementacja 
			for(int j=0; j<320; j++){
				 video_memory[320*k + j] = fgetc(file); 		//Ogolnie to dzialamy na calym obrazku jako na jednowymiarowej tablicy...
			}																//Kazda linijka jest wczytywana co 320 znak
		}																	//Stad to kazdego pojedynczego piksela zaczytujemy piksel obrazka
			
		fclose(file);
	


getch();

return 0;
	}//int main