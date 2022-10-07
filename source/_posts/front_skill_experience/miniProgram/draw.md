---
title: 关于微信小程序的canvas
date: 2019-06-09 10:45:14
categories:
- 前端技巧/经验
- 微信小程序
tags:
- 微信小程序
- canvas
---

# 目录

[在canvas上显示图片](#在canvas上显示图片)
[在canvas上画图](#在canvas上画图)

# 在canvas上显示图片

首先, 我们需要一个canvas的页面元素:

<!--more-->

```html
<!-- canvas.wxml -->
<canvas style="width: {{canvasWidth}}px; height: {{canvasHeight}}px;" canvas-id="firstCanvas"></canvas>
```

> 这里我们采用了canvas自适应屏幕的方案

然后js里我们需要这些数据:

```js
Page({
  data: {
    pictureUrlTmp: '',
    pictureUrl: '',
    canvasHeight: 0,
    canvasWidth: 0,
  }
})
```

> pictureUrlTmp 是本地缓存图片的路径

这里需要说明, 在真机上经过测试之后发现, 显示图片需要先将图片下载下来, 缓存到本地之后才可以正常显示。

那么我们就来写一个downloadFile的方法:

```js
downloadF: function (appPictureUrl, that) {
  return new Promise(function (resolve, reject) {
    wx.downloadFile({
      url: appPictureUrl,
      success(res) {
        if (res.statusCode == 200) {
          console.log(res.tempFilePath)
          that.setData({
            pictureUrlTmp: res.tempFilePath,
            pictureUrl: appPictureUrl
          })
          resolve(res.tempFilePath);
        }
      }
    })
  })
}
```

由于我们需要先将文件下载好, 在显示, 所以我们这里使用了promise。

接下来我们需要将图片显示出来:

```js
onReady: function () {
  var that = this
  var myCanvasWidth
  var myCanvasHeight
  wx.getSystemInfo({
    //获取系统信息成功，将系统窗口的宽高赋给页面的宽高  
    success: function (res) {
      myCanvasHeight = res.windowHeight
      myCanvasWidth = res.windowWidth
    }
  })
  that.setData({
    canvasWidth: myCanvasWidth,
    canvasHeight: myCanvasHeight
  })

  var context = wx.createCanvasContext('firstCanvas', this)
  that.downloadF(appPictureUrl, that).then(res => {
    console.log(res)
    context.drawImage(that.__data__.pictureUrlTmp, 0, 0, myCanvasWidth, myCanvasHeight))
    context.stroke()
    context.draw()
  })
}
```

> 这里将全局变量的pictureUrl下载下来, 然后画到画布上

# 在canvas上画图

这个官方文档比较全, 我这边只是简单做个介绍。这里是[官方文档地址](https://developers.weixin.qq.com/miniprogram/dev/api/canvas/CanvasContext.html)。

```js
// 按照上面的步骤已经获取到了context:

context.setStrokeStyle('#000')
context.setLineWidth(2)
context.moveTo(0, 0);
context.lineTo(0, 100);
context.stroke()
context.draw()
```
