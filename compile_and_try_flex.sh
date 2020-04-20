#!/bin/bash
flex -o mylexer.yy.c mylexer.l
gcc -o mylexer mylexer.yy.c -lfl
printf "\n"
echo "*********************************************************"
echo "Hello World Example"
echo "*********************************************************"
printf "\n"
./mylexer < hello_world.ms
printf "\n"
echo "*********************************************************"
echo "Hello World Wrong String Example"
echo "*********************************************************"
printf "\n"
./mylexer < hello_world_wrong_string.ms
printf "\n"
echo "*********************************************************"
echo "Useless Example"
echo "*********************************************************"
printf "\n"
./mylexer < useless.ms
printf "\n"
echo "*********************************************************"
echo "Prime Numbers Example"
echo "*********************************************************"
printf "\n"
./mylexer < prime.ms
printf "\n"
echo "*********************************************************"
echo "Hello World Nested Comments"
echo "*********************************************************"
printf "\n"
./mylexer < hello_world_nested_comments.ms
