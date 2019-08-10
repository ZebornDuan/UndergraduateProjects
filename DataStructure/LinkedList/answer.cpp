#include <cstdio>
#include <cstring>
#include <iostream>
using namespace std;


struct node{                                     //链表节点 
	char data;
	int previous;
	int next;
}total[10000000];

struct cursor{                                   //光标 
	int neighbor1;                               //光标前元素 
	int neighbor2;                               //光标后元素 
	int position;                                //光标位置 
}left_,right_;

char text[1<<25];
int length;
int how_many = 2;

void create(char *text){                         //根据初始序列创建链表 
	total[0].previous = -1;
	int current = 0;
	for(int i = 0;i < length;i++){
		total[how_many].data = text[i];
		total[current].next = how_many;
		total[how_many].previous = current;
		current = how_many;
		how_many++;
	}
	total[current].next = 1;
	total[1].previous = current;
	total[1].next = -1;
}

void move_left(char which){                      //光标左移  
	if(which == 'L'){
		if(left_.position == 0){
			printf("F\n");
			return;
		}
		else{
			if(total[left_.neighbor1].previous != left_.neighbor2){
				left_.neighbor2 = left_.neighbor1;
				left_.neighbor1 = total[left_.neighbor1].previous;
				left_.position--;                //修改位置 
			}                                    //更新光标前元素并把光标原前元素赋予光标后元素 
			else{
				left_.neighbor2 = left_.neighbor1;
				left_.neighbor1 = total[left_.neighbor1].next;
				left_.position--;
			}
			printf("T\n");
			return;
		}
	}
	else{
		if(right_.position == 0){
			printf("F\n");
			return;
		}
		else{
			if(total[right_.neighbor1].previous != right_.neighbor2){
				right_.neighbor2 = right_.neighbor1;
				right_.neighbor1 = total[right_.neighbor1].previous;
				right_.position--;
			}
			else{
				right_.neighbor2 = right_.neighbor1;
				right_.neighbor1 = total[right_.neighbor1].next;
				right_.position--;
			}
			printf("T\n");
			return;
		}
	}
}

void move_right(char which){                     //光标右移  
	if(which == 'L'){
		if(left_.position == length){
			printf("F\n");
			return;
		}
		else{
			if(total[left_.neighbor2].next != left_.neighbor1){
				left_.neighbor1 = left_.neighbor2;
				left_.neighbor2 = total[left_.neighbor2].next;
				left_.position++;
			}
			else{
				left_.neighbor1 = left_.neighbor2;
				left_.neighbor2 = total[left_.neighbor2].previous;
				left_.position++;
			}
			printf("T\n");
			return;
		}
	}
	else{
		if(right_.position == length){
			printf("F\n");
			return;
		}
		else{
			if(total[right_.neighbor2].next != right_.neighbor1){
				right_.neighbor1 = right_.neighbor2;
				right_.neighbor2 = total[right_.neighbor2].next;
				right_.position++;
			}
			else{
				right_.neighbor1 = right_.neighbor2;
				right_.neighbor2 = total[right_.neighbor2].previous;
				right_.position++;
			}
			printf("T\n");
			return;
		}
	}
}

void insert(char which,char what){               //元素插入 
	if(which == 'L'){
		total[how_many].data = what;
		total[how_many].previous = left_.neighbor1;
		total[how_many].next = left_.neighbor2;  //通过光标存储的前后元素来判断相邻元素需要修改的指针 
		if(total[left_.neighbor1].next == left_.neighbor2)
			total[left_.neighbor1].next = how_many;
		else
			total[left_.neighbor1].previous = how_many;
		if(total[left_.neighbor2].previous == left_.neighbor1)
			total[left_.neighbor2].previous = how_many;
		else
			total[left_.neighbor2].next = how_many;
		left_.neighbor1 = how_many;
		if(right_.position == left_.position)
			right_.neighbor1 = how_many;
		if(right_.position >= left_.position)
			right_.position++;
		left_.position++;
		length++;
		how_many++;
		printf("T\n");
		return;
	}
	else{
		total[how_many].data = what;
		total[how_many].previous = right_.neighbor1;
		total[how_many].next = right_.neighbor2;
		if(total[right_.neighbor1].next == right_.neighbor2)
			total[right_.neighbor1].next = how_many;
		else
			total[right_.neighbor1].previous = how_many;
		if(total[right_.neighbor2].previous == right_.neighbor1)
			total[right_.neighbor2].previous = how_many;
		else
			total[right_.neighbor2].next = how_many;
		right_.neighbor1 = how_many;
		if(left_.position == right_.position)
			left_.neighbor1 = how_many;
		if(left_.position >= right_.position)
			left_.position++;
		right_.position++;
		length++;
		how_many++;
		printf("T\n");
		return;
	}
}

void Delete(char which){                         //元素删除 
	if(which == 'L'){
		if(left_.position == length){
			printf("F\n");
			return;
		}
		else{                                    //通过光标前后元素来判断待删除元素的位置 
			int neighborhood;                    //依次判断相邻元素应该修改的索引 
			if(total[left_.neighbor2].previous == left_.neighbor1)
				neighborhood = total[left_.neighbor2].next;
			else
				neighborhood = total[left_.neighbor2].previous;
			if(total[neighborhood].previous == left_.neighbor2)
				total[neighborhood].previous = left_.neighbor1;
			else
				total[neighborhood].next = left_.neighbor1;
			if(total[left_.neighbor1].next == left_.neighbor2){
				total[left_.neighbor1].next = neighborhood;
				left_.neighbor2 = neighborhood;
				if(right_.position == left_.position)
					right_.neighbor2 = neighborhood;
				if(right_.position == left_.position + 1)
					right_.neighbor1 = left_.neighbor1;
			}
			else{
				total[left_.neighbor1].previous = neighborhood;
				left_.neighbor2 = neighborhood;
				if(right_.position == left_.position)
					right_.neighbor2 = neighborhood;
				if(right_.position == left_.position + 1)
					right_.neighbor1 = left_.neighbor1;
			}
			if(right_.position > left_.position)
				right_.position--;
			length--;
			printf("T\n");
			return;
		}
	}
	else{
		if(right_.position == length){
			printf("F\n");
			return;
		}
		else{
			int neighborhood;
			if(total[right_.neighbor2].previous == right_.neighbor1)
				neighborhood = total[right_.neighbor2].next;
			else
				neighborhood = total[right_.neighbor2].previous;
			if(total[neighborhood].previous == right_.neighbor2)
				total[neighborhood].previous = right_.neighbor1;
			else
				total[neighborhood].next = right_.neighbor1;
			if(total[right_.neighbor1].next == right_.neighbor2){
				total[right_.neighbor1].next = neighborhood;
				right_.neighbor2 = neighborhood;
				if(left_.position == right_.position)
					left_.neighbor2 = neighborhood;
				if(left_.position == right_.position + 1)
					left_.neighbor1 = right_.neighbor1;
			}
			else{
				total[right_.neighbor1].previous = neighborhood;
				right_.neighbor2 = neighborhood;
				if(left_.position == right_.position)
					left_.neighbor2 = neighborhood;
				if(left_.position == right_.position + 1)
					left_.neighbor1 = right_.neighbor1;
			}
			if(left_.position > right_.position)
				left_.position--;
			length--;
			printf("T\n");
			return;
		}
	}
}

void reverse(){                                  //序列翻转 
	if(left_.position >= right_.position){
		printf("F\n");
		return;
	}
	else{                                        //利用光标判断翻转序列前后的索引关系 
		if(total[left_.neighbor2].previous == left_.neighbor1)
			total[left_.neighbor2].previous = right_.neighbor2;
		else
			total[left_.neighbor2].next = right_.neighbor2;
		if(total[right_.neighbor2].previous == right_.neighbor1)
			total[right_.neighbor2].previous = left_.neighbor2;
		else
			total[right_.neighbor2].next = left_.neighbor2;
		if(total[right_.neighbor1].next == right_.neighbor2)
			total[right_.neighbor1].next = left_.neighbor1;
		else
			total[right_.neighbor1].previous = left_.neighbor1;
		if(total[left_.neighbor1].next == left_.neighbor2)
			total[left_.neighbor1].next = right_.neighbor1;
		else
			total[left_.neighbor1].previous = right_.neighbor1;
		int temporary = left_.neighbor2;       //仅修改翻转序列两端元素的索引 
		left_.neighbor2 = right_.neighbor1;
		right_.neighbor1 = temporary;
		printf("T\n");
		return;
	}
}

void show(){                                     //自后向前输出序列 
	int index = total[0].next;
	int have_done = 0;
	while(index != 1){
		printf("%c",total[index].data);
		if(total[index].next != have_done){
			have_done = index;
			index = total[index].next;
		}
		else{
			have_done = index;
			index = total[index].previous;
		}
	}
	printf("\n");
}

int main(){
	gets(text);
	length = strlen(text);
	create(text);
	left_.neighbor1 = 0;
	left_.neighbor2 = total[0].next;
	left_.position = 0;
	right_.neighbor1 = total[1].previous;
	right_.neighbor2 = 1;
	right_.position = length;

	int number;
	scanf("%d\n",&number);
	while(number--){
		char require[5];
		gets(require);
		if(require[0] == '<'){
			move_left(require[2]);
			continue;
		}
		if(require[0] == '>'){
			move_right(require[2]);
			continue;
		}
		if(require[0] == 'I'){
			insert(require[2],require[4]);
			continue;
		}
		if(require[0] == 'D'){
			Delete(require[2]);
			continue;
		}
		if(require[0] == 'R'){
			reverse();
			continue;
		}
		if(require[0] == 'S'){
			show();
			continue;
		}
	}	
}

//输入样例
/*
9
42
> L
I L t
I R '
< R
< R
I R -
I L n
I L s
I L i
I R b
I L a
I R -
I L k
I L a
> L
R
> R
> R
> R
> R
> R
< L
< L
< L
R
< L
< L
< L
< L
< L
< L
< L
R
> L
> L
< R
< R
< R
D L
D L
D L
S
输出样例
T
T
T
T
T
T
T
T
T
T
T
T
T
T
F
F
T
T
T
T
T
T
T
T
F
T
T
T
T
T
T
T
T
T
T
T
T
T
T
T
T
9-is-baka
*/
