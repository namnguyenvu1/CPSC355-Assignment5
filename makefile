# this an example of makefile
default: compile run clean
compile:
	@sleep 0.5
	@echo "_________COMPILATION STEP"
	@sleep 0.5
	gcc -c *.c
	gcc -c *.s
	gcc *.o -o filename.out
run:
	@sleep 0.5
	@echo "_________EXECUTION STEP"
	@sleep 0.5
	./filename.out
clean:
	@sleep 0.5
	@echo "_________CLEAN STEP"
	@sleep 0.5
	# when you use rm: always double check: don't end up deleting your assignment :]
	rm *.o
	rm filename.out

