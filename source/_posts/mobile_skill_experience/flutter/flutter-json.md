---
title: flutter 和 json
date: 2020-01-02 10:10:42
categories:
- 移动开发技巧/经验
- flutter
tags:
- json
- flutter
---

# 前言

前面讲了如何配置flutter的开发环境, 这次来说说如何使用flutter解析json, 等弄明白了如何解析json, 那么就可以进行网络开发了, 因为现在绝大部分传输数据使用的都是json格式, 那么接下来就说说如何解析json吧。

flutter 有两种方式, 一种是如果是比较简单的 json 的话, 可以直接手动解析, 另外一种是针对比较复杂的格式, 使用实体类来映射, 那么接下来分别介绍这两种方式。

<!--more-->

# 手动解析

具体实现方式:

```dart
import 'dart:convert';

String resultJson = '{"result":"1","datas":[{"url":"images/logo.jpg"},{"url":"images/logo1.jpg"}],"message":"success"}';

Map map = json.decode(resultJson);
String result = map["result"];
List datas = map["datas"].toList();
String message = map["message"];
```

# 实体类

如果格式比较复杂的情况, 需要使用[这个地址](https://javiercbk.github.io/json_to_dart)来生成实体类, 可以先使用[这个网站](http://www.bejson.com)来校验json的格式是否正确。

![flutter和json](/images/mobile/flutter/flutter-json-class.png)

接下来将生成的class复制到 xxx.dart 中, 并在文件头部加上以下内容:

```dart
import 'package:json_annotation/json_annotation.dart';
part 'xxx.g.dart';

#JsonSerializable(nullable: false)
```

接着在 terminal 中执行 `flutter packages pub run build_runner build` 命令来生成所需文件。

也可以使用 `flutter package pub run build_runner watch` 命令来监控是否有需要生成的文件。

使用方式:

```dart
Xxx xxx = new Xxx.fromJson(json);
```

嗯, 第二种方式是目前官方最推荐的方式了。
