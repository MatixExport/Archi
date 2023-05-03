#include <iostream.h>
#include <conio.h>

extern "C" float   srednia   (int   rozmiar, float *  tablica);
extern "C" float add_mul_float (float a, float b, float c);

void main()
{
 clrscr();
 float  b[4] = {30.5f,20.2f,10.0f,5.0f};
 cout << "Funkcja assemblerowa srednia       zwrocila wartosc " << srednia   (4,b) << endl;
 cout << "Funkcja assemblerowa add_mul_float zwrocila wartosc " << add_mul_float (1, 2, 3.5) << endl;
 getch();
}
