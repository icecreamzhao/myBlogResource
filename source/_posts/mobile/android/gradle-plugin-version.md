---
title: gradle 和 gradle 插件版本对应关系
date: 2020-04-18 17:08:51
categories:
- 移动开发
- android
tags:
- android
- gradle
---

# android Gradle 插件版本

可以在顶级 `build.gradle` 文件中指定 gradle 插件版本:

```groovy
buildscript {
	repositories {
		google()
	}
	dependencies {
		classpath 'com.android.tools.build:gradle:3.5.2'
	}
}
```

<!-- more -->

下表列出各个 Android Gradle 插件版本所需的 Gradle 版本。

| 插件版本 | 所需的 Gradle 版本 |
| :-----: | :-----: |
| 1.0.0 - 1.1.3 | 2.2.1 - 2.3 |
| 1.2.0 - 1.3.1 | 2.2.1 - 2.9 |
| 1.5.0	| 2.2.1 - 2.13 |
| 2.0.0 - 2.1.2	| 2.10 - 2.13 |
| 2.1.3 - 2.2.3 |2.14.1+ |
| 2.3.0+ | 3.3+ |
| 3.0.0+ | 4.1+ |
| 3.1.0+ | 4.4+ |
| 3.2.0 - 3.2.1 | 4.6+ |
| 3.3.0 - 3.3.2 | 4.10.1+ |
| 3.4.0 - 3.4.1 | 5.1.1+ |
| 3.5.0+ | 5.4.1-5.6.4 |

可以在 gradle-wrapper.properties 文件中指定 Gradle 的版本:

```properties
distributionUrl = https\://services.gradle.org/distributions/gradle-5.4.1-all.zip
```

[更多信息请查看这里](https://developer.android.google.cn/studio/releases/gradle-plugin)
