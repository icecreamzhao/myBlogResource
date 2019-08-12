---
title: 微信小程序的一些技巧
date: 2019-08-01 13:18:55
categories:
- js
- 小程序
tags:
- 小程序
---

# 前言

最近工作上遇到了关于一些微信小程序开发的业务, 今天把遇到的问题总结一下。

# 目录

* 小程序设置tabbar选中颜色
* 将溢出的文本用省略号代替
* 特定区域滚动到顶部时固定
* 微信小程序select下拉框实现
* wx.navigateBack() 携带参数返回
* 微信小程序 选择器picker的使用

<!--more-->

# 小程序设置tabbar选中颜色

```js
'tabbar': {
  'selectedColor': '#4da9ff',
  'list': [
    {
      'pagePath': 'pages/index/index',
      'text': '首页',
      'iconPath': 'images/index.png',
      'selectedIconPath': 'images/index_on.png'
    }
  ]
}
```

`selectedColor`就是被选中tab的字体颜色。

# 将溢出的文本用省略号代替

先来看看效果:

![省略号代替溢出文本](/images/js/miniProgram/ellipsis.png)

比如有一个很长的文本需要展示:

```html
<view class="text-deal">aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</view>
```

但是又只能用一行去显示, 剩下的需要用省略号代替, 那么就可以这样:

```css
.text-deal{
  overflow : hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  /* 这里可以控制显示行数, 1 代表只显示1行, 2 代表显示两行 */
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  word-break: break-all;
}
```


# 特定区域滚动到顶部时固定

先来看看效果:

![固定顶部](/images/js/miniProgram/miniprogramFixedTop.gif)

页面部分:

```html
<scroll-view scroll-y scroll-width-animation style="width:100%; height:{{scrollheight}}px" bindscroll="scrollTopFun">
  <view wx:for="{{arr}}" wx:for-item="item" wx:key="{{item.id}}">
    <view>
      {{item.name}}
      <view wx:if="{{item.id == 10}}">
        topppppppppppp
      </view>
      <view wx:if="{{item.id == 10}}"  class="{{top > 252 ? 'topnav' : ''}}">
        我是要固定到顶部的
      </view>
      <view wx:if="{{item.id == 10}}">
        downnnnnnnnnnn
      </view>
    </view>
  </view>
</scroll-view>
```

js:

```js
data: {
  arr: [],
  top: 0,
  scrollheight: ''
},

onLoad: function () {
  // 初始化数组
  var arrT = new Array();
  for (var i = 0; i != 50; ++i) {
    arrT.push({id: i, name: 'abcd'})
  }
  this.setData({
    arr: arrT
  })

  // 获取屏幕的长度, 将这个长度固定到scroll-view的长度上
  var me = this;
  wx.getSystemInfo({
    success: function (res) {
      me.setData({
        scrollheight: res.windowHeight
      })
    }
  })
},

// 滚动时的调用方法
scrollTopFun(e) {
  this.setData({
    top : e.detail.scrollTop
  })
  console.log(e.detail.scrollTop)
}
```

最后是样式部分:

```css
.topnav{
  position: fixed;
  top: 0rpx;
  z-index:99;
  background: #fff;
  width: 100%;
}
```

# 微信小程序select下拉框实现

先来看下效果:

![下拉框](/images/js/miniProgram/miniprogramSelect.gif)

```html
<view class="select-group">
  <view>测试下拉框</view>
  <view class="select-all">
    <view class='list-msg2' bindtap='bindShowMsg'>
      <text>{{tihuoWay}}</text>
    </view>
    <view class="select_box" wx:if="{{select}}">
      <view class="select_one" bindtap="mySelect" data-name="1">下拉1</view>
      <view class="select_one" bindtap="mySelect" data-name="2">下拉2</view>
      <view class="select_one" bindtap="mySelect" data-name="3">下拉3</view>
    </view>
  </view>
</view>
```

js:

```js
data: {
  select: false,
  tihuoWay: '1'
},

bindShowMsg() {
  this.setData({
    select: !this.data.select
  })
},

mySelect(e) {
  var name = e.currentTarget.dataset.name
  this.setData({
    tihuoWay: name,
    select: false
  })
}
```

wxss:

```css
.select-group {
  display: flex;
  flex-direction: row;
}

.select-all {
  display: flex;
  flex-direction: column;
}

.select_box {
  background-color: #eee;
  padding: 0 10rpx;
  width: 100rpx;
  position: absolute;
  top: 80rpx;
  z-index: 1;
  overflow: hidden;
  animation: myfirst 0.3s;
}

.list-msg2 {
  height: 60rpx;
  width: 100rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
  border: 1px solid #ccc;
  padding: 0 10rpx;
}
```

# wx.navigateBack() 携带参数返回 

先来看看效果:

![navigateBack](/images/js/miniProgram/navigateBack.gif)

第一个页面的js:

```js
data: {
  // 获取上个页面返回的数值
  prePageData: ''
},

toNextPage: function() {
  wx.navigateTo({
    url: '/pages/prePage/prePage',
  })
},
```

第一个页面的wxml:

```html
<view bindtap='toNextPage'>到下个页面</view>
<view>上个页面的东西: {{prePageData}}</view>
```

第二个页面的js:

```js
returnToPrePage: function() {
  // 获取页面栈
  var pages = getCurrentPages();
  // 获取上个页面的实例
  var prePage = pages[pages.length - 2];

  prePage.setData({
    prePageData: 'hahaha'
  })

  wx.navigateBack({
    delta: 1
  })
}
```

第二个页面的wxml:

```html
<view bindtap='returnToPrePage'>返回上个页面</view>
```

# 微信小程序 选择器picker的使用


