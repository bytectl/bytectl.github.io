---
author: "wuxingzhong"
title: "Hugo"
date: 2019-10-10T09:23:18+08:00
draft: false
tags: [""]
categories:  [""]
image = ""
banner = ""
comments = true     # set false to hide Disqus comments
share = true        # set false to share buttons
menu = ""           # set "main" to add this content to the main menu
---

# hugo

## 安装

```bash
export GOPROXY=https://goproxy.cn
export GO111MODULE=on

go install -v github.com/gohugoio/hugo
hugo version

```

## 建立site

```bash
hugo new site bytectl
```
