---
title: webpack-起步
date: 2018-12-12 21:38:19
categories:
- js
- webpack
tags:
- js
- webpack
---

# 前言

从今天开始, 我要学习前端, 我觉得webpack应该是必经之路, 所以做一下笔记。
<!--more-->
# webpack

先来简单的介绍一下webpack, 把项目当作整体, 通过一个给定的文件找到项目的所有依赖文件, 使用loaders处理他们, 最后打包为一个(或多个)浏览器可识别的JavaScript文件。

# 一个简单的demo

通过这个demo来学习webpack

## 安装

使用npm安装webpack

```shell
# 全局安装
npm install -g webpack
# 安装到特定的项目目录
npm install --save-dev webpack
```

## 准备

使用`npm init`来创建package.json文件, 这个文件说明了当前项目的依赖模块, 还包括自定义的脚本任务等等。

接下来终端会根据一系列的问题来创建相关的package.json文件, 当然如果不准备在npm中发布模块的话, 答案并不重要。

接下来在当前项目的根目录下创建两个文件夹:`app`和`public`, 接下来创建三个文件:`index.html`, 放在public文件夹中,  `Greeter.js`和`main.js`, 放在app文件夹中。

在`index.html`文件中写入html代码, 用来引入打包后的js文件。

```html
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <title>Webpack Sample Project</title>
    </head>
    <body>
        <div id='root'>
        </div>
        <script src="bundle.js"></script>
    </body>
</html>
```

接下来在`Greeter.js`文件中, 
