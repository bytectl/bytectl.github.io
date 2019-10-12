---
author: "wuxingzhong"
title: "Linux module"
date: 2019-10-11T19:00:22+08:00
draft: false
tags: [""]
categories:  [""]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---

### module

```c
#include<linux/init.h>   //驱动初始化
#include<linux/module.h>  //驱动模块

MODULE_LICENSE("Dual BSD/GPL"); //遵循linux协议

static int hello_init(void){
    printk(KERN_ALERT "hello world, ring0\n");//打印驱动信息
    return 0;
}

static void hello_exit(void){
    printk(KERN_ALERT "hello world!, i'm exit!\n");//打印驱动信息
}

module_init(hello_init); //打印驱动初始化信息
module_exit(hello_eixt);//打印驱动结果信息

```

### makefile

```makefile

Makefile
pwd=$(shell pwd)
KENEL_SRC=/lib/modules/$(shell uname -r)/build
obj -m:=hello.o
all:
    s(MAKE) -C $(KENEL_SRC) M=$(PWD) modules
clean;
    rm *ko
    rm *.o
```

### 编译

```bash

# 编译:
make
# 加载驱动:
sudo  insmod hello.ko
# 查看信息
dmesg
# 移除模块
sudo rmmod
# 查看信息
dmesg 
# 查看所有驱动
lsmod
```
