#include <cstdio>
#include <cstring>
#include <iostream>
using namespace std;


struct node{                                     //����ڵ� 
	char data;
	int previous;
	int next;
}total[10000000];

struct cursor{                                   //��� 
	int neighbor1;                               //���ǰԪ�� 
	int neighbor2;                               //����Ԫ�� 
	int position;                                //���λ�� 
}left_,right_;

char text[1<<25];
int length;
int how_many = 2;

void create(char *text){                         //���ݳ�ʼ���д������� 
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

void move_left(char which){                      //�������  
	if(which == 'L'){
		if(left_.position == 0){
			printf("F\n");
			return;
		}
		else{
			if(total[left_.neighbor1].previous != left_.neighbor2){
				left_.neighbor2 = left_.neighbor1;
				left_.neighbor1 = total[left_.neighbor1].previous;
				left_.position--;                //�޸�λ�� 
			}                                    //���¹��ǰԪ�ز��ѹ��ԭǰԪ�ظ������Ԫ�� 
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

void move_right(char which){                     //�������  
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

void insert(char which,char what){               //Ԫ�ز��� 
	if(which == 'L'){
		total[how_many].data = what;
		total[how_many].previous = left_.neighbor1;
		total[how_many].next = left_.neighbor2;  //ͨ�����洢��ǰ��Ԫ�����ж�����Ԫ����Ҫ�޸ĵ�ָ�� 
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

void Delete(char which){                         //Ԫ��ɾ�� 
	if(which == 'L'){
		if(left_.position == length){
			printf("F\n");
			return;
		}
		else{                                    //ͨ�����ǰ��Ԫ�����жϴ�ɾ��Ԫ�ص�λ�� 
			int neighborhood;                    //�����ж�����Ԫ��Ӧ���޸ĵ����� 
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

void reverse(){                                  //���з�ת 
	if(left_.position >= right_.position){
		printf("F\n");
		return;
	}
	else{                                        //���ù���жϷ�ת����ǰ���������ϵ 
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
		int temporary = left_.neighbor2;       //���޸ķ�ת��������Ԫ�ص����� 
		left_.neighbor2 = right_.neighbor1;
		right_.neighbor1 = temporary;
		printf("T\n");
		return;
	}
}

void show(){                                     //�Ժ���ǰ������� 
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

//��������
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
�������
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
