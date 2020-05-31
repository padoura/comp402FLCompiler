function result1(): number {
    var alpha, beta : number;
    alpha = 2 +  3 - 4 * (4-5)/7;
    beta = 1 + 2 + 3 - 4*(4-5)/7;
    return ((- alpha + beta) * 2)**2;
}

function result2(alpha : number): number {
    return alpha +-4;
}

function start(): void {
    writeNumber(result2(result1()));
}