---
title: 创建一个 vue 项目
date: 2019-06-24 14:48:19
categories:
- 前端技巧/经验
- vue
tags:
- vue
---

# 前言

之前学过一段时间的vue, 过了小半年不用, 居然连怎么创建vue项目都想不起来了, 很难受。所以这次打算把这个过程记录下来。
<!--more-->

# 配置环境

1. 下载node.js
2. 下载webpack
3. 下载vue
4. 使用vue创建项目

## 下载node.js

访问[这里](http://nodejs.cn/download/)来下载windows或者linux版本。

## 下载webpack

当下载和安装好node之后, 可以使用

```
node -v
```

来查看node是否安装好。node安装好之后就可以下载webpack了。

```
npm install webpack -g
npm install webpack-cli -g
```

这里使用的是全局安装, 也可以去掉`-g`替换成`--save-dev`来局部安装, 就是安装到当前文件夹。

## 下载vue

使用

```
npm install vue -g
npm install vue-cli -g
```

来下载vue和vue的脚手架。

## 使用vue创建项目

如果以上都是全局安装的话, 那么可以直接使用

```
vue init webpack project-name
```

这里`project-name`是你的项目名。

我之前在尝试新建一个vue项目的时候, 遇到的问题是我并不是全局安装, 全都是局部安装。那么在使用`vue init`的时候会说找不到这个命令, 那么可以将`node_modules/.bin`这个文件夹放到环境变量中, 这样`.bin`文件夹里面的`.cmd`文件就会被访问到了。

## 总结

嗯, 突然就想玩玩前端了。
