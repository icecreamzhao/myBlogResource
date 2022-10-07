---
title: 创建你自己的linux服务
date: 2019-09-26 15:11:07
categories:
- 配置技巧/经验
- 系统配置
- linux
tags:
- linux的使用
---

# 目标

使用 systemd 来创建类似于 windows 中的服务。

# 步骤

* 编写需要执行的脚本
* 编写服务的脚本
* 开启服务

## 编写服务脚本

```shell
sudo vi /usr/lib/systemd/system/你的服务名字.service

# 下面是脚本内容

[Unit]
# 服务介绍
Description=enable some service
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

## 开启服务

```shell
sudo systemctl daemon-reload
sudo systemctl enable sunny.service
sudo systemctl start sunny.service
```

# 拓展阅读

[systemd 的github地址](https://github.com/systemd/systemd)
