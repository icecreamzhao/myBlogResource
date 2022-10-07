---
title: Invalid character found in the request target.The valid characters are defined in RFC 7230 and RFC3986
date: 2019-05-16 23:45:23
categories:
- 后端技巧/经验
- java
tags:
- tomcat
---

# 问题

当在通过tomcat传递url时, 后台会报Invalid character found in the request target.The valid characters are defined in RFC 7230 and RFC3986。

<!--more-->

# 解决办法

通过查询发现这个问题是高版本tomcat中的新特性：就是严格按照 RFC 3986规范进行访问解析，而 RFC 3986规范定义了Url中只允许包含英文字母（a-zA-Z）、数字（0-9）、-_.~4个特殊字符以及所有保留字符(RFC3986中指定了以下字符为保留字符：! * ’ ( ) ; : @ & = + $ , / ? # [ ])。而我们的系统在通过地址传参时，在url中传了一段json，传入的参数中有"{"不在RFC3986中的保留字段中，所以会报这个错。

根据（https://bz.apache.org/bugzilla/show_bug.cgi?id=60594） ，从以下版本开始，有配置项能够关闭/配置这个行为：
8.5.x系列的：8.5.12 onwards
8.0.x系列的：8.0.42 onwards
7.0.x系列的：7.0.76 onwards

.../conf/catalina.properties中，找到最后注释掉的一行 `tomcat.util.http.parser.HttpParser.requestTargetAllow=|`，改成`tomcat.util.http.parser.HttpParser.requestTargetAllow=|{}`，表示把｛｝放行

按照上面的方法处理好后，在非IE浏览器上访问，是没有问题了。但若是在IE浏览器上进行访问，这个错误还是会出现，在IE上访问出现这个错误的原因：因为url的参数json中有双引号，火狐和谷歌浏览器会自动对url进行转码，但IE不会

这种情况的处理方法：
给系统配置方向代理服务器，通过反向代理服务器进行urlrewrite，手动取出各个json的数据，手动将双引号进行转码为%22：

具体方式如下：
编辑 Apache安装目录/conf/httpd.conf， 在配置项目反向代理的前面添加如下信息：

```conf
RewriteCond %{QUERY_STRING} json
RewriteCond %{QUERY_STRING} !msKey
RewriteCond %{QUERY_STRING} msInfo
RewriteCond %{QUERY_STRING} player
RewriteCond %{QUERY_STRING} {[^a-zA-Z0-9]([a-zA-Z]+)[^a-zA-Z0-9]:[^a-zA-Z0-9]([a-zA-Z0-9*]+)[^a-zA-Z0-9],[^a-zA-Z0-9]([a-zA-Z]+)[^a-zA-Z0-9]:[^a-zA-Z0-9]([a-zA-Z0-9*]+)[^a-zA-Z0-9]}
RewriteRule ^(.*)? $1?method=sendJson&json={%22%1%22:%22%2%22,%22%3%22:%22%4%22} [R,L,NE]
```

[官网各项配置说明](https://tomcat.apache.org/tomcat-7.0-doc/config/systemprops.html)
