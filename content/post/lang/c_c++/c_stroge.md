---
author: "wuxingzhong"
title: "储存类型"
date: 2019-10-11T19:00:21+08:00
draft: false
tags: ["c"]
categories:  [""]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---

## 储存类型

- auto
- static
- extern  :extern变量又称全局变量，放在静态存储区
- register

一个由C编译的程序占用的内存大致分为以下几部分：

- 栈区（stack）：由编译器自动分配释放，存放函数的参数值，局部变量的值等。
- 堆区（heap）：一般由程序员分配释放（动态内存申请与释放），若程序员不释放，程序结束时可能由操作系统回收。
- 全局区（静态区）（static）：全局变量和静态变量的存储是放在一块的，初始化的全局变量和静态变量在一块区域，未初始化的全局变量和未初始化的静态变量在相邻的另一块区域，该区域在程序结束后由操作系统释放。
- 常量区：字符串常量和其他常量的存储位置，程序结束后由操作系统释放。
- 程序代码区：存放函数体的二进制代码。

若要禁止某个函数被其他C文件用extern关键字方式扩展过去访问，可以在定义此函数时用static关键字限制。
此函数就成了内部函数。

外部函数(从其他文件extern 过去的函数)

### 内部函数

```c
//1.c
externvoid secret();
externvoid public();_int main()_{
    secret();  //错误
    public(); //正确
    return 0;
}
//2.c
static void secret()//内部函数
{
    …//此函数只能本文件中访用
}
void public()
{
    …//此函数其他文件也能访问
}
```

### 全局变量定义

基本格式为：

```bash
    extern 类型 变量名 = 初始化表达式;
```

此时，初始化表达式不可省略，此指令通知编译器在静态存储区中开辟一块指定类型大小的内存区域，用于存储该变量。
下列语句创建了一个初始值为100的int型全局变量m：
extern int m = 100;
C语言规定，只要是在外部，即不是在任何一个函数内定义的变量，编译器就将其当作全局变量，无论变量定义前是否有extern说明符。也就是说，只要在函数外部书写下述形式即可：
int m=100;

当全局变量定义时，当且仅当省略了extern时，初始化表达式才可省略，系统默认将其初始化为0，对于定义的全局数组或结构，编译器将其中的每个元素或成员的所有位都初始化为0。

```c
void main(void)   /*主函数*/
{
    { externint x;/*声明全局变量x*/
    printf("x is %d", x);    /*可以访问*/
    }
    printf("x is %d", x);/*错误，找不到x*/
}
int x = 5;
```

### Static静态变量

tatic变量又称静态变量，是种特殊的变量，近乎一种折衷。此类变量也存放在静态存储区，一旦为其分配了内存，则在整个程序执行期间，他们将固定地占有分配给它们的内存。和extern变量不同的是，static变量只有定义，没有声明

用static 声明一个变量的作用是：

- 对局部变量用static声明，把它分配在静态存储区，该变量在整个程序执行期间不释放，其所分配的空间始终存在。

- 对全局变量用static声明，则该变量的作用域只限于本文件模块(即被声明的文件中)。

```c

int fun(inta)                //a是自动变量
{
    int b = 0;             // b是自动变量，调用后重新赋值
    staticint c = 3;    // c是静态变量，编译就赋值
    b++;
    c++;
    return (a+b+c);
}
int main()
       {
    int x=2, i;
    for (i = 0; i < 3; i++){
       printf("%d\n", fun(x));
    }
    //结果: 7, 8 9
    system("pause");
    return 0;
}
```
