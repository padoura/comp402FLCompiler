// Illustrating all logical operators

var a, b: number;
var aLessThanB, aLessEqualB, aEqualB, aNotEqualB: boolean;

function start(): void {
    a = readNumber();
    b = readNumber();
    aLessThanB = a < b;
    if (not true or true and aLessThanB)
        writeString("aLessThanB is true.\n");
    else{
        writeString("aLessThanB is false.\n");
    };
    aLessEqualB = a <= b;
    if (true and aLessEqualB or not true)
        writeString("aLessEqualB is true.\n");
    else{
        writeString("aLessEqualB is false.\n");
    };
    aEqualB = a == b;
    if (true and aEqualB or not true)
        writeString("aEqualB is true.\n");
    else{
        writeString("aEqualB is false.\n");
    };
    aNotEqualB = true and a != b;
    if (true and aNotEqualB or not true)
        writeString("aNotEqualB is true.\n");
    else{
        writeString("aNotEqualB is false.\n");
    };
    writeString("\n");
}