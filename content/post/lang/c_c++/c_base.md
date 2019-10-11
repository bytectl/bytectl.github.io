---
author: "wuxingzhong"
title: "C_base"
date: 2019-10-11T19:00:19+08:00
draft: false
tags: ["c"]
categories:  [""]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---

## c base

### printf使用(不会进行数据类型转换)

```c
#include<stdio.h>
#include<stdlib.h>
void main()
{
    int x = 123456;
    printf("%d", x);
    //以m指定的字段宽度输出，如果数据的位数
    //小于m，则左端补以空格；如果大于m按照实际宽度
    printf("\n%15d", x);//限定宽度
    printf("\n%16d", x);
    printf("\n%4d", x);
    printf("\n%04d", x);
    printf("\n%016d", x); //如果右边对齐有0，而且大于实际宽度，填充0
    printf("\n%-16d", x); //-左边对齐
    printf("\n%-016d", x); //-有0会被忽略
    //%d->int,%ld->long是一样的
    printf("\n%d,%ld", x, x);
    system("pause");
}
```

### 补码, 反码,赋值

```c
#include<stdio.h>
void main2()
{
    //赋值运算符的本质就是拷贝二进制数据
    int x = 4294967295;
    printf("%x", &x);
    //1111 1111 1111 1111 1111 1111 1111 1111
    printf("%d,%u,%x", x, x, x);
    getchar();
}

void main1()
{
    int x = -1;
      //-1的补码 1111 1111 1111 1111 1111 1111 1111 1111 
    printf("%x", &x);
    //printf   不管是什么类型，吧二进制按照自己的方式来解析
    printf("%d,%u,%x", x, x, x); //-1   4294967295  ffffffff
    //负数是补码，只有有符号的数据才有符号位
    //1000 0000 0000 0000 0000 0000 0000 0001  原码
    //1111 1111 1111 1111 1111 1111 1111 1110  反码
    //1111 1111 1111 1111 1111 1111 1111 1111  补码
 
    //%d，第一个符号位     -1
    //1111 1111 1111 1111 1111 1111 1111 1111  补码
    //1111 1111 1111 1111 1111 1111 1111 1110  反码
    //1000 0000 0000 0000 0000 0000 0000 0001  原码
 
    //%u是无符号
    //1111 1111 1111 1111 1111 1111 1111 1111
    //4294967295
 
    //%x
    //1111 1111 1111 1111 1111 1111 1111 1111
    // f   f    f     f    f    f    f   f
    getchar();
}
```

### 小应用格式化输出(文本左右对齐)

```c
#define   _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<stdlib.h>
void main()
{   char name1[20] = "吴兴中";
    char name2[20] = "曹  崟";
    char phone1[20]= "10086";
    char phone2[20] = "13599840407";
    char addr1[20] = "湖南科大";
    char addr2[20] = "湖南科技大学北校区";
    //左对齐输出
    printf("---------------左对齐------------\n\n");
    printf("%-10s%-20s%-25s\n\n", "姓  名", "手机号码", "所在地址");
    printf("%-10s%-20s%-25s\n\n", name1, phone1,addr1);
    printf("%-10s%-20s%-25s\n\n", name2, phone2, addr2);
 
    //右对齐输出
    printf("---------------右对齐------------\n\n");
    printf("%10s%20s%25s\n\n", "姓  名", "手机号码", "所在地址");
    printf("%10s%20s%25s\n\n", name1, phone1, addr1);
    printf("%10s%20s%25s\n\n", name2, phone2, addr2);
    system("pause");
 
}
```

### %m.nf ,%m.ne,%g

```c
#include<stdio.h>
#include<stdlib.h>
void main()
{
    printf("%05.2f\n",2.0);//%0m.nf 总共输出m列, 不足m前面补0 (其中.占一位)
    printf("%010.2e\n", 20.0);//%0m.ne科学计数法表示, 不足m前面补0(其中.e+各占用一位)
    printf("e=%e\nf=%f\ng=%g\n", 1000000.0, 1000000.0, 1000000.0);
    printf("e=%e\nf=%f\ng=%g\n", 12.34567, 12.34567, 12.34567);
    //%g输出时,按照宽度最小输出,去除无意义的0;
    //%g会以%f或者%e格式输出,并且在输出时去除无意义的0
    printf("%e\n", 200); //输出为不定数    200是整型,printf不进行格式转换
    system("pause");
}
```

### printf需要一一对应

```c
void main()
{    
    printf("%f,%f,%d\n", 3.14f, 3,3); //3.140000,0.000000,8788589   从出错的那个开始, 后面全部出错
    printf("%d,%d,%d,%d,%d,%d,%d,%d\n");//垃圾数据
    printf("%d\n", 1, 2, 3); //少了,后面的不输出,(说明:编译能通过,结果不一定正确)
    system("pause");
}
```

### %大小写字母

```bash
    %D,%O,%U 直接输出D,O,U 
    %F,%S输出为空
    %x,%e,%g 影响输出字母的大小写
    %c,%C 无影响
```

```c

void main()
{
    //%D,%O,%U 直接输出D,O,U %F输出为空
    printf("%2D\n", 1); //D %d对应整数, %找不到对应时, 直接输出后面的字符串D (不包括m.n)
    printf("%O\n", 20); // O
    printf("%22U\n", 50);  //U  printf("%二位\n", 50);  //二位
    printf("%4.3F\n",2.0); // 输出为空   特殊:F 不输出
    printf("%S\n","abc"); // 输出为空   特殊:S 不输出

    // %X和%x, 影响16进制的大小写 %X大写 %x小写
    printf("%X\n", 15);    // F 不影响16进制,影响ABCDEF的输出(以大写输出)
    printf("%x\n", 15);    // f  大于10的数,以abcdef(小写输出)
    //%e和%E %E 其中E次幂的E大写, %e e小写
    printf("%E\n", 2.0);  //E大写
    printf("%e\n", 2.0);  //e小写

    //%g和%G 指数输出时 影响E的大小写
    printf("%G\n", 200000.1);
    printf("%g\n", 200000.1); 

    //%c和%C,无影响
    printf("%C\n",50);
    printf("%c\n", 50);  

    system("pause");
}
```

### sprintf拼接,截取字符串

```c
#define   _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<stdlib.h>
void main()
{
    /*
    %s     直接输出字符串
    %ms    输出字符占m列,右对齐
    %-ms   输出字符占m列,左对齐
    %m.ns  输出字符前n个,输出字符占m列,右对齐
    */
    char str[20] = "notepad111231234344";
    char str2[30];
    sprintf(str2, "%.7s", str);
    printf("echo%10s\n", str2);
    system("pause");
}
```

### printf,sprintf注意事项

```c
//一个解析失败后面的也将解析失败
void main(){
    printf("%f,%d\n", 1, 2); //结果 0.000000,0
    printf("%d,%f,%d\n", 1, 2, 2); //1,0.000000,0
                  //printf不会进行类型转换.
                  //一个解析错误, 后面的也会解析错误
    char str[100];
    sprintf(str,"%f,%d\n", 1, 2); //sprintf同printf
    printf(str);  //0.000000, 0
    system("pause");
   
}
```

### sancf,sscanf使用

- scanf(格式控制,地址表) sscanf(数据源,格式控制,地址表)
- sscanf用法同sancf,只用数据源不同, scanf默认数据源为键盘输入

```c
#define   _CRT_SECURE_NO_WARNINGS  //scanf_s  safe   scanf 不安全
#include<stdio.h>
#include<stdlib.h>
//cd  路径   1.exe<input.txt>output.txt
void main2()
{
    char str[50];
    scanf("%s", str);
    printf("%x", str);
    system(str);
}
void main1()
{
    int num;   //次数
    char strurl[30];//指令
    scanf("%d%s", &num, strurl);//扫描格式化数据初始化num,strurl
    printf("num=%d,strurl=%s", num, strurl);
    char str[50];
    sprintf(str, "for /l %%i  in (1,1,%d) do  %s", num, strurl);
    system(str);
    system("pause");
}
```

```c
#define  _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<stdlib.h>
//sscanf
void main(){
    char str[20]="吴兴中男 22";
    char name[10];
    char sex[4];
    int  age = 0;
    sscanf(str,"%s%s%d",name,sex,&age);
    printf("%s,%s,%d\n", name,sex,age); //吴兴中,男,22
    system("pause");
}
//%f
void mainf(){
    float f=0.0;
    scanf("%7.3f",&f); //操作无效, 不能指定精度
    printf("%f\n",f); //0.000
    system("pause");
}
 
//%md 截取 %其他完全一致
void main33(){
    int num;
    int num2;
    scanf("%2d%d", &num,&num2); //输入 1234
    printf("num=%d,num2=%d\n", num,num2); //输出 num=12, num2 = 34
    system("pause");
}
//*号,抑制符
void main22(){
    int  num1 =0;
    int  num2 =0;
    int  num3 = 0;
    //%*d抑制一次输入,可以在读取文本忽略某个值时使用
    scanf("%d   %*d %d", &num1,&num2,&num3); 
    //抑制一次,&num3可不写,本身不会被赋值没意义
    //格式控制表中的空白符 ,制表符会被忽略
    printf("num1=%d\n", num1);
    printf("mun2=%d\n", num2);
    printf("mun3=%d\n",num3);
    //输入123 123
    //输出123,123, 0
    system("pause");
}
//long long
void main11()
{
    long lg;
    scanf("%d", &lg); //%d,long和int等价
    printf("lg=%d\n", lg);

    longlong ll; //嵌入式的场合 long ,long long都要%ld
                  //32位以上的%d就行
    scanf("%ld", &ll);
    printf("ll=%ld\n", ll);
    system("pause");
}
//double
void maindb()
{
    double db = 1.0;
    scanf("%lf",&db); //%f,对double无效,应该用%lf
    printf("db=%f\n",db);
    system("pause");
}
```

### 小应用文本查看器(文本复制) #输入,输出重定向

```c
#define   _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<stdlib.h>
//cd  路径  view.exe<input.txt>output.txt
//scanf_s  safe
void main()
{
    char str[100];
    //向屏幕(文本: 在命令行中用重定向符号>或< )输出所有文字
    while (scanf("%s", str) != EOF){
       printf("%s\n", str);
    }
  /* 行带空格时应该用gets()
    while (gets(str) != EOF){
       puts(str);
    }
  */
}
```

### puts(),gets()

```c
void main()
{  
    //自动换行
    puts("12345");
    //手动换行
    printf("12345\n");
    char str[50];
    gets(str); //可以获取空格,以回车作为结束接收标志.
    system("pause");
}
```

### 混合编程

```c
#include<stdio.h>
#include<stdlib.h>

//sscanf
void main(){
    int num = 1;
    while (1){
       _asm{
           mov eax, num;
           add eax, 1;
           mov num, eax;
       }
       printf("%d\n",num);
    }
    system("pause");
}
```

### 答疑

```c
//汉语
void main(){
    //bool b; C语言没有Bool类型, c++有
    //汉字占两个字节
    printf("%d\n",sizeof('吴')); //4  c语言规定字符常量占4个字节
    printf("%d\n", sizeof("吴")); //3  汉字占2个字节,字符串结尾'\0'占一个字节
    system("pause");
}
//块语句,同名变量作用范围
//同一个区域,同一个块语句变量不能同名
int a = 33;   //编译时为 all-a
void main(){
    int a = 1; //main-a
    //块语句
    {   printf("%d\n", a); //1 编译器从上往下开始编译
       int a = 2; // main1-a
       printf("%d\n", a); //2同一个区域,找到了变量,覆盖了全局(就近原则)
    }
    printf("%d\n",a);  //1
    system("pause");
}

```
