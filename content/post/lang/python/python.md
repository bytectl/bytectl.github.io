---
author: "wuxingzhong"
title: "Python环境"
date: 2019-10-11T19:07:03+08:00
draft: false
tags: ["python"]
categories:  [""]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---

## 1. [下载](https://www.python.org/)安装

```bash
直接运行安装包即可

```

## 2. 配置

### 包控制器 pip

```bash
https://pypi.python.org/pypi

# 下载
wget https://pypi.python.org/packages/11/b6/abcb525026a4be042b486df43905d6893fb04f05aac21c32c638e939e447/pip-9.0.1.tar.gz#md5=35f01da33009719497f01a4ba69d63c9


#　解压
tar -zxvf pip-9.0.1.tar.gz

# 安装
cd pip-9.0.1/
python setup.py  install

# 安装 mysql-python
pip install MySQL-python

```

## 镜像

```bash
# 临时设置镜像
# 清华镜像
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple xxxx包

```

```python
# -*- coding:utf-8 -*-

import re 

fp = open("init.sql","r")

lines = fp.readlines();
array_list = []
for line in lines:
	obj = re.search(r"into\s+(\w+)\(.*\"(.*)\"", line, re.M | re.I )
	if obj:
		array_list.append(obj.groups())
print array_list

ran = range(0, len(array_list)-1 ,3)
print ran

for i in ran :
	flag = 0
	if(array_list[i][0] == array_list[i+1][0] and 
		array_list[i+1][0] == array_list[i+2][0] ):
		flag = 1
	if flag :
		line = "insert into %s(id, title) values(1, \
'{\"zh\":\"%s\", \"zh_hk\":\"%s\", \"en\":\"%s\"}')" \
		%(array_list[i][0], array_list[i][1],array_list[i+1][1],array_list[i+2][1])
		print line
	else:
		print "error %s %s %s " \
		% (array_list[i][1],array_list[i+1][1],array_list[i+2][1])
fp.close()
```
