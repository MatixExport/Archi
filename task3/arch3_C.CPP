#include <iostream.h>           //cin cout
#include <conio.h>              //clrscr i getch
#include <stdlib.h>             //calloc

extern "C" float   srednia   (int   rozmiar, float *  tablica);
extern "C" int  countAsciiOccurrence(char ascii, char str[]);
void main()
{
    int tryb;
    int rozmiar;
    float * tab;
    char searchedAscii;
    char charTab[255] = "";
   
    while (1){
        clrscr();

        cout<<"Wybierz:\n\
        0 zeby liczyc srednia tablicy\n\
        1 zeby zliczac wystapienia liter w tablicy znakow: ";
        cin>>tryb;
        clrscr();
        if(tryb == 0){
            cout<<"Podaj rozmiar tablicy liczb rzeczywistych: ";
            cin>>rozmiar;
            
            tab = (float *)calloc(rozmiar,sizeof(float));

            for(int i = 0; i<rozmiar; i++){
                cout<<"Podaj kolejny element tablicy: ";
                cin>>tab[i];
            }


            cout << "Funkcja assemblerowa srednia zwrocila wartosc " << srednia(rozmiar,tab) << endl;
        }
        else if (tryb==1){
            cout<<"Wprowadz lanuch znakow: ";
            cin.ignore();
            cin.getline(charTab,254);
            cout << "\n podaj szukany znak: ";
            //scanf("%c", searchedAscii);
            cin >> searchedAscii;
            cout << "Ilosc wystapien danego znaku: " << countAsciiOccurrence(searchedAscii,charTab) << "\n";
        }
        else{
            return;
        }
         getch();
    }
    
    

}
