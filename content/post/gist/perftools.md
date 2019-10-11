---
author: "wuxingzhong"
title: "Perftools"
date: 2019-10-11T17:20:47+08:00
draft: false
tags: ["c"]
# categories:  [""]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---


## google-perftools 

google-perftools 是一款针对 C/C++ 程序的性能分析工具，它是一个遵守 BSD 协议的开源项目。使用该工具可以对 CPU时间片、内存等系统资源的分配和使用进行分析，本文将重点介绍如何进行 CPU 时间片的剖析。 google-perftools 对一个程序的 CPU 性能剖析包括以下几个步骤:

1. 编译目标程序，加入对 google-perftools 库的依赖。
2. 运行目标程序，并用某种方式启动 / 终止剖析函数并产生剖析结果。
3. 运行剖结果转换工具，将不可读的结果数据转化成某种格式的文档（例如 pdf,txt,gv 等）。

## 安装

```bash
yum install gperftools-devel gperftools
```

## perftools使用

方法有三种:

1. 直接调用提供的api：这种方式比较适用于对于程序的某个局部来做分析的情况，直接在要做分析的局部调用相关的api即可。方式：调用函数

    ```C
    #include <google/profiler.h> // 引入头文件
    ProfilerStart()              // 开始分析
    ProfilerStop()               // 结束分析
    ```

2. 链接：这种方式是最为常用的方式  

    ```bash
    # 链接时添加
    –lprofiler
    # 运行程序(假设程序为test), prof为产生的分析文件
    env CPUPROFILE=./test.prof ./test
    ```

3. 链接动态库：这种方式和静态库的方式差不多，但通常**不推荐**使用

    ```bash
    env LD_PRELOAD="/usr/lib/libprofiler.so" <binary> #（不推荐）
    ```

## 结果分析

1. 查看收集数据结果  

pprof工具: 它是一个perl的脚本，通过这个工具，可以将google-perftool的输出结果分析得更为直观，输出为图片、pdf等格式。  
PS：在使用pprof之前需要先安装运行per15，如果要进行图标输出则需要安装dot，如果需要 --gv模式的输出则需要安装gv。

调用pprof分析数据文件：

```bash
# 交互模式
pprof test test.prof

#每个步骤输出一行                       
pprof --text ./test test.prof

# 显示带注解的调用图
pprof --gv ./test test.prof

# Restricts to code paths including a .*Mutex.* entry                       
pprof --gv --focus=Mutex ./test test.prof

#Code paths including Mutex but not string             
pprof --gv --focus=Mutex --ignore=string ./test test.prof

# (Per-line) annotated source listing for getdir()
pprof --list=getdir ./test test.prof

# (Per-line) annotated source listing for getdir()                   
pprof --disasm=getdir ./test test.prof

# Outputs one line per procedure for localhost:1234             
pprof --text localhost:1234

# Outputs the call information in callgrind format
pprof --callgrind ./test test.prof

# 命令产生可视化的结果文档。
pprof --gv ./codeTest test.prof
# 转pdf
pprof --pdf ./codeTest test.prof > test.pdf

```

分析callgrind的输出：  
使用kcachegrind工具来对.callgrind输出进行分析  

```bash
pprof --callgrind /bin/ls ls.prof > ls.callgrind 
kcachegrind ls.callgrind
```

### 服务组件无法正常退出,解决方案

```C
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>
#include <google/profiler.h>
 
//SIGUSR1: start profiling
//SIGUSR2: stop profiling
 
static void gprof_callback(int signum)
{
    if (signum == SIGUSR1) 
    {
        printf("Catch the signal ProfilerStart\n");
        ProfilerStart("bs.prof");
    } 
    else if (signum == SIGUSR2) 
    {
        printf("Catch the signal ProfilerStop\n");
        ProfilerStop();
    }
}
 
static void setup_signal()
{
    struct sigaction profstat;
    profstat.sa_handler = gprof_callback;
    profstat.sa_flags = 0;
    sigemptyset(&profstat.sa_mask);
    sigaddset(&profstat.sa_mask, SIGUSR1);
    sigaddset(&profstat.sa_mask, SIGUSR2);
    if ( sigaction(SIGUSR1, &profstat,NULL) < 0 ) 
    {
        fprintf(stderr, "Fail to connect signal SIGUSR1 with start profiling");
    }
    if ( sigaction(SIGUSR2, &profstat,NULL) < 0 ) 
    {
        fprintf(stderr, "Fail to connect signal SIGUSR2 with stop profiling");
    }
}
 
int loopop_callee()
{
    int n=0;
    for(int i=0; i<10000; i++)
    {
        for(int j=0; j<10000; j++)
        {
             n |= i%100 + j/100;
        }
    }
    return n;
}
 
int loopop()
{
    int n=0;
    while(1)
    {
        for(int i=0; i<10000; i++)
        {
            for(int j=0; j<10000; j++)
            {
                n |= i%100 + j/100;
            }
        }
        printf("result:  %d\n", (loopop_callee)() );
    }
    return n;
}
 
int main(int argc,char** argv)
{
    char program[1024]={0};
    //snprintf(program,1023,"%s_%d.prof",argv[0],getpid());
    setup_signal();
    printf("result:  %d\n", (loopop)() );
    return 0;
}

```
