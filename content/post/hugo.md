---
author: "wuxingzhong"
title: "Hugo"
date: 2019-10-10T09:23:18+08:00
draft: false
tags: [""]
categories:  [""]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---

## 安装

```bash

# 使用gorpoxy
export GOPROXY=https://goproxy.cn
export GO111MODULE=on

go get -v github.com/gohugoio/hugo
hugo version

```

## 简单使用流程

### 建立site

```bash
hugo new site bytectl
```

### 配置主题

```bash
git clone https://github.com/xxx themes/xxx

# 配置
cp themes/xxx/exampleSite/config.yaml ./
vim config.yaml
```

### 编写文章

```bash
hugo new post/hugo.md
vim content/post/hugo.md

```

### 预览

```bash
hugo server -D
```

在浏览器中打开提示hugo提示的网址即可

### 发布

```bash
hugo
```

将生成的文件拷贝到nginx等静态页面服务器中即可
