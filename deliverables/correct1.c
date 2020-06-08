#include "mslib.h"
#include <math.h>


double a;
double b;
int aLessThanB;
int aLessEqualB;
int aEqualB;
int aNotEqualB;

void main() {
	a = readNumber();
	b = readNumber();
	aLessThanB = (a<b);
	if((!(1) || (1 && aLessThanB)))
		writeString("aLessThanB is true.\n");
	else {
	writeString("aLessThanB is false.\n");
	}
	aLessEqualB = (a<=b);
	if(((1 && aLessEqualB) || !(1)))
		writeString("aLessEqualB is true.\n");
	else {
	writeString("aLessEqualB is false.\n");
	}
	aEqualB = (a==b);
	if(((1 && aEqualB) || !(1)))
		writeString("aEqualB is true.\n");
	else {
	writeString("aEqualB is false.\n");
	}
	aNotEqualB = (1 && (a!=b));
	if(((1 && aNotEqualB) || !(1)))
		writeString("aNotEqualB is true.\n");
	else {
	writeString("aNotEqualB is false.\n");
	}
	writeString("\n");
}
