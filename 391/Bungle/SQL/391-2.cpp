using namespace std;
#include <stdio.h>
#include <string.h>
#include <iostream>
#include "md5.h"

using std::string; using std::cout; using std::endl;

int n = 7;
string s = "";
int p = 0;
string find(int m) {
	s += ' ';
	for(int i = 0; i < 95; i++) {
		s[m] = ' ' + i;
		string h = md5(s);
		p++;
		if(p == 1000000) {
			cout << s << endl;
			p = 0;
		}
		if(h=="1")
			return s;
		//for(int j = 1; h.size() > 5 && j < h.size()-4; j++) {
			//if(h.at(j) == '\'' && h.at(j+1) == 'o' && h.at(j+2) == 'r' && h.at(j+3) == '\'' && h.at(j+4) == '1') {
				//return s;
			//}
		//}
		if(m < n) {
			string x = find(m+1);
			if(x == "1") {
				return x;
			}
		}
	}
	s.resize(m);
	return "";
}

int main(int argc, char *argv[]) {

	string str = find(0);
    //cout << "Output: " + str << endl;
	return 0;
}
