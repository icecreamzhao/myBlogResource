---
title: mysql 主从数据库遇到的问题和解决方案
date: 2019-10-17 02:44:50
categories:
- 配置技巧/经验
- 开发工具配置
- mysql
tags:
- mysql
---

# 前言

配置主从数据库请查看[mysql 配置主从数据库](/database/mysql-master-slave.html)。

配置了之后遇到了一些问题, 具体表现为 `Slave_IO_Running` 和 `Slave_SQL_Running` 不是 yes。

# 排查思路

首先使用 `show slave status\G` 命令查看 Last_Error, Last_IO_Error 和 Last_SQL_Error 三个项对应的值, 根据错误信息来具体解决。

如果不能通过以上三个项来确定原因, 那么可以通过查看 Master_Log_File 项对应的值确定日志文件, 然后进入 bin 目录下, 使用 mysqlbinlog.exe 你的日志目录 -v > test.txt 来解析 mysql 的日志。

## 遇到的一些具体的问题

* error connecting to master 'user@localhost:3306'

这里首先到主库中, 使用

```sql
use mysql;
select Host, User from user;
```

来查看你的用户对应的Host是否是locahost, 然后使用用户名和密码登录一下主库检查密码是否错误。

如果还不行, 那就等 1 分钟之后, 他就会报别的错误。~~我的就是这样。~~

* COULD NOT FIND FIRST LOG FILE NAME IN BINARY LOG INDEX FILE

这里应该是从库在读主库的日志的时候出了问题, 解决办法是:

1. 先停止主从服务: `stop slave;`
2. 在主库中使用 `flush logs` 来刷新日志;
3. 在主库中使用 `show master status;` 命令来查看日志文件名和日志号;
4. 到从库中执行 `CHANGE MASTER TO MASTER_LOG_FILE='刚才查看的日志文件名',MASTER_LOG_POS=刚才查看的日志文件号;`
5. 执行 `start slave; show slave status\G`

