---
title: 商城开发笔记 -- 搭建工程
date: 2018-11-17 15:10:41
categories:
- 开发笔记
- 商城
tags:
- 商城开发
---

# 项目说明

## 简介

本项目用 intellij idea 进行开发, Maven管理项目依赖, 技术栈是传统的SSM (Spring, SpringMVC, Mybatis)框架, 前台使用vue

<!--more-->

<br>

## 框架

本项目包含了八个工程, 分别是:

* parent

  这个工程为所有工程的父工程

  * common

    用来存放所有公共方法的工程

  * web

    存放所有controller的工程

  * manager

    是下面所有工程的父工程

    * pojo

      存放实体类的工程

    * dao

      存放对数据库进行操作的工程

    * interface

      服务接口层

    * service

      服务实现类层

OK, 大概介绍了一下这个项目, 那么, 现在就开始动手搭建起来吧!

<br>

## 准备工作

[dubbo](http://dubbo.apache.org/zh-cn/docs/user/preface/background.html)

首先下载[intellij idea](http://www.jetbrains.com/idea/), 选择IU版, 下载安装激活一条龙

<br>

## 新建项目

打开你的idea, `File -> New -> project -> empty project`, 填写你的项目名称和路径

![选择模板](/images/my-project/shopping-mall/idea-create-project0.png)

![填写你的项目名](/images/my-project/shopping-mall/idea-create-project1.png)

现在你的项目大概长这个样子

![项目文件结构](/images/my-project/shopping-mall/idea-create-project2.png)

开始往这个项目里面添加工程, 首先先添加父工程

点击`File -> New -> Module -> Maven`, 由于我们的父工程的作用只是管理Maven依赖的版本的, 所以这里我们不勾选 `Create from archetype`

![新建父工程](/images/my-project/shopping-mall/idea-create-project3.png)

点击下一步, 填写你的域名和项目名

![填写父工程的域名和项目名](/images/my-project/shopping-mall/idea-create-project4.png)

点击下一步, 填写项目名和项目所在路径和项目配置文件路径**(iml文件所在路径)**

![选择父工程项目路径](/images/my-project/shopping-mall/idea-create-project5.png)

点击finish, 现在你的项目长这个样子

![父工程的项目文件结构](/images/my-project/shopping-mall/idea-create-project6.png)

前面说了, 因为父工程的作用只是管理Maven依赖版本, 所以, 将 src 文件夹删掉

OK, 现在, 我们继续

下面创建common模块

`File -> New -> Module -> Maven -> Next`, **注意, 这里和之前不一样, 需要你去选择要继承的工程, `add as module to`选择none, parent那里选择刚刚创建的parent**, 把工程名填写好

![选择继承的父工程](/images/my-project/shopping-mall/idea-create-project7.png)

点击下一步, 填写好工程名, 选好路径

![填写项目名选择项目路径](/images/my-project/shopping-mall/idea-create-project8.png)

OK, 现在你的项目不出意外长这个样子

![项目文件结构](/images/my-project/shopping-mall/idea-create-project9.png)

下面按照上面的步骤再创建一个工程, 名字叫manager, 因为manager工程中也不放任何代码, 所以可以将src目录删掉

看看你创建完的项目目录是不是和我的一样?(我这里忘记删掉src了【吐舌】)

![项目文件结构](/images/my-project/shopping-mall/idea-create-project10.png)

如果不一样, 请将你的manager删掉, 并仔细按照上面的步骤重新创建。那么接下来该创建子工程了, 我们第一个要创建的工程是pojo

同样地, 按照上面的步骤依次创建, **请注意,同样的, 到`Maven -> Next`那里, `add as module to`选择Manager, parent那里同样的选择manager**, 把工程名填写好

![选择需要继承的父工程](/images/my-project/shopping-mall/idea-create-project11.png)

那么, 按照上面的步骤, 依次把`dao, interface, service`创建好, 应该是这个样子

![项目文件结构](/images/my-project/shopping-mall/idea-create-project12.png)

还差最后一个工程我们就完成了! 胜利在望!

由于这个工程是一个web工程, 所以在Maven那里可以选择适合的模板, 挑选最后带有webapp字样的模板去创建, 而且这个工程应该是和common, manager同级, 所以`add as module to`同样选择none, parent那里选择parent

OK, 这个是我们这个项目最后的样子!

![最后的项目文件结构](/images/my-project/shopping-mall/idea-create-project13.png)

大功告成! 我们成功的搭建起了一个SOA架构的项目!

<br>

下一篇我们要搞一搞这个项目的其他依赖。