using namespace std;
#include <stdio.h>
#include <string.h>
#include <iostream>
#include "hashlib2plus/trunk/src/hashlibpp.h"

int main() {
    hashwrapper *myWrapper = new md5wrapper();
	try
	{
		std::cout << myWrapper->getHashFromString("Hello world") << std::endl;
		std::cout << myWrapper->getHashFromFile("/etc/motd") << std::endl;
	}
	catch(hlException &e)
	{
		//your error handling here
	}
	//printf(brute());
	return 0;
}