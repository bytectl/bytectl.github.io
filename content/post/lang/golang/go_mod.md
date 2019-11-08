---
author: "wuxingzhong"
title: "Go mod"
date: 2019-10-11T19:03:33+08:00
draft: false
tags: ["go"]
categories:  ["go"]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---

# go-mod

## 设置包下载代理

```bash
# Enable the go modules feature
export GO111MODULE=on
export GOPROXY=https://goproxy.io
```

## 初始化

法1: main包名 注释-->模块名

```go

// "github.com/example" 为模块名
package main // import "github.com/example"

import (
	"fmt"
)

func main() {
	fmt.Println("Hello, world!")
}

// go mod init
```

法二: 初始化指定

如果你工程中之前已经存在一些依赖包管理工具, 如godep，glide或者dep. 那么go mod init同样也会根据依赖包管理配置文件来推断。

```bash
go mod init github.com/example
```

##  命令管理

添加缺失的模块以及移除不需要的模块, 生成go.sum

```bash
go mod tidy
```

依赖包放到主模块所在的vendor目录中，并且测试所有主模块的包

```bash
go mod vendor
```

检查当前模块的依赖是否已经存储在本地下载的源代码缓存中，以及检查自从下载下来是否有修改

```bash
go mod verify
```

## 虚拟版本号

go.mod文件和go命令通常使用语义版本作为描述模块版本的标准形式，这样可以比较不同版本的先后顺序。例如模块的版本是v1.2.3，那么通过重新对版本号进行标签处理，得到该版本的虚拟版本。形式如：v0.0.0-yyyymmddhhmmss-abcdefabcdef。其中时间是提交时的UTC时间，最后的后缀是提交的哈希值前缀。时间部分确保两个虚拟版本号可以进行比较，以确定两者顺序。

下面有三种形式的虚拟版本号：

vX.0.0-yyyymmddhhmmss-abcdefabcdef，这种情况适合用在在目标版本提交之前 ，没有更早的的版本。（这种形式本来是唯一的形式，所以一些老的go.mod文件使用这种形式）

vX.Y.Z-pre.0.yyyymmddhhmmss-abcdefabcdef，这种情况被用在当目标版本提交之前的最新版本提交是vX.Y.Z-pre。

vX.Y.(Z+1)-0.yyyymmddhhmmss-abcdefabcdef，同理，这种情况是当目标版本提交之前的最新版本是vX.Y.Z。

虚拟版本的生成不需要你去手动操作，go命令会将接收的commit哈希值自动转化为虚拟版本号。

## GO111MODULE

1. GOPATH模式

```bash
# 不使用module,相反的,在vendor和GOPATH目录中查找依赖包. 
export GO111MODULE=off
```

1. modules模式

```bash
# 使用module,将依赖包放在GOPATH/pkg/mod目录下
export GO111MODULE=off
```

1. auto模式

```bash
# 根据当前目录(是否在GOPATH下)情况使用模式
export GO111MODULE=on
```
