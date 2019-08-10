# Array & Vector 数组与向量

数组与向量通常是内存上一块连续的存储空间，用于存储相同类型的数据。数组与向量具有O(1)的查询复杂度，O(n)的增删复杂度。

## 向量

在vector.h中定义了向量类并实现了最基本的接口。这里由于使用了模板类而不能采用通常的声明与定义分离的模式。

#### 空间管理策略

向量是被良好封装的数组，其具有自动调整空间大小的性质。保持一定的空间利用率使得每当有数据加入时都有空间容纳同时避免大量未使用的空间浪费是空间管理策略的目标。

一种扩容的策略是每当当前向量空间不足时扩充确定大小的空间，这种策略的均摊复杂度为O(n)，且每次扩充的空间大小与减少空间的时机和策略都不易权衡。较常用的算法是时刻保持向量的空间利用率为25%到100%。扩容策略为没当当前空间不足时加倍当前的空间，当当前空间利用率低于25%时减半当前的空间。这种算法的均摊复杂度仅为O(logn)。

具体可参考`shrink`和`expand`私有成员函数。

#### 向量去重

向量去重的高效实现首先应当对向量排序，对于有序向量的去重处理可以在O(n)时间内完成，参考vector.h中的uniquify函数。对于无序向量采用find+remove接口的组合实现去重，为O(n^2)的复杂度，通常对应deduplicate接口。

在C++11 STL中的unique函数也是去重的实现，需要元素能够利用'=='运算符(自定义类型需重载该运算符)进行比较。使用实例如下：
```C++
vector<int> r;
// ...
std::sort(r.begin(), r.end());
auto last = std::unique(r.begin(), r.end());
r.resize(std::distance(r.begin(), r));// r.erase(last, r.end());
```

## 二分查找/折半查找(Binary Search)

向量或数组中对于特定元素的查找是常用的操作，针对**有序**序列二分查找是高效的查找策略，具有O(logn)的时间复杂度。

#### 查找策略

在有序区间[l, h)内查找元素e。
```c++
int binarySearch_A(vector<int> A, int e, int l, int h) {
	while (l < h) {
		int m = (l + h) >> 1;
		if (e < A[m])
			h = m;
		else if (A[m] < e)
			l = m + 1;
		else 
			return m;
	}
	return -1; //failure
}

int binarySearch_B(vector<int> A, int e, int l, int h) {
	while (1 < h - l) {
		int m = (l + h) >> 1;
		(e < A[m]) ? h = m : l = m;
	}
	return (e == A[m]) ? l : -1; 
}

int binarySearch_C(vector<int> A, int e, int l, int h) {
	while (l < h) {
		int m = (l + h) >> 1;
		(e < A[m]) ? h = m : l = m + 1;
	}
	return --l; 
}
```

三个版本的渐进复杂度都是O(logn)。版本A在命中时便返回，而版本B必须要到搜索区间为1时才结束，相比较而言，版本A在最好的情况下即命中能更快返回，但是当元素不命中时比较的次数比版本B更多，所以总体而言，版本B是比版本A更加稳定的算法。但是版本A与版本B都有一个不足，即当多个元素命中或查找失败时无法确定的返回某个特定元素。版本C中的算法则弥补了这一不足，成为更加符合算法目标的实现。版本C的算法当多个元素命中时会返回重复元素的秩最大者，即最后一个，当查找失败时则返回小于目标的最大元素。版本C的特性对于优化向量的插入十分适合。同理可以实现当多个元素命中时返回重复元素的秩最小者，查找失败时返回大于目标的最小元素的版本(array.cpp)。

针对版本A，其平均查找长度为1.5logn，在常数因子上还存在优化空间。注意到，版本A中的算法向左边缩小搜索空间只用了一次比较，而向右缩小搜索空间则用了两次比较，这种不均衡正是造成优化空间的因素。针对这个因素的优化即是Fibonacci查找，即每次比较的轴点不是二分整个区间，而是按照Fibonacci数列进行选择，这个轴点在整体向量中的划分比例为黄金分割比例，约为0.618。可以证明Fibonacci查找在常数因子上也已经是最优解，平均查找长度约为1.44logn。对Fibonacci查找的实现这里不再进行过多讨论。

#### C++ STL 查找类算法

C++ STL中查找类算法包括：count,find,binary_search,lower_bound,upper_bound,equal_range。其中count和find是对无序序列的算法，binary_search,lower_bound,upper_bound,equal_range都是基于二分查找的针对有序序列的算法。

- count：返回区间中等于给定对象的元素数目
- find：返回区间等于给定对象的元素的第一个位置
- binary_search：判断区间中是否存在等于给定对象的元素，返回bool型数据
- lower_bound：返回区间中不小于给定对象的第一个元素的位置
- upper_bound：返回区间中大于给定对象的第一个元素的位置
- equal_range：返回lower_bound与upper_bound的返回值构成的pair，即等于给定对象的元素区间

使用实例如下：
```C++
#include <algorithm>
#include <list>
#include <vector>
list<int> r; //vector<int> r;

if (std::count(r.begin(), r.end(), target)) {
// <=> if (std::count(r.begin(), r.end(), target) > 0)
// <=> if (std::find(r.begin(), r.end(), target) != r.end())
	//do something
} else {
	//do something
}

std::sort(r.begin(), r.end());
if (std::binary_search(r.begin(), r.end(), w)) {
	//do something
} else {
	//do something
}
```

## 练习

1. 二维有序数组的查找

在一个二维数组中，每一行都按照从左到右递增的顺序排序，每一列都按照从上到下递增的顺序排序。请完成一个函数，输入这样的一个二维数组和一个整数，判断数组中是否含有该整数。

结合二分查找的思路解决。参考代码见array.cpp。

2. 序列性质  

Given n non-negative integers representing an elevation map where the width of each bar is 1, compute how much water it is able to trap after raining.（给定n个非负整数表示宽度为1的阶梯的高度，计算下雨后的积水量，假设雨量充足。）例如：输入为：[0,1,0,2,1,0,1,3,2,1,2,1]，输出应为6。[题目链接](https://www.lintcode.com/problem/trapping-rain-water/description)

问题等价于将数组补成一个前非降后非增序列，中间有一个不一定唯一的极值。

3. 高精度乘法

类似C++的高级语言所支持的整数运算的位数是有限的，而Python语言中则支持大整数的运算，无论多少的整数都能够完成整数的基本运算。请使用C++或Java等语言实现大整数乘法。约定如下的输入输出格式与数据范围。题目来源于清华大学计算机系数据结构课程2016秋季学期PA1-1，参考代码为highPrecision.cpp。

```
输入:输入共包含n+1行，第1行包含一个整数n，表示你需要计算n组乘法。接下来n行，每行包含两个非负整数a和b。
输出:输出共包含n行，请对于每一组输入的a、b，输出他们的乘积。

输入样例

3
1 1
2 2
123123 789789

输出样例

1
4
97241191047

数据范围

n ≤ 500
a < 10^5000
b < 10^5000

资源限制

时间限制：1s
内存限制：256MB

```

4. 平面查找

小Q对计算几何有着浓厚的兴趣。他经常对着平面直角坐标系发呆，思考一些有趣的问题。今天，他想到了一个十分有意思的题目：首先，小Q会在x轴正半轴和y轴正半轴分别挑选n个点。随后，他将x轴的点与y轴的点一一连接，形成n条线段，并保证任意两条线段不相交。小Q确定这种连接方式有且仅有一种。最后，小Q会给出m个询问。对于每个询问，将会给定一个点P(Px,Py)，请回答线段OP与n条线段会产生多少个交点？题目来源于清华大学计算机系数据结构课程2016秋季学期PA1-4，参考代码为graphicSearch.cpp。对输入输出和数据规模做如下约定
```
输入:第1行包含一个正整数n，表示线段的数量；第2行包含n个正整数，表示小Q在x轴选取的点的横坐标；
第3行包含n个正整数，表示小Q在y轴选取的点的纵坐标；第4行包含一个正整数m，表示询问数量；
随后m行，每行包含两个正整数Px,Py，表示询问中给定的点的横、纵坐标。

输出:共m行，每行包含一个非负整数，表示你对这条询问给出的答案。

输入样例:
3
4 5 3
3 5 4
2
1 1
3 3

输出样例:
0
3

样例说明:
3条线段分别为：(3, 0)-(0, 3)、(4, 0)-(0, 4)、(5, 0)-(0, 5)
(0, 0)-(1, 1)不与他们有交点，答案为0。
(0, 0)-(3, 3)与三条线段均有交点，答案为3。

数据范围:
1 ≤ n ≤ 200,000
1 ≤ m ≤ 200,000
1 ≤ 横纵坐标 < 2^31

资源限制:
时间限制：1 s
内存限制：256 MB

```