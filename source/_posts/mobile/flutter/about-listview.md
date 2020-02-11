---
title: 关于flutter的listview控件需要注意的地方
date: 2020-01-17 04:42:14
categories:
- 移动开发
- flutter
tags:
- flutter
---

# 构造一个listview

官方文档给出了四中可以构造listview的方法, 下面是原文:

1. The default constructor takes an explicit List<Widget> of children. This constructor is appropriate for list views with a small number of children because constructing the list requires doing work for every child that could possibly be displayed in the list view instead of just those children that are actually visible.


<!--morl-->
2. The listView.builder constructor takes an IndexedWidgetBuilder, which builds the children on demand. This constructor is appropriate for list views with a large (or infinite) number of children because the builder is called only for those children that are actually visible.

3. The ListView.separated constructor takes two IndexedWidgetBuilders: `itemBuilder` builds child items on demand, and `separatorBuilder` similarly builds separator children which appear in between the child items. This constructor is appropriate for list views with a fixed number of children.

4. The ListView.custom constructor takes a SliverChildDelegate, which provides the ability to customize additional aspects of the child model. For example, a SliverChildDelegate can control the algorithm used to estimate the size of children that are not actually visible.

简单的翻译一下, 第一段的意思是说:

直接使用默认的构造器, 但是这种方式只适用于承载较少的子部件。

第二种方式是使用ListView的builder方法, 这种方式的好处是, 只有呈现在屏幕上的子部件才会调用这个方法, 所以比较适用于非常多的部件。

第三种方式是使用separated, 这种方式适用于带有固定的子部件的列表。

最后一种方式可以自己定义显示子部件的算法。

那么我们先使用第一种方式试试看:

```dart
import 'package:flutter/material.dart';

class DefaultConstructor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Text('内容一'),
          Text('内容二'),
          Text('内容三'),
          Text('内容四'),
          Text('内容五'),
          Text('内容六'),
        ],
      ),
    );
  }
}
```

大概是这种效果:

![listview效果](/images/mobile/flutter/flutter_listview_default_constructor.png)
