---
author: "wuxingzhong"
title: "C 运算符"
date: 2019-10-11T19:00:20+08:00
draft: false
tags: [""]
categories:  [""]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---

## 汇编语言&C语言混合编程

```c
#include<stdio.h>
#include<stdlib.h>
void main()
{
    int num=5;

    //插入汇编语言
    _asm{
       mov eax,num
       add eax,5
       mov num,eax

    }
    printf("%d\n", num);
    system("pause");
}
```

## +,-

```c
#include<stdio.h>
#include<stdlib.h>
void main()
{
    int num = 5 * +4;  //新版编译器将+ -当成正负,运算通过
    int num2 = 5 * -3;
    printf("%d\n", num); //20
    printf("%d\n", num2);// -15
    system("pause");
}
```

## 取模(%)运算

```c
#include<stdio.h>
#include<stdlib.h>
void main()
{
    //正数取模为正数,0 负数取模为负数,0
    printf("5%%3=%d\n", 5 % 3); 
    printf("5%%-3=%d\n", 5 % -3);
    printf("-5%%3=%d\n", -5 % 3);
    printf("-5%%-3=%d\n", -5 % -3);
    printf("3%%5=%d\n", 3% 5);
    printf("3%%-5=%d\n",3%-5);
    printf("-3%%5=%d\n", -3% 5);
    printf("-3%%-5=%d\n", -3% -5);
    system("pause");
}
//模拟取模运算
#include<stdio.h>
#include<stdlib.h>
int mod(int a, int b);
void main()
{
    //正数取模为正数,0 负数取模为负数,0
    printf("--------模拟取模测试--------\n");
    printf("5%%3=%d\n", mod(5 , 3) );
    printf("5%%-3=%d\n", mod(5 , -3) );
    printf("-5%%3=%d\n", mod(-5 , 3) );
    printf("-5%%-3=%d\n", mod(-5 , -3) );
    printf("3%%5=%d\n", mod(3, 5));
    printf("3%%-5=%d\n", mod(3, -5));
    printf("-3%%5=%d\n", mod(-3, 5));
    printf("-3%%-5=%d\n", mod(-3, -5));
    system("pause");
}
int mod(int a, int b){
    while (abs(a) > abs(b)){
       a = a - (a / b)*b;
    }
    return a;
}
```

### 模拟_itoa函数

```c
#include<stdio.h>
#include<stdlib.h>
//16进制(包括16)以内转换
void my_itoa(char *str,int num, int jz);
//反转两个字符
void rechar(char *c1, char *c2);

void main()
{
    //正数取模为正数,0 负数取模为负数,0
    char str[100];
    my_itoa(str,100888,16);
    printf("str=%s\n",str);
    system("pause");
 
}
void my_itoa(char *str,intnum, intjz){
    if (jz > 16){
       str[0] = '\0';
       return;
    }
    int i = 0;
    char table[]= { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
    //除n取余法
    while (num != 0){
       str[i++] = table[num % jz];
       num = num / jz;
    }
    str[i] = '\0';

    //快速反转法
    int j = 0;
    i--;
    //反转
    while(j<i){
       rechar(&str[j], &str[i]);
       //相互靠近
       j++;
       i--;
    }
}
void rechar(char *c1,char *c2)
{   //相同的不换,不然^运算后会变0
    if (*c1 == *c2){
       return ;
    }
    *c1 = *c1^*c2;
    *c2 = *c1^*c2;
    *c1 = *c1^*c2;
}
```

### ++, --

(1)++, -- 运算符优先级高于乘法.

(2)表达式不能用于++, --

```c
//左右值
void main()
{
    int x = 10;
    x = 5;//x可以被赋值，放在等号的左边被赋值就是左值
    //5右值，能放在等号右边的值就是右值
}

int main(void)
{   int arr[] = { 6, 7, 8, 9, 10 };
    int *ptr = arr, a = 2;
    //(ptr++)
    *(ptr++) += 123;
    //129 7 8  9 10
    //ptr 指针指向 7
    printf("%d,%d\n", *ptr, *(ptr++));// 8 ,7
    //函数参数从右到左入栈 所以先自信*(ptr++) 结果为7 指针指向 8  所以*ptr为8
    system("pause");
    return 0;
}
```
