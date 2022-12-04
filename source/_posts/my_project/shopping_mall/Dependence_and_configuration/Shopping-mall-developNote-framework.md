---
title: 商城开发笔记 -- 架构(已废弃, 开新坑)
date: 2018-11-16 21:31:10
mermaid: true
categories:
- 开发笔记
- 商城
- 配置篇
tags:
- 商城开发
---

> 说明
本系列作者已弃坑, 新坑地址: [家家乐商城开发笔记](/my_project/family_happy_mall/function/first-description.html)

# 前言

OK, 从今天开始, 我将不定时更新这个系列, 也可以说是一个专栏, 我将开发一个商城, 当然是练手用的, 哈哈。
期间我会把我遇到的所有的难以解决的问题, 解决方案, 突然出现的想法都记录在这个系列里, 希望能帮助到你。

## 简介

本项目的目的是让开发者体验一下现代的大型商业项目的全开发过程, 同时本项目将会使用一些比较常见的开源工具, 并将该工具的使用方式记录到本系列中, 如果我觉得有必要, 甚至会自己去实现一个简单的该开源工具, 并将过程记录下来。 OK, 不多bb, 让我们开始吧! 

<!--more-->

## 架构

首先来介绍一下本项目的架构, 在介绍本项目架构之前, 先来介绍一下都有什么架构吧

![架构示意图](/images/my-project/shopping-mall/dubbo-architecture-roadmap.jpg)

1. **ORM**

   单一应用架构, 最原始的架构, 将所有的功能都放到一起, 形成一个系统, 维护性差

2. **MVC**

   垂直应用架构, 将应用拆分成互不相干的几个应用(比如数据库访问层, 服务层, 表现层)

3. **RPC**

   分布式应用架构, 当垂直应用越来越多, 应用之间交互不可避免, 将核心业务独立出来

   举个例子

   商城系统, 在将核心业务独立出来之前, 他的架构是MVC架构, 也就是说分三个模块, 数据库操作层, 服务层, 表现层。也就是这个样子:

   ```mermaid
   graph TB
   orm[数据库操作层] --> service[服务层]
   service --> controller[表现层]
   controller --> view[视图]
   ```

   非常明显的垂直应用架构对吧, 当有垂直应用增加的时候, 会变成这个样子:

   ```mermaid
   graph TD
   order[商城系统] --> orm[订单数据库操作层]
   order --> memberOrm
   order --> goodOrm
   orm --> goodService
   orm --> orderService[订单服务层]
   orderService --> orderController[订单表现层]

   memberOrm[会员数据库操作层] --> orderService[订单服务层]
   memberOrm --> memberService[会员服务层]
   memberService --> memberController[会员表现层]

   goodOrm[商品展示数据库操作层] --> orderService[订单服务层]
   goodOrm --> goodService[商品展示服务层]
   goodService --> goodController[商品表现层]
   ```

   ​    这样的系统复杂程度增加之后会不利于维护, 那么, 我们将核心模块独立出来, 拆分成多个工程, 这样就可以将一个系统部署到多台服务器上了

   ```mermaid
   graph TD
   order[订单系统] --> orm[数据库操作层]
   orm --> orderService[订单服务层]
   orm --> goodService
   orderService --> orderController[订单表现层]

   member[会员系统] --> memberOrm[会员数据库操作层]
   memberOrm --> orderService
   memberOrm --> memberService[会员服务层]
   memberService --> memberController[会员表现层]

   goodShow[商品展示系统] --> goodOrm[商品展示数据库操作层]
   goodOrm --> orderService
   goodOrm --> goodService[商品展示服务层]
   goodService --> goodController[商品表现层]
   ```

   ​

4. **SOA**

   ​    现在的架构, 每一个服务都是独立的, 那么如果想要跨服务器去调用会非常困难, 这个时候, 服务中心就出现了, 所有的服务都需要在这个服务中心去注册并暴露ip和端口, 表现层在调用的时候就可以直接通过该ip去调用, 大概长这个样子

   ```mermaid
   graph TD
   orderController[订单表现层] --> serviceCenter[服务中心]
   goodController[商品表现层] --> serviceCenter
   memberController[会员表现层] --> serviceCenter

   serviceCenter --> orderService[订单服务层]
   serviceCenter --> goodService[商品服务层]
   serviceCenter --> memberService[会员服务层]
   ```

   ​

显而易见, 当然是SOA架构最好了, 我们的这个项目也会采用这种架构来进行开发, 下面来简单介绍一下这个项目的模块组成。