---
title: 使用cocoscreator遇到的一些问题
date: 2019-11-16 11:40:54
catetories:
- cocos
- cocoscreator
tags:
- cocos
- android
---

# 前言

最近接手了一个使用 cocoscreator 的活, 由于之前没有接触过, 所以遇到了很多问题, 但是最后也都解决了, 今天想来记录一下。

# 问题

* 制作一个类系统弹窗, 并使背景置灰。

遇到这个需求时, 我的第一个反应是上官网找找有没有可以直接使用的弹窗组件。但是其实并没有这种东西, 所以需要自己搞一个。

<!--more-->

那么怎么搞? 其实难点只在于使背景置灰和屏蔽其他地方的click事件。那么我的思路是, 搞一个覆盖全屏幕的父组件, 由于cocoscreator是组件在上面的话, 那么在屏幕上的z轴就会在下面。所以首先应该放置灰层, 这个组件需要有 Sprite 和 Button, 直接将 Sprite 大小设置成覆盖全屏幕并设置为半透明(Opacity 属性和 color 属性就可以模拟置灰层), 然后给 Button 一个 click events, 但是并不给它指定的事件, 这样其他组件的点击事件就会被屏蔽, 其他的就好说了, 直接用组件拼一个弹窗就可以了。

我知道这样搞其实很low, 比较好的方式其实是通过代码来进行动态加工组件, 等有空的时候吧, 先加一个 //TODO, 哈哈。

* 如何使用本地代码

就是比如 android 平台有个本地方法, 如何在 cocoscreator 中调用? 其实很简单:

```js
if (cc.sys.isNative) {
	if (cc.sys.os == cc.sys.OS_ANDROID) {
		jsb.reflection.callStaticMethod('AppActivity', 'test()', '(Ljava/lang/String;)V', args + '')
	} else if (cc.sys.os == cc.sys.OS_IOS) {
		jsb.reflection.callStaticMethod('LxbFunctionMgr', 'openUrl:', args + '')
	}
}
```

这样不需要注释也可以看懂, `callStaticMethod` 方法参数依次是要调用的类, 要调用的方法, 参数类型和参数。

* 记录一些cocoscreator的demo

[cocoscreator官方文档](https://docs.cocos.com)
[cocoscreator教程demo集合](https://github.com/Leo501/CocosCreatorTutorial)
[cocoscreator学习笔记](https://github.com/shahdza/Cocos_LearningTest)

