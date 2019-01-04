---
title: php, thinkPHP使用apache服务器的配置方案
date: 2018-12-30 23:52:04
categories:
- php
tags:
- php
- apache
- thinkPHP
---

# 准备

## 下载php

### windows version

[windows下的php下载地址](https://windows.php.net/download)

下载好之后应该是一个压缩包的形式, 直接解压就好。

### Linux version

<br>

## 下载apache服务器

### windows version

[windows下的apache下载地址](https://www.apachehaus.com/cgi-bin/download.plx)

下载好之后应该是一个压缩包的形式, 直接解压就好。

### Linux version

<br>

# 配置

## 配置php

下载好之后, 打开php的根目录, 找到`php.ini-development`这个文件, 将这个文件复制一份, 并重命名为`php.ini`, 编辑这个文件, 找到`extension`部分, 将需要的扩展前面的`;`去掉, 附上我的配置:

```ini
extension=curl
extension=gd2
extension=imap
extension=mbstring
extension=mysql
extension=mysqli
extension=openssl
extension=pdo_firebird
extension=pdo_mysql
```

注意, 这里使用的是php新版本的配置方式, 老版本的配置需要在扩展名前加上`php_`, 而且还需要文件后缀名`.dll`

例如:

```ini
extension=php_curl.dll
```

