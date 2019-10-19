---
title: 开启属于自己的服务器
date: 2019-09-22 17:02:53
categires:
- 运维
- net
- ngrok
tags:
- ngrok
---

# 目标

将 22 端口开放到外网, 可以远程连接自己的虚拟机或者服务器。

# 物料

* 一台服务器(或者虚拟机, 或者树莓派等)
* ngrok 账号

# 准备

ngrok 的账号可以去[这里](https://www.ngrok.cc/login/register)注册。注册好之后, 找到隧道管理下的开通隧道, 选择最下面的香港 ngrok 免费服务器。

如果开通服务器端口使用 ssh 连接的话, 那么请选择 tcp 协议; 如果想开通网站请选择 http 协议。

> 注意, 如果选择 http 协议会有填写前置域名的选项。比如你想让你的域名看起来像这样: `blog.ngrok.cc`, 那么只需要填写 `blog` 就可以了。

<!--more-->

# 步骤

OK, 准备好账号, 并开通隧道了之后就可以在自己的服务器上运行客户端以便映射到隧道中了。

开通好之后, 可以在隧道管理里查看自己的隧道 id, 并点击客户端下载, 选择你的服务器的系统版本(我的是树莓派, 所以选择 linux arm 版本), 下载好之后放到你的服务器上。

编写一个脚本:

```shell
$ vi ngrokStart.sh

#! /bin/bash
sudo setsid ./sunny clientid deb6e36c40f9df4d,6c74653260c38b4f,2a42f4a692de6299
```

这样就可以通过这个脚本启动 sunny 这个服务了, 然后再写一个自启动服务, 让服务器开机之后自动执行这个脚本:

```shell
$ sudo vi /usr/lib/systemd/system/sunny.service

[Unit]
Description=enable sunny Service
After=network.target
# 声明可执行脚本
ConditionFileIsExecutable=/home/littleboy/tools/ngrok/startNgrok.sh

[Service]
Type=simple
# 如果执行失败则重新执行
Restart=always
RestartSec=5
# 自动执行脚本
ExecStart=/home/littleboy/tools/ngrok/startNgrok.sh --background

[Install]
WantedBy=multi-user.target
```

然后执行:

```shell
sudo systemctl daemon-reaload
sudo systemctl enable sunny.service
sudo systemctl start sunny.service
reboot
```

就可以实现开机自启了。
