---
title: 在服务器上部署seafile
date: 2019-09-24 13:56:56
categories:
- 配置技巧/经验
- 系统配置
- linux
tags:
- linux的使用
---

# 目标

部署 seafile 服务器

# 步骤

## 下载服务器端

地址[https://www.seafile.com/download/](https://www.seafile.com/download/), 注意, 这里需要看清楚自己的系统版本。

## 解压

```shell
tar -zxf seafile-server_*
```

## 安装之前的准备工作

```shell
apt-get update
apt-get install python2.7 python-setuptools python-imaging python-mysqldb
```

<!--more-->

## 安装

```shell
cd seafile-server-*
./setup-seafile-mysql.sh  #运行安装脚本并回答预设问题
```

## 启动

* 启动 seafile 服务器

```shell
./seafile.sh start # 启动 Seafile 服务
```

* 启动 seahub

```shell
./seahub.sh start <port>  # 启动 Seahub 网站 （默认运行在8000端口上）
```


* 停止服务

```shell
./seahub.sh stop # 停止 Seafile 进程
./seafile.sh stop # 停止 Seahub
```

* 重启服务

```shell
./seafile.sh restart # 停止当前的 Seafile 进程，然后重启 Seafile
./seahub.sh restart  # 停止当前的 Seahub 进程，并在 8000 端口重新启动 Seahub
```

## 遇到的问题

* mysql不能通过 127.0.0.1 进行连接

通过 `netstat -anpt | grep 3306` 命令查看端口占用情况, 可以通过修改 `/etc/mysql/mariadb.conf.d/50-server.cnf` 配置文件来增加绑定地址。

参考博客: [mariadb无法远程访问的解决思路](https://blog.csdn.net/wxmvp009/article/details/80190753)

* seafile 启动失败

通过 `./seahub.sh start-fastcgi` 命令来达到类似debug的启动效果, 有什么错误可以通过控制台查看

参考博客: [Seafile 之 Seahub 启动失败案例](https://www.jianshu.com/p/2e222a33a916)
