#!/bin/bash
flex -o mylexer.yy.c mylexer.l
gcc -o mylexer mylexer.yy.c -lfl
printf "\n"
echo "*********************************************************"
echo "Hello World Example"
echo "*********************************************************"
printf "\n"
./mylexer < hello_world.fl
printf "\n"
echo "*********************************************************"
echo "Hello World Wrong String Example"
echo "*********************************************************"
printf "\n"
./mylexer < hello_world_wrong_string.fl
printf "\n"
echo "*********************************************************"
echo "Useless Example"
echo "*********************************************************"
printf "\n"
./mylexer < useless_example.fl
