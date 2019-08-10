#include <iostream>
#include <vector>
#include <queue>
using namespace std;

typedef struct TreeNode_ {
	int value;
	TreeNode_ *left;
	TreeNode_ *right;
	TreeNode_(int x) : value(x), left(NULL), right(NULL) {}
} TreeNode;

TreeNode* get_child(vector<int> p, vector<int> i, int pstart, int pend, int istart, int iend) {
	if (pstart > pend)
		return NULL;
	TreeNode *node = new TreeNode(p[pstart]);
	for (int j = istart; j <= iend; j++) {
		if (i[j] == p[pstart]) {
			node->left = get_child(p, i, pstart + 1, pstart + i - istart, istart, i - 1);
			node->right = get_child(p, i, pstart + i - istart + 1, pend, i + 1, iend);
			return node;
		}
	}
}

TreeNode* reconstuct(vector<int> p, vector<int> i) {
	return get_child(p, i, 0, p.size() - 1, 0, i.size() - 1);
}

vector<int> levelTraversal(TreeNode *root) {
	vector<int> *result = new vector<int>();
	if (root == NULL)
		return result;
	queue<TreeNode*> *q = new queue<TreeNode*>();
	q.push(root);
	while (!q.empty()) {
		TreeNode *c = q.front();
		if (c->left != NULL)
			q.push(c->left);
		if (c->right != NULL)
			q.push(c->right);
		result->push_back(c->value);
		q.pop();
	}
	return result;
}

void printLevel(TreeNode *root) {
	if (root == NULL)
		return;
	queue<TreeNode *> *q = new queue<TreeNode *>();
	q.push(root);
	TreeNode *last, *nlast;
	nlast = last = root;
	while (!q.empty()) {
		TreeNode *c = q.front();
		if (c->left != NULL) {
			q.push(c->left);
		}
		if (c->right != NULL) {
			q.push(c->right);
		}
		q.pop();
	}
}

void preOrderTraversal(TreeNode *root) {
	if (root != NULL) {
		cout << root->value; //do something to visit the node
		preOrderTraversal(root->left);
		preOrderTraversal(root->right);
	}
}

void inOrderTraversal(TreeNode *root) {
	if (root != NULL) {
		inOrderTraversal(root->left);
		cout << root->value; //do something to visit the node
		inOrderTraversal(root->right);
	}
}

void postOrderTraversal(TreeNode *root) {
	if (root != NULL) {
		postOrderTraversal(root->left);
		postOrderTraversal(root->right);
		cout << root->value; //do something to visit the node
	}
}

void preOrderTraversal_i(TreeNode *root) {
	stack<TreeNode *> s;
	while (true) {
		while (root != NULL) {
			cout << root->value; //do something to visit the node
			s.push(root);
			root = root->left;
		}
		if (s.empty())
			break;
		root = s.top()->right;
		s.pop();
	}
}

void inOrderTraversal_i(TreeNode *root) {
	stack<TreeNode *> s;
	while (true) {
		while (root != NULL) {
			s.push(root);
			root = root->left; //do something to visit the node
		}
		if (s.empty())
			break;
		root = s.top();
		cout << root->value;
		s.pop();
		root = root->right;
	}
}

void postOrderTraversal_i(TreeNode *root) {
	stack<TreeNode *> s;
	while (true) {
		if (root != NULL) {
			s.push(root);
			root = root->left;
		} else {
			if (s.empty())
				break;
			if (s.top()->right == NULL) {
				root = s.top();
				cout << root->value; //do something to visit the node
				s.pop();
				while (root == s.top()->right) {
					root = s.top();
					cout << root->value; //do something to visit the node
					s.pop();
					if (s.empty())
						break;
				}
			}

			if (!s.empty()) 
				root = s.top()->right;
			else
				root = NULL;
		}
	}
}
