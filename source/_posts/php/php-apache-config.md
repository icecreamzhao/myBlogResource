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

<!--more-->

### Linux version
[linux下的php下载地址](http://www.php.net/downloads.php)
同样, 使用tar解压就好

<br>

## 下载apache服务器

### windows version

[windows下的apache下载地址](https://www.apachehaus.com/cgi-bin/download.plx)

下载好之后应该是一个压缩包的形式, 直接解压就好。

### Linux version

centos下可以直接使用`yum`命令来安装。
```cmd
yum install httpd -y
```
安装完之后可以在`/etc/httpd`目录下找到。


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
接着是很重要的一部分, 配置扩展的路径。
先全局搜索一下`extension_dir`这个字段, 如果没有则加上, 值设为你的扩展文件夹的绝对路径:
```ini
extension_dir = "c:\php\ext"
```

> 注意, 如果遇到了 `call to undifined function: ***` 之类的报错, 则找到这个方法需要的扩展, 并将该扩展前的分号移除。

<br>

## 配置apache
找到apache根目录下的conf/httpd.conf文件并编辑, 在结尾处加上:
```conf
loadModule php5_module C:/php/php5apache2_4.dll
PHPIniDir "C:/php/"
AddType application/x-httpd-php .php

# 下面的配置主要为了防止 curl_init 函数不能被加载
LoadFile C:\php\php5ts.dll
LoadFile C:\php\libeay32.dll
LoadFile C:\php\ssleay32.dll
LoadFile C:\php\libssh2.dll
# 这里需要将这几个文件拷贝到 C:/windows/system32 (64位放在 C:/windows/SysWQOW64 目录下)和apache 根目录的bin下
```
还有一个可选设置是apache的网页文件目录:
```conf
DocumentRoot "${SRVROOT}/htdocs"
```
和这一行:
```conf
# 这里填写你自己的根目录的绝对路径
Define SRVROOT "C:/server/apache/Apache24"
```
接着来安装服务:
```shell
httpd -k install
```
最后来测试运行:
```shell
httpd -k start
```
> 注意, 如果在这期间出现了类似于"通常每个套接字地址(协议/网络地址/端口)只允许使用一次"类似的问题, 那么查看他需要使用的端口号, 然后输入`netstat -a -o`来查看端口占用情况, 找到其pid, 并在任务管理器中找到该进程并结束掉就好。

> 注意, 路径中不能出现中文和空格

这样, 我们的php环境和apache服务器就配置好了。