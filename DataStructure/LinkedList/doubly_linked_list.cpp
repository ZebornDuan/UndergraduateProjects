#include <iostream>
using namespace std;

typedef struct Node_ {
	int value = 0;
	Node_* previous = NULL;
	Node_* next = NULL;
} Node;

void insert_next(Node *node, Node *to_add) {
	if (node == NULL || to_add == NULL)
		return;
	Node *t = node->next;
	node->next = to_add;
	to_add->next = t;
	to_add->previous = node;
	if (t != NULL)
		t->previous = to_add;
}

void insert_previous(Node *node, Node* to_add) {
	if (node == NULL || to_add == NULL)
		return;
	Node *t = node->previous;
	node->previous = to_add;
	to_add->previous = t;
	to_add->next = node;
	if (t != NULL) 
		t->next = to_add;
}

void remove(Node *node) {
	if (node == NULL)
		return;
	Node *t1 = node->previous;
	Node *t2 = node->next;
	if (t1 != NULL)
		t1->next = t2;
	if (t2 != NULL)
		t2->previous = t1;
	delete node;
}

int main(int argc, char const *argv[]) {
	return 0;
}