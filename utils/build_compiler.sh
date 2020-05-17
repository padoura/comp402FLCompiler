#!/bin/bash
bison -d -v -r all myparser.y
flex mylexer.l
gcc -o mycomp myparser.tab.c lex.yy.c cgen.c -lfl