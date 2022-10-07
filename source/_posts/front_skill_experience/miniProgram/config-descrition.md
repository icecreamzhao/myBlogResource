---
title: 微信小程序的配置介绍
date: 2019-03-24 09:26:32
categories:
- 前端技巧/经验
- 微信小程序
tags:
- 微信小程序
---

# 总结

本篇博客介绍了各个配置文件可以设置的一些选项以及含义
<!--more-->

# 全局配置文件介绍

app.json

| 属性 | 含义 |
| :--- | :--- |
| pages | 可以注册小程序的所有的页面 |
| tabBar | 注册小程序的所有的tab |
| networkTimeout | 可以设置网络请求的超时时间 |
| debug | 可以开启debug模式, 在微信调试控制台中打印调试信息 |

# 单独页面的配置文件介绍

以下所有的元素, 全局配置文件中也可以进行配置

| 属性 | 含义 |
| :--- | :--- |
| navigationBarBackgroundColor | 导航栏的背景颜色 |
| navigationBarTextStyle | 导航栏的标题颜色 |
| navigationBarTitleText | 导航栏的标题文字内容 | 

**窗体表现**

| 属性 | 含义 |
| :--- | :--- |
| backgroundColor | 窗体背景颜色 |
| backgroundTextStyle | 窗体下拉时文字的样式 |
| onReachButtonDistance | 上拉事件执行 |
| enablePullDownRefresh | 可以设置全局窗体下拉刷新的表现 |

disableScroll

> 可以设置页面是否开启滚动

只有单独页面可以设置此选项
