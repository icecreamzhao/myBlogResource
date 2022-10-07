---
title: 使用树莓派开启热点
date: 2019-08-18 11:16:36
categories:
- 配置技巧/经验
- 系统配置
- linux
tags:
- linux的使用
---

# 前言

我也是不知道怎么折腾才好了, 之前尝试着将centos装到树莓派上无果, 这不才下载了[树莓派的官网](https://www.raspberrypi.org/downloads/raspbian/)上的系统, 烧录到内存卡上, 这才算是能用上它。但是因为我更倾向于面向命令行, 图形界面无感(尤其是linux -_-!), 所以装了官网上的最小的版本, 在下载的时候我就已经做好了觉悟, 由于是最小的版本, 所以基本上要啥啥没有, 嗯, 以后有够折腾的了。

那么既然要打算命令行, 那么肯定是要ssh登录的了, 所以这才想着让树莓派自己发射wifi信号, 然后自己开放ssh端口, 这样就省去路由器这一步了, 那么就开始吧。
<!--more-->

# 下载create_ap

[create_ap](https://github.com/oblique/create_ap)是github上的一个开源的shell项目, 它使用了hostapd, dnsmasq等开源项目来达到软路由的效果, 首先先下载下来:

```shell
git clone git@github.com:oblique/create_ap.git
```

然而第一步我就遇到了困难, 没有git...

那就装一个呗。

## 安装git

这里有两个方式来安装git, 一种就是使用包管理系统来安装, 非常的方便快捷, 另外一种就是源码安装, 可以自定义安装的各种配置。

### 包管理系统安装

debian/ubuntu:

```shell
sudo apt-get update
sudo apt-get install git
```

centos:

```shell
yum install git
```

验证一下是否安装成功:

```shell
git --version
```

如果有输出的话, 那么就代表安装成功了。

### 源码安装

相对来说较复杂, 首先需要安装构建git所需要的软件包:

```shell
sudo apt update
sudo apt-get install make libssl-dev libghc-zlib-dev libcurl4-gnutls-dev libexpat1-dev gettext unzip
```

然后到[这里](https://github.com/git/git/archive)来查看最新版的链接地址, 使用wget下载下来。

```shell
cd /home/users/git
wget https//github.com/git/git/archive/v2.18.0.tar.gz
```

下载好之后开始解压文件:

```shell
sudo tar v2.18.0.tar.gz
cd v2.18.0
```

之后就可以编译安装了:

```shell
sudo make prefix=/usr/local all
sudo make prefix=/usr/local install
```

如果你没有安装到默认目录, 那么还需要在`~/.bashrc`文件中将git的安装路径放入PATH中:

```shell
export PATH=/你的安装路径:$PATH
export PATH=/你的安装路径/libexec/git-core:$PATH
```

参考博客:
[deiban安装git](https://linux265.com/news/3371.html)

> ok, git 安装好了, 现在可以安安心心的下载咱们的create_ap了。

## 编译create_ap

下载好之后就可以使用make来编译这个项目了:

```shell
cd create_ap
sudo make install
```

喔不, 又出现了一个问题: command dnsmasq not found!

仔细一看, 原来是他用到了dnsmasq, 而我的系统里没有这个东西, 怎么办, 继续装呗...

### 安装dnsmasq

到[官网](www.thekelleys.org.uk/dnsmasq)查看最新的版本, 将之下载下来, 解压, 安装:

```shell
wget http://www.thekelleys.org/uk/dnsmasq/dnsmasq-2.75.tar.gz
tar -xf dnsmasq-2.75.tar.gz
cd dnsmasq-2.75
make install
```
安装完毕即可查看dnsmasq的版本:

```
dnsmasq -v
```

参考博客:
[dns安装与配置](https://www.olinux.org.cn/linux/990.html)

> 嗯, 让我们在继续运行 make install 看看

现在没啥问题了, 那么让我们来尝试着使用看看:

```
sudo create_ap wlan0 热点名 密码
```

嗯, 果然一步一个坑, 还是报错了:

```shell
hostapd command not found
```

继续按呗:

### 安装 hostapd

下载, 安装:

```
git clone git://w1.fi/srv/git/hostap.git
cd hostap/hostapd
```

注意, 这里需要改一下配置:

```shell
cp defconfig .config
vi .config
# 找到 CONFIG_DRIVER_NL80211=y, 将#号去掉
```

执行: make, 如果这里报错了, 那么先使用包管理系统安装:

```shell
sudo apt-get install libnl-genl-3-200 libnl-genl-3-dev libnl-idiag-3-dev
```
参考博客:
[hostapd linux documentation page](https://blog.csdn.net/magod/article/details/6736102)

# 配置create_ap

修改/etc/create_ap.conf, 将名称和密码修改为自己想要的, 保存。
修改 /usr/lib/systemd/system/create_ap.service, 在最下方加上一句:

```shell
ExecStart=/usr/bin/create_ap -n wlan0 热点名 密码
```

保存退出, 执行:

```shell
sudo systemctl daemon-reload
sudo systemctl enable create_ap.service
sudo systemctl start create_ap.service
reboot
```

开启启动就可以看到新创建的热点了!

参考博客:
[树莓派开热点并自动启动](https://blog.csdn.net/zanran8/article/details/80698347)
