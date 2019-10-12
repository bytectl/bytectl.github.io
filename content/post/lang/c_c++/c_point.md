---
author: "wuxingzhong"
title: "C_point"
date: 2019-10-11T19:00:21+08:00
draft: false
tags: [""]
categories:  [""]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---

## c指针

- 改变一个变量，需要这个变量的地址
- 如果变量是数据，就需要指针    保存变量的地址
- /如果是指针，就需要二级指针保存指针变量的地址

指向行的指针 (指向n-1维的数组指针)

```c
int main()
{
    int m[4][3] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 };
    //第一一个指向二维数组的行指针
    // 定义一个指向这个二维数组的行指针只要将 int m[x][y]中的m[x]换成 (*p) 注意括号就行了 
    int (*p)[3] = m;
    //这样 p[x][y] 就能访问m里的值了
    //一个变量循环法
    for (int i = 0; i < 4 * 3; i++){
       printf("%2d ", p[0][i]);
       if ((i + 1) % 3 == 0){
           printf("\n");
       }
    }
    //三维
    int m2[2][3][2] = {1,2,3,4,5,6,7,8,9,10,11,12};
    //指向三维行的行指针换m2[2] 为 (*pp) 注意要括号
    int(*pp) [3][2]  = m2;
 
    for (int i = 0; i < 2*3*2; i++){
       printf("%2d ", pp[0][0][i]);//在内存中顺序排放的..
       if ((i + 1) % 2 == 0){
           printf("\n");
       }
       if ((i + 1) % 6 == 0){
           printf("\n");
       }
    }
    // n维同理
 
    system("pause");
    return 0;
}
```
函数传递参数时.(形参定义 为相应维数的指针,或者同样的大小的数组)

```c
//int a;
//void go1(int *p);
//二维
//int a[3][4];
void go20(int(*p)[4]){
    printf("%d\n", p[2][3]);
};
//void go21(int *p[4]); //错误这个是 *(p[4]) 是四个列指针
 
void go22(intp[][4]){
    printf("%d\n", p[2][3]);
};
void go23(intp[3][4]){
    printf("%d\n", p[2][3]);
};
 
//int a[1][2][3] 同理 void go(int p[][2][3])
int main()
{
    int a[3][4] = {1,2,3,4,5,6,7,8,9,10,11,12};
    go20(a);
    go22(a);
    go23(a);
    system("pause");
    return 0;
}
```

指针数组

```c
int main()
{
    int *p[4]; //这个是 *(p[4]) 是4个指针,指向一个变量(或者1列)如同 m[4],将m换成*p
    int m[4] = { 1, 2, 3, 4 };
    p[0] = &m[0];
    p[1] = &m[1];
    p[2] = &m[2];
    p[3] = &m[3];
    printf("%d\n", p[0][0]);
    printf("%d\n", p[1][0]);
    printf("%d\n", p[2][0]);
    printf("%d\n", p[3][0]);
    system("pause");
    return 0;
}
```

指向函数地址的指针

```c
void fun(int a,int b){
    printf("%d\n", a + b);
}
int main()
{
    //void fun(int a,int b)
    //定义一个函数指针,只要将函数名换成fun  换成(*p)注意括号,其他不变;
    void (*p)(int b, int v); //形参名称可以不同, 类型必须相同
    p = fun; //绑定到函数
    p(3,4);  //将指针变量当成函数名调用函数就行
 
    system("pause");
    return 0;
}
```

应用:(一个函数动态的调用另一个函数,(前提:函数的参数和返回值定义相同 ))

```c
//做加法
void add(int a,int b){
    printf("%d\n", a + b);
}
//做乘法
void chen(int a, int b){
    printf("%d\n",a*b);
}
//计算器   (*fun) 注意要括号
void jisuanqi(void (*fun)(int xa, int xb), int a, int b){
       fun(a,b);
}
int main()
{   //jisuanqi这个函数动态的调用外部函数add 和chen
    jisuanqi(add, 3, 4); // 7
    jisuanqi(chen, 3, 4);// 12
    system("pause");
    return 0;
}
```

指针大小

```c
void main(){
    int *p;
    int **pp;
    char *c;
    double *d;;
    void(*f)(int a, int b);
    //所有指针,在32位系统下,都是占用4个字节, 32位
    printf("%d\n", sizeof(p));//4
    printf("%d\n", sizeof(pp));//4
    printf("%d\n", sizeof(c));//4
    printf("%d\n", sizeof(d));//4
    printf("%d\n", sizeof(f));//4
    system("pause");
}
```

三级指针

```c
#include<stdio.h>
#include<stdlib.h>
int a = 10;
int *p1 = &a;
int b = 101;
int *p2 = &b;  //全局变量
//C程序分配给全局变量内存以后，才启动main函数。
 
void change(int **pp)  //新建一个二级指针，指向P2 ,
//不会改变原来的
{
    pp = &p2;
    printf("\nchangepp=%x", &pp);
}
  
void changeA(int *** ppp)
{
 
    *ppp = &p2;
}
 
void main()
{
    int **pp = &p1;
    printf("\nmain pp=%x", &pp);
    //change(pp);
    changeA(&pp);
    printf("\n%d", **pp);
    getchar();
}
```

指针外挂应用

```c
#include<stdio.h>
#include<stdlib.h>
#include<windows.h>
//靶子程序
void print(){
    printf("我是靶子程序的print,别人调用我\n");
    system("title 马化腾请吃饭");
    system("color 3f");
}
int add(int a, int b){
    printf("加法计算器!\n");
    returna + b;
}
void main()
{
    int  num1 = 2015;
    int num2 = 400;
    int *p1= &num1;
    int *p2 = &num2;
    int **pp = &p2;
    char str[5] = { 'A', 'B', 'C', 'D', 'E' };
    char *pch = str;
    while (1)
    {
       printf("\n\n");
       printf("print=%x,add=%x\n", print, add);
       printf("num1=%x,num2=%x\n", &num1, &num2);
       printf("&p1=%x,&p2=%x,&pp=%x,&pch=%x,str=%x\n", &p1, &p2, &pp, &pch, str);
       printf("\n");
       printf("num1=%d\n", num1);
       printf("num2=%d\n", num2);
       printf("*p1=%d\n", *p1);
       printf("**pp=%d\n", **pp);
       printf("str=%c\n", *pch);
       Sleep(12000);
    }
 
    system("pause");
}
```

dll动态库

```c
//指针外挂函数
#include<stdio.h>
 
_declspec(dllexport) go2(){
    //num1=96f880,num2=96f874&p1=96f868,&p2=96f85c,&pp=96f850,&pch=96f834,str=96f840
    int *p = (int *)0x96f880; //num1
    int **pp = (int **)0x96f85c; //p2
    int ***ppp = (int ***)0x96f850;   //pp
    char **c = (char  **)0x96f834; //pch
    char **str = (char **)0x96f840;
    *p = 11;
    int num = 20;
    *pp = &num;
 
}
 
_declspec(dllexport) go1()
{

    void(*pri)();
    int(*ad)(int a, int b);
    pri = (void(*)())0x1051096;
    ad = (int(*)(int, int))0x10510f5;
     //调用pri 和ad 所指向的函数
    printf("add=%d\n", ad(3,4));
    pri();

}
#include<Windows.h>
#include<stdio.h>
#include<stdlib.h>
//外挂
//改变一个数据，需要数据的地址，也就是指针，int需要int*
//改变一个指针变量，需要指针的地址，二级指针，int*需要int **
//改变一个二级指针，需要二级指针的地址，三级指针，int**需要int ***
//改变一个指针，指针指向数组，需要指针的地址，数组的首地址
//函数指针，找到地址，进行类型转换，调用函数。

_declspec(dllexport) goB()
{
    int *p1 = (int *)0x2ef86c;//改变两个变量
    int *p2 = (int*)0x2ef860;
    *p1 = 10000;
    *p1 = 2147483647;
    int **p3 = (int **)0x2ef854;
    *p3 = (int *)0x2ef860;     //改变指针
 
    int ***p4 = (int ***)0x2ef83c;
    *p4 = (int **)0x2ef848;
 
    char **pp = (char **)0x2ef820;
    *pp = (char *)(0x2ef82c + 0x1);
 
 
}
 
_declspec(dllexport) goA()
{
    int(*p)(int, int);
    p = (int(*)(int, int))0xd010f0;
    printf("%d", p(10, 30));
 
 
}
_declspec(dllexport) go()
{
    //void msg();
 
    while (1)
    {
       void(*p)();
       p = (void(*)())0xd91122;
       p();
 
    }
 
}
```

外挂原理:

地址操作系统管理,进程的首地址是变动的, 变量地址相对首地址是 固定的

所以只要分析出首地址, 根据相对地址找到变量地址和函数地址


地址相加减注意(依赖于指针的类型)

```c

int main(int sum,char *args[]){
    double d[10];
    //指针的减法
    printf("%d\n", &d[9] - &d[3]); //6 因为&d[9]和&d[3]都是地址,&d[3]+6=&d[9]
    int a[] = { 1, 2, 3, 4, 5 };
    int *p = a;
    //printf("%d\n",*++p);//2, ++的优先级高于*
    printf("%d\n", (*p)++); //1 相当于a[0]加了1
    printf("%d\n", a[0]);   //2
    system("pause");
    return 0;
}
void main41()
{
    double a[10] = { 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 0.0 };
    printf("%d", &a[9] - &a[3]);
    printf("\n%f", *(&a[3] + 2));
    //指针的减法
    //(0x300500+9*8- 0x300500+3*8)/sizeof(double)
    //指针的加法
    // 0x300500+3*sizeof(double)
    getchar();
}
void main4()
{
    //指针与整数不能直接赋值，如果需要赋值，强制类型转换
    int *p = (int *)1234;
    //int *p = (int *)01234;
    //int m = (int)&p;
}
 
void main()
{
    double a[10] = { 11, 2, 13, 4, 15, 6, 17, 8, 19, 0 };
    double *p = a;
    //printf("\n%f", *p++);//11，根据指针取出内容,指针自增
    //printf("\n%f", *++p);//2 先自增指针，再取出内容
    printf("\n%f", ++*p);//先取出内容，然后自增
    //都是改变指针，自增，数据没有改变，
    printf("\n%f", a[0]);
 
    //printf("%f", *(p + 3)); //指针的加法
    //printf("%f", *p + 9); //数据加法

    //printf("%d", sizeof(*p)); //数据类型
    //printf("\n%d", sizeof(*p++));//double类型
    //printf("\n%d", sizeof(p)); //指针类型
    //printf("\n%d", sizeof(p++)); //指针类型
 
    //printf("%f", ++(*p));  *p是数据，数据自增
    //printf("\n%f", a[0]);
    //printf("%f", (*p)++);  //*p是数据，数据自增
    //printf("\n%f", a[0]);
    getchar();
}
```

二维数组与高级指针

```c
#include<stdio.h>
#include<stdlib.h>
void   main11()
{
    int a[3][4] = { { 1, 2, 3, 4 },
    { 5, 6, 7, 8 },
    { 9, 10, 11, 12 } };
    int(*p)[4] = a;
 
    //a是一个常量指针
 
    //printf("\n%x,%x", main, &main);  //c31154,c31154 相同
    //函数名实际上就是地址，取函数地址，函数名会解析为取函数地址
    printf("\n%x,%x", a, &a);  //5afab0,5afab0 相同
    //数组名，数组名实际上就是地址，数组名会取数组的地址，
    printf("\n%x,%x", p, &p); //变量指针 , 5afab0,5afaa4 不同
 
    getchar();
 
}
void main12()
{
    int a[3][4] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 };
    //int *p = a;  “初始化”: 无法从“int [3][4]”转换为“int *”
    //int **p = a; 无法从“int [3][4]”转换为“int **”
    int(*p)[4] = a;   //一个指针指向一个有四个元素一维数组,
    printf("%d,%d\n", sizeof(p), sizeof(*p));//4,16
    printf("%d,%d,%d\n", p, p + 1, p + 2);//行指针，每移动一个，一行的大小
    printf("%d,%d,%d\n", p[0], p[1], p[2]);
    printf("%d,p[0]=%d\n", sizeof(p), sizeof(p[0]));//4,p[0]=16
    getchar();
}
 
void main()
{
    int a[3][4] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 };
    printf("a=%d\n", sizeof(a));//数组大小。a=48
    printf("*a=%d\n", sizeof(*a)); //*a=16
    printf("*a+0=%d\n", sizeof(*a + 0)); //*a+0=4 相当于*(a+0)+0 列指针
    int(*p)[4] = a;//用一个指向有四个元素的一维数组的指针指向a
    printf("\np=%d,*p=%d,*p+0=%d\n", sizeof(p), sizeof(*p), sizeof(*p + 0));
    //p=4,*p=16,*p+0=4
    // p行指针
    // *p取出行指针内容，可以得到一行多大
    //*p+0，列指针;//在某一行，取出第0个元素的地址 ,就是int类型

    char str[10] = "calc";   //str会被解析为地址
    //system((const char *)&str);
    //system(str);
    getchar();
}
 
#include<stdlib.h>
void main12313()
{
    //第一个下标挖掉，数组名替换成(*p)
    //指针指向二维数组
    int a1[10];
    int *px = a1;

    int a[10][9];
    int(*p)[9] = a;
 
    int b[3][4][5];
    int(*p1)[4][5] = b;

    int c[1][2][3][4];
    int(*p2)[2][3][4] = c;
 
}
```
