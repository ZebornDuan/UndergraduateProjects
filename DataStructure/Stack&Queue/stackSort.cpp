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
	for(int i = scale;i > 0;i--){                          //�Ӻ���ǰ���Ҽ���ֵ 
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
		bool empty = (stack[length] == 0);                 //�ж��Ƿ�ջ�� 
		bool peak = (stack[length - 1] < temporary[current]);
		if(empty || peak){                                 //�ж�ջ��Ԫ���뼴����ջ��Ԫ������ܷ��Ϊ����ֵ 
			for(int i = index[current];current <= i;current++){
				stack[length] = element[current];
				length++;                                  //���ջ�ջ���ջ��Ԫ�طǼ���ֵ�������ջֱ�����ּ���ֵ 
			}
		}
		printf("%d ",stack[length - 1]);                   //ÿ��ջ��Ϊ����ֵ����ջ 
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
