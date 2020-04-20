./compile_and_try_flex.sh > results.txt

diffResult=$(diff golden.txt results.txt)

if [[ -z $diffResult ]]; then
    echo "no diff"
else
    echo -e "diff found:\n--------------------"
    colordiff golden.txt results.txt
    echo "--------------------"
    echo "Replace golden? [y/n]"
    read isGolden
    isGolden=${isGolden:-n}

    if [ "$isGolden" == "y" ]; then
        mv results.txt golden.txt
        echo "Golden replaced"
    else
        echo "Golden not replaced"
    fi
fi

