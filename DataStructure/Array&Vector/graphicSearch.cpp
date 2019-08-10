#include <cstdio>
#include <iostream>
#include <cstdlib>
using namespace std;

int compare(const void *a,const void *b ){
	return *(long long *)a - *(long long *)b;
}

int main(){
	long long scale;
	scanf("%d",&scale);
	long long *x = new long long[200000];
	long long *y = new long long[200000];
	for(long long i = 0;i < scale;i++)
		scanf("%d",&x[i]);
	for(long long i = 0;i < scale;i++)
		scanf("%d",&y[i]);
	qsort(x,scale,sizeof(x[0]),compare);
	qsort(y,scale,sizeof(y[0]),compare);         //对点按坐标排序 
	long long question;
	scanf("%d",&question);
	long long *Px = new long long[200000],*Py = new long long[200000];
	long long *result = new long long[200000];
	for(long long i = 0;i < question;i++){
		scanf("%d",&Px[i]);
		scanf("%d",&Py[i]);
		long long up_bound = scale - 1;
		long long down_bound = 0;
		long long Ax = -Px[i];
		long long By = -Py[i];
		long long bottomY = y[0] - Py[i],topY = y[scale - 1] - Py[i];
		long long bottomX = x[0] - Px[i],topX = x[scale - 1] - Px[i];
		long long bottom = Ax * By - bottomY * bottomX;
		long long top = Ax * By - topY * topX;
		if(bottom < 0){                          //判断是否位于最低的直线下方 
			result[i] = 0;
			continue;
		}
		if(top >= 0){                            //判断是否位于最高直线的上方 
			result[i] = scale;
			continue;
		}
		if(scale == 2){                          //只有两条直线则直接输出结果 
			result[i] = 1;
			continue;
		}
		while(up_bound - down_bound > 1){
			long long middle = (up_bound + down_bound + 1) / 2;
			long long Ay = y[middle] - Py[i];
			long long Bx = x[middle] - Px[i];						
			long long product = Ax * By - Ay * Bx; 
			if(product == 0){                    
				result[i] = middle + 1;
				break;
			}
			if(product > 0)
				down_bound = middle;
			else
				up_bound = middle;
			result[i] = down_bound + 1;
		}
	}
	for(long long i = 0;i < question;i++)
		printf("%d\n",result[i]);
	delete[] x;
	delete[] y;
	delete[] Px;
	delete[] Py;
	delete[] result;	
}
