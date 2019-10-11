---
author: "wuxingzhong"
title: "Httpd Tools"
date: 2019-10-10T19:22:49+08:00
draft: false
tags: ["software"]
categories:  ["software"]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---

##  install
```bash
yum install httpd-tools
```

## ab

```bash
# 压测短连接
ab -n 1000 -c 100  10.108.167.100:9040/info
```