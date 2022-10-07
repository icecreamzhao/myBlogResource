---
title: flutter apk 打包
date: 2020-02-10 16:36:49
categories:
- 移动开发技巧/经验
- flutter
tags:
- flutter
---

# 步骤

1. 创建签名文件
2. 在 gradle 中配置签名
3. 执行构建命令

<!--more-->

# 创建签名文件

```shell
keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
```

# 在 gradle 中配置签名

在项目根目录的 android 目录下新建一个 `key.properties`, 内容如下:

```properties
storePassword=
keyPassword=
keyAlias=key
storeFile=key.jks
```

将上面的内容根据创建签名文件时添加的内容填充好。

接着在本目录的app目录下找到 `build.gradle` 文件, 添加一下内容:

```gradle
// 在最外层添加下面的内容:
// 用于自动签名
def keystorePropertiesFile = rootProject.file("key.properties")
def keystoreProperties = new Properties()
keystoreProperties.load(new FileInputStream(keystorePropertiesFile))

// 在 android 层下添加以下内容:
// 用于自动签名
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile file(keystoreProperties['storeFile'])
        storePassword keystoreProperties['storePassword']
    }
}

找到 android 层下的 buildTypes, 改为一下内容:
// 用于自动签名
buildTypes {
    release {
      minifyEnabled true
      useProguard false
        // TODO: Add your own signing config for the release build.
        // Signing with the debug keys for now, so `flutter run --release` works.
        signingConfig signingConfigs.release
    }
}
```

# 执行构建命令

```shell
# 可选项有: android-arm, android-arm64, android-x64
flutter build apk --target-platform android-arm64
```

OK, 构建成功之后会直接将 apk 所在路径显示出来。
