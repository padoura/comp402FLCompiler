build:
	utils/build_compiler.sh

test:
	utils/compile_and_try.sh > results/results.txt 2>&1
	utils/run_regression.sh

clean:
	rm -rf myparser.tab.*
	rm -f results/results.txt myparser.output mycomp lex.yy.c