// File: factorial.ms

function start(): void {
    var n, i, fact: number;
    writeString("Enter an integer: ");
    n = readNumber();

    if (n < 0)
        writeString("Error! Factorial of a negative number does not exist.");
    else {
        for (i = 1; i <= n; i=i+1) {
            fact = fact*i;
        };
        writeString("Factorial of ");
        writeNumber(n);
        writeString(" is ");
        writeNumber(fact);
    };
    writeString("\n");
    return;
}