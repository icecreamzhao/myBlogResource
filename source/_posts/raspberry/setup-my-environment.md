---
title: 设置我的树莓派环境脚本
date: 2020-06-16 04:18:02
categories:
- 运维
- raspberry
tags:
- shell
- raspberry
---

# 摘要

首先总结一下本篇博客的内容: 将一个全新的树莓派通过执行脚本的方式将我所有的使用习惯和开发环境下载到本地并编译, 该脚本通过命令选项的方式将所需要的可选项设置好, 这样脚本在执行中途就不需要等待用户输入了。

最后将所有的软件安装位置和安装的成功与否生成一个txt文本文档保存在用户根目录下。

本脚本如果在安装某个软件失败了, 需要自行解决并安装下一个软件。

<!--more-->

# 包含的所有东西

## 服务器部分

| 名称 | 版本 |
| :--: | :--: |
| tomcat | |
| nginx | |
| apache | |

## 开发环境部分

| 名称 | 版本 |
| :--: | :--: |
| java | |
| gcc | |
| clang | |
| llvm | |
| python | |
| gradle | |
| redis | |
| maven | |
| meriadb | |
| zookeeper | |
| cmake | |
| node | |
| make | |

## 工具部分

| 名称 | 版本 | 说明 |
| :--: | :--: | :--- |
| createap | | 可以将树莓派作为一个移动热点使用 |
| v2ray | | 代理, 包含server和client |
| seafile | | 文件管理 自带web gui |
| vsftpd | | ftp协议的文件共享 |
| vim | | 自己的一些配置 |

还包括 bashrc, vimrc。

## vim plugins

| 名称 | 版本 | 说明 |
| :--: | :--: | :--: |

# 脚本内容

## 思路

首先我需要一些变量来存储将要安装的软件的名字, 路径, 版本等:

```sh
#!/bin/bash

# 目录
PROGRAMPATH=~/programTools
SERVERPATH=~/server
TOOLPATH=~/tools

# 用户密码
PASSWD=""

# 开发环境程序
programList=("java", "gcc", "clang", "llvm", "python", "gradle", "redis", "maven", "meriadb", "zookeeper", "cmake", "node", "make")
serverList=("tomcat", "nginx", "apache")
toolList=("createap", "v2ray", "seafile", "vsftpd", "vim")

# gcc
GCCVERSION=10.1.0
GCCFILENAME=gcc-source.tar.gz

# make
MAKEVERSION=4.3
MAKEFILENAME=make-source.tar.gz

# git
GITVERSION=2.27.0
GITFILENAME=git-source.tar.gz
```

接着我需要编写一个帮助函数, 以便告诉用户这个脚本都支持那些参数:

```
show_help() {
	echo "命令行参数:"
	echo "--program-path: 开发环境所需程序的安装位置"
	echo "--server-path: 服务器程序的安装位置"
	echo "--tool-path: 工具的安装位置"
	echo "--show-program-list: 展示开发环境中所有可安装程序的列表(保存到当前目录下的program-list.txt)"
	echo "--show-server-list: 展示所有可安装服务器程序的列表(保存到当前目录下的server-list.txt)"
	echo "--show-tool-list: 展示所有可安装工具的列表(保存到当前目录下的tool-list.txt)"
}
```

然后是直接写在外面执行的接收参数的逻辑:

```sh
while test $# -gt 0 ; do
	case "$1" in
		-h | --help)
			show_help
			exit 0
			;;
		--server-path)
			shift
			check_line_args "$1" "服务器" "1" $#
			shift
			;;
		--program-path)
			shift
			check_line_args "$1" "开发环境" "2" $#
			shift
			;;
		--tool-path)
			shift
			check_line_args "$1" "工具" "3" $#
			shift
			;;
		--show-program-list)
			for (( i = 0 ; i <= ${#programList[@]} ; i++)) do
				echo ${programList[i]} >> program-list.txt
			done;
			exit 0
			;;
		--show-server-list)
			for (( i = 0 ; i <= ${#serverList[@]} ; i++)) do
				echo ${serverList[i]} >> server-list.txt
			done;
			exit 0
			;;
		--show-tool-list)
			for (( i = 0 ; i <= ${#toolList[@]} ; i++)) do
				echo ${toolList[i]} >> tool-list.txt
			done;
			exit 0
			;;
		*)
			echo "不支持的参数, 请使用 --help 查看帮助"
			exit 1
			;;
	esac
done
```

介绍一下这段脚本中的一些比较基础的语法:

* shift

将第一个参数移出。比如:

```sh
bash test.sh --a b
```

test.sh 的内容:

```sh
#!/bin/bash
shift
echo $1
```

输出为 b

* $1

代表第一个参数, 以此类推, $2 代表第二个

* $#

代表参数的个数

下面是check_line_args函数的实现:

```sh
check_line_args() {
	if test "$3" == "1" ; then
		SERVERPATH="$1"
	elif test "$3" == "2" ; then
		PROGRAMPATH="$1"
	elif test "$3" == "3" ; then
		TOOLPATH="$1"
	fi
	if test "$1" == "" ; then
		echo "请输入$2所需程序的安装路径"
		exit 1
	fi
	check_mkr "$1"
}
```

下面是check_mkr函数的实现:

```sh
check_mkr() {
	if [[ ! -d "$1" ]] ; then
		mkdir "$1"
	fi
}
```
