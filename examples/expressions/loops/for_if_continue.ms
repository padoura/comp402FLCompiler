function start(): void {
    var counter : number;
    for (counter=0;counter<10;counter=counter+1){
        if (counter == 0)
            continue;
        else
            writeNumber(counter);
            writeString("\n");
    };
}