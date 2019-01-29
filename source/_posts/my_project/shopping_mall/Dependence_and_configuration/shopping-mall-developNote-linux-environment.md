---
title: 商城开发笔记-linux端环境搭建
date: 2018-12-09 17:56:18
categories:
- 开发笔记
- 商城
- 配置篇
tags:
- 商城开发
- linux
---

# 在Linux系统(CentOS)下搭建运行环境

<br>

## 前言

由于[这篇文章](/operation_system/deploy-system.html), 我尝试着把我的项目放到linux系统上运行试试看, 然后就有了这篇总结。

<!--more-->

<br>

## 准备

* 一台已经装好linux系统的电脑

嗯, 只需要这些, 具体装机的教程[看这里](/operation_system/deploy-system.html)。

<br>

## 搭建环境

具体的步骤[看这里](/linux/Linux_Basic_Operation/linux-java-git-maven-zookeeper.html)

按照以上步骤我们就可以得到一台安装好java, maven, git以及zookeeper的linux系统的电脑了。

<br>

## 启动项目

我们现在用的是linux系统, 当然要使用全自动化来做我们想做的事情啦, 所以编写shell脚本来运行我们的项目。

由于我们的项目架构是分布式的, 需要启动多个项目, 所以需要编写多个shell脚本来运行我们的项目。

> startShoppingMall.sh

```shell
#!/bin/bash
zookeeper=~/tools/zookeeper/bin
web=~/git/shopping_mall/web

sh $zookeeper/zkServer.sh
gnome-terminal -t "service_project" -x bash -c "sh ./startService.sh;exec bash;"

sleep 20s

cd $web
mvn tomcat7:run
```

具体的思路是:

1. 声明所需要的变量(2 - 3 行)
2. 启动zookeeper(5行)
3. 启动另一个窗口来执行启动service project的脚本(6行)
4. 等待20秒(8行)
5. 启动web project(10 - 11行)

> startService.sh

```shell
#!/bin/bash
service=~/git/shopping_mall/service
cd $service
mvn tomcat7:run
```

<br>

## 遇到的问题

### jdk解压缩的问题

oracle官网的jdk压缩包解压不了,  [这篇文章](/linux/Linux_Basic_Operation/linux-java-git-maven-zookeeper.html)里有讲。

<br>

### 启动项目不能访问的问题

* 启动项目之后访问不了, ubuntu没有这个问题, CentOS有, 因为CentOS自带防火墙, 需要将指定的端口设为白名单

#### 查看防火墙状态

```shell
$ systemctl status firewalld
```

#### 开启防火墙并设置开机自启

```shell
$ systemctl start firewalld
$ systemctl enable firewalld
```

#### 开放端口

```shell
$ firewall-cmd --zone=public --add-port=22/tcp --permanent
$ firewall-cmd --reload # 重新载入使更改生效
```

#### 查看指定端口是否开放

```shell
$ firewall-cmd --zone=public --query-port=22/tcp
```

#### 查看所有开放端口

```shell
$ firewall-cmd --zone=public --list-ports
```

#### 关掉开放的端口

```shell
$ firewall-cmd --zone=public --remove-port=22/tcp --permanent
$ firewall-cmd --reload # 重新载入使更改生效
```

#### 批量开放端口

```shell
$ firewall-cmd --zone=public --add-port=100-500/tcp --permanent
$ firewall-cmd --reload # 重新载入使更改生效
```

#### 批量限制端口

```shell
$ firewall-cmd --zone=public --remove-port=100-500/tcp --permanent
$ firewall-cmd --reload
```

#### 开放ip

```shell
$ firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="192.168.0.200" port protocol="tcp" port="80" reject"
$ firewall-cmd --reload # 重新载入使更改生效
```

限制指定ip访问指定端口

#### 查看设置的规则

```shell
$ firewall-cmd --zone=public --list-rich-rules
```

#### 解除ip限制

```shell
$ firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="192.168.0.200" port protocol="tcp" port="80" accept"
$ firewall-cmd --reload # 重新载入使更改生效
```

#### 限制ip段

```shell
$ firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="10.0.0.0/24" port protocol="tcp" port="80" reject"
$ firewall-cmd --reload # 重新载入使更改生效
```

其中10.0.0.0/24表示为从10.0.0.0这个IP开始，24代表子网掩码为255.255.255.0，共包含256个地址，即从0-255共256个IP，即正好限制了这一整段的IP地址，具体的设置规则可参考下表

| 选项 | IP总数 | 子网掩码        | C段个数 |
| ---- | ------ | --------------- | ------- |
| /30  | 4      | 255.255.255.252 | 1/64    |
| /29  | 8      | 255.255.255.248 | 1/32    |
| /28  | 16     | 255.255.255.240 | 1/16    |
| /27  | 32     | 255.255.255.224 | 1/8     |
| /26  | 64     | 255.255.255.192 | 1/4     |
| /24  | 256    | 255.255.255.0   | 1       |
| /23  | 512    | 255.255.254.0   | 2       |
| /22  | 1024   | 255.255.252.0   | 4       |
| /21  | 2048   | 255.255.248.0   | 8       |
| /20  | 4096   | 255.255.240.0   | 16      |
| /19  | 8192   | 255.255.224.0   | 32      |
| /18  | 16384  | 255.255.192.0   | 64      |
| /17  | 32768  | 255.255.128.0   | 128     |
| /16  | 65536  | 255.255.0.0     | 256     |

#### 打开限制ip段

```shell
$ firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="10.0.0.0/24" port protocol="tcp" port="80" accept"
$ firewall-cmd --reload # 重新载入使更改生效
```

* 还有一种情况是端口已经被占用

这种情况可以使用

```shell
$ netstat -nl | grep 8080
```

来查看指定的端口号有没有被占用, 更多的选项请输入

```shell
$ man netstat
```

来查看