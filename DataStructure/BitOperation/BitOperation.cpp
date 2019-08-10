#include <iostream>
#include <cmath>
using namespace std;


int getNumberOf1(int n) {
	int c = 0;
	while (n != 0) {
		c++;
		n = (n - 1) & n;
	}
	return c;
}

double Power(double base, int exponent) {
	int r = 0;
	unsigned int n = abs(exponent);
	while (n != 0) {
		if ((n & 1) == 1) 
			r *= base;
		base *= base;
		n >>= 1;
	}
	return exponent > 0 ? r : 1/r;
}

bool OppositeSigns(int x, int y) {
	return (x ^ y) < 0;
}

bool getSign(int v) {
	int sign;

	sign = -(v < 0); // negative number: -1 else: 0

	sign = -(int)((unsigned int)((int)v) >> (sizeof(int) * CHAR_BIT - 1));

	sign = v >> (sizeof(int) * CHAR_BIT - 1);

	return sign;
}

int getAbsoluteValue(int v) {
	unsigned int r;
	int const mask = v >> (sizeof(int) * CHAR_BIT - 1);
	r = (v + mask) ^ mask;
	// r = (v + mask) - mask; // this also works
	return r;
}

int max(int x, int y) {
	return x ^ ((x ^ y) & -(x < y));
}

// y ^ ((x ^ y) & -(x < y)); // int min(int x, int y)

bool isPowerOf2(int v) {
	return v && !(v & (v - 1));
}

void swap(int& x, int& y) {
	if (x != y) {
		x ^= y;
		y ^= x;
		x ^= y;
	}
}

int main() {
	cout << getSign(1);
	return 0;
}

