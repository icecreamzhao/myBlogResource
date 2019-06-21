---
title: 关于小程序数组的一个坑
date: 2019-06-09 11:18:51
categories:
- js
- 小程序
tags:
- 小程序
- 坑
---

# 前言

有个需求是这样的, 有一个全局数组, 我需要在页面中监听这个数组并时刻将页面数组和全局数组保持同步, 我不太会watch什么的, 直接一个`setInterval`, 非常简单粗暴。

<!--more-->
# 解决方案

```js
data: {
  array: []
},

onLoad: function() {
  var appArray = getApp().globalData.array
  var that = this
  setInterval(function() {
    if (appArray && that.array !== appArray) {
      that.setData({
        array: appArray
      })
    }
  }, 1000)
}
```

这么写乍一看没啥问题, 但是实际测试的时候发现if语句里的语句只执行一次, 以后就不执行了, 仔细想想觉得应该是这样:

第一次setData()的时候绑定的是数组的地址, 而不是数组中的数据, 所以它就总是相等的了, 那么我们可以用for语句来对数组进行push, 这样就可以在全局变量被改变的时候去执行if里的语句了。
