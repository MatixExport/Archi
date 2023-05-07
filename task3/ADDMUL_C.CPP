#include <iostream.h>
#include <conio.h>
#include <stdlib.h>

extern "C" float   srednia   (int   rozmiar, float *  tablica);
extern "C" float add_mul_float (float a, float b, float c);

void main()
{
    int tryb;
    int rozmiar;
    float * tab;
    while (1){
        clrscr();

        cout<<"Wybierz 0 zeby liczyc srednia tablicy lub 1 zeby zliczac wystapienia liter w tablicy: ";
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


            cout << "Funkcja assemblerowa srednia (suma) zwrocila wartosc " << srednia   (rozmiar,tab) << endl;
        }
        else{
            //here ju du jor dżob
            cout << "Funkcja assemblerowa add_mul_float  zwrocila wartosc " << add_mul_float (1, 2, 3.5) << endl;

        }
         getch();
    }
    
    

}
