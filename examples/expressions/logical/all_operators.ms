var a, b: number;
var aLessThanB: boolean;

function start(): void {
    a = readNumber();
    b = readNumber();
    aLessThanB = a < b;
    if (not true or true and aLessThanB)
        writeString("aLessThanB is true.");
    else{
        writeString("aLessThanB is false.");
    };
    aLessEqualB = a <= b;
    if (true and aLessEqualB or not true)
        writeString("aLessEqualB is true.");
    else{
        writeString("aLessEqualB is false.");
    };
    aEqualB = a == b;
    if (true and aEqualB or not true)
        writeString("aEqualB is true.");
    else{
        writeString("aEqualB is false.");
    };
    aNotEqualB = true and a != b;
    if (true and aNotEqualB or not true)
        writeString("aNotEqualB is true.");
    else{
        writeString("aNotEqualB is false.");
    };
}