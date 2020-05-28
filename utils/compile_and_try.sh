#!/bin/bash
utils/build_compiler.sh
printf "\n"
echo "*********************************************************"
echo "Hello World Example"
echo "*********************************************************"
printf "\n"
./mycomp < examples/complete_examples//hello_world.ms
printf "\n"
echo "*********************************************************"
echo "Hello World Wrong String Example"
echo "*********************************************************"
printf "\n"
./mycomp < examples/complete_examples//hello_world_wrong_string.ms
printf "\n"
echo "*********************************************************"
echo "Useless Example"
echo "*********************************************************"
printf "\n"
./mycomp < examples/complete_examples//useless.ms
printf "\n"
echo "*********************************************************"
echo "Prime Numbers Example"
echo "*********************************************************"
printf "\n"
./mycomp < examples/complete_examples//prime.ms
printf "\n"
echo "*********************************************************"
echo "Hello World Nested Comments"
echo "*********************************************************"
printf "\n"
./mycomp < examples/complete_examples//hello_world_nested_comments.ms
printf "\n"
echo "*********************************************************"
echo "Hello World Unescaped Backslash"
echo "*********************************************************"
printf "\n"
./mycomp < examples/complete_examples/hello_world_unescaped_backslash.ms
printf "\n"
echo "*********************************************************"
echo "Empty Start"
echo "*********************************************************"
printf "\n"
./mycomp < examples/declarations/start/empty_body.ms
printf "\n"
echo "*********************************************************"
echo "Constant Declaration: Scalars"
echo "*********************************************************"
printf "\n"
./mycomp < examples/declarations/constants/scalars.ms
printf "\n"
echo "*********************************************************"
echo "Variable Declaration: Scalars"
echo "*********************************************************"
printf "\n"
./mycomp < examples/declarations/variables/scalars.ms
printf "\n"
echo "*********************************************************"
echo "Constant Declaration: Arrays"
echo "*********************************************************"
printf "\n"
./mycomp < examples/declarations/variables/arrays.ms
printf "\n"
echo "*********************************************************"
echo "Function Declaration: Empty Functions"
echo "*********************************************************"
printf "\n"
./mycomp < examples/declarations/functions/empty_functions.ms