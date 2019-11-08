---
author: "wuxingzhong"
title: "Delve"
date: 2019-10-11T19:03:29+08:00
draft: false
tags: [""]
categories:  [""]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---


# delve
[go 调试工具](https://github.com/go-delve/delve)

## 安装

```bash
go get -u github.com/go-delve/delve/cmd/dlv
```

## 使用 

### 本地调试

```

dlv debug main.go --  args

# 编译
go build -gcflags='-N -l' main.go
dlv exec main -- args 
# git-bash中
winpty dlv debug main.go -- args 

# 已经运行的程序
dlv attach  pid
```

### 远程调试

```
# 服务端
dlv debug --headless  --api-version 2 -l 0.0.0.0:2345  main.go -- args

# 服务端attach 
dlv attach --headless  --api-version 2 -l 0.0.0.0:2345  pid

# 客户端
dlv connect 127.0.0.1:2345

```

### 配合vscode调试

launch.json

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "discovery remote",
            "type": "go",
            "request": "attach",
            "mode": "remote",
            "remotePath": "${workspaceFolder}",
            "port": 2345,
            "host": "127.0.0.1"
        }
    ]
}
```