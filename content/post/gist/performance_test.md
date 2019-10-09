+++
author = "wuxingzhong"
date = "2019-07-11T10:54:24+02:00"
draft = false
title = "性能测试"
tags = ["c"]
image = ""
banner = ""
comments = true     # set false to hide Disqus comments
share = true     e to share buttons
menu = ""           # set "main" to add this content to the main menu
+++

# 性能测试工具

## 生成测试

编译 和链接时,添加参数 -pg

```C
// 服务程序,添加如下代码:
static void sighandler( int sig_no )
{
    exit(0);
}

int main(int argc, char* argv[])
{
    // 接收信号 
    signal( SIGUSR1, sighandler );
}

// 发送命令使程序正常退出,生成gnem.out

kill -USR1  pid

```

## 使用

```bash

gprof  ./程序  gnem.out > report.txt
```

## 图形化

```bash
# 安装 graphviz
wget http://www.graphviz.org/pub/graphviz/ARCHIVE/graphviz-2.18.tar.gz
tar -zxvf graphviz-2.18.tar.gz
cd graphviz-2.18
./configure
make
make install

# 安装gprof2dot

pip install gprof2dot

```

## 生成图形

```bash
# 生成图片 
gprof ./程序 gnem.out  | gprof2dot -n0 -e0 | dot -Tpng -o output.png

gprof ./程序 gnem.out >report.txt
gprof2dot report.txt > report.dot     #转为dot文件
dot -Tpng -oreport.png report.dot     #生成png文件
```

## 使用注意

一般gprof只能查看用户函数信息。如果想查看库函数的信息，需要在编译是再加入“-lc_p”编译参数代替“-lc”编译参数，这样程序会链接libc_p.a库，才可以产生库函数的profiling信息。
