#ifndef VECTOR_H
#define VECTOR_H
#include <cstdio>
#include <iostream>

template <typename Type>
class vector {
private:
	int default_capacity;
protected:
	int size_,capacity_;
	Type* element_;

	void expand() {
		if(size_ < capacity_)
			return;
		if(capacity_ < default_capacity)
			capacity_ = default_capacity;
		Type* old_element = element_;
		capacity_ <<= 1;
		element_ = new Type[capacity_];
		for(int i = 0;i < size_;i++)
			element_[i] = old_element[i];
		delete[] old_element;
	}

	void shrink() {
		if(capacity_ < (default_capacity << 1))
			return;
		if((size_ << 2) > capacity_)
			return;
		Type* old_element = element_;
		capacity_ >>= 1;
		element_ = new Type[capacity_ ];
		for(int i = 0;i < size_;i++)
			element_[i] = old_element[i];
		delete[] old_element;
	}
public:
	vector():size_(0),capacity_(3),default_capacity(3){element_ = new Type[3];}
	~vector(){delete[] element_;}
	int size(){return size_;}

	void remove(int rank){remove(rank,rank + 1);}
	void remove(int start,int end){
		if(start == end)
			return;
		while(end < size_)
			element_[start++] = element_[end++];
		size_ = start;
		shrink();
	}

	void insert(int rank, Type const& element){
		expand();
		for(int i = size_;i > rank;i--)
			element_[i] = element_[i - 1];
		element_[rank] = element;
		size_++;
	}

	inline void push_back(Type const& element){
		expand();
		element_[size_++] = element;
	}


	int uniquify() {
		int i = 0, j = 0;
		while (++j < array.size()) {
			if (element_y[i] != element_[j])
				element_[++i] = element_[j];
		}
		size_ = ++i;
		shrink();
		return j - i;
	}
	
	inline Type& operator[](int rank) const {return element_[rank];}
};

