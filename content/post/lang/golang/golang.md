---
author: "wuxingzhong"
title: "Golang环境"
date: 2019-10-11T19:03:32+08:00
draft: false
tags: [""]
categories:  [""]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---


# 下载go开发包
```
# 根据自己的需求选择
http://golangtc.com/download
```

# 安装

## Windows下

```
scoope install golang
go env 
```
其中GOPATH是你的工作（工程）目录你的代码都会在该目录下,GOPATH可以有多个，windows以分号";"进行区分，Linux系统是冒号":", 默认会将go get的内容放在第一个目录下　　    

## linux下
```

cd /usr/local
sudo curl -O https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz
tar -xf go1.11.4.linux-amd64.tar.gz

vim /etc/profile.d/golang.sh

# 添加
export PATH=/usr/local/go/bin:$PATH
export GOPATH=/home/go


```
# 开发ide
## sublime 插件
```
# gosublime
#　配置
{
    "env": {
        "GOPATH": "D:/grean_soft/go",
        "GOROOT": "E:/work/code/git/aliyun_code/golang"
    }
}

```
# 编译

```bash
#  编译运行
go run print.go

# 编译go
go build print.go

```
# go get 

```bash
# 获取 https://github.com/kubernetes/kubernetes
go get -d k8s.io/kubernetes
cd $GOPATH/src/k8s.io/kubernetes
make

go get -d github.com/coreos/etcd


# 获取 https://github.com/nsqio/nsq
go get -d nsqio/nsq
cd $GOPATH/src/nsqio/nsq
make

# GOPATH下的src目录为 go get(git)下来的源码
# GOPATH下的pkg 目录为 包 如.a
```

# 安装go项目依赖

```
cd goproject

go get ./...
```

## dep

```bash

go get -u github.com/golang/dep/cmd/dep

dep init

dep ensure -add github.com/foo/bar github.com/baz/quux

```