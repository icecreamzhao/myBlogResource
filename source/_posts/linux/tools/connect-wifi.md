---
title: linux 连接wifi
date: 2020-01-01 04:25:16
categories:
- 运维
- linux
tags:
- linux的使用
---

# 步骤

* 查看自己的网卡名称

```shell
ifconfig
```

![ifconfig命令](/images/linux/ethcard/ifconfig.png)

<!--more-->

* 将wifi名和密码写入配置

```shell
wpa_passphrase wifi名 wifi密码 >> /etc/wpa_supplicant/网卡名.conf
```

* 加载配置文件

```shell
wpa_supplicant -i 网卡名 -c /etc/wpa_supplicant/网卡名.conf -B
```

* 查看能否获取到ip

```shell
dhclient 网卡名
ip addr
```
