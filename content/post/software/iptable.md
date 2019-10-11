---
author: "wuxingzhong"
title: "Iptable"
date: 2019-10-10T19:24:53+08:00
draft: false
tags: ["software", "linux"]
categories:  ["software"]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---


## 限流

```bash
iptables -A INPUT -p tcp –dport 443  -m limit --limit 100/sec --limit-burst 1000 -j ACCEPT

-m limit --limit 100/sec 限制每秒连接请求数

–limit-burst：触发阀值，一次涌入数据包数量

```

## 连接追踪

```bash
yum install conntrack-tools
conntrack -L  |grep 5672 |grep udp
```

## nat

```bash
# 包路由前
iptables -t nat -A PREROUTING -d 172.16.17.242/32 -p udp --dport 124 -j DNAT --to-destination 172.16.17.180
# 包准备发送前
iptables -t nat -A POSTROUTING  -p udp --sport 124 -j SNAT --to-source 172.16.17.242

```
