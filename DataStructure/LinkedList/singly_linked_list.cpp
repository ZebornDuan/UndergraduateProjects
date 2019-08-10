#include <iostream>
#include <vector>
#include <stack>
using namespace std;

typedef struct Node_ {
	int n;
	Node_* next = NULL;
} Node;

void print_list(Node *head) {
	if (head == NULL)
		return;
	cout << head->n;
	while ((head = head->next) != NULL)
		cout << " -> " << head->n;
	cout << endl;
}

void insert_next(Node *node, Node *to_add) {
	if (node == NULL || to_add == NULL)
		return;
	Node *t = node->next;
	node->next = to_add;
	to_add->next = t;
}

void insert_next(Node *node, int to_add) {
	if (node == NULL)
		return;
	Node *node_to_add = new Node();
	node_to_add->n = to_add;
	Node *t = node->next;
	node->next = node_to_add;
	node_to_add->next = t;
}

Node* reverse(Node *head) {
	if (head == NULL)
		return NULL;
	if (head->next == NULL)
		return head;
	Node *t1 = head;
	Node *t2 = head->next;
	Node *t3;

	while (t2 != NULL) {
		t3 = t2->next;
		t2->next = t1;
		t1 = t2;
		t2 = t3;
	}

	head->next = NULL;
	return t1;
}

//---------------------print a list in reverse order--------------
class reverse_order_print {
public:
	vector<int> *v;

	reverse_order_print() {
		v = new vector<int>();
	}

	// if changes to the list are allowed, just reverse the list and scan it
	vector<int> method1(Node *node) {
		Node *t = reverse(node);
		while (t != NULL) {
			v->push_back(t->n);
			t = t->next;
		}
		return *v;
	}

	//recursive implementation without changing the list
	vector<int> method2(Node *node) {
		if (node != NULL) {
			method2(node->next);
			v->push_back(node->n);
		}
		return *v;
	}

	//use a stack
	vector<int> method3(Node *node) {
		stack<int> *s = new stack<int>();
		while (node != NULL) {
			s->push(node->n);
			node = node->next;
		}

		while (!s->empty()) {
			v->push_back(s->top());
			s->pop();
		}

		return *v;
	}
};

//----------------merge two sorted list(exercise)------------------------
Node* merge_r(Node *head1, Node* head2) {
	if (head1 == NULL)
		return head2;
	if (head2 == NULL)
		return head1;
	if (head1->n <= head2->n) {
		head1->next = merge_r(head1->next, head2);
		return head1;
	}
	else {
		head2->next = merge_r(head1, head2->next);
		return head2;
	}
}

Node* merge_i(Node* head1, Node* head2) {
	if (head1 == NULL)
		return head2;
	if (head2 == NULL)
		return head1;
	Node *merge_head = NULL;
	if (head1->n <= head2->n) {
		merge_head = head1;
		head1 = head1->next;
	} else {
		merge_head = head2;
		head2 = head2->next;
	}

	Node *current = merge_head;
	while (head1 != NULL && head2 != NULL) {
		if (head1->n <= head2->n) {
			current->next = head1;
			current = head1;
			head1 = head1->next;
		} else {
			current->next = head2;
			current = head2;
			head2 = head2->next;
		}
	}

	if (head1 == NULL)
		current->next = head2;
	else
		current->next = head1;

	return merge_head;
}

//----------------------add two numbers by list(exercise)-------------------------
Node* list_add(Node *node1, Node *node2) {
	Node *n1 = reverse(node1);
	Node *n2 = reverse(node2);
	int a = 0;
	Node *buffer = NULL;

	while (n1 != NULL && n2 != NULL) {
		Node *number = new Node();
		int r = n1->n + n2->n + a;
		number->n = r % 10;
		a = r / 10;
		number->next = buffer;
		buffer = number;
		n1 = n1->next;
		n2 = n2->next;
	}

	if (n1 == NULL) {
		while (n2 != NULL) {
			Node *number = new Node();
			int r = n2->n + a;
			number->n = r % 10;
			a = r / 10;
			number->next = buffer;
			buffer = number;
			n2 = n2->next;
		}
	} else {
		while (n1 != NULL) {
			Node *number = new Node();
			int r = n1->n + a;
			number->n = r % 10;
			a = r / 10;
			number->next = buffer;
			buffer = number;
			n1 = n1->next;
		}
	}

	return buffer;
}

//----------------Judge whether two linked list is crossing--------

Node* isCrossing(Node *head1, Node *head2) {
	Node *t1 = head1;
	Node *t2 = head2;
	while (t1 != t2) {
		t1 = (t1 == NULL) ? head2 : t1->next;
		t2 = (t2 == NULL) ? head1 : t2->next;
	}
	return t1;
} 

//----------------Find the entry of of the loop--------------------

Node* isLoop(Node *head) {
	if (head == NULL || head->next == NULL || head->next->next == NULL)
		return NULL;
	Node *fast = head->next->next;
	Node *slow = head->next;
	while (fast != slow) {
		if (fast.next != NULL && fast.next.next != NULL) {
			fast = fast.next.next;
			slow = slow.next;
		} else 
			return NULL;
	}

	fast = head;
	while (fast != slow) {
		fast = fast.next;
		slow = slow.next;
	}

	return slow;
}

Node* findEntryOfLoop(Node *head) {
	Node *fast = head->next;
	Node *slow = head;
	while (fast != NULL) {
		slow.next = NULL;
		slow = fast;
		fast = fast.next;
	}
	return slow;
}

//****************************************************************

int main(int argc, char** argv) {
	Node *head = new Node();
	head->n = 0;
	for (int i = 9; i > 0; i--)
		insert_next(head, i);

	reverse_order_print *rop = new reverse_order_print();
	vector<int> r = rop->method3(head);
	for (int i = 0; i < r.size(); i++)
		cout << r[i] << " ";


	Node *a1 = new Node();
	a1->n = 1;
	insert_next(a1, 4);
	insert_next(a1, 3);
	insert_next(a1, 2);

	Node *a2 = new Node();
	a2->n = 6;
	insert_next(a2, 8);

	Node *r = list_add(a1, a2);
	print_list(r);
}