---
title: CentOS的ssh远程连接遇到的问题
date: 2019-06-21 19:17:15
categories:
- 操作系统
- linux
tags:
- linux
- ssh
- centos
---

# 前言

之前由于在我的surface book 2 上开虚拟机, 然后一直都是本地连接, 所以一直都没啥问题。后来因为我要在另一台电脑上搞点东西, 然后还用到了linux, 所以想着直接局域网下远程访问这台虚拟机应该也是没啥问题的吧, 但是也还是遇到了一些坑, 故此记录一下。
<!--more-->

# 问题复盘

第一步我直接在另一台电脑上装了putty天真的想像本地连接那样访问这台虚拟机, 遇到的第一个问题就是ip地址问题。

## ip地址

我是使用VM来开的虚拟机, 由于我的虚拟机的网络适配器一开始设置的模式是仅主机模式, 所以局域网内其他的电脑是访问不到这个系统的。那么解决的方式是切换成NAT模式, 和主机共享同一个ip, 这样其他电脑如果想访问这个系统的话直接访问主机的ip就可以了。

## ssh端口

那么接下来可以访问到了之后, 马上就遇到了下一个问题, 就是端口问题。我尝试着使用putty来访问主机的ip, 端口是默认的22, 直接连接到了windows的cmd模式, 由于ssh的默认端口都是22, 所以会直接访问到windows开放的ssh。那么这里可以用端口转发来解决这个问题。

在虚拟网络编辑器下, 点击nat设置, 就可以设置端口转发了。主机端口代表你要使用其他电脑访问这台主机的端口, 设置一个非ssh默认值就可以了, 比如23之类的。虚拟机ip地址则是这台虚拟机的ip加上ssh的默认端口22, 这样就可以直接以主机ip:23的来访问这台虚拟机了。

那么也可以修改linux默认的ssh端口。可以查看[这篇文章](https://blog.csdn.net/mrqiang9001/article/details/78308830)。

# 总结

感觉说的比较笼统, 遇到的问题和解释的内容都不具体, 有功夫的话在重新好好的重构一篇吧。