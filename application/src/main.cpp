#include <iostream>
#include <string>

#include "mylib.h"

int main(int argc, char **argv)
{
	std::cout << "Creating hello sayer" << std::endl;
	MyLib::HelloSayer hello_sayer = MyLib::HelloSayer();

	std::cout << "About to say hello ..." << std::endl;

	std::string addressee = "Mansura";
	hello_sayer.say_hello(addressee);	

	return 0;
}
