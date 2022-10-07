---
title: hexo建站教程
date: 2018-11-15 19:43:59
categories:
- 博客技巧/经验
- hexo
tags:
- hexo
---

# 使用GitHub Pages加hexo搭建博客教程

## 介绍

如果你需要搭建属于自己的博客, 但又觉得犯不上为了这么个类似于记笔记的地方花上个大几百块钱来租一台服务器, 那么GitPages了解一下! 

GitPages是Github网站用于给开发者搭建介绍自己的开源项目的静态网站, 不使用数据库存储数据, 所以我觉得用来写博客再合适不过了。而且显然不只我自己一个人这么认为, 甚至现在已经有帮助你更快速的搭建一个看起来现代化的博客的工具了, 就比如hexo, 它支持你使用**markdown**语法来写笔记, 其他的一切交给它就好, 是一款非常棒的工具。

<!--more-->

## 安装

### 新建一个 GitHub Pages 项目

介绍完了这两个东西, 那么就开始吧! 

1. 首先, 使用你的GitHub账号来新建一个项目

   ![点击这里!](/images/my-project/hexo/github-create-project0.png)

   ![命名规则是 username.github.io](/images/my-project/hexo/github-create-project1.png)

2. 接着进入到你刚刚创建的项目的设置里

   ![进入设置](/images/my-project/hexo/github-create-project2.png)

3. 然后找到GitHub Pages那一行, 选择一个分支, 点击保存

   ![开启GitHub](/images/my-project/hexo/github-create-project3.png)

**ok! 这样你就拥有了属于你自己的GitHub Pages项目!**

### 安装hexo

hexo自带[简中文档](https://hexo.io/zh-cn/docs/), 简单来说, 就是使用markdown解析文章, 并自动生成漂亮的静态网页。

由于hexo基于node, 所以需要首先安装node, [安装地址](https://nodejs.org/zh-cn/)。 ~~不知道的请去面壁...~~

安装好node之后, 使用`npm install -g hexo-cli` 来安装hexo

由于hexo3.0之后分模块化了, 所以, 必备的插件还是需要单独安装的, 比如:

hexo-server

安装命令是: `npm install hexo-server --save`

其他的插件[在这里](https://hexo.io/plugins/)

### 安装Git

Git是用来管理项目版本的, 可以使用这个工具将你的项目上传至你刚刚创建的GitHub工程中。[Git官网](https://git-scm.com/)

安装好Git之后, 我们还需要创建一个SSH密钥, 在开始菜单中找到Git bash, 设置Git 的Username 和 Email

命令是:

`git config --global user.name "你的username"`

`git config --global user.email "你的邮箱"`

然后创建一个SSH密钥

`ssh-keygen -t rsa -C "你的邮箱"`

连续三个回车, 你就能在你的用户根目录下找到.ssh文件夹了, 将id_rsa.pub文件中的内容拷贝到你的github账号设置中的SSH and GPG keys中去, 这样你就可以将你的项目上传至你的Github账号的项目中了。

### 万事大吉, 创建博客!

创建一个新的目录, 在该目录下使用`hexo init <folder>`命令, folder就是将要存放你的博客的内容的地方

cd到该目录下, 执行`npm install`

会创建以下目录

```
|---_config.yml   配置文件
|---package.json  
|---scaffolds 存放模板的地方
|---source 存放你的博客和其他资源的地方
|---themes 主题
```

修改配置文件`_config.yml`的头部分:

```xml
title: LittleboyDK's Blog <!-- 全局变量, 你的博客的标题 -->
subtitle:
description:
keywords:
author: littleboydk <!-- 作者名字 -->
language: zh <!-- 使用的语言 -->
timezone: Asia/Shanghai <!-- 时区 -->
```

以及尾部分:

```xml
deploy:
  type: git
  repo: git@github.com:icecreamzhao/icecreamzhao.github.io.git
  branch: master
```

配置好了之后, 就大功告成了! 现在让我们来看看搭建好的博客长什么样子吧! 使用`hexo server` 命令(需要安装hexo-server插件), 启动服务器, 在浏览器访问http://localhost:4000
