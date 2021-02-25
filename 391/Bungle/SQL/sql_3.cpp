using namespace std;
#include <stdio.h>
#include <string.h>
#include <iostream>
#include "md5.h"

using std::string; using std::cout; using std::endl; using std::stoi; using std::to_string;

string s = "1358000000";
string find(int m) {
	while(true) {
		s = to_string(1+std::stoi(s));
		string h = md5(s); // md5 function modified by me, starting at md5.cpp line 348
		if(stoi(s) % 1000000 == 0) {
			cout << s << endl;
		}
		if(h=="1")
			return s;
	}
	return "";
}

int main(int argc, char *argv[]) {
	string str = find(0);
    	cout << "Output: " + str << endl;
	return 0;
}
