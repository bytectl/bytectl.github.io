---
author: "wuxingzhong"
title: "Vscode+go"
date: 2019-10-11T19:03:34+08:00
draft: false
tags: [""]
categories:  [""]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---



```bash
GOPATH=$(go env GOPATH)

mkdir -p ${GOPATH}/src/golang.org/x/
cd ${GOPATH}/src/golang.org/x/

git clone https://github.com/golang/tools.git

git clone https://github.com/golang/lint.git



git clone https://github.com/golang/sys.git
go install golang.org/x/sys/windows

```
