---
author: "wuxingzhong"
title: "Gitbook"
date: 2019-10-10T19:20:37+08:00
draft: false
tags: ["software"]
categories:  ["software"]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---


## 安装

```bash
npm install gitbook-cli -g
```

## 安装calibre  [参考](https://calibre-ebook.com/download_linux/)

用于生成epub和mobi格式电子书

```bash
wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"

```

## 使用

```bash
# 创建书籍
gitbook init
# 启动预览
gitbook serve
# 本地编译
gitbook build
```

## 生成

```bash
# 生成pdf文件
gitbook pdf ./ mybook.pdf

# 生成epub文件
gitbook epub ./ mybook.epub

# 生成mobi文件，支持kindle
gitbook mobi ./ mybook.mobi

```
