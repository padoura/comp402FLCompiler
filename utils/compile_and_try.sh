#!/bin/bash
utils/build_compiler.sh
printf "\n"
echo "*********************************************************"
echo "Hello World Example"
echo "*********************************************************"
./mycomp < examples/complete_examples//hello_world.ms > tmp.c
cat tmp.c
echo "*********************************************************"
gcc -std=c99 -w -o tmp tmp.c -lm
./tmp
printf "\n"
echo "*********************************************************"
echo "Hello World Wrong String Example"
echo "*********************************************************"
./mycomp < examples/complete_examples//hello_world_wrong_string.ms > tmp.c
cat tmp.c
printf "\n"
echo "*********************************************************"
echo "Useless Example"
echo "*********************************************************"
./mycomp < examples/complete_examples//useless.ms > tmp.c
cat tmp.c
echo "*********************************************************"
gcc -std=c99 -w -o tmp tmp.c -lm
./tmp < examples/complete_examples/useless.in
printf "\n"
echo "*********************************************************"
echo "Prime Numbers Example"
echo "*********************************************************"
./mycomp < examples/complete_examples//prime.ms > tmp.c
cat tmp.c
echo "*********************************************************"
gcc -std=c99 -w -o tmp tmp.c -lm
./tmp < examples/complete_examples/prime.in
printf "\n"
echo "*********************************************************"
echo "Hello World Nested Comments"
echo "*********************************************************"
./mycomp < examples/complete_examples//hello_world_nested_comments.ms > tmp.c
cat tmp.c
printf "\n"
echo "*********************************************************"
echo "Hello World Unescaped Backslash"
echo "*********************************************************"
./mycomp < examples/complete_examples/hello_world_unescaped_backslash.ms > tmp.c
cat tmp.c
printf "\n"
echo "*********************************************************"
echo "Empty Start"
echo "*********************************************************"
./mycomp < examples/declarations/start/empty_body.ms > tmp.c
cat tmp.c
echo "*********************************************************"
gcc -std=c99 -w -o tmp tmp.c -lm
./tmp
printf "\n"
echo "*********************************************************"
echo "Constant Declaration: Scalars"
echo "*********************************************************"
./mycomp < examples/declarations/constants/scalars.ms > tmp.c
cat tmp.c
echo "*********************************************************"
gcc -std=c99 -w -o tmp tmp.c -lm
./tmp
printf "\n"
echo "*********************************************************"
echo "Variable Declaration: Scalars"
echo "*********************************************************"
./mycomp < examples/declarations/variables/scalars.ms > tmp.c
cat tmp.c
echo "*********************************************************"
gcc -std=c99 -w -o tmp tmp.c -lm
./tmp
printf "\n"
echo "*********************************************************"
echo "Constant Declaration: Arrays"
echo "*********************************************************"
./mycomp < examples/declarations/variables/arrays.ms > tmp.c
cat tmp.c
echo "*********************************************************"
gcc -std=c99 -w -o tmp tmp.c -lm
./tmp
printf "\n"
echo "*********************************************************"
echo "Function Declaration: Empty Functions"
echo "*********************************************************"
./mycomp < examples/declarations/functions/empty_functions.ms > tmp.c
cat tmp.c
echo "*********************************************************"
gcc -std=c99 -w -o tmp tmp.c -lm
./tmp
printf "\n"
echo "*********************************************************"
echo "Function Declaration: Empty Functions with Input"
echo "*********************************************************"
./mycomp < examples/declarations/functions/empty_functions_with_input.ms > tmp.c
cat tmp.c
echo "*********************************************************"
gcc -std=c99 -w -o tmp tmp.c -lm
./tmp
printf "\n"
echo "*********************************************************"
echo "Expressions: Arithmetic"
echo "*********************************************************"
./mycomp < examples/expressions/arithmetic/function_calls.ms > tmp.c
cat tmp.c
echo "*********************************************************"
gcc -std=c99 -w -o tmp tmp.c -lm
./tmp
printf "\n"
echo "*********************************************************"
echo "Expressions: While with break"
echo "*********************************************************"
./mycomp < examples/expressions/loops/while_if_break.ms > tmp.c
cat tmp.c
echo "*********************************************************"
gcc -std=c99 -w -o tmp tmp.c -lm
./tmp
printf "\n"
echo "*********************************************************"
echo "Expressions: For with continue"
echo "*********************************************************"
./mycomp < examples/expressions/loops/for_if_continue.ms > tmp.c
cat tmp.c
echo "*********************************************************"
gcc -std=c99 -w -o tmp tmp.c -lm
./tmp
printf "\n"
echo "*********************************************************"
echo "Expressions: Logical Operators"
echo "*********************************************************"
./mycomp < examples/expressions/logical/all_operators.ms > tmp.c
cat tmp.c
echo "*********************************************************"
gcc -std=c99 -w -o tmp tmp.c -lm
./tmp < examples/expressions/logical/all_operators.in
printf "\n"
echo "*********************************************************"
echo "Simple Calculator Example"
echo "*********************************************************"
./mycomp < examples/complete_examples/calculator.ms > tmp.c
cat tmp.c
echo "*********************************************************"
gcc -std=c99 -w -o tmp tmp.c -lm
./tmp < examples/complete_examples/calculator.in
printf "\n"
echo "*********************************************************"
echo "Factorial Example"
echo "*********************************************************"
./mycomp < examples/complete_examples/factorial.ms > tmp.c
cat tmp.c
echo "*********************************************************"
gcc -std=c99 -w -o tmp tmp.c -lm
./tmp < examples/complete_examples/factorial.in
rm tmp tmp.c