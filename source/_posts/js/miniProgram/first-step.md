---
title: 微信小程序的目录结构以及各个文件的用处
date: 2019-03-24 09:02:08
categories:
- js
- miniProgram
tags:
- miniProgram
---

# 总结

本篇博客介绍了微信小程序的目录结构以及各个文件的作用。
<!--more-->
# 微信小程序的目录结构

新建好一个微信小程序之后, 会有很多初始的目录和js文件, 来看看他们具体代表了什么意义。

## 根目录下的四个文件

分别是:

* app.js
* app.json
* app.wxss
* project.config.json

app.js

> 可以通过这个文件注册微信小程序应用

app.json

> 微信小程序应用的全局配置, 比如网络响应时间, 路径等等

app.wxss

> 微信小程序的全局样式


## 目录

有三个初始目录, 分别是:

* pages
* logs
* utils

pages

> 存放着小程序的所有页面, 每个小程序最多由四个文件组成, 分别是js文件, json文件, wxml文件, wxss文件
js文件可以处理页面的逻辑和数据交互
json 文件可以配置小程序的配置信息
wxml 文件可以展示页面的元素和内容
wxss 文件可以设置页面的样式

utils

> 存放着util.js文件, 存放工具函数, 达到代码复用的目的。
