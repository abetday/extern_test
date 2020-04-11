.PHONY: all clean

# name     : 动态库的名字
# major    : 主版本号
# minor    : 子版本号
# revision : 修正版本号
libA_name  = moduleA
libA_major = 1
libA_minor = 1
libA_revision = 0

LIBA_LINK_NAME = lib$(libA_name).so
LIBA_SO_NAME	  = lib$(libA_name).so.$(libA_major).$(libA_minor)
LIBA_REAL_NAME = lib$(libA_name).so.$(libA_major).$(libA_minor).$(libA_revision)

libaname:
	@echo "libmoduleA.so:"
	@echo "	linkname: $(LIBA_LINK_NAME)"
	@echo "	soname	: $(LIBA_SO_NAME)"
	@echo "	realname: $(LIBA_REAL_NAME)"

run:
	$(info ### Running...)
# 运行前加'@', 运行"a.out"但不显示命令"./bin/a.out"
	@./bin/a.out

all: moduleA mycp version
	$(info ### make all)
	sudo ldconfig
	sudo ln -s ${PWD}/lib/$(LIBA_REAL_NAME) ${PWD}/lib/$(LIBA_LINK_NAME)
	gcc ./src/moduleB.cpp -l$(libA_name) -lstdc++ -I./inc -L./lib -o ./bin/a.out

moduleA: outputdir libaname
	$(info ### make libmouduleA)
	gcc -fPIC -shared ./src/moduleA.c -I./inc -o ./lib/$(LIBA_REAL_NAME) -Wl,-soname,$(LIBA_SO_NAME)

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


