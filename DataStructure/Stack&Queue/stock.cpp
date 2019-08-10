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
	long long *queue = new long long[scale_];    //存储股票的最大持股量 
	long long *queue_ = new long long[scale_];   //存储对应的股票的退市次序 
	long long head = 0,tail = 0;
	while(scale_--){
		long long addition = 0;
		long long time = 0;
		scanf("%lld",&time);
		day = day + time;
		stock = stock + possession * time;
		char judge = getchar();
		if(judge == ' '){                        //判断当天为上市还是退市 
			scanf("%lld",&addition);
			long long number = 1;
			while(head != tail){                 //对于上市的股票确定其持股量在所有股票中的位置 
				if(addition >= queue[tail - 1]){
					number = number + queue_[tail - 1];
					tail--;
					continue;                    //先退市且持股量小的股票直接覆盖 
				}
				break;
			}
			queue[tail] = addition;
			queue_[tail] = number;
			tail++;
		}
		else{
			queue_[head]--;                      //股票退市操作队首元素 
			if(queue_[head] == 0)
				head++;
		}
		if(head != tail){
			possession = queue[head];
			continue;
		}
		possession = 0;                          //股市为空 
	}
	printf("%lld",stock);
	delete[] queue;
	delete[] queue_; 
}
