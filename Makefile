.PHONY: all clean

all: moduleA
	gcc ./src/moduleB.cpp -lstdc++ -I./inc -lmoduleA -L./lib -o ./bin/a.out

moduleA: 
	gcc -fPIC -shared ./src/moduleA.c -I./inc -o ./lib/libmoduleA.so

clean:
	rm -rf ./a.out ./*.so ./lib/* ./bin/*

# makefile:
# -I : Specify the path of header files
# -L : Specify the path of source files
# -o : Specify the path of output file
# -fPIC : 是生成的lib是相对地址的(或者说是地址无关的)

# Note:
# This version we get a excutable file: ./bin/a.out
# But we want to run it, we need do something more to Specify the path of "libmoduleA.so"
# 	(1) sudo vi /etc/ld.so.conf.d/hhs_test.conf
# 		[hhs]
#		/home/anymous/Practice/extern_test/lib
# 	(2) sudo ldconfig
#  	(2) ./bin/a.out


