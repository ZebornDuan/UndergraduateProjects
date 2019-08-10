#include <iostream>
#include <cstdio>
using namespace std;

int main(){
	int scale;
	scanf("%d",&scale);
	int *element = new int[2000001];
	int *index = new int[2000001];
	int *temporary = new int[2000001];
	int *stack = new int[2000001];
	int length = 0,current = 0;
	temporary[scale] = 0;
	for(int i = 0;i < scale;i++) 
		scanf("%d",&element[i]);
	for(int i = scale;i > 0;i--){                          //从后往前查找极大值 
		stack[i - 1] = 0;
		if(temporary[i] > element[i - 1]){
			temporary[i - 1] = temporary[i];
			index[i - 1] = index[i];
			continue;
		}
		temporary[i - 1] = element[i - 1];
		index[i - 1] = i - 1;
	}
	while(scale--){
		bool empty = (stack[length] == 0);                 //判断是否栈空 
		bool peak = (stack[length - 1] < temporary[current]);
		if(empty || peak){                                 //判断栈顶元素与即将入栈的元素相比能否成为极大值 
			for(int i = index[current];current <= i;current++){
				stack[length] = element[current];
				length++;                                  //如果栈空或者栈顶元素非极大值则继续入栈直到出现极大值 
			}
		}
		printf("%d ",stack[length - 1]);                   //每当栈顶为极大值即出栈 
		length--;
		if(length == 0)
			stack[length] = 0;
	}
	delete[] element;
	delete[] temporary;
	delete[] index;
	delete[] stack;
	return 0;
}
