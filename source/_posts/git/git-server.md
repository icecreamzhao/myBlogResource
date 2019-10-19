---
title: 使用git搭建服务器
date: 2019-09-01 16:39:23
categories:
- git
- 服务器
tags:
- git
---

# 前言

当我们想使用git来管理源码, 但是又不想将代码上传至github或者其他的托管平台时, 可以尝试着自己搭建一个git服务器作为私有仓库。

<!--more-->

# 安装git

安装git的话, 有两种方式, 一种是直接使用包管理系统安装, 另外一种是使用编译的方式安装。

## 包管理系统安装git

* debian

apt-get install git

* centos

yum install git

## 编译的方式安装git

去[这里](https://github.com/git/git/releases)查看git的最新版本并下载, 在写篇博客时, 最新版本是2.23:

```shell
wget https://github.com/git/git/archive/v2.23.0.tar.gz -O git-2.23.0.tar.gz
# 解压
tar -zxf git-2.23.0.tar.gz
cd git-2.23.0
# 编译并指定安装位置
make prefix=/home/littleboy/tools/git/build all
make prefix=/home/littleboy/tools/git/build install
# vi ~/.bashrc
# 添加:
export PATH=/home/littleboy/tools/git/build:$PATH
```

# 创建一个git用户

```shell
useradd git -m
```

# 创建证书登录

获取到需要登陆到服务器的机器的公钥, 将公钥放到`/home/git/.ssh/authorized_keys`文件中。

# 初始化Git仓库

选定一个目录, 并使用命令来初始化:

```shell
sudo mkdir /gitStorage & cd /gitStorage
git init --bare sample.git
# 将owner改为git
sudo chown -R git:git sample.git
```

# 禁用shell登录

```shell
sudo vi /etc/passwd
# 找到类似于, 并不一定完全相同的一行:
# git:x:1001:1001:,,,:/home/git:/bin/bash
# 将bash改为 git安装目录/bin/git-shell
```

# 克隆git仓库

```shell
git clone git@ipAddress:/gitStorage/sample.git
```

ok, 基本上git服务器就搭建完成了。那么接下来介绍使用场景。

* 已经有了一个本地的git项目, 希望添加一个远程仓库。

```shell
# 添加一个远程仓库并指定一个简单的名字
git remote add test git@ipAddress:/gitStorage/sample.git
git add .
git commit -m "first commit"
# 拉取远程仓库
git fetch test
# 查看远程仓库的详情
git remote show test
# 如果远程仓库没有master分支, 那么就创建一个:
git push test master
# 现在查看一下本地的分支, 应该只有一个master分支
git branch -a
# 将远程仓库的某一个分支绑定到本地分支
# git branch --set-upstream-to=远程仓库的别名/远程仓库的分支 本地分支
git branch --set-upstream-to=test/master master
# 拉取远程仓库
git pull
```
