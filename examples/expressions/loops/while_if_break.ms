function start(): void {
    var counter = 0 : number;
    while (true){
        if (counter == 10)
            break;
        else
            counter = counter + 1;
            writeString("still counting...");
    };
    writeNumber(counter);
    return;
    counter = counter + 1;
}