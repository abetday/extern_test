.PHONY: all clean

all:
	gcc moduleB.cpp -lstdc++ moduleA.c

clean:
	rm -rf ./a.out

