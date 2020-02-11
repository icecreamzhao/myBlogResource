---
title: flutter 打包之后安装到手机上无法访问网络
date: 2020-02-10 16:52:48
categories:
- 移动开发
- flutter
tags:
- flutter
---

# 解决方案

在 `项目根目录/android/app/src/AndroidManifest.xml` 文件的第一层下添加一下内容:

```xml
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
```

来申请网络权限。
