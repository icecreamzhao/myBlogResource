---
title: mysql 配置主从数据库
date: 2019-07-17 10:57:02
categories:
- 配置技巧/经验
- 开发工具配置
- mysql
tags:
- mysql
---

# 目标

* 将两台可以ping通的电脑上的mysql数据库设置为主从状态

<!--more-->

# 物料

两台已经装好mysql, 并且可以互相ping通的主机
安装windows解压版mysql可以查看[这篇文章](/software/set_up/mysql-setup.html)。

# 步骤

* 首先, 打开 防火墙的高级设置, 添加入站规则, 将 mysql默认的3306端口添加好, 保存。

* 编辑将要设置的主数据库的my.ini:

```
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
 
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin

[mysqld]

##server_id和log_bin两项即可，其它配置都是可配可不配

# 这里填写mysql安装地址
basedir=C:/Users/Administrator/mysql-8.0.16-winx64
datadir=C:/Users/administrator/mysql-8.0.16-winx64/data

# 唯一标识id
server-id=1

# 开启二进制日志
log-bin=mysql-bin
 
# port=5506
 
# binlog-do-db=wordpress是表示只备份wordpress。
# binlog_ignore_db=mysql表示忽略备份mysql。
# 不加binlog-do-db和binlog_ignore_db，那就表示备份全部数据库
# binlog-do-db=wordpress
# binlog_ignore_db=mysql
 
 
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M 
 
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
```

* 编辑从数据库的my.ini

```
[mysql]
# 设置mysql客户端默认字符集
default-character-set=utf8 
[mysqld]

# 这里填写mysql安装地址
basedir=C:/Users/Administrator/mysql-8.0.16-winx64
datadir=C:/Users/administrator/mysql-8.0.16-winx64/data

server-id=2
# 开启二进制日志
log-bin=mysql-bin
relay-log=relay-bin
# 设置只读权限
read-only=1
# 复制时忽略相关表或者数据库
# replicate-do-db = name 只对这个数据库进行镜像处理。
# replicate-ignore-table = dbname.tablename 不对这个数据表进行镜像处理。
# replicate-wild-ignore-table = dbn.tablen 不对这些数据表进行镜像处理。
# replicate-ignore-db = dbname 不对这个数据库进行镜像处理。
 
replicate-ignore-db = mysql
replicate-ignore-db = information_schema
# replicate-wild-do-table = tt.admin
# 所要同步的数据库的单个表
# replicate-wild-do-table = test.user
```

* 创建一个用户给从数据库

在主数据库上执行:

```
CREATE USER 'user'@'这里填写从数据库的地址' IDENTIFIED BY 'password';
GRANT REPLICATION SLAVE ON *.* TO 'user'@'从数据库地址';
# 注意, 第二句话适用于高版本, 低版本可以在后面加上: IDENTIFIED BY 'password';
```

这样就创建了一个给从数据库登录主数据库的用户user。

* 在从数据库上配置主数据库给从数据库登录的用户

首先查看主数据库的日志号:

```
show master status;
```

然后在从数据库上执行:
```
change master to master_host='主数据库的地址',master_user='刚才在主数据库中创建的用户user',master_password='password',master_port=3306,master_log_file='刚才看的主数据库的日志号';
```

* 执行从数据库的SLAVE服务:

```
START SLAVE;

# 停止服务
STOP SLAVE;
```

* 完成

# 其他

查看slave日志:

```
show slave status;
```

如果遇到了一些错误导致主从复制停止, 那么可以使用

```
slave stop;
SET GLOBAL SQL_SLAVE_SKIP_COUNTER = n（保险起见设置n=1）        #跳过这n个event
slave start
```

或者

```
vi /etc/my.cnf
[mysqld]
#slave-skip-errors=1062,1053,1146 #跳过指定error no类型的错误
#slave-skip-errors=all #跳过所有错误
```

怎么判断mysql的主从是否同步？(同步日志)

```
show slave status\G
```

查看`Slave_IO_Running`和`Slave_SQL_Running`是否都是yes。

# 参考博客

[sharding-jdbc的读写分离，数据库主从同步实践](https://blog.csdn.net/qq_18416057/article/details/82898234)
