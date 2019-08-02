---
title: js和java自带sha密码加密
date: 2019-07-24 16:54:24
categories:
- 加密
tags:
- 加密
---

# 前言

用到了对数据库密码进行一个简单的加密的功能, 顺便总结一下。
<!--more-->

# js实现SHA加密

[Google的加密库](http://blog.kwin.wang/downloads/CryptoJS-v3.1.2.zip)包含了很多常用的加密方式, 包括AES、DES、SHA-1、SHA-2、SHA256、MD5等。

* SHA-256

```js
<script src="components/core.js"></script>
<script src="rollups/sha256.js"></script>

var waitSignData = '123'
var signData = CryptoJS.SHA256(waitSignData).toString();

console.log(signData)
```

# Java实现加密

```java
import javax.xml.bind.annotation.adapters.HexBinaryAdapter;
import java.security.MessageDigest;

public static String encodeSHA256(byte[] data) throws Exception {
    // 初始化MessageDigest
    MessageDigest md = MessageDigest.getInstance("SHA-256");
    // 执行摘要方法
    byte[] digest = md.digest(data);
    return new HexBinaryAdapter().marshal(digest);
}

/**
 * 将原数据和加密后的数据进行比较
 * @param passwd 原数据
 * @param encode 加密后的数据
 * @return 比较结果
 */
public static boolean validatePasswd(String data, String encodeData) {
    return MessageDigest.isEqual(data.getBytes(), encodeData.getBytes());
}
```
