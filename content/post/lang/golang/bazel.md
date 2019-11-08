---
author: "wuxingzhong"
title: "Bazel"
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
# bazel

bazel , 支持java , c go 等等组织编译.  这样即使服务是异构 不同语言开发,相同构建方式. 

参考

```bash
https://blog.csdn.net/RA681t58CJxsgCkJ31/article/details/80504480
```

build的脚本

```bash
# build WORKSPACE 下面所有的 target
build //...

# 直接编译target
build //:demo

# 执行target
run //:demo

# 跑demo_test测试
test //:demo_test

# gazelle

bazel run //:gazelle

# 交叉编译

bazel build --experimental_platforms=@io_bazel_rule_go//go/toolchain:linux_amd64 //:demo

# 列出所有targets
# @workspace名称//://target
bazel query @com_github_grpc_grpc//... --output
label_kind

# 忽略目录
bazel build //... -//ignore_dir/...

# protoc
bazel run @com_github_google_protobuf//:protoc -- --help

# query deps
bazel query "rdeps(deps(//examples/...), @com_lls//:zlib)"

```
