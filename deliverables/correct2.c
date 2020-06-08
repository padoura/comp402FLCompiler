#include "mslib.h"
#include <math.h>


void main() {
	double first;
double second;
double operator;
	writeString("Enter a digit for operator (1:addition, 2:substraction, 3:multiplication, 4: division):\n");
	operator = readNumber();
	writeString("Enter first operand:\n");
	first = readNumber();
	writeString("Enter second operand:\n");
	second = readNumber();
	writeString("Result: ");
	if((operator==1))
		{
	writeNumber(first+second);
	}
	else if((operator==2))
		{
	writeNumber(first-second);
	}
	else if((operator==3))
		writeNumber(first*second);
	else if((operator==4))
		{
	writeNumber(first/second);
	}
	else writeString("Error! Invalid input.");
	writeString("\n");
}
