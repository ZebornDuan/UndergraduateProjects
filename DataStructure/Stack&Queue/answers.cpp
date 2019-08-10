#include <stack>
#include <deque>
#include <vector>
using namespace std;

//p1
class queueByStack{
private:
	stack<int> *s1;
	stack<int> *s2;

public:
	queueByStack() {
		s1 = new stack<int>();
		s2 = new stack<int>();
	}
	~queueByStack() {
		delete s1;
		delete s2;
	}

	void enqueue(int t) {
		s1->push(t);
	}

	int dequeue() {
		if (s2->empty()) {
			while (!s1->empty()) {
				s2->push(s1->top());
				s1->pop();
			}
		}
		int r = s2->top();
		s2->pop();
		return r;
	}
};

//p2
class stackWithMin {
private:
	stack<int> *s1;
	stack<int> *s2;

public:
	stackWithMin() {
		s1 = new stack<int>();
		s2 = new stack<int>();
	}
	~stackWithMin() {
		delete s1;
		delete s2;
	}

	void push_v1(int t) {
		s1->push(t);
		if (s2->empty())
			s2->push(t);
		else
			if (s2->top() >= t)
				s2->push(t);
	}

	void pop_v1() {
		if (s1->top() == s2->top())
			s2->pop();
		s1->pop();
	}

	void push_v2(int t) {
		s1->push(t);
		if (s2->empty() || s2->top() >= t)
			s2->push(t);
		else 
			s2->push(s2->top());
	}

	void pop_v2() {
		s1->pop();
		s2->pop();
	}

	int top() {return s1->top();}
	int min() {return s2->top();}
};

//p3
int getLast(stack<int>& s) {
	int r = s.top();
	s.pop();
	if (s.empty())
		return r;
	else {
		int last = getLast(s);
		s.push(r);
		return last;
	}
}

//p4
void reverse(stack<int>& s) {
	if (s.empty())
		return;
	int i = getLast(s);
	reverse(s);
	s.push(i);
}

//p5
void stackSort(stack<int>& s) {
	stack<int> t;
	while (!s.empty()) {
		if (t.empty() || s.top() <= t.top()) {
			t.push(s.top());
			s.pop();
		} else {
			int i = s.top();
			s.pop();
			while ((!t.empty()) && t.top() < i) {
				s.push(t.top());
				t.pop();
			}
			t.push(i);
		}
	}

	while (!t.empty()) {
		s.push(t.top());
		t.pop();
	}
}

//p6
bool isPopOrder(vector<int> a1, vector<int> a2) {
	stack<int> s;
	for (int i = 0, j = 0; i < a1.size(); i++) {
		s.push(a1[i++]);
		while (j < a2.size() && a2[j] == s.top()) {
			s.pop();
			j++;
		}
	}
	return s.empty();
}

//p7
vector<int> maxInWindow(vector<int> array, int window_size) {
	vector<int> result;
	if (window_size == 0)
		return result;
	int start;
	deque<int> q;
	for (int i = 0; i < array.size(); i++) {
		while ((!q.empty()) && array[q.back()] <= array[i])
			q.pop_back();
		if ((!q.empty()) && i - q.front() + 1 > window_size)
			q.pop_front();
		q.push_back(i);
		if (i + 1 >= size)
			result.push_back(array[q.front()]);
	}
	return result;
}
