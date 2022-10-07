---
title: javascript权威指南读书笔记-第一天
date: 2018-12-13 21:01:45
categories:
- 笔记
- 读书笔记
- JavaScript权威指南
tags:
- js
---

# null和undefined

null 的类型是Object(可用typeof来得到结果), 而undefined的类型就是undefined

undefined是一个预定义的全局属性, 而null是一个关键字

通常如果想要给一个变量传入空值的话, 最佳选择是null

# 包装对象

```js
var s = "test";
s.len = 4;
console.log(s.len);
```

output:

```js
undefined
```

在声明一个字符串类型的值时, JavaScript会这样做:

```js
var s = new String("test");
```

而之后就会销毁这个对象, 所以给它定义属性也会被忽略, 同理, 数字和布尔值也是这样的做法。

