.PHONY: all clean

run: all
	./bin/a.out

all: moduleA
	sudo ldconfig
	sudo ln -s /home/anymous/Practice/extern_test/lib/libmoduleA.so.1.10 /home/anymous/Practice/extern_test/lib/libmoduleA.so
	gcc ./src/moduleB.cpp ./lib/libmoduleA.so -lstdc++ -I./inc -L./lib -o ./bin/a.out

moduleA: outputdir
	gcc -fPIC -shared ./src/moduleA.c -I./inc -o ./lib/libmoduleA.so.1.10 -Wl,-soname,libmoduleA.so.1

outputdir:
	mkdir -p ./lib ./bin

clean:
	rm -rf ./a.out ./*.so ./lib/ ./bin/

# makefile:
# -I : Specify the path of header files
# -L : Specify the path of source files
# -o : Specify the path of output file
# -stdc++ : It's neccessary for compiling C++ file or so
# -fPIC : 是生成的lib是相对地址的(或者说是地址无关的)
# -Wl,-soname,$(soname) : Specify "libmoduleA.so.1" as [so name]

#libname:
#	real name : libmoduleA.so.1.10
#	so name : libmoduleA.so.1
#	link name : libmoduleA.so #在Makefile里面创建软链接要使用绝对路径


# Note:
# This version we get a excutable file: ./bin/a.out
# But we want to run it, we need do something more to Specify the path of "libmoduleA.so"
# 	(1) sudo vi /etc/ld.so.conf.d/hhs_test.conf
# 		[hhs]
#		/home/anymous/Practice/extern_test/lib
# 	(2) sudo ldconfig
#  	(2) ./bin/a.out


