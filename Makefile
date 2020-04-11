.PHONY: all clean

# name	   : 动态库的名字
# major	   : 主版本号
# minor	   : 子版本号
# revision : 修正版本号
name  = moduleA
major = 1
minor = 1
revision = 0

LIB_LINK_NAME = lib$(name).so
LIB_SO_NAME	  = lib$(name).so.$(major).$(minor)
LIB_REAL_NAME = lib$(name).so.$(major).$(minor).$(revision)

libname:
	@echo "libmoduleA.so:"
	@echo "	linkname: $(LIB_LINK_NAME)"
	@echo "	soname	: $(LIB_SO_NAME)"
	@echo "	realname: $(LIB_REAL_NAME)"

run:
	$(info ### Running...)
# 运行前加'@', 运行"a.out"但不显示命令"./bin/a.out"
	@./bin/a.out

all: moduleA mycp version
	$(info ### make all)
	sudo ldconfig
	sudo ln -s ${PWD}/lib/$(LIB_REAL_NAME) ${PWD}/lib/$(LIB_LINK_NAME)
	gcc ./src/moduleB.cpp -lmoduleA -lstdc++ -I./inc -L./lib -o ./bin/a.out

moduleA: outputdir libname
	$(info ### make libmouduleA)
	gcc -fPIC -shared ./src/moduleA.c -I./inc -o ./lib/$(LIB_REAL_NAME) -Wl,-soname,$(LIB_SO_NAME)

# add app mycp
mycp: 
	$(info ### make mycp)
	gcc ./src/mycp.c -o ./bin/mycp

outputdir:
	$(info ### create ./lib ./bin)
	mkdir -p ./lib ./bin

version:
	$(info ### generate ./inc/version.h)
	@echo "const char *version = \"`git rev-parse HEAD`\";" > ${PWD}/inc/version.h
	@echo "const char *branch  = \"`git symbolic-ref --short -q HEAD`\";" >> ${PWD}/inc/version.h

clean:
	$(info ### make clean...)
	rm -rf ./a.out ./*.so ./lib/ ./bin/

# makefile:
# -I : Specify the path of header files
# -L : Specify the path of source files
# -o : Specify the path of output file
# -stdc++ : It's neccessary for compiling C++ file or so
# -fPIC : 是生成的lib是相对地址的(或者说是地址无关的)
# -Wl,-soname,$(soname) : Specify "libmoduleA.so.1.1" as [so name]

#libname:
#	real name : libmoduleA.so.1.1.1
#	so name : libmoduleA.so.1.1
#	link name : libmoduleA.so #在Makefile里面创建软链接要使用绝对路径


# Note:
# This version we get a excutable file: ./bin/a.out
# But we want to run it, we need do something more to Specify the path of "libmoduleA.so"
# 	(1) sudo vi /etc/ld.so.conf.d/hhs_test.conf
# 		[hhs]
#		/home/anymous/Practice/extern_test/lib
# 	(2) sudo ldconfig
#  	(2) ./bin/a.out


