---
title: linux mariadb 的一些问题
date: 2020-08-26 12:32:31
categories:
- 配置技巧/经验
- 开发工具配置
- mariadb
tags:
- mysql
- mariadb
---

# 安装

```
sudo apt install mariadb-server
sudo mysql_secure_installation
```

# 远程登录

```
GRANT ALL ON *.* TO 'admin'@'localhost' IDENTIFIED BY 'password' WITH GRANT OPTION;
FLUSH PRIVILEGES;
exit
```

# 中文乱码

```
vim /etc/my.cnf.d/mariadb-server.cnf

# 在server.cnf中[mysqld]标签下添加代码
init-connect='SET NAMES utf8'
character-set-server = utf8

systemctl restart mariadb
```
