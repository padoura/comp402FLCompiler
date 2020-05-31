// File: calculator.ms

function start(): void {
    var first, second, operator: number;
    writeString("Enter a digit for operator (1:addition, 2:substraction, 3:multiplication, 4: division): ");
    operator = readNumber();
    writeString("Enter first operand: ");
    first = readNumber();
    writeString("Enter second operand: ");
    second = readNumber();

    if (operator == 1){
        writeNumber(first + second);
    };
    else if (operator == 2){
        writeNumber(first - second);
    };
    else if (operator == 3)
        writeNumber(first * second);
    else if (operator == 4){
        writeNumber(first / second);
    };
    else
        writeString("Error! operator is not correct");
}