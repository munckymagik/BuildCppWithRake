#include <iostream>
#include "mylib.h"

namespace mylib {

void HelloSayer::say_hello(const std::string & addressee)
{
	std::cout << "Hello " << addressee << "!" << std::endl;

}

};
