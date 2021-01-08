---
title: Flutter 按钮二三事
date: 2020-12-23 14:37:07
categories:
- 移动开发
- flutter
tags:
- flutter
---

# 前言

在flutter中, 内置了很多不同的按钮, 其中有一些已经要被放弃掉了, 今天来梳理一下。

# 被废弃和被替换的按钮

| 废弃的按钮 | 废弃的按钮样式 | 替换的按钮 | 替换的按钮样式 |
| :------- | :-------------- | :---------- | :------------- |
| FlatButton | ButtonTheme | TextButton | TextButtonTheme |
| RaisedButton | ButtonTheme | ElevatedButton | ElevatedButtonTheme |
| OutlineButton | ButtonTheme | OutlinedButton | OutlinedButtonTheme |

## 变化

### 样式变化

按照[官方文档](https://flutter.dev/go/material-button-migration-guide)所说, 新的按钮符合当前Material Design规范, 所以看起来和以前有所不同, 具体体现在内边距, 边角弧度和按住/悬停/按下的反馈。

### 属性的变化

由原先的:

```dart
FlatButton(
  focusColor: Colors.red,
  hoverColor: Colors.green,
  splashColor: Colors.blue,
  onPressed: () { },
  child: Text('FlatButton with custom overlay colors'),
)
```

变为现在的:

```dart
TextButton(
  style: ButtonStyle(
    overlayColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.focused))
          return Colors.red;
        if (states.contains(MaterialState.hovered))
            return Colors.green;
        if (states.contains(MaterialState.pressed))
            return Colors.blue;
        return null; // Defer to the widget's default.
    }),
  ),
  onPressed: () { },
  child: Text('TextButton with custom overlay colors'),
)
```

也就是说全部由ButtonStyle接管, 就像TextField中的style一样。
