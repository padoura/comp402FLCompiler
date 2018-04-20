#!/bin/bash
flex -o mylexer.yy.c mylexer.l
gcc -o mylexer mylexer.yy.c -lfl
echo "*********************************************************"
echo "Hello World Example"
echo "*********************************************************"
./mylexer < hello_world.fl
echo "*********************************************************"
echo "Useless Example"
echo "*********************************************************"
./mylexer < useless_example.fl
