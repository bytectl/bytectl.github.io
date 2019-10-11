---
author: "wuxingzhong"
title: "Tcmalloc"
date: 2019-10-11T17:16:25+08:00
draft: false
tags: ["c", "gist", "software"]
categories:  ["c"]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---


## libunwind

libunwind库为基于64位CPU和操作系统的程序提供了基本的堆栈辗转开解功能，其中包括用于输出堆栈跟踪的API、用于以编程方式辗转开解堆栈的API以及支持C++异常处理机制的API。

## 安装

```bash

# 64位操作系统安装 libunwind库.32位不要安装
yum install libunwind-devel

# 或者编译安装
git clone git://git.sv.gnu.org/libunwind.git
cd libunwind
./autogen.sh
./configure
make &&make install

```

## gperftools

快速内存分配和调用分析工具

### 安装

```bash
yum install gperftools-devel gperftools

# 编译安装
wget https://codeload.github.com/gperftools/gperftools/tar.gz/gperftools-2.5
git clone https://github.com/gperftools/gperftools.git
./autogen.sh
./configure
make && make install
```

### 使用tcmalloc
编译时添加
```bash
-ltcmalloc  -ltcmalloc_minimal 
```

### mysql使用tcmalloc

```bash
# 打开 mysqld_safe 脚本  默认 /usr/bin/mysqld_safe
cd /usr/bin/mysqld_safe
# 在此脚本文件加入
LD_PRELOAD="/usr/local/lib/libtcmalloc.so"
service mysql restart
```
