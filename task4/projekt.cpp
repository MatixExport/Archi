#include <dos.h>            //intr, regpack
#include <iostream.h>       //input/output
#include <conio.h>          //pliki
#include <stdio.h>          //getch, clrscr

typedef unsigned char BYTE;
typedef unsigned int WORD;
typedef unsigned int UINT;
typedef unsigned long DWORD;
typedef unsigned long LONG; 

struct BITMAPFILEHEADER{
    UINT bfType; //Opis formatu pliku. Musi być ‘BM’.
    DWORD bfSize; //Rozmiar pliku BMP w bajtach.
    UINT bfReserved1; //Zarezerwowane. Musi być równe 0.
    UINT bfReserved2; //Zarezerwowane. Musi być równe 0.
    DWORD bfOffBits; //Przesunięcie w bajtach początku danych
}; 
	
struct BITMAPINFOHEADER{
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
    DWORD biClrImportant; //Ilość kolorów z palety niezbędnych do wyświetlenia obrazu. 
}; 

struct RGBQUAD { 
    BYTE rgbBlue; 
    BYTE rgbGreen; 
    BYTE rgbRed; 
    BYTE rgbReserved; 
};



int trybCzarnoBialy = 0;          //bool 1-sa kolory 0-nie ma

char fileName[10][20]={"IMAGES/AREA.bmp","IMAGES/BABOON.bmp","IMAGES/LENA.bmp","IMAGES/PEPPERS.bmp","IMAGES/PLANE.bmp","IMAGES/TANK.bmp","IMAGES/areo.BMP","IMAGES/boat.BMP","IMAGES/lenaczby.BMP","IMAGES/bridge.BMP"};
int fileNumber;
BITMAPFILEHEADER BM_fileHeader;
BITMAPINFOHEADER BM_infoHeader;	
RGBQUAD paleta[256] ; 
unsigned char far* video_memory = (BYTE *)0xA0000000L;			//nie wiem dlaczego to far ale inaczej jest null pointer

void ustawPaleteKolorow(){            //bool nie istnieje
    outportb(0x03C8, 0); 				//rozpocznij ustawianie palety od koloru nr 0
    for (int i = 0; i < 256; i++) 		    //ilość kolorów w palecie 8-bitowej
    {
        outp(0x03C9, (trybCzarnoBialy ? i:(int)paleta[i].rgbRed)   * 63 / 255); 	//skalowana składowa R
        outp(0x03C9, (trybCzarnoBialy ? i:(int)paleta[i].rgbGreen) * 63 / 255); 	//skalowana składowa G
        outp(0x03C9, (trybCzarnoBialy ? i:(int)paleta[i].rgbBlue)  * 63 / 255); 	//skalowana składowa B
    }
    
}

void trybTekstowy(){
    REGPACK regs;					
    regs.r_ax = 0x10;
    intr(0x10, &regs);              //int 16  z rejestrami ze struktury regs
}	
void trybGraficzny(){
    REGPACK regs;					
    regs.r_ax = 0x13;
    intr(0x10, &regs);
	ustawPaleteKolorow();
}



void clrscr(){              //nadpisanie tej funkcji bo standardowa zostawia szary ekran a nie czarny
    trybGraficzny();
        for(int i=199; i>=0; i--){											
        for(int j=0; j<320; j++){
            video_memory[320*i + j] = 0;		
        }																
    }	
    trybTekstowy();
}

void wyswietl(){
    FILE * file = fopen(fileName[fileNumber], "rb");
    trybGraficzny();

    fread(&BM_fileHeader, sizeof(BITMAPFILEHEADER), 1, file);
    fread(&BM_infoHeader, sizeof(BITMAPINFOHEADER), 1, file); 

    fread(&paleta, sizeof(RGBQUAD),256,file);
    
  //  fseek(file,BM_fileHeader.bfOffBits,SEEK_SET);  				// Od poczatku pliku przesuwa o ten offset dzieki czemu jesteśmy w miejscu gdzie zaczynaja sie konkretne piksele obrazu
            //powyższa linia pomija palete kolorów ale że my używamy kolorków to można ją usunąć

    for(int i=199; i>=0; i--){											//obraz jest od tyłu
        for(int j=0; j<320; j++){
            video_memory[320*i + j] = fgetc(file); 		
        }																
    }
    ustawPaleteKolorow();
    fclose(file);
    getch();
    trybTekstowy();	
}

void wybierzPlik(){
    clrscr();
    cout<<"Wybierz:\n\
    0.AREA\n\
    1.BABOON\n\
    2.LENA\n\
    3.PEPPERS\n\
    4.PLANE\n\
    5.TANK\n\
    6.areo\n\
    7.boat\n\
    8.lenaczby\n\
    9.bridge";
    cin>>fileNumber;
}

void progowanie(){
    cout<<"podaj prog: ";
    int prog;
    cin>>prog;
    clrscr();
    trybGraficzny();
    FILE * file = fopen(fileName[fileNumber], "rb");
    fread(&BM_fileHeader, sizeof(BITMAPFILEHEADER), 1, file);
    fread(&BM_infoHeader, sizeof(BITMAPINFOHEADER), 1, file); 

    fread(&paleta, sizeof(RGBQUAD),256,file);

    int wartosc;
    for(int i=199; i>=0; i--){											//obraz jest od tyłu
        for(int j=0; j<320; j++){
            int x = (int)fgetc(file);
            if((x>=prog)||(!trybCzarnoBialy)){
                video_memory[320*i + j] = x;
            }
            else{
                video_memory[320*i + j] = 0;
            }
        }																
    }
    if(!trybCzarnoBialy){
        for(i = 0; i<prog;i++ ){
            outp(0x03C9,0); 	//skalowana składowa R
			outp(0x03C9,0); 	//skalowana składowa G
			outp(0x03C9,0); 	//skalowana składowa B
        }
         for (i = prog; i < 256; i++) 		    //ilość kolorów w palecie 8-bitowej
		{                               
			outp(0x03C9, (int)paleta[i].rgbRed   * 63 / 255); 	//skalowana składowa R
			outp(0x03C9, (int)paleta[i].rgbGreen * 63 / 255); 	//skalowana składowa G
			outp(0x03C9, (int)paleta[i].rgbBlue  * 63 / 255); 	//skalowana składowa B
		}
    }	
    //ustawPaleteKolorow();
    fclose(file);
    getch();
    trybTekstowy();
}
void negatyw(){
    clrscr();
    trybGraficzny();
    FILE * file = fopen(fileName[fileNumber], "rb");
    fread(&BM_fileHeader, sizeof(BITMAPFILEHEADER), 1, file);
    fread(&BM_infoHeader, sizeof(BITMAPINFOHEADER), 1, file); 

    fread(&paleta, sizeof(RGBQUAD),256,file);

    int wartosc;
    for(int i=199; i>=0; i--){											//obraz jest od tyłu
        for(int j=0; j<320; j++){
             video_memory[320*i + j] = (!trybCzarnoBialy ? fgetc(file) : ~fgetc(file)); 	
        }																
    }	
    ///negowanie plety kolorow//
    outportb(0x03C8, 0); 
					//rozpocznij ustawianie palety od koloru nr 0
	if(!trybCzarnoBialy){
		for (i = 0; i < 256; i++) 		    //ilość kolorów w palecie 8-bitowej
		{                               
			outp(0x03C9, ~((int)paleta[i].rgbRed)   * 63 / 255); 	//skalowana składowa R
			outp(0x03C9, ~((int)paleta[i].rgbGreen) * 63 / 255); 	//skalowana składowa G
			outp(0x03C9, ~((int)paleta[i].rgbBlue)  * 63 / 255); 	//skalowana składowa B
		}
	}
    
    fclose(file);
    getch();
    trybTekstowy();
}

int main(){
    int opcja = 1;
    while(opcja != 7){
        clrscr();
        cout<<"Wybierz:\n\
        1.Negatyw\n\
        2.Progowanie\n\
        3.Wyswietl\n\
        4.Kolor\n\
        5.Czarno biale\n\
        6.Zmien plik\n\
        7.Zakoncz\n";
        cin>>opcja;
        switch(opcja){
            case 1:
                negatyw();
            break;
            case 2:
                progowanie();
            break;
            case 3:
                wyswietl();
            break;
            case 4:
                trybCzarnoBialy = 0;
            break;
            case 5:
                trybCzarnoBialy = 1;
            break;
            case 6:
                wybierzPlik();
            break;
			default:
				opcja = 7;
			break;

        }
    }
return 0;
}