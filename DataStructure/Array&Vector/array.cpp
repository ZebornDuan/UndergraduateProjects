#include <iostream>
#include <vector>

using namespace std;

int binarySearch(vector<int> array, int target) {
	int l = 0;
	int r = array.size();
	while (l < r) {
		int m = (l + r) / 2;
		if (array[m] >= target) 
			r = m;
		else 
			l = m + 1;
	}
	return r;
}

bool find_ex1(int target, vector<vector<int> > array) {
	int a = array.size() - 1;
	int b = 0;
	while (a >= 0 && b < array[0].size()) {
		if (array[a][b] > target)
			a--;
		else if (array[a][b] < target)
			b++;
		else
			return true;
	}
	return false;
}