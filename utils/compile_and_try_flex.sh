#!/bin/bash
flex -o mylexer.yy.c mylexer.l
gcc -o mylexer mylexer.yy.c -lfl
printf "\n"
echo "*********************************************************"
echo "Hello World Example"
echo "*********************************************************"
printf "\n"
./mylexer < examples/hello_world.ms
printf "\n"
echo "*********************************************************"
echo "Hello World Wrong String Example"
echo "*********************************************************"
printf "\n"
./mylexer < examples/hello_world_wrong_string.ms
printf "\n"
echo "*********************************************************"
echo "Useless Example"
echo "*********************************************************"
printf "\n"
./mylexer < examples/useless.ms
printf "\n"
echo "*********************************************************"
echo "Prime Numbers Example"
echo "*********************************************************"
printf "\n"
./mylexer < examples/prime.ms
printf "\n"
echo "*********************************************************"
echo "Hello World Nested Comments"
echo "*********************************************************"
printf "\n"
./mylexer < examples/hello_world_nested_comments.ms
printf "\n"
echo "*********************************************************"
echo "Hello World Unescaped Backslash"
echo "*********************************************************"
printf "\n"
./mylexer < examples/hello_world_unescaped_backslash.ms
