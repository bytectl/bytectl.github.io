---
author: "wuxingzhong"
title: "Lua"
date: 2019-10-11T19:05:28+08:00
draft: false
tags: [""]
categories:  [""]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---

## lua 简介

Lua 是一种轻量小巧的脚本语言，用标准C语言编写并以源代码形式开放， 其设计目的是为了嵌入应用程序中，从而为应用程序提供灵活的扩展和定制功能。
Lua 是巴西里约热内卢天主教大学（Pontifical Catholic University of Rio de Janeiro）里的一个研究小组，由Roberto Ierusalimschy、Waldemar Celes 和 Luiz Henrique de Figueiredo所组成并于1993年开发。

## 设计目的

其设计目的是为了嵌入应用程序中，从而为应用程序提供灵活的扩展和定制功能。
## Lua 特性

- 轻量级: 它用标准C语言编写并以源代码形式开放，编译后仅仅一百余K，可以很方便的嵌入别的程序里。
- 可扩展: Lua提供了非常易于使用的扩展接口和机制：由宿主语言(通常是C或C++)提供这些功能，Lua可以使用它们，就像是本来就内置的功能一样。
- 其它特性:
    - 支持面向过程(procedure-oriented)编程和函数式编程(functional programming)；
    - 自动内存管理；只提供了一种通用类型的表（table），用它可以实现数组，哈希表，集合，对象；
    - 语言内置模式匹配；闭包(closure)；函数也可以看做一个值；提供多线程（协同进程，并非操作系统所支持的线程）支持；
    - 通过闭包和table可以很方便地支持面向对象编程所需要的一些关键机制，比如数据抽象，虚函数，继承和重载等。

## Lua 应用场景

- 游戏开发
- 独立应用脚本
- Web 应用脚本
- 扩展和数据库插件如：MySQL Proxy 和 MySQL WorkBench
- 安全系统，如入侵检测系统

### Lua 环境安装

### Linux 系统上安装

Linux & Mac上安装 Lua 安装非常简单，只需要下载源码包并在终端解压编译即可，本文使用了5.3.0版本进行安装：

```bash
curl -R -O http://www.lua.org/ftp/lua-5.3.0.tar.gz
tar zxf lua-5.3.0.tar.gz
cd lua-5.3.0
make linux test
make install
```

### Mac OS X 系统上安装

```bash
curl -R -O http://www.lua.org/ftp/lua-5.3.0.tar.gz
tar zxf lua-5.3.0.tar.gz
cd lua-5.3.0
make macosx test
make install
```

接下来我们创建一个 HelloWorld.lua 文件，代码如下:

```lua
print("Hello World!")
```

执行以下命令:

```bash
lua HelloWorld.lua
```

脚本编程

```lua
#!/usr/bin/lua

print("hello,lua!!!")
```

执行

```bash
./hello.lua
```

## lua基本语法

### 注释

#### 单行注释  

两个减号是单行注释:

```lua
-- 注释内容
```

#### 多行注释

```lua
--[[
 多行注释
 多行注释
 --]]
```

#### 标示符  

Lua 表示符用于定义一个变量，函数获取其他用户定义的项。标示符以一个字母 A 到 Z 或 a 到 z 或下划线 _ 开头后加上0个或多个字母，下划线，数字（0到9）。  

最好不要使用下划线加大写字母的标示符，因为Lua的保留字也是这样的。  

Lua 不允许使用特殊字符如 @, $, 和 % 来定义标示符。 

Lua 是一个区分大小写的编程语言。因此在 Lua 中 W3c 与 w3c 是两个不同的标示符。

#### 关键词

以下列出了 Lua 的保留关键字。保留关键字不能作为常量或变量或其他用户自定义标示符：

-           | -	       | -	     |-
------------|----------|---------|----
and	        | break	   |do	     |else
elseif	    | end	   |false	 |for
function	| if	   |in	     |local
nil	        | not	   |or	     |repeat
return	    | then	   |true     |until
while	    |          |         |

一般约定，以下划线开头连接一串大写字母的名字（比如 _VERSION）被保留用于 Lua 内部全局变量。

#### 全局变量

在默认情况下，变量总是认为是全局的。  
全局变量不需要声明，给一个变量赋值后即创建了这个全局变量，访问一个没有初始化的全局变量也不会出错，只不过得到的结果是：nil。

```lua
> print(b)
nil
> b=10
> print(b)
10
> 
```

如果你想删除一个全局变量，只需要将变量赋值为nil。  

```lua
b = nil
print(b)      --> nil
```

这样变量b就好像从没被使用过一样。换句话说,     当且仅当一个变量不等于nil时，这个变量即存在。  

## Lua 数据类型

Lua是动态类型语言，变量不要类型定义,只需要为变量赋值。 值可以存储在变量中，作为参数传递或结果返回。

Lua中有8个基本类型分别为：nil、boolean、number、string、userdata、function、thread和table。

数据类型	| 描述
------------|---------
nil	        |只有值nil属于该类，表示一个无效值  
boolean	    | 包含两个值：false和true。
number	    | 表示双精度类型的实浮点数
string	    | 字符串由一对双引号或单引号来表示
function	| 由 C 或 Lua 编写的函数
userdata	| 表示任意存储在变量中的C数据结构
thread	    | 表示执行的独立线路，用于执行协同程序
table	    | 最简单构造表达式是{}，用来创建一个空表。

我们可以使用type函数测试给定变量或者值的类型：

```lua
print(type("Hello world"))      --> string
print(type(10.4*3))             --> number
print(type(print))              --> function
print(type(type))               --> function
print(type(true))               --> boolean
print(type(nil))                --> nil
print(type(type(X)))            --> string

```

### string（字符串）

用  "[[]]" 来表示"一块"字符串。

```lua
html = [[
<html>
<head></head>
<body>
    <a href="http://www.w3cschool.cc/">w3cschool菜鸟教程</a>
</body>
</html>
]]
print(html)
```

在对一个数字字符串上进行算术操作时，Lua 会尝试将这个数字字符串转成一个数字:

```lua
> print("2" + 6)
8.0
> print("2" + "6")
8.0
> print("-2e2" * "6")
-1200.0
> print("error" + 1)   --报错
```

字符串连接使用的是 ..

```lua

> print("a" .. 'b')
ab
> print(157 .. 428)
157428
> print("123".."12456")
```

使用 # 来计算字符串的长度，放在字符串前面

```lua
> str = "www.wxz.cn"
> print(#str)

```

### table（表）

```lua
-- 创建一个空的 table
local tbl1 = {}

-- 直接初始表
local tbl2 = {"apple", "pear", "orange", "grape"}

> a={"11","122","333" }
> print(a)
table: 0xeac590
> print(a[0])
nil
> print(a[1])
11
> print(a[2])
122
> print(a[3])
333

```

Lua 中的表（table）是一个"关联数组"（associative arrays），数组的索引可以是数字或者是字符串。

```lua
-- table_test.lua 脚本文件
a = {}
a["key"] = "value"
key = 10
a[key] = 22
a[key] = a[key] + 11
for k, v in pairs(a) do
    print(k .. " : " .. v)
end

脚本执行结果为：
$ lua table_test.lua
key : value
10 : 33
```

不同于其他语言的数组把 0 作为数组的初始索引，在 Lua 里表的默认初始索引一般以 **1 开始**。

```lua
-- table_test2.lua 脚本文件
local tbl = {"apple", "pear", "orange", "grape"}
for key, val in pairs(tbl) do
    print("Key", key)
end

脚本执行结果为：
$ lua table_test2.lua 
Key	1
Key	2
Key	3
Key	4
```

table 不会固定长度大小，有新数据添加时 table 长度会自动增长，没初始的 table 都是 nil。

```lua
-- table_test3.lua 脚本文件
a3 = {}
for i = 1, 10 do
    a3[i] = i
end
a3["key"] = "val"
print(a3["key"])
print(a3["none"])

脚本执行结果为：
$ lua table_test3.lua 
val
nil
```

### function（函数）

在 Lua 中，函数是被看作是"第一类值（First-Class Value）"，函数可以存在变量里:

```lua
-- function_test.lua 脚本文件
function factorial1(n)
    if n == 0 then
        return 1
    else
        return n * factorial1(n - 1)
    end
end
print(factorial1(5))
factorial2 = factorial1
print(factorial2(5))

脚本执行结果为：
$ lua function_test.lua 
120
120
```

function 可以以匿名函数（anonymous function）的方式通过参数传递:

```lua
-- function_test2.lua 脚本文件
function anonymous(tab, fun)
    for k, v in pairs(tab) do
        print(fun(k, v))
    end
end
tab = { key1 = "val1", key2 = "val2" }
anonymous(tab, function(key, val)
    return key .. " = " .. val
end)

脚本执行结果为：
$ lua function_test2.lua 
key1 = val1
key2 = val2
```

### thread（线程）

- 在 Lua 里，最主要的线程是协同程序（coroutine）。它跟线程（thread）差不多，拥有自己独立的栈、局部变量和指令指针，可以跟其他协同程序共享全局变量和其他大部分东西。  
- 线程跟协程的区别：线程可以同时多个运行，而协程任意时刻只能运行一个，并且处于运行状态的协程只有被挂起（suspend）时才会暂停。

### userdata（自定义类型）

userdata 是一种用户自定义数据，用于表示一种由应用程序或 C/C++ 语言库所创建的类型，可以将任意 C/C++ 的任意数据类型的数据（通常是 struct 和 指针）存储到 Lua 变量中调用。


## Lua 变量

- Lua 变量有三种类型：全局变量、局部变量、表中的域。  
- Lua 中的变量全是全局变量，那怕是语句块或是函数里，除非用 local 显示声明为局部变量。  
- 局部变量的作用域为从声明位置开始到所在语句块结束。    
- 变量的默认值均为 nil。
- **尽可能的使用局部变量**

```lua
-- test.lua 文件脚本
a = 5               -- 全局变量
local b = 5         -- 局部变量

function joke()
    c = 5           -- 全局变量
    local d = 6     -- 局部变量
end

joke()
print(c,d)          --> 5 nil

do 
    local a = 6     -- 局部变量
    b = 6           -- 全局变量
    print(a,b);     --> 6 6
end

print(a,b)      --> 5 6
```

### 赋值语句

Lua可以对多个变量同时赋值，变量列表和值列表的各个元素用逗号分开，赋值语句右边的值会依次赋给左边的变量。

```lua
a, b = 10, 2*x       <-->       a=10; b=2*x
```

遇到赋值语句Lua会先计算右边所有的值然后再执行赋值操作, 所以可以做如下交换

```lua
x, y = y, x                     -- swap 'x' for 'y'
a[i], a[j] = a[j], a[i]         -- swap 'a[i]' for 'a[j]'
```

当变量个数和值的个数不一致时，Lua会一直以变量个数为基础采取以下策略：

> a. 变量个数 > 值的个数             按变量个数补足nil  
> b. 变量个数 < 值的个数             多余的值会被忽略

```lua

a, b, c = 0, 1
print(a,b,c)             --> 0   1   nil
 
a, b = a+1, b+1, b+2     -- value of b+2 is ignored
print(a,b)               --> 1   2
 
a, b, c = 0
print(a,b,c)             --> 0   nil   nil

-- 注意：如果要对多个变量赋值必须依次对每个变量赋值。
a, b, c = 0, 0, 0
print(a,b,c)             --> 0   0   0

```

多值赋值经常用来交换变量，或将函数调用返回给变量：

```lua
-- 获取函数返回值
a, b = f()
-- f()返回两个值，第一个赋给a，第二个赋给b。
```

应该**尽可能的使用局部变量**，有两个好处：  

1. 避免命名冲突。

2. 访问局部变量的速度比全局变量更快。

## 索引

对 table 的索引使用方括号 []。Lua 也提供了. 操作。

```lua
t[i]
t.i                  -- 当索引为字符串类型时的一种简化写法
gettable_event(t,i)  -- 采用索引访问本质上是一个类似这样的函数调用
```

例如: 

```lua
> site = {}
> site["key"] = "www.wxz.com"
> print(site["key"])
www.wxz.com
> print(site.key)
www.wxz.com
```

## 循环语句

### while 循环

```lua
a=10
while( a < 20 )
do
   print("a 的值为:", a)
   a = a+1
end

```

## Lua for 循环

### 数值for循环

Lua 编程语言中数值for循环语法格式:

```lua
for var=exp1,exp2,exp3 do  
    <执行体>  
end  
```

var从exp1变化到exp2，每次变化以exp3为步长递增var，并执行一次"执行体"。exp3是可选的，如果不指定，默认为1。

```lua
for i=1,f(x) do
    print(i)
end
 
for i=10,1,-1 do
    print(i)
end
```

for的三个表达式在循环开始前一次性求值，以后不再进行求值。比如上面的f(x)只会在循环开始前执行一次，其结果用在后面的循环中。 验证如下:

```lua
#!/usr/local/bin/lua  
function f(x)  
    print("function")  
    return x*1   
end  
for i=1,f(5) do print(i)  
end  

以上实例输出结果为：
function
1
2
3
4
5
可以看到 函数f(x)只在循环开始前执行一次。
```

###  泛型for循环

泛型for循环通过一个迭代器函数来遍历所有值，类似java中的foreach语句。  
Lua 编程语言中泛型for循环语法格式:

```lua
--打印数组a的所有值  
for i,v in ipairs(a) 
	do print(v)
end
```

i是数组索引值，v是对应索引的数组元素值。ipairs是Lua提供的一个迭代器函数，用来迭代数组。

```lua
#!/usr/local/bin/lua  
days = {"Suanday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"}  
for i,v in ipairs(days) do  print(v) end   
```

### repeat...until 循环

repeat...until 循环语句不同于 for 和 while循环，for 和 while 循环的条件语句在当前循环执行开始时判断，而 repeat...until 循环的条件语句在当前循环结束后判断。  
repeat...until 循环语法格式:

```lua
repeat
   statements
until( condition )
```

我们注意到循环条件判断语句（condition）在循环体末尾部分，所以在条件进行判断前循环体都会执行一次。
如果条件判断语句（condition）为 false，循环会重新开始执行，**直到条件判断语句（condition）为 true**才会停止执行。

## 流程控制

### Lua if 语句

```lua
if(布尔表达式)
then
   --[ 在布尔表达式为 true 时执行的语句 --]
end
```

### if...else 语句

```lua
if(布尔表达式)
then
   --[ 布尔表达式为 true 时执行该语句块 --]
else
   --[ 布尔表达式为 false 时执行该语句块 --]
end
```

## Lua 函数

### 函数定义

```lua
optional_function_scope function function_name( argument1, argument2, argument3..., argumentn)
	function_body
	return result_params_comma_separated
end
```

解析：

- optional_function_scope: 该参数是可选的制定函数是全局函数还是局部函数，未设置该参数默认为全局函数，如果你需要设置函数为局部函数需要使用关键字 local。

- function_name: 指定函数名称。

- argument1, argument2, argument3..., argumentn: 函数参数，多个参数以逗号隔开，函数也可以不带参数。
- function_body: 函数体，函数中需要执行的代码语句块。
- result_params_comma_separated:函数返回值，Lua语言函数可以返回多个值，每个值以逗号隔开。

### 可变参数

- Lua函数可以接受可变数目的参数，和C语言类似在函数参数列表中使用三点（...) 表示函数有可变的参数。  

- Lua将函数的参数放在一个叫arg的表中，#arg 表示传入参数的个数。  

```lua
function average(...)
   result = 0
   local arg={...}
   for i,v in ipairs(arg) do
      result = result + v
   end
   print("总共传入 " .. #arg .. " 个数")
   return result/#arg
end

print("平均值为",average(10,5,3,4,5,6))
```
