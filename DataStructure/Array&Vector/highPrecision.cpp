#include <cmath>
#include <cstdio>
#include <string>
#include <cstring>
#include <stdlib.h>
#include <iostream>

#define M_PI 3.14159265358979323846
using namespace std;

//**********************************************************************************// 
void multiplication(string data1,string data2){
    int number1[5001] = {0},number2[5001] = {0},result[10001] = {0};
    string Result;
    bool begin = false;
    for(int i = data1.length(),j = 0;i > 0;i--,j++)
        number1[i] = data1[j] - '0';
    for(int i = data2.length(),j = 0;i > 0;i--,j++)
        number2[i] = data2[j] - '0';
    for(int i = 1;i <= data1.length();i++)                      //���ձ���ģʽ��λ������Ӧ��� 
        for(int j = 1;j <= data2.length();j++)
            result[i + j - 1] += number1[i] * number2[j];
    for(int i = 1;i <= data1.length() + data2.length() + 1;i++){//���ݷ�λ������н�λ���Ժ���ǰ�������ս�� 
        result[i + 1] += result[i] / 10;
        result[i] = result[i] % 10; 
    }
    for(int i = data1.length() + data2.length() + 1;i > 0;i--){
        if(result[i] == 0 && begin == false && i != 0)
            continue;
        else{
            begin = true;
            Result += char(result[i] + '0');
        }
    }
    cout<<Result<<endl;
}
//********************************************************************************//
//***********A Developed Version of High Precision Multiplication*****************//
//**************Calculating in one hundred million binary system******************//
int change(string data,long long number[]){                //�����ڽ��ƣ�ÿ��λΪһ����Ԫ���д洢 
    int length = data.length(),index = 0;
    while(length / 8){
        string temporary = data.substr(length - 8,8);
        number[++index] = atoi(temporary.c_str());
        length -= 8;
    }
    if(length){                                            //���ղ����λ��ֱ�Ӵ洢 
        string temporary = data.substr(0,length);
        number[++index] = atoi(temporary.c_str());
    }
    return index;
}

void calculation(string data1,string data2){
    long long number1[5000],number2[5000],result[10000] = {0};
    int length1 = change(data1,number1);
    int length2 = change(data2,number2);
    int final = length1 + length2 + 1;
    for(int i = 1;i <= length1;i++)                        //����ģʽ�ļ�����̣������Ľ��� 
        for(int j = 1;j <= length2;j++)
            result[i + j - 1] += number1[i] * number2[j];           
    for(int i = 1;i <= final;i++){
        result[i + 1] += result[i] / 100000000;
        result[i] = result[i] % 100000000; 
    }
    while(result[final] == 0 && final > 0)
        final--;
    printf("%d",result[final]);
    for(int i = final - 1;i > 0;i--)
        printf("%0*d",8,result[i]);
    printf("\n");
}

//***********************************************************************************//
int main(){//���ղ��õİ汾Ϊ�ڽ��Ƶı���ģʽ�߾��ȳ˷�
    int n;
    cin>>n;
    string data1[n],data2[n];
    for(int i = 0;i < n;i++)
        cin>>data1[i]>>data2[i];
    for(int i = 0;i < n;i++)
        calculation(data1[i],data2[i]);
    return 0;
}
//***********************************************************************************//
//���η�ʵ�ֵĸ߾��ȳ˷�����Ҫ˼��Ϊ�����������Ϊ��λ����ֱ����� 
string add(string data1,string data2){//�߾��ȼӷ������ںϲ����̣������μ���ĸ��������ӵ����ս�� 
    int number1[5001] = {0},number2[5001] = {0},result[10001] = {0};
    string Result;
    bool begin = false;
    for(int i = data1.length(),j = 0;i > 0;i--,j++)
        number1[i] = data1[j] - '0';
    for(int i = data2.length(),j = 0;i > 0;i--,j++)
        number2[i] = data2[j] - '0';
    for(int i = 1;i <= max(data1.length(),data2.length());i++){
        result[i] = (number1[i] + number2[i]) % 10 + result[i];
        if(result[i] == 10){
            result[i] = 0;
            result[i + 1] += 1;
        }
        result[i + 1] += (number1[i] + number2[i]) / 10;
    }
    for(int i = max(data1.length() + 1,data2.length() + 1);i > 0;i--){
        if(result[i] == 0 && begin == false && i != 0)
            continue;
        else{
            begin = true;
            Result += char(result[i] + '0');
        }
    }
    return Result;
}

string Multiplication(string number1,string number2){
    int length;
    string head,tail,result_head,result_tail,result;
    if(number1.length() == 1 && number2.length() == 1){   //�����������Ϊһλ��ֱ����� 
        int data1 = number1[0] - '0';
        int data2 = number2[0] - '0';
        int result_ = data1 * data2;
        result += char(result_ / 10 + '0');
        if(result_ >= 10)
            result += char(result_ % 10 + '0');
        else result = char(result_ % 10 + '0');
        return result;
    }
    else if(number1.length() == 1 && number2.length() > 1){//�Զ���һλ�ĳ������в�֣�ֱ���ֳ�ÿһλ����һλ 
        bool all_0 = true;
        for(int i = 0;i < number2.length() / 2;i++){       //���ֵĽ�����ܳ���ȫ��Ϊ0�����������ִ����������ж� 
            head += number2[i];
            if(number2[i] != 0)
                all_0 = false;
        }
        if(all_0)
            head = '0';
        all_0 = true;
        for(int i = number2.length() / 2;i != number2.length();i++){
            tail += number2[i];
            if(number2[i] != 0)
                all_0 = false;
        }
        if(all_0)
            tail = '0';
        length = tail.length();
        result_head = Multiplication(number1,head);
        result_tail = Multiplication(number1,tail);
        for(int i = 0;i < length;i++)
            result_head += '0';                             //����δ���ʱ����λ���ڽ����0���Ի�ԭ������мӷ����� 
        result = add(result_head,result_tail);
        return result;
    }
    else if(number1.length() > 1 && number2.length() == 1){
        bool all_0 = true;
        for(int i = 0;i < number1.length() / 2;i++){
            head += number1[i];
            if(number1[i] != 0)
                all_0 = false;
        }
        if(all_0)
            head = '0';
        all_0 = true;
        for(int i = number1.length() / 2;i != number1.length();i++){
            tail += number1[i];
            if(number1[i] != 0)
                all_0 = false;
        }
        if(all_0)
            tail = '0';
        length = tail.length();
        result_head = Multiplication(number2,head);
        result_tail = Multiplication(number2,tail);
        for(int i = 0;i < length;i++)
            result_head += '0';
        result =add(result_head,result_tail);
        return result;
    }
    else{
        bool all_0 = true;
        string head1,tail1,head2,tail2,AC,AD,BC,BD;
        for(int i = 0;i < number1.length() / 2;i++){
            head1 += number1[i];
            if(number1[i] != 0)
                all_0 = false;
        }
        if(all_0)
            head1 = '0';
        all_0 = true;
        for(int i = number1.length() / 2;i != number1.length();i++){
            tail1 += number1[i];
            if(number1[i] != 0)
                all_0 = false;
        }
        if(all_0)
            tail1 = '0';
        all_0 = true;
        for(int i = 0;i < number2.length() / 2;i++){
            head2 += number2[i];
            if(number2[i] != 0)
                all_0 = false;
        }
        if(all_0)
            head2 = '0';
        all_0 = true;
        for(int i = number2.length() / 2;i != number2.length();i++){
            tail2 += number2[i];
            if(number2[i] != 0)
                all_0 = false;
        }
        if(all_0)
            tail2 = '0';
        int Length1 = (number1.length() + 1) / 2;
        int Length2 = (number2.length() + 1) / 2;
        AC = Multiplication(head1,head2);
        AD = Multiplication(head1,tail2);
        BC = Multiplication(tail1,head2);
        BD = Multiplication(tail1,tail2);
        for(int i = 0;i < Length1 + Length2;i++)
            AC += '0';
        for(int i = 0;i < Length1;i++)
            AD += '0';
        for(int i = 0;i < Length2;i++)
            BC += '0';
        result = add(AC,AD);
        result = add(result,BC);
        result = add(result,BD);
    }
    return result;
}

//**********************************************************************************//
//*********High Precision Multiplication Using Fast Fourier Transform***************//
class COMPLEX{                                   //���帴���࣬������Ը���������� 
    public:
        long double Re,Im;
        COMPLEX(long double Re = 0.0,long double Im = 0.0){
            this->Re = Re;
            this->Im = Im;
        }
        inline COMPLEX operator +(const COMPLEX &_number){
            return COMPLEX(this->Re + _number.Re,this->Im + _number.Im);
        }
        inline COMPLEX operator -(const COMPLEX &_number){
            return COMPLEX(this->Re - _number.Re,this->Im - _number.Im);
        }
        inline COMPLEX operator *(const COMPLEX &_number){
            return COMPLEX(this->Re * _number.Re - this->Im * _number.Im,
                this->Re * _number.Im + this->Im * _number.Re);
        }
};

class FFT{
    public:
        string data1,data2;
        int length1,length2,length,top,reverse[10000]/* = {0} */;
        int result[10000]/* = {0} */,number1[10000],number2[10000],number[10000];
        COMPLEX x,y,complex1[10000],complex2[10000],complex3[10000],Complex[10000];
        FFT(string data1_,string data2_);
        void fft(COMPLEX value[],int flag);
        void get_result();
};

FFT::FFT(string data1_,string data2_){
    data1 = data1_;
    data2 = data2_;
    this->length1 = data1.length();
    this->length2 = data2.length(); 
}

void FFT::fft(COMPLEX value[],int flag){         //���ٸ���Ҷ�任
    for(int i = 0;i < this->top;i++)
        this->Complex[i] = value[this->reverse[i]];
    for(int i = 0;i < this->top;i++)
        value[i] = this->Complex[i];
    for(int i = 2;i <= this->top;i <<= 1){
        COMPLEX w_n(cos(2 * M_PI / i),flag * sin(2 * M_PI / i)); 
        for(int j = 0;j < this->top;j += i){
            COMPLEX w(1,0);
            for(int k = j;k < j + i / 2;k++){
                x = value[k];
                y = value[k + i / 2] * w;
                value[k] = x + y;
                value[k + i / 2] = x - y;
                w = w * w_n; 
            }
        }
    }
    if(flag == -1)
        for(int i = 0;i < this->top;i++)
            value[i].Re /= this->top;
}

void FFT::get_result(){
    for(this->top = 1,this->length = 0;this->top < max(this->length1,this->length2);
		  this->top <<= 1,this->length++);
    this->top<<= 1;//����������ʽ��չΪ2���������� 
    this->length++;//��ָ�� 
    for(int i = 0;i < this->top;i++){//���������λ��ת���� 
        int index = 0;
        for(int j = i;j;j >>= 1)
            this->number[index++] = j & 1;
        for(int k = 0;k < this->length;k++)
            this->reverse[i] = (this->reverse[i] << 1) | this->number[k];
    }
    for(int i = 0;i < this->length1;i++)
        this->number1[this->length1 - i - 1] = data1[i] - '0';
    for(int i = 0;i < this->length2;i++)
        this->number2[this->length2 - i - 1] = data2[i] - '0';
    for(int i = 0;i < this->top;i++){
        this->complex1[i] = COMPLEX(this->number1[i]);
        this->complex2[i] = COMPLEX(this->number2[i]);
    }
    fft(this->complex1,1);
    fft(this->complex2,1);//DFT�任��ϵ��ʽת��ֵʽ 
    for(int i = 0;i < this->top;i++)
        this->complex3[i] = this->complex1[i] * this->complex2[i];//��ֵʽ����˷� 
    fft(this->complex3,-1);//��DFT�任 ��ֵʽתϵ��ʽ 
    for(int i = 0;i < this->top;i++)
        this->result[i] = this->complex3[i].Re + 0.5;
    for(int i = 0;i < this->top;i++){
        this->result[i + 1] += this->result[i] / 10;
        this->result[i] %= 10;
    }
    int final = this->length1 + this->length2 - 1;
    while(this->result[final] == 0 && final > 0)
        final--;
    for(int i = final;i >= 0;i--)
        putchar(result[i] + '0');
    putchar('\n');
}

