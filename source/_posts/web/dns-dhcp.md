---
title: DNS 和 DHCP 的区别以及原理
date: 2019-09-14 18:55:00
categories:
- 运维
- net
tags:
- web
- dns
- dhcp
---

DHCP 是一种能够将 ip 地址和 相关的 ip 信息分配给网络中计算机的协议; 而 DNS 技术可以将域名转换成 ip 地址。这都是为了确保计算机可以找到合适的站点。虽然上面一句话概括了 DNS 和 DHCP 的定义, 但是他们具体的工作原理是怎么样的? 它们又有什么区别? 下面将逐一介绍。

<!--more-->

# DHCP 是什么?

DHCP (Dynamic Host Configuration Protocol) 即动态主机配置协议。主要用于快速给计算机分配 ip 地址。此外, 它还可以给设备正确的配置子网掩码, 默认网关和 DNS 服务器信息。由于这些功能, 现在几乎每台连接到网络的机器都配置了 DHCP。例如计算机, 千兆网交换机, 网络交换机等。在网络交换机上使用 DHCP 可以提供许多有价值的 TCP/IP 服务, 例如自动升级客户端系统上的软件。因此, 现在大多数的网络交换机都支持 DHCP。

# DHCP 如何工作?

DHCP 的工作原理是将 IP 地址和 IP 信息 "出租" 给设备一段时间。因此 DHCP 客户端必须通过一系列 DHCP 消息与 DHCP 服务器进行交互, 主要包括 DHCP DISCOVER, DHCP OFFER, DHCP REQUEST, DHCP ACK。如下图所示:

![dhcp工作原理](/images/web/dhcp/dhcp.jpg)

首先客户端发送广播数据包 DHCP DISCOVER(包括计算机的 MAC 地址和名称), 便于 DHCP 相应。它基本上在说 "我正在寻找一个可以租用 ip 地址的 DHCP 服务器"。服务器接收 DHCP DISCOVER 并使用 DHCP OFFER 响应, 然后客户端回复 DHCP REQUEST, 这意味着他想接收 DHCP 服务器发送的配置。获取此 DHCP REQUEST 消息后, DHCP 服务器将发送 DHCP ACK 消息给 DHCP 客户端, 告知 DHCP 客户端可以使用分给他的 ip 地址。

# DNS 是什么?

DNS(Domain Name System) 即域名系统。由解析器和域名服务器构成。如上述所提, 他们可以匹配可读名称和他们相关的 ip 地址。DNS 是网络基础架构中的重要组件, 它在提供内容和应用程序的同时确保了高可用性和用户响应时间。若是 DNS 失败, 则大多数应用程序将无法运行。

# DNS 如何工作?

如下图所示:

![DNS工作原理](http://image109.360doc.com/DownloadImg/2018/10/1207/146713824_2_20181012072214527)

当我们在浏览器中输入域名的时候, 例如 [icecreamzhao.github.io](https://icecreamzhao.github.io), 浏览器通常不知道该域名在哪里。因此, 它向本地 DNS 服务器 (LDNS) 发送查询。询问关于该域名的 ip 地址是多少的问题。如果 LDNS 没有记录, 他将在互联网中搜索查找出谁拥有该域名。首先, LDNS 进入其中一个根服务器, 将其定向到 .io DNS 服务器。然后该服务器找到拥有者并通知 LDNS 该域名的名称服务器(NS)的记录。LDNS 通过请求包含该域名的 ip 地址的地址记录来响应。LDNS 收到 ip 地址记录后, 会将 ip 地址发送给浏览器, 并缓存该记录以备将来参考。
