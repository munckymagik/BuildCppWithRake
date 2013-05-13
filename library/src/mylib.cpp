#include <iostream>
#include "mylib.h"

namespace MyLib {

void HelloSayer::say_hello(const std::string & addressee)
{
	std::cout << "Hello " << addressee << "!" << std::endl;

}


};
