using namespace std;
#include <stdio.h>
#include <string.h>
#include <iostream>
#include "md5.h"

using std::string; using std::cout; using std::endl;

int n = 7;
string s = " ";
int p = 0;
int l = 0;
string find(int m) {
	while(true) {
		l = (int) s[m] - 31;
		int i;
		for(i = 0 + l; i < 95; i++) {
			s[m] = ' ' + i;
			string h = md5(s); // md5 function modified by me, starting at md5.cpp line 348
			p++;
			if(p == 1000000) {
				cout << s << endl;
				p = 0;
			}
			if(h=="1")
				return s;
			if(m < n) {
				m++;
				s += ' ';
				break;
			}
		}
		if(i == 95) {
			//cout << s << endl;
			s.resize(m);
			m--;
			l++;
		}
	}
	return "";
}

int main(int argc, char *argv[]) {
	string str = find(0);
    	cout << "Output: " + str << endl;
	return 0;
}
