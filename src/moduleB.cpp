#include <iostream>
#include "moduleB.h"
#include "version.h"

int main(int argc, char *argv[])
{
	std::cout<<"Version: "<<version<<std::endl;
	std::cout<<"Branch : "<<branch<<std::endl;
	std::cout<<fun(2,3)<<std::endl;
	return 0;
}
