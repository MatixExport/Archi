#include <iostream.h>
#include <conio.h>
#include <stdlib.h>

extern "C" float   srednia   (int   rozmiar, float *  tablica);
extern "C" float add_mul_float (float a, float b, float c);

void main()
{
 clrscr();
 float *b = (float *)calloc(4,sizeof(float));
 b[0] = 30.5f;
 b[1] = 20.2f;
 b[2] = 10.0f;
 b[3] = 5.0f;

  cout << "Funkcja assemblerowa srednia       zwrocila wartosc " << srednia   (4,b) << endl;
 cout << "Funkcja assemblerowa add_mul_float zwrocila wartosc " << add_mul_float (1, 2, 3.5) << endl;
 getch();
}
