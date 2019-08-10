#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iostream>
using namespace std;

int main(){
	long long scale;
	long long day = 0,stock = 0,possession = 0;
	scanf("%lld",&scale);
	long long scale_ = scale << 1;
	long long *queue = new long long[scale_];    //�洢��Ʊ�����ֹ��� 
	long long *queue_ = new long long[scale_];   //�洢��Ӧ�Ĺ�Ʊ�����д��� 
	long long head = 0,tail = 0;
	while(scale_--){
		long long addition = 0;
		long long time = 0;
		scanf("%lld",&time);
		day = day + time;
		stock = stock + possession * time;
		char judge = getchar();
		if(judge == ' '){                        //�жϵ���Ϊ���л������� 
			scanf("%lld",&addition);
			long long number = 1;
			while(head != tail){                 //�������еĹ�Ʊȷ����ֹ��������й�Ʊ�е�λ�� 
				if(addition >= queue[tail - 1]){
					number = number + queue_[tail - 1];
					tail--;
					continue;                    //�������ҳֹ���С�Ĺ�Ʊֱ�Ӹ��� 
				}
				break;
			}
			queue[tail] = addition;
			queue_[tail] = number;
			tail++;
		}
		else{
			queue_[head]--;                      //��Ʊ���в�������Ԫ�� 
			if(queue_[head] == 0)
				head++;
		}
		if(head != tail){
			possession = queue[head];
			continue;
		}
		possession = 0;                          //����Ϊ�� 
	}
	printf("%lld",stock);
	delete[] queue;
	delete[] queue_; 
}
