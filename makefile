CC = gcc

build_myprintf:
	@echo "Building executable a.out"
	${CC} -no-pie -g main.c main.s -o a.out
	@echo "Executable a.out was built"

run_myprintf:
	./a.out
