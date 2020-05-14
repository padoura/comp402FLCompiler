#!/bin/bash

diffResult=$(diff results/golden.txt results/results.txt)

if [ -z $diffResult ]; then
    echo "no diff"
else
    echo -e "diff found:\n--------------------"
    colordiff results/golden.txt results/results.txt
    echo "--------------------"
    echo "Replace golden? [y/(n)]"
    read isGolden
    isGolden=${isGolden:-n}

    if [ "$isGolden" == "y" ]; then
        mv results/results.txt results/golden.txt
        echo "Golden replaced"
    else
        echo "Golden not replaced"
    fi
fi

