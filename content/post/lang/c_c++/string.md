---
author: "wuxingzhong"
title: "String"
date: 2019-10-11T19:00:23+08:00
draft: false
tags: ["c", "string"]
categories:  ["c"]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---

##  c string

注: C语言中没有字符串这个特定类型, C语言风格字符串:  以'\0'作为结束符

```c
//字符串必需有结束符'\0'
void main()
{
    char str[4] = { 'c', 'a', 'l', 'c' };//没有结束符'\0'
    printf("%s\n", str);  //遇到结束符'\0'才结束,没有结束符'\0',会越界读取内存,直到遇到'\0'
    char ss[4] = "calc";
    printf("%s\n", ss); //同理
    system("pause");
}

// 字符串修改字符
void main2()
{
    char str[10] = "taskoist"; //接收字符时开辟内存
    char *p = str;
    p = p + 4;
    *p = 'l'; //可以修改
    system(str);
    system("pause");
}

void main()
{
    char *p = "taskoist";
    char *ps = p;
    p = p + 4;
    *p = 'l';   //不可修改"taskoist"是字符串常量,
              //写入位置 0x00F9585C 时发生访问冲突。
    system(ps);
    system("pause");
}
// 字符串数组赋值注意:
void main(){
    //1.
    char stp[20] = "tasklist"; //可以 , 定义时初始化
    //2.
    char str[20];
    //str = "tasklist"; //错误 str是一个地址常量, 不可以字节赋值,
    //应该用
    strcpy(str,"tasklist");
    //或者
    sprintf(str,"%s","tasklist");
    //3.
    char *p;
    p = "tasklist";//可以,p指向的是一个字符串常量的地址
    //4 
    //char *strp=(char *)malloc(20*sizeof(char));
    printf("%x\n", strp);//b979c8   地址不同了
   //strp = "tasklist" //可以, 不过strp指向被改变了, malloc的内存无法free,将泄漏,绝对不能这样做
    printf("%x\n", strp);//135862
}
//字符串相加
//字符串相加
int main(){
    //法1.
    char str[20] = "";
    sprintf(str, "%s %s", "123","456");
    //法2.
    strcat(str,"789");
    fprintf(stdout,"%s\n",str); //123 456789
    system("pause");
    return 0;

}
//自己实现字符串相加, 求字符串长度的函数
#include<stdio.h>
#include<stdlib.h>
//实现字符串拼接函数
//获取计算字符串长度
int getstrlen(char *str){
    int len = 0;
    while(*str!='\0'){
       len++; //计数
       str++; //移动指针
    }
    return len;
}
void mystrcat(char *des, char *add){
    int deslen = getstrlen(des);
    int addlen = getstrlen(add);
    char *pstr = des; //变量备份
    pstr += deslen;   //移动指针
    for (int i = 0; i <=addlen; i++){//复制到'\0',包括'\0'
       *pstr = add[i];
       pstr++;
    }
}
//测试
int main(){
    char str[20] ="123";
    mystrcat(str,"456");
    printf("%s\n", str);
    system("pause");
    return 0;
}
string.h 字符串处理库
//字符串检索 ststr()
int main(){
    char allstr[200] = "i love you china!";
    char str[20] = "you";
    //没有找到返回null 找到返回查找的字符串在被查找字符串的第一个出现的位置的地址
    char *p = strstr(allstr,str);//查找字符串 
    if (p == NULL){
       printf("没有找到!!\n");
    }
    else{
       printf("%s\n",p); //you china!
    }
    system("pause");
    return 0;
}
//模拟字符串检索
//模拟字符串检索
//获取计算字符串长度
int getstrlen(char *str){
    int len = 0;
    while (*str != '\0'){
       len++; //计数
       str++; //移动指针
    }
    return len;
}
char *mystrstr(char *allstr, char *str){
    int alllen = getstrlen(allstr);
    int strlen = getstrlen(str);
    char *pall = allstr;
    char *pstr = str;
    char *recordpos = NULL;
    //匹配字符串为空返回NULL
    if (0 == strlen){
       returnNULL;
    }
    for (int i = 0,out=0; i<alllen; i++){
       //已匹配到str的末尾,匹配成功结束,退出
       if (*pstr == '\0'){
           recordpos = pall + out;
           break;
       }
       //剩余的字符串比匹配的短,匹配不成功,退出
       if (alllen-out < strlen){
            recordpos=NULL;
            break;
       }
       //如果匹配
       if (pall[i] == *pstr){
           //移动指针
           pstr++;          
       }else{
           //不匹配,从头开始
           pstr = str;
           //i从out开始往下匹配
           i = out;
           //out移动一个
           out++;
       }
    }
    return recordpos;
}
int main(){
    char allstr[200] = "i love yyyou china!";
    char str[20] = "you";
    //没有找到返回null 找到返回查找的字符串在被查找字符串的第一个出现的位置的地址
    char *p = mystrstr(allstr, str);//查找字符串
    if (p == NULL){
       printf("没有找到!!\n");
    }
    else{
       printf("%s\n", p); //you china!
    }
    system("pause");
    return 0;
}
//模拟字符串检索2
char * findstr(char *allstr, char *str)
{
    char *p = NULL;
    int allength = getstrlen (allstr);//获取母字符串的长度
    int  strlength = getstrlen (str); //获取子字符串的长度
    for (int i = 0; i < allength - strlength; i++)
    {
       int flag = 1;//标识假定字符串相等
       for (int j = 0; j < strlength; j++)
       {
           if (allstr[i + j] != str[j]) //判定字符是否相等
           {
              flag = 0;  //不等，跳出循环
              break;
           }
       }
       if (flag == 1) //如果为1，就是相等，
       {
           p = &allstr[i];
           break;//t跳出循环
       }
    }
    return p;
}
//模拟字符串检索3, 要求不用下标
char *pstrstr(char *allstr, char *str){
    char *pall ;
    char *pstr;
    char *recordpos = NULL;
    for (pall = allstr; *pall != 0; pall++){
       allstr = pall;
       for (pstr=str; *pstr != 0; pstr++){
 
           if (*allstr == *pstr){
              allstr++;
           }
           else{//不等退出,进行下一次从头开始查找
                break;
           }
       }
       //探测一下,如果前一个for是循环完成退出,说明找到
       if (*pstr== 0){
           //找到跳出
           recordpos = pall;
           break;
       }
    }
    return recordpos;
}


//去除首尾字符
char *trim(char *s/*in out*/){
    char temp[256];
    if (s == NULL){
       return NULL;
    }
    memset(temp, 0, sizeof(temp));
    char *ptou = s;
    char *pwei = (s + strlen(s)-1);

    while (*ptou== ' '&&ptou!=pwei){
           ptou++;
    }
    while (*pwei == ' '&&ptou != pwei){
       pwei--;
    }
    *(pwei + 1) = '\0'; //截断
    strcpy(temp, ptou);
    strcpy(s, temp);
    return s;
}
void  main()
{
    char str[100] = " 的 123 45 67 89  ";
    printf("---%s---\n", trim(str));
    system("pause");
}
```

## char *a && char a[]

用字符数组和字符指针变量都能实现字符串的存储和运算，但它们二者之间是有区别的，不应混为一谈，主要有以下几点。

- 字符数组由若干个元素组成，每个元素中放一个字符，而字符指针变量中存放的是地址（字符串第1个字符的地址），决不是将字符串放到字符指针变量中。
- 赋值方式。可以对字符指针变量赋值，但不能对数组名赋值。

```c
char *a; a = 'I love China!';   // 对
char str[14]; str[0] = 'I';     // 对
char str[14]; str = "I love China!"; // 错
```

### 初始化的含义

```c
char *a = "I love China！";    // 与
char *a; a = "I love China！"; // 等价
char str[14] = "I love China！"; 与
char str[14];
str[] = "I love China！";     //错误  不等价
```

### 存储单元的内容

编译时为字符数组分配若干存储单元，以存放各元素的值，而对字符指针变量，只分配一个存储单元

```c
char *a; scnaf("%s", a);   错
char *a, str[10];
a = str;
scanf("%s", a);      // 对
```

- 指针变量的值是可以改变的，而数组名代表一个固定的值(数组首元素的地址)，不能改变。

```c
int main()
{
    char *a = "I love China!";//不能改为char a[]="I love China!";
    a = a + 7;    printf("%s\n", a);   return 0;
}
```

- 字符数组中各元素的值是可以改变的，但字符指针变量指向的字符串常量中的内容是不可以被取代的。

```c
char a[] = "House", *b = " House";
a[2] = ’r’;        对
```

- 引用数组元数

```c  
对字符数组可以用下标法和地址法引用数组元素（a[5], *(a + 5)）。如果字符指针变量p = a，则也可以用指针变量带下标的形式和地址法引用（p[5], *(p + 5)）。
char *a = "I love China!";
则a[5]的值是第6个字符，即字母’e’
// 用指针变量指向一个格式字符串，可以用它代替printf函数中的格式字符串。
char *format;
format = "a = %d, b = %f\n";
printf(format, a, b);
// 相当于
printf("a = %d, b = %f\n", a, b);
```
