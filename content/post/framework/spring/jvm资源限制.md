---
author: "wuxingzhong"
title: "Jvm资源限制"
date: 2019-10-11T16:57:19+08:00
draft: false
tags: [""]
categories:  [""]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---

# 前言

参考: https://qingmu.io/2018/12/17/How-to-securely-limit-JVM-resources-in-a-container/

Java与Docker的结合，虽然更好的解决了application的封装问题。但也存在着不兼容，比如Java并不能自动的发现Docker设置的内存限制,CPU限制。

这将导致JVM不能稳定服务业务！容器会杀死你JVM进程，而健康检查又将拉起你的JVM进程，进而导致你监控你的pod一天重启次数甚至能达到几百次。

我们希望当Java进程运行在容器中时，java能够自动识别到容器限制，获取到正确的内存和CPU信息，而不用每次都需要在kubernetes的yaml描述文件中显示的配置完容器，还需要配置JVM参数。

使用JVM MaxRAM参数或者解锁实验特性的JVM参数，升级JDK到10+，我们可以解决这个问题（也许吧~.~）。

首先Docker容器本质是是宿主机上的一个进程，它与宿主机共享一个/proc目录，也就是说我们在容器内看到的/proc/meminfo，/proc/cpuinfo
与直接在宿主机上看到的一致，如下:

- Host

```bash
cat /proc/meminfo 
MemTotal:       197869260 kB
MemFree:         3698100 kB
MemAvailable:   62230260 kB
```

- 容器

```bash
docker run -it --rm alpine cat /proc/meminfo
MemTotal:       197869260 kB
MemFree:         3677800 kB
MemAvailable:   62210088 kB
```

那么Java是如何获取到Host的内存信息的呢？没错就是通过/proc/meminfo来获取到的。

默认情况下，JVM的Max Heap Size是系统内存的1/4，假如我们系统是8G，那么JVM将的默认Heap≈2G。

Docker通过CGroups完成的是对内存的限制，而/proc目录是已只读形式挂载到容器中的，由于默认情况下Java压根就看不见CGroups的限制的内存大小，而默认使用/proc/meminfo中的信息作为内存信息进行启动，这种不兼容情况会导致，如果容器分配的内存小于JVM的内存，JVM进程会被理解杀死。

## 内存不兼容测试

### 测试用例1(OPENJDK)

```bash
docker run -m 1GB  --rm  openjdk:8-jre-slim java  -XshowSettings:vm  -version
docker run -m 1GB  --rm  openjdk:8-jre-slim java  -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap   -XshowSettings:vm  -version
docker run -m 1GB --rm  openjdk:9-jre-slim java  -XshowSettings:vm  -version
docker run -m 1GB --rm  openjdk:10-jre-slim java -XshowSettings:vm  -version
docker run -m 1GB --rm  openjdk:11-jre-slim java -XshowSettings:vm  -version
docker run -m 1GB --rm  openjdk:12 java -XshowSettings:vm  -version
```

结果:

|jdk版本     | 测试结果   |
|------------|------------|
|openjdk:8   | fail       |
|8 + 参数    | ok         |
|openjdk:9   | fail       |
|9 + 参数    | ok         |
|openjdk:9   | fail       |
|openjdk:10  | ok         |
|openjdk:11  | ok         |
|openjdk:12  | ok         |

### 测试用例2(IBMOPENJ9)

```bash
docker run -m 4GB --rm  adoptopenjdk/openjdk8-openj9:alpine-slim  java -XshowSettings:vm  -version
docker run -m 4GB --rm  adoptopenjdk/openjdk9-openj9:alpine-slim  java -XshowSettings:vm  -version
docker run -m 4GB --rm  adoptopenjdk/openjdk10-openj9:alpine-slim  java -XshowSettings:vm  -version
docker run -m 4GB --rm  adoptopenjdk/openjdk11-openj9:alpine-slim  java -XshowSettings:vm  -version
```

结果:

|jdk版本           | 测试结果 |
|------------------|---------|
|openjdk8-openj9   | ok       |
|openjdk9-openj9   | ok       |
|openjdk10-openj9  | ok       |
|openjdk11-openj9  | ok       |

### 分析

分析之前我们先了解这么一个情况：

```bash
JavaMemory (MaxRAM) = 元数据+线程+代码缓存+OffHeap+Heap...
```

一般我们都只配置Heap即使用-Xmx来指定JVM可使用的最大堆。而JVM默认会使用它获取到的最大内存的1/4作为堆的原因也是如此。

### 安全性（即不会超过容器限制被容器kill）

OpenJdk

OpenJdk8-12,都能保证这个安全性的特点（8和9需要特殊参数，-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap）。

OpenJ9

IbmOpenJ9所有的版本都能识别到容器限制。

### 资源利用率

OpenJdk

自动识别到容器限制后，OpenJdk把最大堆设置为了大概容器内存的1/4，对内存的浪费不可谓不大。

当然可以配合另一个JVM参数来配置最大堆。`-XX:MaxRAMFraction=int`。下面是我整理的一个常见内存设置的表格，
从中我们可以看到似乎JVM默认的最大堆的取值为`MaxRAMFraction=4`，随着内存的增加，堆的闲置空间越来越大，在16G容器内存时，java堆只有不到4G。

MaxRAMFraction取值 | 堆占比	|容器内存=1G|容器内存=2G|容器内存=4G|容器内存=8G| 容器内存=16G
-------------------|-------|------------|-----------|----------|------------|------
1 | ≈90% |	910.50M|1.78G	|3.56G	    |7.11G	 |14.22G
2 |	≈50% | 	455.50M|910.50M	|1.78G	    |3.56G	 |7.11G
3 |	≈33% |	304.00M|608.00M	|1.19G	    |2.37G	 |4.74G
4 |	≈25% |	228.00M|455.50M	|910.50M	|1.78G	 |3.56G

OpenJ9
关于OpenJ9的的详细介绍你可以从这里 [了解更多](https://www.eclipse.org/openj9/docs/xxusecontainersupport/)。
对于内存利用率OpenJ9的策略是优于OpenJdk的。以下是OpenJ9的策略表格

容器内存<size>	| 最大Java堆大小
----------------|---------------
小于1 GB        |	50％<size>
1 GB - 2 GB	    | <size> - 512 MB
大于2 GB	    | 大于2 GB

## 结论

注意：这里我们说的是容器内存限制，和物理机内存不同，

### 自动档

如果你想要的是，不显示的指定-Xmx，让Java进程自动的发现容器限制。
1.如果你想要的是jvm进程在容器中安全稳定的运行，不被容器kiil，并且你的JDK版本小于10（大于等于JDK10的版本不需要设置，参考前面的测试）
你需要额外设置JVM参数`-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap`，即可保证你的Java进程不会因为内存问题被容器Kill。
当然这个方式使用起来简单，可靠，缺点也很明显，资源利用率过低（参考前面的表格MaxRAMFraction=4）。

2.如果想在基础上我还想提高一些内存资源利用率，并且容器内存为1 GB - 4 GB，我建议你设置`-XX:MaxRAMFraction=2`，在大于8G的可以尝试设置`-XX:MaxRAMFraction=1`（参考上表格）。

### 手动挡

如果你想要的是手动挡的体验，更加进一步的利用内存资源，那么你可能需要回到手动配置时代-Xmx

手动挡部分，请可以完全忽略上面我的BB。

1.上面的我们说到了自动挡的配置，用起来很简单很舒服，自动发现容器限制，无需担心和思考去配置-Xmx。

2.比如你有内存1G那么我建议你的-Xmx750M,2G建议配置-Xmx1700M,4G建议配置-Xmx3500-3700M,8G建议设置-Xmx7500-7600M,

总之就是至少保留300M以上的内存留给JVM的其他内存。如果堆特别大，可以预留到1G甚至2G。

3.手动挡用起来就没有那么舒服了，当然资源利用率相对而言就更高了。

```bash

docker run --rm  -e "JAVA_OPT=-Xms512m -Xmx1024m" -e CLOUD_OPTION=' -Xquickstart --spring.cloud.config.uri=http://172.16.18.251:8990/ --spring.cloud.config.profile=251' device:1.3.1-openj9

docker run --rm  -e "JAVA_OPT=-Xms512m -Xmx1024m" -e CLOUD_OPTION='--spring.cloud.config.uri=http://172.16.18.251:8990/ --spring.cloud.config.profile=251' device:1.3.1-openjdk

watch 'ps -aux | grep device-1.3.1-open | grep -v auto'

```
